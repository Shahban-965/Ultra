// ============================================================================
// ULTRADOWNLOADER V8.0 — COMPLETE 222-PLATFORM MULTI-DOMAIN REGISTRY
// - Social Media:       22 Supported Platforms
// - Video & Movies:     34 Supported Platforms (All 17 User Movie Portals + 17 Global)
// - Courses & Lectures: 32 Supported Platforms (Free Open + Enrolled Cookie Auth)
// - TeraBox & Cloud:    32 Supported Platforms (All 22 TeraBox/iTeraPlay/ViralHub Mirrors + 10 Cloud)
// - 18+ Adult Vault:   102 Supported Platforms (USA Direct + PK ISP-Bypass Ready)
// TOTAL = 222 DISTINCT ACTIVE PLATFORMS!
// ============================================================================

function p(id, displayName, subtitle, category, accentColor, iconKey, domains, extra = {}) {
  const firstDomain = domains[0] || 'example.com';
  return {
    id,
    displayName,
    subtitle,
    category,
    accentColor,
    iconKey,
    iconSvg: '',
    domains,
    exampleUrl: extra.exampleUrl || `https://${firstDomain}/`,
    seoSlug: extra.seoSlug || `${id.replace(/_/g, '-')}-video-downloader`,
    isAdult: category === 'adult_18',
    supportsSearch: Boolean(extra.supportsSearch),
    regionNote: extra.regionNote || 'Global',
    authHint: extra.authHint || 'free_direct',
  };
}

// 1. SOCIAL MEDIA (22 PLATFORMS)
const SOCIAL_PLATFORMS = [
  p('youtube', 'YouTube', '8K/4K 60FPS · Shorts · 320kbps MP3', 'social', '#FF0033', 'youtube', ['youtube.com/watch', 'youtu.be', 'm.youtube.com'], { supportsSearch: true, exampleUrl: 'https://www.youtube.com/watch?v=WhWc3b3KhnY', seoSlug: 'youtube-4k-video-mp3-downloader' }),
  p('youtube_shorts', 'YouTube Shorts', 'Vertical 1080p60 HD Shorts & MP3', 'social', '#FF2E54', 'shorts', ['youtube.com/shorts'], { supportsSearch: true }),
  p('tiktok', 'TikTok', 'No-Watermark Full HD Video & MP3', 'social', '#25F4EE', 'tiktok', ['tiktok.com', 'vm.tiktok.com', 'vt.tiktok.com']),
  p('instagram', 'Instagram', 'Reels · Stories · Carousel Video HD', 'social', '#DD2A7B', 'instagram', ['instagram.com', 'instagr.am']),
  p('facebook', 'Facebook Watch', 'Public & Private Reels · Watch 1080p', 'social', '#1877F2', 'facebook', ['facebook.com', 'fb.watch', 'fb.com']),
  p('twitter_x', 'X (Twitter)', 'HD Post Videos · Spaces & GIFs', 'social', '#38BDF8', 'x', ['x.com', 'twitter.com', 't.co']),
  p('reddit', 'Reddit Video', 'Auto Video + Audio FFmpeg MP4 Mux', 'social', '#FF4500', 'reddit', ['reddit.com', 'redd.it', 'v.redd.it']),
  p('pinterest', 'Pinterest', 'Video Pins & Story Pins HD MP4', 'social', '#E60023', 'pinterest', ['pinterest.com', 'pin.it']),
  p('snapchat', 'Snapchat Spotlight', 'Public Spotlight & Story Video Saver', 'social', '#FFFC00', 'spark', ['snapchat.com']),
  p('linkedin', 'LinkedIn Video', 'Native Post & Event Video Extractor', 'social', '#0A66C2', 'linkedin', ['linkedin.com/posts', 'linkedin.com/feed']),
  p('threads', 'Meta Threads', 'Threads HD Video & Voice Clips', 'social', '#A855F7', 'spark', ['threads.net']),
  p('telegram', 'Telegram Public', 'Public Channel Video Media Streamer', 'social', '#229ED9', 'telegram', ['t.me']),
  p('vk_video', 'VK Video', 'Full HD 1080p/4K Social Clips', 'social', '#0077FF', 'vimeo', ['vk.com', 'vkvideo.ru']),
  p('tumblr', 'Tumblr Media', 'Dashboard HD MP4 & Loops Extractor', 'social', '#36465D', 'vimeo', ['tumblr.com']),
  p('bluesky', 'Bluesky Social', 'ATProto Native HLS/MP4 Video Saver', 'social', '#0285FF', 'vimeo', ['bsky.app']),
  p('rednote', 'RedNote (Xiaohongshu)', 'No-Watermark HD Lifestyle Videos', 'social', '#FF2442', 'pinterest', ['xiaohongshu.com', 'xhslink.com']),
  p('lemon8', 'Lemon8 Video', 'HD Creator Reels & Tutorials', 'social', '#FACC15', 'spark', ['lemon8-app.com']),
  p('kwai', 'SnackVideo / Kwai', 'No-Watermark Short Video Saver PK', 'social', '#FF7700', 'play', ['kwai.com', 'snackvideo.com']),
  p('likee', 'Likee Video', 'Short Vertical HD MP4 Downloader', 'social', '#EC4899', 'play', ['likee.video']),
  p('weibo', 'Weibo Video', 'HD Social Stream & Live Replay MP4', 'social', '#E6162D', 'reddit', ['weibo.com', 'weibo.cn']),
  p('douyin', 'Douyin HD', 'Original 1080p60 Short Stream Saver', 'social', '#14B8A6', 'tiktok', ['douyin.com']),
  p('mastodon', 'Mastodon Social', 'Federated ActivityPub MP4 Extractor', 'social', '#6364FF', 'globe', ['mastodon.social']),
];

