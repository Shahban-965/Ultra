// ============================================================================
// EXTENDED EMBED EXTRACTORS — extra platforms that need their own endpoint
// (legacy/oEmbed/JSON APIs). Every function is best-effort: it returns `null`
// on any failure so the universal HTML sniffer can still try afterwards.
// ============================================================================
import { AppError } from '../utils/errors.js';

const UA =
  'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36';

const BROWSER_HEADERS = {
  'User-Agent': UA,
  Accept: 'text/html,application/xhtml+xml,application/json;q=0.9,*/*;q=0.8',
  'Accept-Language': 'en-US,en;q=0.9',
};

async function fetchJson(url, extraHeaders = {}) {
  try {
    const res = await fetch(url, {
      headers: { ...BROWSER_HEADERS, ...extraHeaders },
      redirect: 'follow',
      signal: AbortSignal.timeout(12000),
    });
    if (!res.ok) return null;
    const text = await res.text();
    try {
      return JSON.parse(text);
    } catch {
      return null;
    }
  } catch {
    return null;
  }
}

async function fetchHtml(url, extraHeaders = {}) {
  try {
    const res = await fetch(url, {
      headers: { ...BROWSER_HEADERS, ...extraHeaders },
      redirect: 'follow',
      signal: AbortSignal.timeout(12000),
    });
    if (!res.ok) return null;
    return await res.text();
  } catch {
    return null;
  }
}

function decodeEscapes(value) {
  return String(value || '')
    .replace(/\\u002[fF]/g, '/')
    .replace(/\\u0026/g, '&')
    .replace(/\\\//g, '/')
    .replace(/&amp;/g, '&')
    .trim();
}

// Builds the standard analysis shape from a flat list of media URLs.
function buildResult({ platform, canonicalUrl, title, thumbnailUrl, sources, extractorTier }) {
  const usable = (sources || []).filter((s) => s && /^https?:\/\//i.test(s.url || ''));
  if (usable.length === 0) return null;

  const videoAudio = usable.map((source, index) => {
    const ext = /\.m3u8/i.test(source.url) ? 'ts' : source.ext || 'mp4';
    const qualityTitle = source.label || (index === 0 ? 'HD' : `Source ${index + 1}`);
    const safeName = String(title || 'Video').replace(/[^\p{L}\p{N}\s_-]/gu, '').trim().slice(0, 60) || 'Video';
    const encodedName = encodeURIComponent(`${safeName.replace(/\s+/g, '_')}_${qualityTitle}.${ext}`);
    return {
      formatId: `ext-${index}`,
      formatSelector: 'direct_idm_stream',
      qualityKey: qualityTitle,
      qualityTitle,
      qualitySub: ext === 'ts' ? 'HLS Stream' : 'Direct MP4',
      formatExt: ext,
      hasVideo: true,
      hasAudio: true,
      requiresMux: false,
      sizeBytes: Number(source.sizeBytes || 0),
      directCdnUrl: source.url,
      streamUrl:
        ext === 'ts'
          ? `/api/v1/stream/hls-download/${encodedName}?url=${encodeURIComponent(source.url)}`
          : `/api/v1/stream/direct-download/${encodedName}?url=${encodeURIComponent(source.url)}`,
    };
  });

  return {
    platform,
    canonicalUrl,
    extractorTier: extractorTier || 'extended_embed',
    media: {
      title: String(title || 'Video').slice(0, 180),
      thumbnailUrl: thumbnailUrl || '',
      durationText: 'Video',
      maxResolutionLabel: 'HD',
      estimatedBestSizeBytes: 0,
      isAdult: false,
      subtitles: [],
      previewPlayer: {
        mode: videoAudio[0].formatExt === 'ts' ? 'hls_proxy' : 'direct_range_proxy',
        streamUrl: videoAudio[0].streamUrl,
      },
      streams: { videoWithAudio: videoAudio, videoOnly: [], audioOnly: [] },
    },
    streams: { videoAudio, videoOnly: [], audioOnly: [] },
  };
}

// ---------------------------------------------------------------- Reddit
async function extractReddit(parsed, platform) {
  const match = /\/r\/[^/]+\/comments\/([a-z0-9]+)/i.exec(parsed.pathname);
  if (!match) return null;
  const postId = match[1];

  const endpoints = [
    `https://www.reddit.com/comments/${postId}.json?limit=1&raw_json=1`,
    `https://old.reddit.com/comments/${postId}.json?limit=1&raw_json=1`,
    `https://api.reddit.com/comments/${postId}?limit=1&raw_json=1`,
  ];

  for (const endpoint of endpoints) {
    const data = await fetchJson(endpoint, { Accept: 'application/json' });
    const post = data?.[0]?.data?.children?.[0]?.data;
    if (!post) continue;

    const redditVideo = post.secure_media?.reddit_video || post.media?.reddit_video || null;
    const sources = [];
    if (redditVideo?.fallback_url) sources.push({ url: redditVideo.fallback_url, label: 'HD MP4' });
    if (redditVideo?.hls_url) sources.push({ url: redditVideo.hls_url, label: 'HLS' });

    if (sources.length === 0) {
      const direct = /\.(mp4|webm|gif)(\?|$)/i.exec(post.url_overridden_by_dest || post.url || '');
      if (direct) sources.push({ url: post.url_overridden_by_dest || post.url, label: 'Original' });
    }

    const built = buildResult({
      platform,
      canonicalUrl: `https://www.reddit.com${parsed.pathname}`,
      title: post.title,
      thumbnailUrl: post.thumbnail && post.thumbnail.startsWith('http') ? post.thumbnail : '',
      sources,
      extractorTier: 'reddit_json',
    });
    if (built) return built;
  }
  return null;
}

// ---------------------------------------------------------------- OK.ru
async function extractOkRu(parsed, platform) {
  const match = /\/video\/(\d+)/.exec(parsed.pathname);
  if (!match) return null;

  const html = await fetchHtml(`https://m.ok.ru/video/${match[1]}`, {
    'User-Agent':
      'Mozilla/5.0 (iPhone; CPU iPhone OS 17_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.5 Mobile/15E148 Safari/604.1',
  });
  if (!html) return null;

  const decoded = decodeEscapes(html);
  const sources = [];
  const metadata = /"metadata"\s*:\s*\{([\s\S]{0,4000}?)\}\s*[,}]/.exec(decoded);
  if (metadata) {
    const hls = /"hlsManifestUrl"\s*:\s*"([^"]+)"/.exec(metadata[1]);
    if (hls) sources.push({ url: hls[1], label: 'HLS' });
    const videos = [...metadata[1].matchAll(/"url"\s*:\s*"(https?:[^"]+?\.mp4[^"]*)"/g)];
    videos.forEach((m, i) => sources.push({ url: m[1], label: i === 0 ? 'HD MP4' : `MP4 ${i + 1}` }));
  }
  if (sources.length === 0) {
    const direct = /(https?:[^"'\\\s]+?\.mp4[^"'\\\s]*)/.exec(decoded);
    if (direct) sources.push({ url: direct[1], label: 'MP4' });
  }

  const title = (/"videoName"\s*:\s*"([^"]+)"/.exec(decoded)?.[1] || 'OK.ru Video').trim();
  return buildResult({
    platform,
    canonicalUrl: `https://ok.ru/video/${match[1]}`,
    title,
    thumbnailUrl: '',
    sources,
    extractorTier: 'okru_metadata',
  });
}

