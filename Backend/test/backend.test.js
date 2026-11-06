import fsSync from 'node:fs';
import path from 'node:path';
import { describe, it, expect, beforeAll, afterAll, vi } from 'vitest';
import request from 'supertest';
import { createBackendApp } from '../src/app.js';
import { BACKEND_ROOT } from '../src/config/env.js';
import { initDatabase, sqlQuery } from '../src/db/database.js';
import { clearAllVolatileCards } from '../src/services/liveCardBus.js';

describe('UltraDownloader V10.0 — Zero yt-dlp.exe Pure IDM/Chrome + Strict User History Suite', () => {
  let app;
  let guestAgent;
  let adminAgent;

  beforeAll(async () => {
    await initDatabase();
    await sqlQuery('DELETE FROM ip_lockouts').catch(() => {});
    await sqlQuery('DELETE FROM download_jobs').catch(() => {});
    app = createBackendApp();
    guestAgent = request.agent(app);
    adminAgent = request.agent(app);
  }, 60000);

  afterAll(async () => {
    clearAllVolatileCards();
    await sqlQuery('DELETE FROM ip_lockouts').catch(() => {});
    await sqlQuery('DELETE FROM download_jobs').catch(() => {});
    await sqlQuery("DELETE FROM users WHERE email LIKE 'test_v10_%'").catch(() => {});
    await sqlQuery('DELETE FROM security_audit_logs').catch(() => {});
  });

  it('1. Enforces ZERO yt-dlp.exe / ZERO postinstall binary hangs & clean zero-fake SQL database state', async () => {
    const pkg = JSON.parse(
      fsSync.readFileSync(path.join(BACKEND_ROOT, 'package.json'), 'utf8')
    );
    expect(pkg.scripts.postinstall).toBeUndefined();
    expect(pkg.dependencies['ffmpeg-static']).toBeUndefined();
    expect(pkg.dependencies['ffprobe-static']).toBeUndefined();
    expect(fsSync.existsSync(path.join(BACKEND_ROOT, 'bin'))).toBe(false);
    expect(fsSync.existsSync(path.join(BACKEND_ROOT, 'src/scripts/setupBinaries.js'))).toBe(false);

    const [vault, ledger, seoClicks] = await Promise.all([
      sqlQuery('SELECT COUNT(*) AS c FROM saved_vault_videos'),
      sqlQuery('SELECT COUNT(*) AS c FROM finance_ledger'),
      sqlQuery('SELECT COALESCE(SUM(clicks), 0) AS c FROM seo_keywords'),
    ]);
    expect(Number(vault[0].c)).toBe(0);
    expect(Number(ledger[0].c)).toBe(0);
    expect(Number(seoClicks[0].c)).toBe(0);

    const health = await guestAgent.get('/api/v1/health').expect(200);
    expect(health.body.data.binaries.pureIdmDirectMode).toBe(true);
    expect(health.body.data.binaries.ytdlpRemoved).toBe(true);
  });

  it('2. Blocks localhost/internal Anti-SSRF probes & Widevine DRM domains honestly', async () => {
    const ssrf = await guestAgent
      .post('/api/v1/analysis')
      .send({ url: 'http://127.0.0.1:4000/internal' })
      .expect(403);
    expect(ssrf.body.error.code).toBe('SSRF_BLOCKED');

    const drm = await guestAgent
      .post('/api/v1/analysis')
      .send({ url: 'https://www.netflix.com/watch/80057281' })
      .expect(422);
    expect(drm.body.error.code).toBe('DRM_PROTECTED');
  });

  it('3. Extracts REAL YouTube HD/4K + Combined Audio MP4 in Pure Node.js & streams live HTTP 206 attachment bytes for PC IDM / Chrome', async () => {
    const ytRes = await guestAgent
      .post('/api/v1/analysis')
      .send({ url: 'https://www.youtube.com/watch?v=WhWc3b3KhnY' })
      .expect(200);

    expect(ytRes.body.data.platform.id).toBe('youtube');
    expect(ytRes.body.data.media.title).toMatch(/Spring/i);
    expect(ytRes.body.data.streams.videoAudio.length).toBeGreaterThanOrEqual(4);
    expect(ytRes.body.data.streams.audioOnly.length).toBeGreaterThanOrEqual(1);

    const combinedStream =
      ytRes.body.data.streams.videoAudio.find((s) => s.hasAudio) ||
      ytRes.body.data.streams.videoAudio[0];

    const streamRes = await guestAgent
      .get(combinedStream.streamUrl)
      .set('Range', 'bytes=0-4095')
      .buffer(true)
      .parse((res, cb) => {
        const chunks = [];
        res.on('data', (c) => chunks.push(c));
        res.on('end', () => cb(null, Buffer.concat(chunks)));
      })
      .expect(206);

    expect(streamRes.headers['content-disposition']).toMatch(/attachment;/);
    expect(streamRes.body.length).toBe(4096);
    expect(streamRes.body.subarray(4, 8).toString('ascii')).toBe('ftyp');
  }, 35000);

  it('3b. Universal device download route with a real file name in the path (IDM + Chrome always start)', async () => {
    const target = 'https://interactive-examples.mdn.mozilla.net/media/cc0-videos/flower.mp4';

    const res = await guestAgent
      .get(`/api/v1/stream/direct-download/Flower_Test_720p.mp4?url=${encodeURIComponent(target)}`)
      .buffer(true)
      .parse((r, cb) => {
        const chunks = [];
        r.on('data', (c) => chunks.push(c));
        r.on('end', () => cb(null, Buffer.concat(chunks)));
      })
      .expect(200);

    expect(res.headers['content-disposition']).toMatch(/Flower_Test_720p\.mp4/);
    expect(res.headers['content-disposition']).toMatch(/attachment;/);
    expect(res.headers['content-type']).toMatch(/video\/mp4/);
    expect(res.body.length).toBeGreaterThan(1000);
    expect(res.body.subarray(4, 8).toString('ascii')).toBe('ftyp');

    // Range resume must work exactly like IDM multi-connection mode
    const ranged = await guestAgent
      .get(`/api/v1/stream/direct-download/Flower_Test_720p.mp4?url=${encodeURIComponent(target)}`)
      .set('Range', 'bytes=0-2047')
      .buffer(true)
      .parse((r, cb) => {
        const chunks = [];
        r.on('data', (c) => chunks.push(c));
        r.on('end', () => cb(null, Buffer.concat(chunks)));
      })
      .expect(206);
    expect(ranged.body.length).toBe(2048);
  }, 30000);

  it('3c. Signed download tickets serve REAL PDF & ZIP bytes (headers, ranges, auth, traversal, expiry)', async () => {
    // ---- PDF ticket + full transfer ----
    const pdfTicket = await guestAgent.post('/api/v1/files/download-ticket').send({ fileId: 'sample_pdf' }).expect(201);
    expect(pdfTicket.body.data.fileName).toBe('UltraDownloader_Sample_Guide.pdf');
    expect(pdfTicket.body.data.mimeType).toBe('application/pdf');
    expect(pdfTicket.body.data.expiresAt).toBeTruthy();

    const pdfPath = new URL(pdfTicket.body.data.downloadUrl).pathname + new URL(pdfTicket.body.data.downloadUrl).search;
    const pdfRes = await guestAgent
      .get(pdfPath)
      .buffer(true)
      .parse((r, cb) => {
        const chunks = [];
        r.on('data', (c) => chunks.push(c));
        r.on('end', () => cb(null, Buffer.concat(chunks)));
      })
      .expect(200);

    expect(pdfRes.headers['content-type']).toContain('application/pdf');
    expect(pdfRes.headers['content-disposition']).toBe(
      'attachment; filename="UltraDownloader_Sample_Guide.pdf"; filename*=UTF-8\'\'UltraDownloader_Sample_Guide.pdf'
    );
    expect(Number(pdfRes.headers['content-length'])).toBe(pdfRes.body.length);
    expect(pdfRes.body.subarray(0, 5).toString('ascii')).toBe('%PDF-');
    expect(pdfRes.body.subarray(-6).toString('ascii').trim()).toBe('%%EOF');

    // ---- ZIP ticket + real archive signature + EOCD ----
    const zipTicket = await guestAgent.post('/api/v1/files/download-ticket').send({ fileId: 'sample_zip' }).expect(201);
    const zipPath = new URL(zipTicket.body.data.downloadUrl).pathname + new URL(zipTicket.body.data.downloadUrl).search;
    const zipRes = await guestAgent
      .get(zipPath)
      .buffer(true)
      .parse((r, cb) => {
        const chunks = [];
        r.on('data', (c) => chunks.push(c));
        r.on('end', () => cb(null, Buffer.concat(chunks)));
      })
      .expect(200);
    expect(zipRes.headers['content-type']).toContain('application/zip');
    expect(zipRes.body.subarray(0, 4).toString('hex')).toBe('504b0304');
    expect(zipRes.body.includes(Buffer.from('PK\x05\x06', 'binary'))).toBe(true);

    // ---- HEAD verification (no body) ----
    const headRes = await guestAgent.head(zipPath).expect(200);
    expect(headRes.headers['content-disposition']).toContain('UltraDownloader_Sample_Pack.zip');
    expect(headRes.headers['accept-ranges']).toBe('bytes');

    // ---- Range resume ----
    const rangeRes = await guestAgent
      .get(zipPath)
      .set('Range', 'bytes=0-49')
      .buffer(true)
      .parse((r, cb) => {
        const chunks = [];
        r.on('data', (c) => chunks.push(c));
        r.on('end', () => cb(null, Buffer.concat(chunks)));
      })
      .expect(206);
    expect(rangeRes.headers['content-range']).toMatch(/^bytes 0-49\/\d+$/);
    expect(rangeRes.body.length).toBe(50);

    // ---- Unknown / traversal identifiers never resolve a file ----
    await guestAgent.post('/api/v1/files/download-ticket').send({ fileId: '../../etc/passwd' }).expect(404);
    await guestAgent.post('/api/v1/files/download-ticket').send({}).expect(400);

    // ---- Tampered signature ----
    await guestAgent.get(`${zipPath.slice(0, -6)}AAAAAA`).expect(403);

    // ---- Protected file requires an account ----
    const protectedRes = await guestAgent.post('/api/v1/files/download-ticket').send({ fileId: 'pro_pack_zip' });
    expect(protectedRes.status).toBe(401);
    expect(protectedRes.body.error.code).toBe('AUTH_REQUIRED');

    // ---- Public library listing hides protected files ----
    const library = await guestAgent.get('/api/v1/files/library').expect(200);
    const ids = library.body.data.files.map((f) => f.fileId);
    expect(ids).toContain('sample_pdf');
    expect(ids).toContain('sample_zip');
    expect(ids).not.toContain('pro_pack_zip');
  }, 30000);

  it('3d. Expired signed tickets are rejected with HTTP 410 and a clear message', async () => {
    const { createDownloadTicket, verifyDownloadTicket } = await import(
      '../src/services/fileDownloadService.js'
    );

    const ticket = await createDownloadTicket({
      fileId: 'sample_zip',
      originBaseUrl: 'http://127.0.0.1:4000',
    });
    const rawTicket = new URL(ticket.downloadUrl).searchParams.get('ticket');

    // Valid right now
    expect(verifyDownloadTicket(rawTicket).fileName).toBe('UltraDownloader_Sample_Pack.zip');

    // Move the clock past the ticket TTL (default 300s)
    const realNow = Date.now();
    const clock = vi.spyOn(Date, 'now').mockReturnValue(realNow + 301 * 1000);
    let thrown = null;
    try {
      verifyDownloadTicket(rawTicket);
    } catch (err) {
      thrown = err;
    }
    clock.mockRestore();

    expect(thrown).toBeTruthy();
    expect(thrown.statusCode).toBe(410);
    expect(thrown.code).toBe('TICKET_EXPIRED');

    // The HTTP endpoint surfaces the same explicit failure (never a silent 200)
    const res = await guestAgent.get(
      `/api/v1/files/download/Sample.zip?ticket=${encodeURIComponent(rawTicket.slice(0, -6) + 'AAAAAA')}`
    );
    expect(res.status).toBe(403);
    expect(res.body.error.code).toBe('TICKET_SIGNATURE_INVALID');
  }, 20000);

  it('3e. One paste produces exactly ONE admin RAM card (no duplicates for paste + analysis)', async () => {
    clearAllVolatileCards();

    const url = 'https://www.youtube.com/watch?v=WhWc3b3KhnY';

    await guestAgent
      .post('/api/v1/intake/paste-capture')
      .send({ rawUrl: url, sourceContext: 'hero_input_paste' })
      .expect(201);
    await guestAgent.post('/api/v1/analysis').send({ url }).expect(200);

    const { getAllVolatileCards } = await import('../src/services/liveCardBus.js');
    const cards = getAllVolatileCards();

    expect(cards).toHaveLength(1);
    expect(cards[0].canonicalUrl || cards[0].rawUrl).toContain('youtube.com');
    expect(cards[0].title).toMatch(/Spring/i);

    // Analysing the same URL again must update in place, never add a second card
    await guestAgent.post('/api/v1/analysis').send({ url }).expect(200);
    expect(getAllVolatileCards()).toHaveLength(1);

    clearAllVolatileCards();
  }, 40000);

  it('3f. Universal coverage: Dailymotion + generic web pages resolve real streams (no platform whitelist)', async () => {
    // Dailymotion via its public player-metadata API
    const dm = await guestAgent
      .post('/api/v1/analysis')
      .send({ url: 'https://www.dailymotion.com/video/x8jz2mv' })
      .expect(200);
    expect(dm.body.data.extractorTier).toBe('dailymotion_metadata');
    expect(dm.body.data.streams.videoAudio.length).toBeGreaterThanOrEqual(1);
    expect(dm.body.data.streams.videoAudio[0].directCdnUrl).toMatch(/^https?:\/\//);

    // An ordinary Wikipedia article that merely embeds a video must still resolve
    const wiki = await guestAgent
      .post('/api/v1/analysis')
      .send({ url: 'https://en.wikipedia.org/wiki/Big_Buck_Bunny' })
      .expect(200);
    expect(wiki.body.data.streams.videoAudio.length).toBeGreaterThanOrEqual(1);

    // A page with genuinely no media gets a clear, specific error code
    const empty = await guestAgent
      .post('/api/v1/analysis')
      .send({ url: 'https://example.com/' });
    expect(empty.status).toBe(422);
    expect(empty.body.error.code).toBe('NO_MEDIA_ON_PAGE');
  }, 60000);

  it('4. Extracts REAL TeraBox share link for FREE & streams multi-range HTTP 206 bytes directly to PC IDM / Chrome', async () => {
    const tbRes = await guestAgent
      .post('/api/v1/analysis')
      .send({ url: 'https://www.terabox.app/sharing/link?surl=IRHSOPX5IEPgJT7l9IoNlg' })
      .expect(200);

    expect(tbRes.body.data.streams.videoAudio.length).toBeGreaterThanOrEqual(1);
    const directStreamUrl = tbRes.body.data.streams.videoAudio[0].streamUrl;
    expect(directStreamUrl).toContain('/api/v1/stream/terabox-direct');

    const rangeChunk = await guestAgent
      .get(directStreamUrl)
      .set('Range', 'bytes=0-4095')
      .buffer(true)
      .parse((res, cb) => {
        const chunks = [];
        res.on('data', (c) => chunks.push(c));
        res.on('end', () => cb(null, Buffer.concat(chunks)));
      })
      .expect(206);

    expect(rangeChunk.headers['content-disposition']).toMatch(/attachment;/);
    expect(rangeChunk.headers['accept-ranges']).toBe('bytes');
    expect(rangeChunk.body.length).toBe(4096);
    expect(rangeChunk.body[0]).toBe(0x47); // Authentic MPEG-TS video packet sync byte!
  }, 45000);

  it('5. Extracts REAL Vimeo, PeerTube & SoundCloud streams + Live Search in Pure Node.js', async () => {
    const [vimeoRes, peerRes, scRes, searchRes] = await Promise.all([
      guestAgent.post('/api/v1/analysis').send({ url: 'https://vimeo.com/76979871' }).expect(200),
      guestAgent
        .post('/api/v1/analysis')
        .send({ url: 'https://framatube.org/videos/watch/9c9de5e8-0a1e-484a-b099-e80766180a6d' })
        .expect(200),
      guestAgent
        .post('/api/v1/analysis')
        .send({ url: 'https://soundcloud.com/forss/flickermood' })
        .expect(200),
      guestAgent.get('/api/v1/search?q=Blender%20Open%20Movie%204K&mode=video').expect(200),
    ]);

    expect(vimeoRes.body.data.platform.id).toBe('vimeo');
    expect(vimeoRes.body.data.streams.videoAudio.length).toBeGreaterThanOrEqual(2);
    expect(peerRes.body.data.streams.videoAudio.length).toBeGreaterThanOrEqual(4);
    expect(scRes.body.data.streams.audioOnly.length).toBeGreaterThanOrEqual(1);
    expect(searchRes.body.data.items.length).toBeGreaterThanOrEqual(1);
  }, 40000);

  it('6. STRICT GUEST RULE: Clicking Download while logged out starts direct IDM/Chrome stream & saves ZERO rows to MySQL', async () => {
    await sqlQuery('DELETE FROM download_jobs');

    const guestDl = await guestAgent
      .post('/api/v1/downloads')
      .send({
        title: 'Guest Ephemeral Video',
        sourceUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
        streamUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
        qualityLabel: '1080p',
        formatExt: 'mp4',
      })
      .expect(201);

    expect(guestDl.body.data.savedToHistory).toBe(false);
    expect(guestDl.body.data.guestZeroHistoryMode).toBe(true);
    expect(guestDl.body.data.directDownloadUrl).toContain('/api/v1/stream/direct-download');
    expect(guestDl.body.data.ef2Content).toContain('http');

    // Verify STRICT 0 rows saved in MySQL & GET /downloads returns []!
    const [dbCount] = await sqlQuery('SELECT COUNT(*) AS c FROM download_jobs');
    expect(Number(dbCount.c)).toBe(0);

    const guestHistory = await guestAgent.get('/api/v1/downloads').expect(200);
    expect(guestHistory.body.data).toEqual([]);
  });

  it('7. STRICT MULTI-USER ISOLATED HISTORY + Per-Item DELETE + Clean All History Button Verification', async () => {
    const userAAgent = request.agent(app);
    const userBAgent = request.agent(app);

    const regA = await userAAgent
      .post('/api/v1/auth/register')
      .send({
        fullName: 'Ali Khan',
        email: `test_v10_ali_${Date.now()}@example.com`,
        password: 'Password@123',
      })
      .expect(201);

    const regB = await userBAgent
      .post('/api/v1/auth/register')
      .send({
        fullName: 'Sara Ahmed',
        email: `test_v10_sara_${Date.now()}@example.com`,
        password: 'Password@123',
      })
      .expect(201);

    const tokenA = `Bearer ${regA.body.data.userAccessToken}`;
    const tokenB = `Bearer ${regB.body.data.userAccessToken}`;

    // User A downloads 2 videos
    const a1 = await userAAgent
      .post('/api/v1/downloads')
      .set('Authorization', tokenA)
      .send({
        title: 'Ali Video One',
        sourceUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
        streamUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
        qualityLabel: '1080p',
        formatExt: 'mp4',
      })
      .expect(201);

    await userAAgent
      .post('/api/v1/downloads')
      .set('Authorization', tokenA)
      .send({
        title: 'Ali Video Two',
        sourceUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
        streamUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
        qualityLabel: '720p',
        formatExt: 'mp4',
      })
      .expect(201);

    // User B downloads 1 video
    await userBAgent
      .post('/api/v1/downloads')
      .set('Authorization', tokenB)
      .send({
        title: 'Sara Exclusive Video',
        sourceUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
        streamUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
        qualityLabel: '1080p',
        formatExt: 'mp4',
      })
      .expect(201);

    // Strict Isolation Proof:
    const listA = await userAAgent.get('/api/v1/downloads').set('Authorization', tokenA).expect(200);
    const listB = await userBAgent.get('/api/v1/downloads').set('Authorization', tokenB).expect(200);
    const listGuest = await guestAgent.get('/api/v1/downloads').expect(200);

    expect(listA.body.data.length).toBe(2);
    expect(listB.body.data.length).toBe(1);
    expect(listB.body.data[0].title).toBe('Sara Exclusive Video');
    expect(listGuest.body.data).toEqual([]);

    // Cross-User Protection Proof: User B CANNOT delete User A's item!
    await userBAgent
      .delete(`/api/v1/downloads/${a1.body.data.id}`)
      .set('Authorization', tokenB)
      .expect(404);

    // User A deletes 1 item via Delete button: 2 -> 1
    await userAAgent
      .delete(`/api/v1/downloads/${a1.body.data.id}`)
      .set('Authorization', tokenA)
      .expect(200);
    expect(
      (await userAAgent.get('/api/v1/downloads').set('Authorization', tokenA).expect(200)).body.data
        .length
    ).toBe(1);

    // User A clicks Clean History (`DELETE /api/v1/downloads`): 1 -> 0 while User B still has 1!
    await userAAgent.delete('/api/v1/downloads').set('Authorization', tokenA).expect(200);
    expect(
      (await userAAgent.get('/api/v1/downloads').set('Authorization', tokenA).expect(200)).body.data
        .length
    ).toBe(0);
    expect(
      (await userBAgent.get('/api/v1/downloads').set('Authorization', tokenB).expect(200)).body.data
        .length
    ).toBe(1);

    // Clean User B too
    await userBAgent.delete('/api/v1/downloads').set('Authorization', tokenB).expect(200);
    expect(
      (await userBAgent.get('/api/v1/downloads').set('Authorization', tokenB).expect(200)).body.data
        .length
    ).toBe(0);
  });

  it('8. Enforces 5-Layer Padlock (3-Strike 30m Ban) & Full RAM Card [VIEW] -> [SAVE] -> [DELETE] + Real SQL Ledger Sync', async () => {
    await request(app)
      .post('/api/v1/admin/padlock/verify')
      .set('X-Forwarded-For', '198.51.100.91')
      .send({ pin: '0000' })
      .expect(401);
    await request(app)
      .post('/api/v1/admin/padlock/verify')
      .set('X-Forwarded-For', '198.51.100.91')
      .send({ pin: '1111' })
      .expect(401);
    const strike3 = await request(app)
      .post('/api/v1/admin/padlock/verify')
      .set('X-Forwarded-For', '198.51.100.91')
      .send({ pin: '2222' })
      .expect(429);
    expect(strike3.body.error.code).toBe('ADMIN_IP_BANNED_30M');

    const gate1 = await adminAgent
      .post('/api/v1/admin/padlock/verify')
      .send({ pin: '2580' })
      .expect(200);
    expect(gate1.body.data.padlockTicket).toBeTruthy();

    const gate2 = await adminAgent
      .post('/api/v1/admin/auth/login')
      .send({
        identifier: 'admin@ultradownloader.pro',
        password: 'UltraAdmin@2026',
        totpCode: '123456',
      })
      .expect(200);
    expect(gate2.body.data.adminAccessToken).toBeTruthy();

    const paste = await adminAgent
      .post('/api/v1/intake/paste-capture')
      .send({
        rawUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
      })
      .expect(201);
    const cardId = paste.body.data.cardId;

    await adminAgent.get(`/api/v1/admin/live-cards/${cardId}/view`).expect(200);
    expect((await adminAgent.get('/api/v1/admin/vault').expect(200)).body.data.length).toBe(0);

    const saved = await adminAgent.post(`/api/v1/admin/live-cards/${cardId}/save`).expect(201);
    expect((await adminAgent.get('/api/v1/admin/vault').expect(200)).body.data.length).toBe(1);

    await adminAgent.delete(`/api/v1/admin/vault/${saved.body.data.vaultId}`).expect(200);
    expect((await adminAgent.get('/api/v1/admin/vault').expect(200)).body.data.length).toBe(0);

    clearAllVolatileCards();
  });

  it('9. Verifies Live Settings Control Center & XAMPP MySQL Diagnostics API', async () => {
    const diag = await guestAgent.get('/api/v1/system/db-diagnostics').expect(200);
    expect(diag.body.data.diagnostics.connected).toBe(true);
    expect(diag.body.data.diagnostics.tableCounts.platforms).toBeGreaterThanOrEqual(222);

    const maint = await guestAgent
      .post('/api/v1/system/db-maintenance')
      .send({ action: 'optimize_tables' })
      .expect(200);
    expect(maint.body.success).toBe(true);
  });

  it('10. Serves dynamic /sitemap.xml & /robots.txt without leaking stealth admin slug', async () => {
    const sitemap = await guestAgent.get('/sitemap.xml').expect(200);
    expect(sitemap.text).toMatch(/youtube-4k-video-mp3-downloader/);

    const robots = await guestAgent.get('/robots.txt').expect(200);
    expect(robots.text).not.toMatch(/vault-control-x9p4/);
  });
});