// 2. VIDEO & MOVIES (34 PLATFORMS — ALL 17 USER MOVIE SITES + 17 GLOBAL STREAMING SITES)
const VIDEO_MOVIE_PLATFORMS = [
  p('justwatch', 'JustWatch Movies', 'Trailers, Previews & Free Stream Links', 'video', '#FACC15', 'play', ['justwatch.com'], { exampleUrl: 'https://www.justwatch.com/in/movies' }),
  p('fmoviesse', 'FMovies SE', 'Deep Embed & HLS Movie Stream Sniffer', 'video', '#00ACC1', 'vimeo', ['fmoviesse.net'], { regionNote: 'PK/Global' }),
  p('myfreemovies', 'MyFreeMovies', 'Embedded MP4 & M3U8 Movie Extractor', 'video', '#10B981', 'vimeo', ['myfreemovies.site'], { regionNote: 'PK/Global' }),
  p('rottentomatoes', 'Rotten Tomatoes', '4K/1080p Movie Trailers & Teasers', 'video', '#FA320A', 'play', ['rottentomatoes.com']),
  p('hotsflix', 'HotsFlix', 'HD HLS & Embed Stream Extractor', 'video', '#EF4444', 'vimeo', ['hotsflix.net']),
  p('fmovies_org', 'FMovies Org', 'Multi-Server HLS/MP4 Movie Sniffer', 'video', '#0EA5E9', 'vimeo', ['fmovies-co.org']),
  p('fawesome_tv', 'Fawesome TV', 'Free Full Movies & TV Shows HLS', 'video', '#F97316', 'play', ['fawesome.tv']),
  p('shemaroome', 'ShemarooMe Free', 'Free Bollywood & Classic Hindi Movies', 'video', '#E11D48', 'play', ['shemaroome.com']),
  p('watch_movies_pk_2025', 'Watch-Movies PK (2025)', 'Indian & Bollywood HD Embed Extractor', 'video', '#22C55E', 'play', ['watch-movies.com.pk/category/'], { regionNote: 'Pakistan Hub' }),
  p('watch_movies_pk', 'Watch-Movies.com.pk', 'Pakistani & South Asian Movie Portal', 'video', '#16A34A', 'play', ['watch-movies.com.pk'], { regionNote: 'Pakistan Hub' }),
  p('movies123_go4u', '123MoviesGo4U', 'Fast Iframe & M3U8 Movie Sniffer', 'video', '#84CC16', 'vimeo', ['123moviesgo4u.com']),
  p('mewatch_sg', 'mewatch Movies', 'Free Non-DRM Asian Movies & Series', 'video', '#A855F7', 'vimeo', ['mewatch.sg']),
  p('onlinemovies7', 'OnlineMovies7', 'Direct & Embedded HD Movie Extractor', 'video', '#06B6D4', 'vimeo', ['onlinemovies7.info']),
  p('tubi_tv', 'Tubi TV Free', 'Free Ad-Supported Movies (Non-DRM)', 'video', '#F59E0B', 'play', ['tubi.tv', 'gdpr.tubi.tv']),
  p('moviesfoundonline', 'MoviesFoundOnline', 'Free Public Domain & Indie Full Films', 'video', '#3B82F6', 'play', ['moviesfoundonline.com']),
  p('media_io_movies', 'Media.io Movie Hub', 'Web Media & Stream Link Extractor', 'video', '#8B5CF6', 'globe', ['media.io']),
  p('sunnxt_free', 'Sun NXT Free', 'Free South Indian Movies & Clips', 'video', '#EA580C', 'play', ['sunnxt.com']),
  p('vimeo', 'Vimeo 4K', '4K/1080p Player Bypass + Subtitles', 'video', '#1AB7EA', 'vimeo', ['vimeo.com', 'player.vimeo.com'], { exampleUrl: 'https://vimeo.com/76979871' }),
  p('dailymotion', 'Dailymotion HD', '1080p60 HLS & MP4 Movie/Drama Saver', 'video', '#00AAFF', 'dailymotion', ['dailymotion.com', 'dai.ly']),
  p('twitch', 'Twitch VOD & Clips', '1080p60 Stream VODs & Highlights', 'video', '#9146FF', 'twitch', ['twitch.tv', 'clips.twitch.tv']),
  p('kick', 'Kick Streams', 'Full HD Live Replays & Stream Clips', 'video', '#53FC18', 'kick', ['kick.com']),
  p('rumble', 'Rumble 4K', 'Uncensored 4K/1080p MP4 Video Saver', 'video', '#85C742', 'rumble', ['rumble.com']),
  p('bilibili', 'Bilibili Anime & Film', '1080p Anime, Donghua & Cinema Muxer', 'video', '#00A1D6', 'vimeo', ['bilibili.com', 'bilibili.tv']),
  p('odysee', 'Odysee Cinema', 'Decentralized Full-Length MP4 Streams', 'video', '#F2416B', 'odysee', ['odysee.com']),
  p('bitchute', 'BitChute Video', 'Direct MP4 Channel Stream Extractor', 'video', '#EF4136', 'play', ['bitchute.com']),
  p('archive_cinema', 'Internet Archive Films', '10,000+ Full Classic Movies MP4/MKV', 'video', '#64748B', 'globe', ['archive.org/details'], { exampleUrl: 'https://archive.org/details/BigBuckBunny_124' }),
  p('ok_ru_movies', 'OK.ru Full Movies', 'Popular Hindi/Urdu Dubbed HD Movies', 'video', '#EE8208', 'play', ['ok.ru', 'odnoklassniki.ru'], { regionNote: 'PK Popular' }),
  p('soundcloud', 'SoundCloud Studio', '320kbps MP3 & Native M4A Audio Engine', 'video', '#FF5500', 'play', ['soundcloud.com'], { exampleUrl: 'https://soundcloud.com/forss/flickermood' }),
  p('peertube', 'PeerTube / Framatube', 'Multi-Resolution 240p–1080p Fast MP4', 'video', '#F1680D', 'play', ['framatube.org', 'tilvids.com'], { exampleUrl: 'https://framatube.org/videos/watch/9c9de5e8-0a1e-484a-b099-e80766180a6d' }),
  p('plex_free', 'Plex Free Movies', 'Non-DRM Free Trailers & Web Streams', 'video', '#E5A00D', 'play', ['watch.plex.tv', 'plex.tv']),
  p('pluto_tv', 'Pluto TV Clips', 'Free Non-DRM Channels & VOD Clips', 'video', '#FDE047', 'play', ['pluto.tv']),
  p('mx_player', 'MX Player Free', 'Free Hindi Web Series & Movie Streams', 'video', '#0284C7', 'play', ['mxplayer.in']),
  p('ary_zap_pk', 'Pakistani Drama Portals', 'ARY / Hum / Geo Web Embed Extractor', 'video', '#10B981', 'play', ['aryzap.com', 'hum.tv', 'harpalgeo.tv'], { regionNote: 'Pakistan Hub' }),
  p('direct_hls', 'Direct MP4 / MKV / M3U8', '16-Thread IDM Parallel Stream Engine', 'video', '#38BDF8', 'globe', ['commondatastorage.googleapis.com', 'test-streams.mux.dev', 'interactive-examples.mdn.mozilla.net'], { exampleUrl: 'https://interactive-examples.mdn.mozilla.net/media/cc0-videos/flower.mp4' }),
];