// --------------------------------------------------------------- Bitchute
async function extractBitchute(parsed, platform) {
  const match = /\/video\/([a-zA-Z0-9]{8,})/.exec(parsed.pathname);
  if (!match) return null;

  const api = await fetchJson(`https://www.bitchute.com/api/video/${match[1]}`, {
    Accept: 'application/json',
  });
  const html = api ? null : await fetchHtml(`https://www.bitchute.com/video/${match[1]}/`);
  const haystack = api ? JSON.stringify(api) : decodeEscapes(html || '');
  if (!haystack) return null;

  const sources = [];
  const mp4 = /(https?:[^"'\\\s]+?\/video\/[^"'\\\s]+?\.mp4)/.exec(haystack);
  if (mp4) sources.push({ url: mp4[1], label: 'MP4' });
  const hls = /(https?:[^"'\\\s]+?\.m3u8[^"'\\\s]*)/.exec(haystack);
  if (hls) sources.push({ url: hls[1], label: 'HLS' });

  const title = (api?.video_name || /"video_name"\s*:\s*"([^"]+)"/.exec(haystack)?.[1] || 'BitChute Video').trim();
  return buildResult({
    platform,
    canonicalUrl: `https://www.bitchute.com/video/${match[1]}/`,
    title,
    thumbnailUrl: '',
    sources,
    extractorTier: 'bitchute_api',
  });
}

// ------------------------------------------------------------------- VK
async function extractVk(parsed, platform) {
  if (!/(^|\.)vk\.com$|(^|\.)vkvideo\.ru$/i.test(parsed.hostname)) return null;

  const oid =
    parsed.searchParams.get('oid') || /video(-?\d+)_/.exec(parsed.search)?.[1] || '';
  const videoId = parsed.searchParams.get('id') || /video-?\d+_(\d+)/.exec(parsed.search)?.[1] || '';
  if (!oid || !videoId) return null;

  const html = await fetchHtml(
    `https://vk.com/video_ext.php?oid=${encodeURIComponent(oid)}&id=${encodeURIComponent(videoId)}&hd=2`,
    { Referer: 'https://vk.com/' }
  );
  if (!html) return null;

  const decoded = decodeEscapes(html);
  const sources = [];
  const hls = /"hls"\s*:\s*"([^"]+)"/.exec(decoded);
  if (hls) sources.push({ url: hls[1], label: 'HLS' });
  ['2160', '1440', '1080', '720', '480', '360'].forEach((quality) => {
    const match = new RegExp(`"${quality}"\\s*:\\s*"([^"]+)"`).exec(decoded);
    if (match) sources.push({ url: match[1], label: `${quality}p MP4` });
  });

  return buildResult({
    platform,
    canonicalUrl: `https://vk.com/video${oid}_${videoId}`,
    title: (/"md_title"\s*:\s*"([^"]+)"/.exec(decoded)?.[1] || 'VK Video').trim(),
    thumbnailUrl: '',
    sources,
    extractorTier: 'vk_video_ext',
  });
}

