import fs from 'node:fs';
import { Readable } from 'node:stream';
import { pipeline } from 'node:stream/promises';
import { assertSafeOutboundUrl } from '../security/antiSsrfGuard.js';
import { selectOptimalUpstreamUserAgent } from './idmTurboDownloader.js';
import { AppError } from '../utils/errors.js';

function applyContentDispositionHeader(res, downloadFileName) {
  if (!downloadFileName) return;
  const asciiFallback =
    String(downloadFileName)
      .replace(/[^\x20-\x7E]/g, '_')
      .replace(/["\\]/g, '')
      .trim() || 'video.mp4';
  const utf8Encoded = encodeURIComponent(downloadFileName);
  res.setHeader(
    'Content-Disposition',
    `attachment; filename="${asciiFallback}"; filename*=UTF-8''${utf8Encoded}`
  );
}

// ============================================================================
// REAL RFC-9110 HTTP 206 PARTIAL CONTENT RANGE STREAMER (LOCAL FILES ON DISK)
// ============================================================================
export function streamLocalFileWithRange(
  req,
  res,
  filePath,
  mimeType = 'video/mp4',
  downloadFileName = null
) {
  if (!fs.existsSync(filePath)) {
    throw new AppError(404, 'NOT_FOUND', 'Requested media file does not exist on disk.');
  }

  const stat = fs.statSync(filePath);
  const totalSize = stat.size;
  const rangeHeader = req.headers.range;

  res.setHeader('Accept-Ranges', 'bytes');
  res.setHeader('Content-Type', mimeType);
  applyContentDispositionHeader(res, downloadFileName);

  if (rangeHeader) {
    const match = /bytes=(\d*)-(\d*)/.exec(rangeHeader);
    if (!match) {
      res.setHeader('Content-Range', `bytes */${totalSize}`);
      return res.status(416).end();
    }
    const start = match[1] ? parseInt(match[1], 10) : 0;
    const end = match[2] ? parseInt(match[2], 10) : totalSize - 1;

    if (start >= totalSize || end >= totalSize || start > end) {
      res.setHeader('Content-Range', `bytes */${totalSize}`);
      return res.status(416).end();
    }

    const chunkSize = end - start + 1;
    res.status(206);
    res.setHeader('Content-Range', `bytes ${start}-${end}/${totalSize}`);
    res.setHeader('Content-Length', chunkSize);
    return fs.createReadStream(filePath, { start, end }).pipe(res);
  }

  res.status(200);
  res.setHeader('Content-Length', totalSize);
  return fs.createReadStream(filePath).pipe(res);
}

// ============================================================================
// ZERO-STORAGE LIVE REMOTE STREAM, M3U8 HLS PROXY & DIRECT IDM/CHROME DOWNLOADER
// Supports BOTH inline <video>/Hls.js playback AND HTTP 206 multi-connection
// attachment streaming straight into Windows PC `IDMan.exe` or Google Chrome!
// ============================================================================
export async function proxyRemoteMediaStream(req, res, { asAttachment = false } = {}) {
  const targetUrl = String(req.query.url || '').trim();
  const parsed = await assertSafeOutboundUrl(targetUrl, { performDnsCheck: true });
  const customReferer = String(req.query.referer || '').trim();
  const requestedFilename = String(
    req.query.filename || req.params?.fileHint || ''
  ).trim();

  const upstreamHeaders = {
    'User-Agent': selectOptimalUpstreamUserAgent(parsed.toString()),
    Accept: '*/*',
  };

  if (customReferer && !parsed.hostname.includes('googlevideo.com')) {
    upstreamHeaders.Referer = customReferer;
  }
  if (req.headers.range) {
    upstreamHeaders.Range = req.headers.range;
  }

  const controller = new AbortController();
  req.on('close', () => controller.abort());

  let upstream;
  try {
    upstream = await fetch(parsed.toString(), {
      method: req.method === 'HEAD' ? 'HEAD' : 'GET',
      headers: upstreamHeaders,
      redirect: 'follow',
      signal: controller.signal,
    });
  } catch (err) {
    if (err.name === 'AbortError') return;
    throw new AppError(502, 'UPSTREAM_ERROR', `Upstream stream unreachable: ${err.message}`);
  }

  const contentType = upstream.headers.get('content-type') || 'video/mp4';

  if (!asAttachment && (contentType.includes('mpegurl') || parsed.pathname.endsWith('.m3u8'))) {
    const manifestText = await upstream.text();
    const rewritten = manifestText
      .split('\n')
      .map((line) => {
        const trimmed = line.trim();
        if (!trimmed || trimmed.startsWith('#')) return line;
        const resolvedSeg = new URL(trimmed, parsed.toString()).toString();
        return `/api/v1/stream/proxy?url=${encodeURIComponent(resolvedSeg)}`;
      })
      .join('\n');

    res.status(200);
    res.setHeader('Content-Type', 'application/vnd.apple.mpegurl');
    res.setHeader('Access-Control-Allow-Origin', '*');
    return res.send(rewritten);
  }

  res.status(upstream.status);
  res.setHeader('Content-Type', contentType);
  res.setHeader('Accept-Ranges', upstream.headers.get('accept-ranges') || 'bytes');
  res.setHeader('Access-Control-Allow-Origin', '*');

  if (asAttachment || requestedFilename) {
    applyContentDispositionHeader(res, requestedFilename || 'UltraDownloader_Video.mp4');
  }

  const contentLength = upstream.headers.get('content-length');
  if (contentLength) res.setHeader('Content-Length', contentLength);

  const contentRange = upstream.headers.get('content-range');
  if (contentRange) res.setHeader('Content-Range', contentRange);

  if (req.method === 'HEAD' || !upstream.body) {
    return res.end();
  }

  await pipeline(Readable.fromWeb(upstream.body), res).catch(() => {});
}

// ============================================================================
// INSTANT HTTP 200 / 206 ATTACHMENT STREAM FOR WINDOWS PC IDM & GOOGLE CHROME
// ============================================================================
export async function streamDirectDownloadPassThrough(req, res) {
  return proxyRemoteMediaStream(req, res, { asAttachment: true });
}

// ============================================================================
// UNIVERSAL HLS (.m3u8) -> SINGLE PLAYABLE FILE DOWNLOADER (.ts / .mp4)
// Works for any streaming-only platform: master + media playlists are parsed,
// the highest-quality variant is selected and every segment is concatenated
// into ONE attachment file streamed straight to Chrome / PC IDM.
// ============================================================================
async function fetchTextWithUa(targetUrl, extraHeaders = {}) {
  const res = await fetch(targetUrl, {
    redirect: 'follow',
    headers: {
      'User-Agent': selectOptimalUpstreamUserAgent(targetUrl),
      Accept: '*/*',
      ...extraHeaders,
    },
  });
  if (!res.ok) throw new AppError(502, 'UPSTREAM_ERROR', `Upstream HTTP ${res.status}`);
  return { text: await res.text(), finalUrl: res.url || targetUrl };
}

function parseAttributeList(line) {
  const attrs = {};
  const body = line.slice(line.indexOf(':') + 1);
  body.split(',').forEach((pair) => {
    const idx = pair.indexOf('=');
    if (idx === -1) return;
    attrs[pair.slice(0, idx).trim()] = pair
      .slice(idx + 1)
      .trim()
      .replace(/^"|"$/g, '');
  });
  return attrs;
}

function pickHighestBandwidthVariant(manifestText, baseUrl) {
  const lines = manifestText.split(/\r?\n/);
  let best = null;
  for (let i = 0; i < lines.length; i++) {
    const line = lines[i].trim();
    if (!line.startsWith('#EXT-X-STREAM-INF')) continue;
    const attrs = parseAttributeList(line);
    const bandwidth = Number(attrs.BANDWIDTH || attrs['AVERAGE-BANDWIDTH'] || 0);
    const nextLine = (lines[i + 1] || '').trim();
    if (!nextLine || nextLine.startsWith('#')) continue;
    if (!best || bandwidth > best.bandwidth) {
      best = { bandwidth, url: new URL(nextLine, baseUrl).toString() };
    }
  }
  return best;
}

export async function streamHlsDownloadAsFile(req, res) {
  const targetUrl = String(req.query.url || '').trim();
  const parsedTarget = await assertSafeOutboundUrl(targetUrl, { performDnsCheck: true });
  const referer = String(req.query.referer || '').trim();
  const requested =
    String(req.query.filename || req.params?.fileHint || 'UltraDownloader_Video.ts')
      .replace(/[^\p{L}\p{N}\s_.-]/gu, '')
      .trim() || 'UltraDownloader_Video.ts';
  const fileName = /\.(ts|mp4)$/i.test(requested) ? requested : `${requested}.ts`;

  const extraHeaders = referer && /^https?:\/\//i.test(referer) ? { Referer: referer } : {};
  const first = await fetchTextWithUa(parsedTarget.toString(), extraHeaders);
  let mediaManifest = first.text;
  let mediaBase = first.finalUrl;

  if (mediaManifest.includes('#EXT-X-STREAM-INF')) {
    const variant = pickHighestBandwidthVariant(mediaManifest, mediaBase);
    if (!variant) throw new AppError(422, 'STREAM_UNAVAILABLE', 'No playable HLS variant found.');
    const variantRes = await fetchTextWithUa(variant.url, extraHeaders);
    mediaManifest = variantRes.text;
    mediaBase = variantRes.finalUrl;
  }

  const lines = mediaManifest.split(/\r?\n/);
  const segments = [];
  let initSegment = '';
  let isFmp4 = false;

  for (const rawLine of lines) {
    const line = rawLine.trim();
    if (!line) continue;
    if (line.startsWith('#EXT-X-MAP')) {
      const attrs = parseAttributeList(line);
      if (attrs.URI) {
        initSegment = new URL(attrs.URI, mediaBase).toString();
        isFmp4 = true;
      }
      continue;
    }
    if (line.startsWith('#EXT-X-KEY') && /METHOD=(?!NONE)/i.test(line)) {
      throw new AppError(
        422,
        'DRM_PROTECTED',
        'This HLS stream is encrypted and cannot be downloaded.'
      );
    }
    if (line.startsWith('#')) continue;
    segments.push(new URL(line, mediaBase).toString());
  }

  if (segments.length === 0) {
    throw new AppError(422, 'STREAM_UNAVAILABLE', 'This HLS playlist contains no media segments.');
  }

  res.status(200);
  res.setHeader('Content-Type', isFmp4 ? 'video/mp4' : 'video/mp2t');
  res.setHeader('Accept-Ranges', 'none');
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Cache-Control', 'no-store');
  applyContentDispositionHeader(res, isFmp4 ? fileName.replace(/\.ts$/i, '.mp4') : fileName);

  let clientGone = false;
  req.on('close', () => {
    clientGone = true;
  });

  const writeChunk = async (chunkUrl) => {
    if (clientGone) return false;
    let upstream;
    try {
      upstream = await fetch(chunkUrl, {
        redirect: 'follow',
        headers: { 'User-Agent': selectOptimalUpstreamUserAgent(chunkUrl), Accept: '*/*' },
      });
    } catch {
      return true;
    }
    if (!upstream.ok || !upstream.body) return true;
    const buffer = Buffer.from(await upstream.arrayBuffer());
    if (!res.write(buffer)) {
      await new Promise((resolve) => res.once('drain', resolve));
    }
    return true;
  };

  try {
    if (initSegment) await writeChunk(initSegment);
    for (const segmentUrl of segments) {
      if (clientGone) break;
      await writeChunk(segmentUrl);
    }
  } finally {
    res.end();
  }
}

// ============================================================================
// PURE NODE.JS LIVE PREVIEW RESOLVER (ZERO `yt-dlp.exe` DEPENDENCY!)
// ============================================================================
export async function pipeLivePureJsPreview(req, res) {
  const targetUrl = String(req.query.url || '').trim();
  await assertSafeOutboundUrl(targetUrl, { performDnsCheck: true });

  const { analyzeMediaUrl } = await import('./extractorEngine.js');
  const analysis = await analyzeMediaUrl({ rawUrl: targetUrl });
  const directPreview =
    analysis?.media?.previewPlayer?.streamUrl ||
    analysis?.streams?.videoAudio?.[0]?.streamUrl ||
    '';

  if (!directPreview || directPreview.includes('/stream/live-pipe')) {
    throw new AppError(422, 'STREAM_UNAVAILABLE', 'Unable to resolve preview stream.');
  }

  return res.redirect(302, directPreview);
}

// ============================================================================
// REAL SUBTITLE STREAM FETCHER (.VTT / .SRT)
// ============================================================================
export async function proxySubtitleDownload(req, res) {
  const targetUrl = String(req.query.url || '').trim();
  const lang = String(req.query.lang || 'en').replace(/[^a-zA-Z0-9_-]/g, '');
  const parsed = await assertSafeOutboundUrl(targetUrl, { performDnsCheck: true });

  const upstream = await fetch(parsed.toString());
  if (!upstream.ok) {
    throw new AppError(502, 'UPSTREAM_ERROR', 'Unable to fetch subtitle track from source.');
  }
  const text = await upstream.text();
  res.status(200);
  res.setHeader('Content-Type', 'text/vtt; charset=utf-8');
  res.setHeader('Content-Disposition', `attachment; filename="subtitles.${lang}.vtt"`);
  res.send(text);
}