// 3. COURSES & LECTURES (32 PLATFORMS — FREE OPEN + PAID ENROLLED COOKIE SUPPORT!)
const EDUCATION_PLATFORMS = [
  p('coursera', 'Coursera (Free & Enrolled)', 'Open Previews + Enrolled Cookie Video/SRT', 'education', '#0056D2', 'coursera', ['coursera.org'], { authHint: 'free_or_cookie' }),
  p('udemy', 'Udemy (Open & Enrolled)', 'Free Previews + Enrolled Non-DRM via Cookie', 'education', '#A435F0', 'udemy', ['udemy.com'], { authHint: 'free_or_cookie' }),
  p('edx', 'edX University Courses', 'Open Audit & Enrolled HD Lecture MP4', 'education', '#02262B', 'education', ['edx.org', 'courses.edx.org'], { authHint: 'free_or_cookie' }),
  p('mit_ocw', 'MIT OpenCourseWare', '100% Free Full University Video Lectures', 'education', '#A31F34', 'education', ['ocw.mit.edu']),
  p('harvard_cs50', 'Harvard CS50 Portal', 'Free 4K Computer Science Lectures & SRT', 'education', '#C41230', 'education', ['cs50.harvard.edu', 'cs50.tv']),
  p('khan_academy', 'Khan Academy', 'Free Math, Science & SAT Video Lessons', 'education', '#14BF96', 'education', ['khanacademy.org']),
  p('freecodecamp', 'freeCodeCamp.org', 'Full 10-Hour Coding Bootcamps in HD', 'education', '#0A0A23', 'education', ['freecodecamp.org']),
  p('nptel_swayam', 'NPTEL / SWAYAM', 'Free Engineering & University Lectures', 'education', '#FF6B00', 'education', ['nptel.ac.in', 'swayam.gov.in']),
  p('vu_pakistan', 'Virtual University PK', 'VU OpenCourseWare & Lecture Videos PK', 'education', '#059669', 'education', ['ocw.vu.edu.pk', 'vu.edu.pk'], { regionNote: 'Pakistan Edu' }),
  p('digiskills_pk', 'DigiSkills Pakistan', 'Free Freelancing & IT Training Videos', 'education', '#16A34A', 'education', ['digiskills.pk', 'lms.digiskills.pk'], { regionNote: 'Pakistan Edu' }),
  p('stanford_online', 'Stanford Online', 'Public AI & CS Lecture Video Extractor', 'education', '#8C1515', 'education', ['online.stanford.edu']),
  p('yale_courses', 'Open Yale Courses', 'Full Free Humanities & Science Courses', 'education', '#00356B', 'education', ['oyc.yale.edu']),
  p('ted_talks', 'TED Talks & TED-Ed', '1080p Talks + Multi-Language Subtitles', 'education', '#E62B1E', 'education', ['ted.com']),
  p('linkedin_learning', 'LinkedIn Learning', 'Preview + Enrolled Cookie Video Saver', 'education', '#0A66C2', 'education', ['linkedin.com/learning'], { authHint: 'free_or_cookie' }),
  p('skillshare', 'Skillshare Classes', 'Preview + Non-DRM Class Stream Extractor', 'education', '#00FF84', 'education', ['skillshare.com'], { authHint: 'free_or_cookie' }),
  p('pluralsight', 'Pluralsight Tech', 'Preview + Cookie Authenticated Courses', 'education', '#F15B2A', 'education', ['pluralsight.com'], { authHint: 'free_or_cookie' }),
  p('teachable', 'Teachable Courses', ' Wistia/HLS Free & Enrolled Course Saver', 'education', '#1EA69A', 'education', ['teachable.com', 'fast.wistia.net'], { authHint: 'free_or_cookie' }),
  p('thinkific', 'Thinkific Academy', 'Free Lessons & Enrolled Student Videos', 'education', '#2B6CB0', 'education', ['thinkific.com'], { authHint: 'free_or_cookie' }),
  p('kajabi', 'Kajabi Creator Courses', 'Embedded Wistia/Vimeo Course Extractor', 'education', '#2563EB', 'education', ['kajabi.com', 'mykajabi.com'], { authHint: 'free_or_cookie' }),
  p('skool_classroom', 'Skool Classroom', 'Community Course Loom/Mux Video Saver', 'education', '#F59E0B', 'education', ['skool.com'], { authHint: 'free_or_cookie' }),
  p('podia', 'Podia Courses', 'Free Webinars & Enrolled Course Videos', 'education', '#6366F1', 'education', ['podia.com'], { authHint: 'free_or_cookie' }),
  p('gumroad_courses', 'Gumroad Video Tutorials', 'Purchased & Free Creator Video Streams', 'education', '#FF90E8', 'education', ['gumroad.com', 'app.gumroad.com'], { authHint: 'free_or_cookie' }),
  p('domestika', 'Domestika Creative', 'Open Previews & Non-DRM Lesson Saver', 'education', '#F02D00', 'education', ['domestika.org'], { authHint: 'free_or_cookie' }),
  p('hotmart_club', 'Hotmart Academy', 'Creator Course Embedded Stream Sniffer', 'education', '#F04E23', 'education', ['hotmart.com'], { authHint: 'free_or_cookie' }),
  p('loom_lectures', 'Loom Class Recordings', 'Instant 1080p Screen & Lecture Saver', 'education', '#625DF5', 'loom', ['loom.com']),
  p('panopto', 'Panopto University LMS', 'Public & Authenticated Campus Recordings', 'education', '#047857', 'education', ['panopto.com']),
  p('kaltura_edu', 'Kaltura Campus Media', 'University MediaSpace HLS/MP4 Extractor', 'education', '#0284C7', 'education', ['kaltura.com']),
  p('echo360', 'Echo360 Lecture Capture', 'Recorded Classroom Stream Downloader', 'education', '#0EA5E9', 'education', ['echo360.org', 'echo360.ca']),
  p('zoom_cloud', 'Zoom Cloud Recordings', 'Shared Meeting & Webinar MP4 Extractor', 'education', '#2D8CFF', 'loom', ['zoom.us/rec']),
  p('bigbluebutton', 'BigBlueButton LMS', 'Open-Source University Lecture Saver', 'education', '#1D4ED8', 'education', ['bigbluebutton.org']),
  p('alison_openlearn', 'OpenLearn & Alison', 'Free Certificate Course Video Sniffer', 'education', '#0D9488', 'education', ['open.edu', 'alison.com']),
  p('laracasts_scrimba', 'Laracasts & Dev Casts', 'Full HD Developer Screencast Extractor', 'education', '#EF4444', 'education', ['laracasts.com', 'egghead.io']),
];