// ------------------------------------------------------------- Bilibili
async function extractBilibili(parsed, platform) {
  const bv = /\/(BV[a-zA-Z0-9]{8,})/.exec(parsed.pathname)?.[1];
  if (!bv) return null;

  const view = await fetchJson(
    `https://api.bilibili.com/x/web-interface/view?bvid=${bv}`,
    { Referer: 'https://www.bilibili.com/' }
  );
  const data = view?.data;
  if (!data?.cid) return null;

  const play = await fetchJson(
    `https://api.bilibili.com/x/player/playurl?bvid=${bv}&cid=${data.cid}&qn=80&fnval=16&fourk=1`,
    { Referer: `https://www.bilibili.com/video/${bv}/` }
  );

  const durl = play?.data?.durl || [];
  const dash = play?.data?.dash || null;
  const sources = [];

  durl.forEach((item, i) => {
    if (item?.url) sources.push({ url: item.url, label: i === 0 ? 'HD MP4' : `MP4 ${i + 1}` });
  });
  if (sources.length === 0 && dash) {
    (dash.video || []).slice(0, 4).forEach((v) => {
      sources.push({ url: v.baseUrl || v.base_url, label: `${v.height || 720}p MP4` });
    });
  }

  return buildResult({
    platform,
    canonicalUrl: `https://www.bilibili.com/video/${bv}`,
    title: data.title || 'Bilibili Video',
    thumbnailUrl: data.pic || '',
    sources,
    extractorTier: 'bilibili_playurl',
  });
}

// --------------------------------------------------------- Odysee / LBRY
async function extractOdysee(parsed, platform) {
  if (!/odysee\.com$/i.test(parsed.hostname)) return null;
  const claimId = /(?:[?&])(?:claim|v)=([a-zA-Z0-9]+)/.exec(parsed.search)?.[1] || '';
  if (!claimId) return null;

  const body = {
    jsonrpc: '2.0',
    method: 'get',
    params: { uri: `lbry://${claimId}`, save_file: false },
  };

  const res = await fetch('https://api.na-backend.odysee.com/api/v1/proxy?m=get', {
    method: 'POST',
    headers: { ...BROWSER_HEADERS, 'Content-Type': 'application/json' },
    body: JSON.stringify(body),
    signal: AbortSignal.timeout(12000),
  }).catch(() => null);
  if (!res?.ok) return null;

  const json = await res.json().catch(() => null);
  const result = json?.result;
  if (!result?.streaming_url) return null;

  return buildResult({
    platform,
    canonicalUrl: `https://odysee.com/${claimId}`,
    title: result.title || 'Odysee Video',
    thumbnailUrl: result.thumbnail?.url || '',
    sources: [{ url: result.streaming_url, label: 'HD MP4' }],
    extractorTier: 'odysee_lbry_api',
  });
}

/**
 * Tries every extended platform extractor. Returns null when none applies.
 */
export async function tryExtendedEmbedExtractors(healedUrl, platform) {
  let parsed;
  try {
    parsed = new URL(healedUrl);
  } catch {
    return null;
  }

  const chain = [extractReddit, extractOkRu, extractBitchute, extractVk, extractBilibili, extractOdysee];

  for (const extractor of chain) {
    try {
      const result = await extractor(parsed, platform);
      if (result) return result;
    } catch (err) {
      if (err instanceof AppError) throw err;
      // swallow and continue with the next extractor
    }
  }
  return null;
}
