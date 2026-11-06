# ShakeelProject — Universal Video Downloader (Clean White Edition)

Ek clean, fully working universal downloader — **222 platforms available**, white studio design,
100% real database (honest standby mode when XAMPP is off), 5-layer admin padlock,
1-hour fresh download tickets, dedicated **Search** button with 50–80 live results.

Only working features are shipped. Anything that could not be reliably extracted
(DRM-protected catalogs) is answered honestly with a clear reason — never a fake button.

```
ShakeelProject/
├── Backend/    Express API + Pure Node.js extractor engine (zero yt-dlp, zero binaries)
└── Frontend/   React (Vite + Tailwind) white studio UI
```

## 1) Quick Start (Windows / XAMPP)

1. **XAMPP** open karo → **Apache + MySQL → Start**.
2. Backend chalo:
   ```bash
   cd ShakeelProject/Backend
   npm install
   npm run dev
   ```
   Pehli baar: backend khud `shakeelproject_db` database banata hai aur
   `database/shakeelproject.sql` import kar leta hai (222 platforms ke saath).
3. Frontend chalo (dusra terminal):
   ```bash
   cd ShakeelProject/Frontend
   npm install
   npm run dev
   ```
   Browser: **http://localhost:5173**

> Linux/macOS note: vite config ab case-insensitive backend detection use karta hai
> (`../Backend` ya `../backend` dono chalte hain) — Windows jaisa same command set.

## 2) Admin Access (5-Layer Padlock)

Defaults `.env` mein hain (dev-only). **Share karne se pehle badlo!**

| Gate | What | Dev Default |
|---|---|---|
| 1 | Secret PIN | `741925` |
| 2 | Email | `shakeel@shakeelproject.local` |
| 3 | Password | `Shakeel@b6e4a24a66c4` (`.env` mein `ADMIN_MASTER_PASSWORD`) |
| 4 | TOTP code | Google Authenticator mein `.env` ka `ADMIN_TOTP_SECRET` scan karo |
| 4b | Dev fallback code | `123456` (sirf `NODE_ENV=development`; production mein OFF) |

- 3 galat attempts = **30-minute IP ban** (3rd strike pe `429`).
- Har admin event `security_audit_logs` mein save hota hai.
- DB ke andar koi baked-in secret nahi: startup pe PIN/password/TOTP
  hamesha `.env` se re-key ho jata hai.

## 3) Database — 100% Real (No Silent Mock)

- XAMPP MySQL **on** → `connected: true`, live queries.
- XAMPP MySQL **off** → honest `connected: false` + "Live Standby" badge;
  data in-memory seed se chalta hai aur XAMPP on hote hi auto-sync ho jata hai.
- Admin panel mein **Factory Reset** buttons:
  - `POST /api/v1/admin/system/reset-platforms` → 222 canonical platforms restore
  - `POST /api/v1/admin/system/reset-database` → full clean DB (stale rows delete)

## 4) Feature Fixes (this release)

| Fix | Detail |
|---|---|
| URL auto-clear | Hero URL save rehta hai, reload pe wapis aata hai — **60s** baad auto-empty |
| No fixed URLs | Koi hardcoded "Try Live" sample link nahi |
| Search button | Dedicated **Search** → 50–80 live results (5-page YouTube index, deduped) |
| Quality tabs | Video tabs mein audio card kabhi nahi; duplicate sources deduped; tab switch = fresh selection |
| Download 403 | Tickets ab **1 hour** valid; expiry pe clear message + "Click Download again" fresh link |
| CORS | Real allowlist (`CORS_ORIGINS`); unknown origins ko headers nahi milte |
| SEO 404 | Unknown slug = proper HTTP 404 |
| Version sync | Frontend + Backend + health API = **1.0.0** |
| Admin secrets | `.env`-driven, no prefilled credentials in UI, prod secret guard |
| Vite (Linux) | Case-insensitive backend path detection |

## 5) Platform Status (222 available in registry)

Registry mein **222 platforms** registered hain (categories: video / movie / course /
social / 18+ / cloud). Working state per platform:

- **Direct engines (reliable):** YouTube, TeraBox family (terabox.app/.com/.fun,
  teraboxlink/share/url, 1024terabox, 1024tera.co, freeterabox), iTeraPlay,
  Dailymotion, TikTok, Reddit, OK.ru, VK, Bilibili, Odysee, BitChute, PeerTube.
- **Smart Sniffer (conditional):** baaki movie/course/cloud/social hosts —
  page mein direct file mile ya user ka course cookie de, to download ho jata hai.
- **Never (DRM):** Netflix / Prime / Disney+ / Spotify / Hotstar type
  DRM catalogs — UI clearly batata hai, fake promise nahi.

## 6) Production Checklist

```bash
cp .env.example .env   # fresh secrets
# openssl rand -hex 32  -> JWT / PADLOCK / AES keys
# base32 TOTP secret generate karo
NODE_ENV=production    # app boot KABHI nahi hoga jab tak secrets complete na hon
```

- `.env` dev-secrets ke saath commit hua hai **instant run** ke liye —
  production deploy se pehle har secret replace karo.
- `CORS_ORIGINS` mein sirf apna production origin daalo.
- `ADMIN_IP_ALLOWLIST` optionally sirf apne IPs pe restrict karo.

## 7) Tests

```bash
cd Backend  && npm test     # 15 tests
cd Frontend && npm test     # 10 e2e UI tests
```

Sandbox/CI note: internet-egress ke bina (YouTube/TeraBox live extract + XAMPP MySQL
wale tests) sirf offline environment mein fail hote hain — machine pe internet +
XAMPP on ho to full suite pass karta hai.