// 4. TERABOX & CLOUD (32 PLATFORMS — ALL 22 EXACT USER TERABOX MIRRORS + 10 CLOUD HOSTS!)
const CLOUD_TERABOX_PLATFORMS = [
  p('terabox_app', 'TeraBox.app (Official)', 'Free Native 16x Turbo Stream + Full MP4', 'cloud_terabox', '#0EA5E9', 'terabox', ['terabox.app', 'www.terabox.ap'], { exampleUrl: 'https://www.terabox.app/sharing/link?surl=IRHSOPX5IEPgJT7l9IoNlg' }),
  p('terabox_com', 'TeraBox.com', '100% Free No-Key Full Video & Folder Saver', 'cloud_terabox', '#1D6FF2', 'terabox', ['terabox.com'], { exampleUrl: 'https://www.terabox.app/sharing/link?surl=IRHSOPX5IEPgJT7l9IoNlg' }),
  p('teraviralhub', 'TeraViralHub.com', 'Auto Unwraps Viral Share Posts -> MP4', 'cloud_terabox', '#06B6D4', 'terabox', ['teraviralhub.com']),
  p('iteraplay_free', 'iTeraPlay.com (Free Engine)', 'Built-In 100% Free iTeraPlay Link Resolver', 'cloud_terabox', '#38BDF8', 'terabox', ['iteraplay.com', 'iteraplayvideo.com']),
  p('mirrobox', 'MirroBox (ww & www)', 'Supports ww.mirrobox.com & mirrobox.com', 'cloud_terabox', '#0284C7', 'terabox', ['mirrobox.com', 'ww.mirrobox.com']),
  p('nephobox', 'NephoBox.com', 'Full Cloud Player + 16x Fast MP4 Download', 'cloud_terabox', '#2563EB', 'terabox', ['nephobox.com']),
  p('freeterabox', 'FreeTeraBox.com', 'Instant Free HLS Stream + MP4 Muxer', 'cloud_terabox', '#0EA5E9', 'terabox', ['freeterabox.com']),
  p('tera1024', '1024Tera (.com & .co)', 'Supports 1024tera.com & www.1024tera.co', 'cloud_terabox', '#06B6D4', 'terabox', ['1024tera.com', '1024tera.co']),
  p('funbox4', '4FunBox (.com & .co)', 'Supports 4funbox.co & www.4funbox.com', 'cloud_terabox', '#3B82F6', 'terabox', ['4funbox.com', '4funbox.co']),
  p('momerybox', 'MomeryBox.com', 'Supports momerybox.com & www.momerybox.com', 'cloud_terabox', '#0EA5E9', 'terabox', ['momerybox.com']),
  p('tibibox', 'TibiBox.com', 'Supports tibibox.com & www.tibibox.com', 'cloud_terabox', '#0284C7', 'terabox', ['tibibox.com']),
  p('terabox_fun', 'TeraBox.fun', 'Instant Share Link Player & MP4 Saver', 'cloud_terabox', '#38BDF8', 'terabox', ['terabox.fun']),
  p('teraboxapp_com', 'TeraBoxApp.com', 'Supports teraboxapp.com & Mobile Shares', 'cloud_terabox', '#1D6FF2', 'terabox', ['teraboxapp.com']),
  p('terabox1024', '1024TeraBox.com', 'Direct Mirror Share Folder & Video Engine', 'cloud_terabox', '#0891B2', 'terabox', ['1024terabox.com']),
  p('terasharelink', 'TeraShareLink.com', 'Shared Cloud Link Online Player & Saver', 'cloud_terabox', '#06B6D4', 'terashare', ['terasharelink.com']),
  p('terasharefile', 'TeraShareFile.com', 'Cloud Video Mirror Fast Stream Resolver', 'cloud_terabox', '#0284C7', 'terashare', ['terasharefile.com']),
  p('terafileshare', 'TeraFileShare.com', 'Zero-Login Cloud Video Extractor', 'cloud_terabox', '#0EA5E9', 'terashare', ['terafileshare.com']),
  p('teraboxlink', 'TeraBoxLink & URL', 'Shortened Cloud Share Link Unwrapper', 'cloud_terabox', '#2563EB', 'terashare', ['teraboxlink.com', 'teraboxurl.com', 'teraboxshare.com']),
  p('gdrive', 'Google Drive Public', 'Shared MP4/MKV Large File Bypass Saver', 'cloud_terabox', '#10B981', 'gdrive', ['drive.google.com', 'docs.google.com']),
  p('mediafire', 'MediaFire Cloud', 'Direct High-Speed 16x IDM File Extractor', 'cloud_terabox', '#0070F3', 'terashare', ['mediafire.com']),
  p('dropbox', 'Dropbox Shared Video', 'Raw Binary Stream & Fast MP4 Download', 'cloud_terabox', '#0061FF', 'terashare', ['dropbox.com']),
  p('onedrive_share', 'OneDrive Shared Link', 'Microsoft Cloud Shared Video Streamer', 'cloud_terabox', '#0078D4', 'gdrive', ['1drv.ms', 'onedrive.live.com']),
  p('pixeldrain', 'PixelDrain Cloud', 'Full Gigabit 16x Parallel Cloud Download', 'cloud_terabox', '#8B5CF6', 'gdrive', ['pixeldrain.com']),
  p('gofile_io', 'GoFile.io Cloud', 'High-Speed Shared Video Folder Extractor', 'cloud_terabox', '#14B8A6', 'terashare', ['gofile.io']),
  p('streamtape', 'Streamtape Cloud', 'Movie Embed Cloud Stream Unwrapper', 'cloud_terabox', '#F59E0B', 'terashare', ['streamtape.com', 'streamtape.to']),
  p('doodstream', 'DoodStream / MyVidPlay', 'Viral Cloud Video Embed Extractor', 'cloud_terabox', '#EF4444', 'terashare', ['doodstream.com', 'dood.li', 'myvidplay.com']),
  p('mixdrop', 'MixDrop Cloud', 'Embedded Cloud MP4 Video Resolver', 'cloud_terabox', '#EC4899', 'terashare', ['mixdrop.ag', 'mixdrop.co']),
  p('voe_cloud', 'VOE.sx Cloud', 'HLS Cloud Movie Host Stream Saver', 'cloud_terabox', '#6366F1', 'terashare', ['voe.sx']),
  p('filemoon', 'FileMoon HD Cloud', '1080p HLS Cloud Stream Extractor', 'cloud_terabox', '#F97316', 'terashare', ['filemoon.sx', 'filemoon.in']),
  p('krakenfiles', 'KrakenFiles Audio/Video', 'Instant Cloud MP4 & MP3 Fast Saver', 'cloud_terabox', '#06B6D4', 'gdrive', ['krakenfiles.com']),
  p('pcloud_yandex', 'pCloud & Yandex Disk', 'Public Cloud Drive Stream Extractor', 'cloud_terabox', '#22C55E', 'gdrive', ['pcloud.link', 'disk.yandex.com', 'yadi.sk']),
  p('sendvid_cloud', 'SendVid & Catbox', 'Instant Direct Cloud MP4 Host Saver', 'cloud_terabox', '#38BDF8', 'terashare', ['sendvid.com', 'files.catbox.moe']),
];

// 5. 18+ ADULT VAULT (102 PLATFORMS — USA DIRECT + PAKISTAN PTA ISP-BYPASS SUPPORTED!)
const ADULT_PORTAL_SPECS = [
  ['adult_ph', 'Pornhub', 'pornhub.com', '#F97316', 'USA Direct · PK DoH/Proxy'],
  ['adult_xh', 'xHamster', 'xhamster.com', '#EC4899', 'USA Direct · PK DoH/Proxy'],
  ['adult_xv', 'XVideos', 'xvideos.com', '#EF4444', 'USA Direct · PK DoH/Proxy'],
  ['adult_xnxx', 'XNXX HD', 'xnxx.com', '#2563EB', 'USA Direct · PK DoH/Proxy'],
  ['adult_redtube', 'RedTube', 'redtube.com', '#DC2626', 'USA Direct · PK DoH/Proxy'],
  ['adult_youporn', 'YouPorn', 'youporn.com', '#F43F5E', 'USA Direct · PK DoH/Proxy'],
  ['adult_spankbang', 'SpankBang 4K', 'spankbang.com', '#F97316', 'USA Direct · PK DoH/Proxy'],
  ['adult_eporner', 'Eporner 4K 60fps', 'eporner.com', '#EF4444', 'USA Direct · PK DoH/Proxy'],
  ['adult_tube8', 'Tube8 HD', 'tube8.com', '#E11D48', 'USA Direct · PK DoH/Proxy'],
  ['adult_tnaflix', 'TNAFlix', 'tnaflix.com', '#DB2777', 'USA Direct · PK DoH/Proxy'],
  ['adult_sunporno', 'SunPorno', 'sunporno.com', '#F59E0B', 'USA Direct · PK DoH/Proxy'],
  ['adult_motherless', 'Motherless Media', 'motherless.com', '#991B1B', 'USA Direct · PK DoH/Proxy'],
  ['adult_thumbzilla', 'Thumbzilla HD', 'thumbzilla.com', '#FB7185', 'USA Direct · PK DoH/Proxy'],
  ['adult_beeg', 'Beeg 4K', 'beeg.com', '#F43F5E', 'USA Direct · PK DoH/Proxy'],
  ['adult_hclips', 'HClips', 'hclips.com', '#EC4899', 'USA Direct · PK DoH/Proxy'],
  ['adult_txxx', 'TXXX HD', 'txxx.com', '#EF4444', 'USA Direct · PK DoH/Proxy'],
  ['adult_upornia', 'UPornia', 'upornia.com', '#D946EF', 'USA Direct · PK DoH/Proxy'],
  ['adult_vjav', 'VJav HD', 'vjav.com', '#EC4899', 'USA Direct · PK DoH/Proxy'],
  ['adult_javhd', 'JavHD Clips', 'javhd.com', '#F43F5E', 'USA Direct · PK DoH/Proxy'],
  ['adult_missav', 'MissAV HLS', 'missav.com', '#E11D48', 'USA Direct · PK DoH/Proxy'],
  ['adult_thisav', 'ThisAV', 'thisav.com', '#FB7185', 'USA Direct · PK DoH/Proxy'],
  ['adult_fuq', 'Fuq Aggregator', 'fuq.com', '#F97316', 'USA Direct · PK DoH/Proxy'],
  ['adult_drtuber', 'DrTuber', 'drtuber.com', '#EF4444', 'USA Direct · PK DoH/Proxy'],
  ['adult_nuvid', 'NuVid HD', 'nuvid.com', '#EC4899', 'USA Direct · PK DoH/Proxy'],
  ['adult_pornone', 'PornOne', 'pornone.com', '#F59E0B', 'USA Direct · PK DoH/Proxy'],
  ['adult_porntrex', 'PornTrex 4K', 'porntrex.com', '#E11D48', 'USA Direct · PK DoH/Proxy'],
  ['adult_hqporner', 'HQPorner 1080p', 'hqporner.com', '#DC2626', 'USA Direct · PK DoH/Proxy'],
  ['adult_4tube', '4Tube HD', '4tube.com', '#F43F5E', 'USA Direct · PK DoH/Proxy'],
  ['adult_pornmd', 'PornMD', 'pornmd.com', '#FB7185', 'USA Direct · PK DoH/Proxy'],
  ['adult_empflix', 'EmpFlix', 'empflix.com', '#EC4899', 'USA Direct · PK DoH/Proxy'],
  ['adult_redgifs', 'RedGifs HD Sound', 'redgifs.com', '#A855F7', 'USA Direct · PK DoH/Proxy'],
  ['adult_erome', 'EroMe Albums', 'erome.com', '#EC4899', 'USA Direct · PK DoH/Proxy'],
  ['adult_bunkr', 'Bunkr Vault', 'bunkr.si', '#8B5CF6', 'USA Direct · PK Open/DoH'],
  ['adult_cyberdrop', 'Cyberdrop Media', 'cyberdrop.me', '#6366F1', 'USA Direct · PK Open/DoH'],
  ['adult_coomer', 'Coomer Party', 'coomer.su', '#EC4899', 'USA Direct · PK DoH/Proxy'],
  ['adult_rule34', 'Rule34Video', 'rule34video.com', '#10B981', 'USA Direct · PK DoH/Proxy'],
  ['adult_hanime', 'Hanime 1080p', 'hanime.tv', '#F43F5E', 'USA Direct · PK DoH/Proxy'],
  ['adult_hentaihaven', 'HentaiHaven', 'hentaihaven.xxx', '#EF4444', 'USA Direct · PK DoH/Proxy'],
  ['adult_iwara', 'Iwara 3D HD', 'iwara.tv', '#EC4899', 'USA Direct · PK Open/DoH'],
  ['adult_newgrounds', 'Newgrounds 18+', 'newgrounds.com', '#F59E0B', 'USA Direct · PK Open'],
  ['adult_chaturbate', 'Chaturbate Clips', 'chaturbate.com', '#F97316', 'USA Direct · PK DoH/Proxy'],
  ['adult_stripchat', 'Stripchat Stream', 'stripchat.com', '#E11D48', 'USA Direct · PK DoH/Proxy'],
  ['adult_bongacams', 'BongaCams Stream', 'bongacams.com', '#EC4899', 'USA Direct · PK DoH/Proxy'],
  ['adult_cam4', 'Cam4 Live/Clips', 'cam4.com', '#FB923C', 'USA Direct · PK DoH/Proxy'],
  ['adult_myfreecams', 'MyFreeCams Clips', 'myfreecams.com', '#22C55E', 'USA Direct · PK DoH/Proxy'],
  ['adult_livejasmin', 'LiveJasmin Clips', 'livejasmin.com', '#EF4444', 'USA Direct · PK DoH/Proxy'],
  ['adult_onlyfans_free', 'OnlyFans Public', 'onlyfans.com', '#00AFF0', 'Cookie/Preview · USA/PK'],
  ['adult_fansly', 'Fansly Public', 'fansly.com', '#38BDF8', 'Cookie/Preview · USA/PK'],
  ['adult_manyvids', 'ManyVids Trailers', 'manyvids.com', '#EC4899', 'USA Direct · PK DoH/Proxy'],
  ['adult_clips4sale', 'Clips4Sale Previews', 'clips4sale.com', '#F43F5E', 'USA Direct · PK DoH/Proxy'],
  ['adult_loyalfans', 'LoyalFans Clips', 'loyalfans.com', '#FB7185', 'USA Direct · PK DoH/Proxy'],
  ['adult_justforfans', 'JustForFans Clips', 'justfor.fans', '#A855F7', 'USA Direct · PK DoH/Proxy'],
  ['adult_brazzers', 'Brazzers Trailers', 'brazzers.com', '#FACC15', 'USA Direct · PK DoH/Proxy'],
  ['adult_bangbros', 'BangBros Trailers', 'bangbros.com', '#F97316', 'USA Direct · PK DoH/Proxy'],
  ['adult_realitykings', 'RealityKings Clips', 'realitykings.com', '#EAB308', 'USA Direct · PK DoH/Proxy'],
  ['adult_naughtyamerica', 'NaughtyAmerica Clips', 'naughtyamerica.com', '#EF4444', 'USA Direct · PK DoH/Proxy'],
  ['adult_mofos', 'Mofos Trailers', 'mofos.com', '#EC4899', 'USA Direct · PK DoH/Proxy'],
  ['adult_teamskeet', 'TeamSkeet Clips', 'teamskeet.com', '#0EA5E9', 'USA Direct · PK DoH/Proxy'],
  ['adult_adulttime', 'AdultTime Trailers', 'adulttime.com', '#F43F5E', 'USA Direct · PK DoH/Proxy'],
  ['adult_digitalplayground', 'DigitalPlayground', 'digitalplayground.com', '#E11D48', 'USA Direct · PK DoH/Proxy'],
  ['adult_babes', 'Babes Network', 'babes.com', '#FB7185', 'USA Direct · PK DoH/Proxy'],
  ['adult_evilangel', 'EvilAngel Trailers', 'evilangel.com', '#DC2626', 'USA Direct · PK DoH/Proxy'],
  ['adult_kink', 'Kink Trailers', 'kink.com', '#991B1B', 'USA Direct · PK DoH/Proxy'],
  ['adult_pornflip', 'PornFlip HD', 'pornflip.com', '#F97316', 'USA Direct · PK DoH/Proxy'],
  ['adult_pornhat', 'PornHat', 'pornhat.com', '#EF4444', 'USA Direct · PK DoH/Proxy'],
  ['adult_porndoe', 'PornDoe HD', 'porndoe.com', '#EC4899', 'USA Direct · PK DoH/Proxy'],
  ['adult_porn00', 'Porn00', 'porn00.org', '#F43F5E', 'USA Direct · PK DoH/Proxy'],
  ['adult_porngo', 'PornGo 1080p', 'porngo.com', '#E11D48', 'USA Direct · PK DoH/Proxy'],
  ['adult_pornhits', 'PornHits', 'pornhits.com', '#FB7185', 'USA Direct · PK DoH/Proxy'],
  ['adult_porntop', 'PornTop', 'porntop.com', '#F59E0B', 'USA Direct · PK DoH/Proxy'],
  ['adult_porndig', 'PornDig 4K', 'porndig.com', '#EF4444', 'USA Direct · PK DoH/Proxy'],
  ['adult_porntube', 'PornTube HD', 'porntube.com', '#DC2626', 'USA Direct · PK DoH/Proxy'],
  ['adult_pornhd', 'PornHD 1080p', 'pornhd.com', '#F97316', 'USA Direct · PK DoH/Proxy'],
  ['adult_pornvibe', 'PornVibe', 'pornvibe.org', '#EC4899', 'USA Direct · PK DoH/Proxy'],
  ['adult_xozilla', 'Xozilla HD', 'xozilla.com', '#F43F5E', 'USA Direct · PK DoH/Proxy'],
  ['adult_xxxbunker', 'XXXBunker', 'xxxbunker.com', '#991B1B', 'USA Direct · PK DoH/Proxy'],
  ['adult_anysex', 'AnySex Video', 'anysex.com', '#FB7185', 'USA Direct · PK DoH/Proxy'],
  ['adult_bravotube', 'BravoTube', 'bravotube.net', '#E11D48', 'USA Direct · PK DoH/Proxy'],
  ['adult_alphaporno', 'AlphaPorno', 'alphaporno.com', '#EC4899', 'USA Direct · PK DoH/Proxy'],
  ['adult_analdin', 'Analdin HD', 'analdin.com', '#EF4444', 'USA Direct · PK DoH/Proxy'],
  ['adult_gotporn', 'GotPorn', 'gotporn.com', '#F97316', 'USA Direct · PK DoH/Proxy'],
  ['adult_hdzog', 'HDZog 1080p', 'hdzog.com', '#E11D48', 'USA Direct · PK DoH/Proxy'],
  ['adult_hotmovs', 'HotMovs', 'hotmovs.com', '#F43F5E', 'USA Direct · PK DoH/Proxy'],
  ['adult_iceporn', 'IcePorn', 'iceporn.com', '#38BDF8', 'USA Direct · PK DoH/Proxy'],
  ['adult_jizzbunker', 'JizzBunker', 'jizzbunker.com', '#FB7185', 'USA Direct · PK DoH/Proxy'],
  ['adult_lovehomeporn', 'LoveHomePorn', 'lovehomeporn.com', '#EC4899', 'USA Direct · PK DoH/Proxy'],
  ['adult_movs4k', 'Movs4K Ultra', 'movs4k.com', '#A855F7', 'USA Direct · PK DoH/Proxy'],
  ['adult_netfapx', 'NetFapX', 'netfapx.com', '#EF4444', 'USA Direct · PK DoH/Proxy'],
  ['adult_newsyporn', 'NewsyPorn', 'newsyporn.com', '#F97316', 'USA Direct · PK DoH/Proxy'],
  ['adult_nonstoppartner', 'NonStopPartner', 'nonstoppartner.com', '#E11D48', 'USA Direct · PK DoH/Proxy'],
  ['adult_okxxx', 'okXXX HD', 'ok.xxx', '#EC4899', 'USA Direct · PK DoH/Proxy'],
  ['adult_pervclips', 'PervClips', 'pervclips.com', '#F43F5E', 'USA Direct · PK DoH/Proxy'],
  ['adult_plusone8', 'PlusOne8', 'plusone8.com', '#FB7185', 'USA Direct · PK DoH/Proxy'],
  ['adult_pornlib', 'PornLib', 'pornlib.com', '#EF4444', 'USA Direct · PK DoH/Proxy'],
  ['adult_pornovoisines', 'PornoVoisines', 'pornovoisines.com', '#EC4899', 'USA Direct · PK DoH/Proxy'],
  ['adult_sexu', 'Sexu HD', 'sexu.com', '#E11D48', 'USA Direct · PK DoH/Proxy'],
  ['adult_sxyprn', 'SxyPrn Full HD', 'sxyprn.com', '#A855F7', 'USA Direct · PK DoH/Proxy'],
  ['adult_trendyporn', 'TrendyPorn', 'trendyporn.com', '#F97316', 'USA Direct · PK DoH/Proxy'],
  ['adult_heavyr', 'Heavy-R Video', 'heavy-r.com', '#DC2626', 'USA Direct · PK DoH/Proxy'],
  ['adult_biqle', 'Biqle HD', 'biqle.ru', '#3B82F6', 'USA Direct · PK DoH/Proxy'],
  ['adult_fapello', 'Fapello Video', 'fapello.com', '#EC4899', 'USA Direct · PK DoH/Proxy'],
  ['adult_imgur_nsfw', 'NSFW GIF/MP4 Mirrors', 'gifdeliverynetwork.com', '#8B5CF6', 'USA Direct · PK Open/DoH'],
];

const ADULT_PLATFORMS = ADULT_PORTAL_SPECS.map(([id, name, domain, color, regionNote]) =>
  p(
    id,
    name,
    `18+ ${regionNote} · Fast MP4/HLS`,
    'adult_18',
    color,
    'adult_ph',
    [domain],
    { regionNote }
  )
);

export const PLATFORM_DEFINITIONS = [
  ...SOCIAL_PLATFORMS,
  ...VIDEO_MOVIE_PLATFORMS,
  ...EDUCATION_PLATFORMS,
  ...CLOUD_TERABOX_PLATFORMS,
  ...ADULT_PLATFORMS,
];

export const DEFAULT_AD_WATERFALL = {
  native_banner: {
    enabled: false,
    title: '',
    subtitle: '',
    ctaText: 'Visit Partner',
    targetUrl: '',
  },
  player_preroll_vast: {
    enabled: false,
    skipAfterSeconds: 4,
    sponsorBrand: '',
    headline: '',
  },
  download_click_direct_tab: {
    enabled: false,
    cooldownMinutes: 20,
    triggerMode: 'on_download_click',
    directUrl: '',
  },
  progress_modal_sponsor: {
    enabled: false,
    title: '',
    subtitle: '',
  },
};

export const DEFAULT_SYSTEM_SETTINGS = {
  guestDailyDownloadLimit: 50,
  userDailyDownloadLimit: 500,
  guestMaxFileSizeMb: 8192,
  vaultMaxStorageGb: 200,
  allowAdultSources: true,
  storageGateMode: 'three_button_admin_gate',
  idmConnections: 16,
  dnsOverHttpsBypass: true,
  autoUnwrapIteraplay: true,
};

export function detectPlatformFromUrl(rawUrl, platformsList = PLATFORM_DEFINITIONS) {
  const lower = String(rawUrl || '').toLowerCase();
  for (const plat of platformsList) {
    const domains = plat.domains || [];
    if (domains.some((d) => lower.includes(String(d).toLowerCase()))) {
      return plat;
    }
  }
  return {
    id: 'universal_web',
    displayName: (() => {
      try {
        return new URL(rawUrl).hostname.replace(/^www\./, '');
      } catch {
        return 'Web Stream';
      }
    })(),
    subtitle: 'Universal Live yt-dlp / Deep Sniffer',
    category: 'video',
    accentColor: '#38BDF8',
    iconKey: 'globe',
    iconSvg: '',
    domains: [],
    isAdult: false,
  };
}
