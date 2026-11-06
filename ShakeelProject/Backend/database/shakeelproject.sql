-- ============================================================================
-- ShakeelProject — Clean Universal Downloader Database (XAMPP phpMyAdmin / MySQL / MariaDB)
-- Includes All 222 Active Platforms + High-Concurrency Composite Indexes
-- Import Steps in XAMPP:
--   1. Open XAMPP Control Panel -> Click [Start] on Apache & MySQL
--   2. Open http://localhost/phpmyadmin -> Click [Import] tab at top
--   3. Choose this file (shakeelproject.sql) -> Click [Import / Go]
-- ============================================================================

SET NAMES utf8mb4;
CREATE DATABASE IF NOT EXISTS `shakeelproject_db` CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `shakeelproject_db`;

DROP TABLE IF EXISTS `security_audit_logs`;
DROP TABLE IF EXISTS `analytics_events`;
DROP TABLE IF EXISTS `share_links`;
DROP TABLE IF EXISTS `download_jobs`;
DROP TABLE IF EXISTS `encrypted_cookies`;
DROP TABLE IF EXISTS `seo_keywords`;
DROP TABLE IF EXISTS `finance_ledger`;
DROP TABLE IF EXISTS `saved_vault_videos`;
DROP TABLE IF EXISTS `system_settings`;
DROP TABLE IF EXISTS `ad_waterfall_zones`;
DROP TABLE IF EXISTS `platforms`;
DROP TABLE IF EXISTS `user_favorites`;
DROP TABLE IF EXISTS `users`;
DROP TABLE IF EXISTS `ip_lockouts`;
DROP TABLE IF EXISTS `admin_users`;
DROP TABLE IF EXISTS `websites`;

CREATE TABLE `websites` (
  `id` VARCHAR(64) PRIMARY KEY,
  `name` VARCHAR(191) NOT NULL,
  `domain` VARCHAR(191) NOT NULL,
  `content_mode` VARCHAR(64) NOT NULL DEFAULT 'clean_mainstream',
  `status` VARCHAR(32) NOT NULL DEFAULT 'ACTIVE',
  `monthly_revenue` DOUBLE NOT NULL DEFAULT 0,
  `monthly_expense` DOUBLE NOT NULL DEFAULT 0,
  `seo_score` INT NOT NULL DEFAULT 100,
  `created_at` VARCHAR(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `admin_users` (
  `id` VARCHAR(64) PRIMARY KEY,
  `username` VARCHAR(100) NOT NULL UNIQUE,
  `email` VARCHAR(191) NOT NULL UNIQUE,
  `full_name` VARCHAR(191) NOT NULL,
  `password_hash` VARCHAR(255) NOT NULL,
  `pin_hash` VARCHAR(255) NOT NULL,
  `totp_secret` VARCHAR(128) NOT NULL,
  `role` VARCHAR(64) NOT NULL DEFAULT 'super_admin',
  `last_login_at` VARCHAR(64) NULL,
  `created_at` VARCHAR(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `ip_lockouts` (
  `ip_address` VARCHAR(64) PRIMARY KEY,
  `failed_attempts` INT NOT NULL DEFAULT 0,
  `banned_until` VARCHAR(64) NULL,
  `updated_at` VARCHAR(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `users` (
  `id` VARCHAR(64) PRIMARY KEY,
  `full_name` VARCHAR(191) NOT NULL,
  `email` VARCHAR(191) NOT NULL UNIQUE,
  `password_hash` VARCHAR(255) NOT NULL,
  `daily_quota` INT NOT NULL DEFAULT 500,
  `created_at` VARCHAR(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `user_favorites` (
  `id` VARCHAR(64) PRIMARY KEY,
  `user_id` VARCHAR(64) NOT NULL,
  `video_url` TEXT NOT NULL,
  `title` VARCHAR(500) NOT NULL,
  `thumbnail_url` TEXT NOT NULL,
  `platform_id` VARCHAR(64) NOT NULL,
  `duration_text` VARCHAR(64) NOT NULL,
  `created_at` VARCHAR(64) NOT NULL,
  INDEX `idx_fav_user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `platforms` (
  `id` VARCHAR(64) PRIMARY KEY,
  `display_name` VARCHAR(191) NOT NULL,
  `subtitle` VARCHAR(255) NOT NULL,
  `category` VARCHAR(64) NOT NULL,
  `accent_color` VARCHAR(32) NOT NULL,
  `icon_key` VARCHAR(64) NOT NULL,
  `icon_svg` LONGTEXT NULL,
  `domains_json` LONGTEXT NOT NULL,
  `example_url` VARCHAR(500) NOT NULL,
  `seo_slug` VARCHAR(191) NOT NULL,
  `is_adult` TINYINT(1) NOT NULL DEFAULT 0,
  `supports_search` TINYINT(1) NOT NULL DEFAULT 0,
  `supports_online_player` TINYINT(1) NOT NULL DEFAULT 1,
  `supports_download` TINYINT(1) NOT NULL DEFAULT 1,
  `supports_resume` TINYINT(1) NOT NULL DEFAULT 1,
  `is_enabled` TINYINT(1) NOT NULL DEFAULT 1,
  `health_status` VARCHAR(32) NOT NULL DEFAULT 'operational',
  `known_limitations` TEXT NOT NULL,
  `created_at` VARCHAR(64) NOT NULL,
  INDEX `idx_platforms_cat_enabled` (`category`, `is_enabled`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `ad_waterfall_zones` (
  `zone_key` VARCHAR(64) PRIMARY KEY,
  `enabled` TINYINT(1) NOT NULL DEFAULT 0,
  `cooldown_minutes` INT NOT NULL DEFAULT 20,
  `config_json` LONGTEXT NOT NULL,
  `updated_at` VARCHAR(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `system_settings` (
  `setting_key` VARCHAR(64) PRIMARY KEY,
  `setting_json` LONGTEXT NOT NULL,
  `updated_at` VARCHAR(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `saved_vault_videos` (
  `id` VARCHAR(64) PRIMARY KEY,
  `website_id` VARCHAR(64) NOT NULL,
  `title` VARCHAR(500) NOT NULL,
  `source_url` TEXT NOT NULL,
  `stream_url` TEXT NOT NULL,
  `local_file_path` TEXT NULL,
  `thumbnail_url` TEXT NOT NULL,
  `platform_id` VARCHAR(64) NOT NULL,
  `platform_json` LONGTEXT NOT NULL,
  `category` VARCHAR(64) NOT NULL,
  `duration_text` VARCHAR(64) NOT NULL,
  `resolution_label` VARCHAR(64) NOT NULL,
  `file_size_bytes` BIGINT NOT NULL DEFAULT 0,
  `file_present_on_disk` TINYINT(1) NOT NULL DEFAULT 1,
  `is_pinned` TINYINT(1) NOT NULL DEFAULT 0,
  `is_adult` TINYINT(1) NOT NULL DEFAULT 0,
  `admin_notes` TEXT NULL,
  `saved_at` VARCHAR(64) NOT NULL,
  INDEX `idx_vault_site_saved` (`website_id`, `saved_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `finance_ledger` (
  `id` VARCHAR(64) PRIMARY KEY,
  `website_id` VARCHAR(64) NOT NULL,
  `website_label` VARCHAR(191) NOT NULL,
  `entry_type` VARCHAR(32) NOT NULL,
  `category` VARCHAR(191) NOT NULL,
  `amount` DOUBLE NOT NULL,
  `status` VARCHAR(64) NOT NULL DEFAULT 'RECORDED',
  `entry_date` VARCHAR(32) NOT NULL,
  `notes` TEXT NULL,
  `created_at` VARCHAR(64) NOT NULL,
  INDEX `idx_ledger_site_date` (`website_id`, `entry_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `seo_keywords` (
  `id` VARCHAR(64) PRIMARY KEY,
  `keyword` VARCHAR(255) NOT NULL,
  `slug` VARCHAR(191) NOT NULL UNIQUE,
  `impressions` INT NOT NULL DEFAULT 0,
  `clicks` INT NOT NULL DEFAULT 0,
  `created_at` VARCHAR(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `encrypted_cookies` (
  `id` VARCHAR(64) PRIMARY KEY,
  `platform_label` VARCHAR(191) NOT NULL,
  `platform_id` VARCHAR(64) NOT NULL,
  `iv_hex` VARCHAR(64) NOT NULL,
  `auth_tag_hex` VARCHAR(64) NOT NULL,
  `ciphertext_hex` LONGTEXT NOT NULL,
  `masked_preview` VARCHAR(191) NOT NULL,
  `status` VARCHAR(64) NOT NULL DEFAULT 'Active',
  `updated_at` VARCHAR(64) NOT NULL,
  INDEX `idx_cookie_platform` (`platform_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `download_jobs` (
  `id` VARCHAR(64) PRIMARY KEY,
  `requester_ip` VARCHAR(64) NOT NULL,
  `user_id` VARCHAR(64) NULL,
  `title` VARCHAR(512) NOT NULL,
  `file_name` VARCHAR(512) NOT NULL,
  `source_url` TEXT NOT NULL,
  `format_selector` TEXT NOT NULL,
  `stream_url` TEXT NULL,
  `local_output_path` TEXT NULL,
  `thumbnail_url` TEXT NULL,
  `platform_id` VARCHAR(64) NOT NULL,
  `quality_label` VARCHAR(64) NOT NULL,
  `format_ext` VARCHAR(16) NOT NULL,
  `status` VARCHAR(32) NOT NULL,
  `progress_pct` DOUBLE NOT NULL DEFAULT 0,
  `bytes_downloaded` BIGINT NOT NULL DEFAULT 0,
  `total_bytes` BIGINT NOT NULL DEFAULT 0,
  `speed_bps` BIGINT NOT NULL DEFAULT 0,
  `eta_seconds` INT NOT NULL DEFAULT 0,
  `error_message` TEXT NULL,
  `created_at` VARCHAR(64) NOT NULL,
  INDEX `idx_dl_ip_created` (`requester_ip`, `created_at`),
  INDEX `idx_dl_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `share_links` (
  `short_code` VARCHAR(32) PRIMARY KEY,
  `source_url` TEXT NOT NULL,
  `title` VARCHAR(500) NOT NULL,
  `platform_id` VARCHAR(64) NOT NULL,
  `thumbnail_url` TEXT NULL,
  `duration_text` VARCHAR(64) NULL,
  `stream_url` TEXT NOT NULL,
  `views` INT NOT NULL DEFAULT 0,
  `created_at` VARCHAR(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `analytics_events` (
  `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
  `website_id` VARCHAR(64) NOT NULL,
  `event_name` VARCHAR(64) NOT NULL,
  `platform_id` VARCHAR(64) NULL,
  `meta_json` LONGTEXT NULL,
  `created_at` VARCHAR(64) NOT NULL,
  INDEX `idx_events_web_event` (`website_id`, `event_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `security_audit_logs` (
  `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
  `event_type` VARCHAR(64) NOT NULL,
  `ip_address` VARCHAR(64) NOT NULL,
  `user_agent` VARCHAR(255) NULL,
  `details_text` VARCHAR(500) NULL,
  `created_at` VARCHAR(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `websites` VALUES ('site_main_clean', 'UltraDownloader Main Hub', 'localhost:5173', 'clean_mainstream', 'ACTIVE', 0, 0, 100, '2026-10-23T00:00:00.000Z');
INSERT INTO `websites` VALUES ('site_adult_vault', 'Dedicated 18+ Vault Hub', 'vault18.local', 'adult_18_only', 'ACTIVE', 0, 0, 100, '2026-10-23T00:00:00.000Z');
INSERT INTO `admin_users` VALUES ('admin-master-01', 'superadmin', 'admin@shakeelproject.local', 'Master Super-Admin', 'PLACEHOLDER_PIN_HASH_REKEYED_BY_BACKEND', 'PLACEHOLDER_PASSWORD_HASH_REKEYED_BY_BACKEND', 'JBSWY3DPEHPK3PXP', 'super_admin', NULL, '2026-10-23T00:00:00.000Z');

INSERT INTO `platforms` VALUES ('youtube', 'YouTube', '8K/4K 60FPS · Shorts · 320kbps MP3', 'social', '#FF0033', 'youtube', NULL, '["youtube.com/watch","youtu.be","m.youtube.com"]', 'https://www.youtube.com/watch?v=WhWc3b3KhnY', 'youtube-4k-video-mp3-downloader', 0, 1, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-youtube', 'YouTube Video Downloader', 'youtube-4k-video-mp3-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('youtube_shorts', 'YouTube Shorts', 'Vertical 1080p60 HD Shorts & MP3', 'social', '#FF2E54', 'shorts', NULL, '["youtube.com/shorts"]', 'https://youtube.com/shorts/', 'youtube-shorts-video-downloader', 0, 1, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-youtube_shorts', 'YouTube Shorts Video Downloader', 'youtube-shorts-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('tiktok', 'TikTok', 'No-Watermark Full HD Video & MP3', 'social', '#25F4EE', 'tiktok', NULL, '["tiktok.com","vm.tiktok.com","vt.tiktok.com"]', 'https://tiktok.com/', 'tiktok-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-tiktok', 'TikTok Video Downloader', 'tiktok-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('instagram', 'Instagram', 'Reels · Stories · Carousel Video HD', 'social', '#DD2A7B', 'instagram', NULL, '["instagram.com","instagr.am"]', 'https://instagram.com/', 'instagram-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-instagram', 'Instagram Video Downloader', 'instagram-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('facebook', 'Facebook Watch', 'Public & Private Reels · Watch 1080p', 'social', '#1877F2', 'facebook', NULL, '["facebook.com","fb.watch","fb.com"]', 'https://facebook.com/', 'facebook-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-facebook', 'Facebook Watch Video Downloader', 'facebook-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('twitter_x', 'X (Twitter)', 'HD Post Videos · Spaces & GIFs', 'social', '#38BDF8', 'x', NULL, '["x.com","twitter.com","t.co"]', 'https://x.com/', 'twitter-x-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-twitter_x', 'X (Twitter) Video Downloader', 'twitter-x-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('reddit', 'Reddit Video', 'Auto Video + Audio FFmpeg MP4 Mux', 'social', '#FF4500', 'reddit', NULL, '["reddit.com","redd.it","v.redd.it"]', 'https://reddit.com/', 'reddit-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-reddit', 'Reddit Video Video Downloader', 'reddit-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('pinterest', 'Pinterest', 'Video Pins & Story Pins HD MP4', 'social', '#E60023', 'pinterest', NULL, '["pinterest.com","pin.it"]', 'https://pinterest.com/', 'pinterest-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-pinterest', 'Pinterest Video Downloader', 'pinterest-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('snapchat', 'Snapchat Spotlight', 'Public Spotlight & Story Video Saver', 'social', '#FFFC00', 'spark', NULL, '["snapchat.com"]', 'https://snapchat.com/', 'snapchat-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-snapchat', 'Snapchat Spotlight Video Downloader', 'snapchat-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('linkedin', 'LinkedIn Video', 'Native Post & Event Video Extractor', 'social', '#0A66C2', 'linkedin', NULL, '["linkedin.com/posts","linkedin.com/feed"]', 'https://linkedin.com/posts/', 'linkedin-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-linkedin', 'LinkedIn Video Video Downloader', 'linkedin-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('threads', 'Meta Threads', 'Threads HD Video & Voice Clips', 'social', '#A855F7', 'spark', NULL, '["threads.net"]', 'https://threads.net/', 'threads-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-threads', 'Meta Threads Video Downloader', 'threads-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('telegram', 'Telegram Public', 'Public Channel Video Media Streamer', 'social', '#229ED9', 'telegram', NULL, '["t.me"]', 'https://t.me/', 'telegram-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-telegram', 'Telegram Public Video Downloader', 'telegram-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('vk_video', 'VK Video', 'Full HD 1080p/4K Social Clips', 'social', '#0077FF', 'vimeo', NULL, '["vk.com","vkvideo.ru"]', 'https://vk.com/', 'vk-video-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-vk_video', 'VK Video Video Downloader', 'vk-video-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('tumblr', 'Tumblr Media', 'Dashboard HD MP4 & Loops Extractor', 'social', '#36465D', 'vimeo', NULL, '["tumblr.com"]', 'https://tumblr.com/', 'tumblr-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-tumblr', 'Tumblr Media Video Downloader', 'tumblr-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('bluesky', 'Bluesky Social', 'ATProto Native HLS/MP4 Video Saver', 'social', '#0285FF', 'vimeo', NULL, '["bsky.app"]', 'https://bsky.app/', 'bluesky-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-bluesky', 'Bluesky Social Video Downloader', 'bluesky-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('rednote', 'RedNote (Xiaohongshu)', 'No-Watermark HD Lifestyle Videos', 'social', '#FF2442', 'pinterest', NULL, '["xiaohongshu.com","xhslink.com"]', 'https://xiaohongshu.com/', 'rednote-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-rednote', 'RedNote (Xiaohongshu) Video Downloader', 'rednote-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('lemon8', 'Lemon8 Video', 'HD Creator Reels & Tutorials', 'social', '#FACC15', 'spark', NULL, '["lemon8-app.com"]', 'https://lemon8-app.com/', 'lemon8-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-lemon8', 'Lemon8 Video Video Downloader', 'lemon8-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('kwai', 'SnackVideo / Kwai', 'No-Watermark Short Video Saver PK', 'social', '#FF7700', 'play', NULL, '["kwai.com","snackvideo.com"]', 'https://kwai.com/', 'kwai-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-kwai', 'SnackVideo / Kwai Video Downloader', 'kwai-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('likee', 'Likee Video', 'Short Vertical HD MP4 Downloader', 'social', '#EC4899', 'play', NULL, '["likee.video"]', 'https://likee.video/', 'likee-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-likee', 'Likee Video Video Downloader', 'likee-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('weibo', 'Weibo Video', 'HD Social Stream & Live Replay MP4', 'social', '#E6162D', 'reddit', NULL, '["weibo.com","weibo.cn"]', 'https://weibo.com/', 'weibo-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-weibo', 'Weibo Video Video Downloader', 'weibo-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('douyin', 'Douyin HD', 'Original 1080p60 Short Stream Saver', 'social', '#14B8A6', 'tiktok', NULL, '["douyin.com"]', 'https://douyin.com/', 'douyin-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-douyin', 'Douyin HD Video Downloader', 'douyin-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('mastodon', 'Mastodon Social', 'Federated ActivityPub MP4 Extractor', 'social', '#6364FF', 'globe', NULL, '["mastodon.social"]', 'https://mastodon.social/', 'mastodon-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-mastodon', 'Mastodon Social Video Downloader', 'mastodon-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('justwatch', 'JustWatch Movies', 'Trailers, Previews & Free Stream Links', 'video', '#FACC15', 'play', NULL, '["justwatch.com"]', 'https://www.justwatch.com/in/movies', 'justwatch-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-justwatch', 'JustWatch Movies Video Downloader', 'justwatch-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('fmoviesse', 'FMovies SE', 'Deep Embed & HLS Movie Stream Sniffer', 'video', '#00ACC1', 'vimeo', NULL, '["fmoviesse.net"]', 'https://fmoviesse.net/', 'fmoviesse-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'PK/Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-fmoviesse', 'FMovies SE Video Downloader', 'fmoviesse-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('myfreemovies', 'MyFreeMovies', 'Embedded MP4 & M3U8 Movie Extractor', 'video', '#10B981', 'vimeo', NULL, '["myfreemovies.site"]', 'https://myfreemovies.site/', 'myfreemovies-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'PK/Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-myfreemovies', 'MyFreeMovies Video Downloader', 'myfreemovies-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('rottentomatoes', 'Rotten Tomatoes', '4K/1080p Movie Trailers & Teasers', 'video', '#FA320A', 'play', NULL, '["rottentomatoes.com"]', 'https://rottentomatoes.com/', 'rottentomatoes-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-rottentomatoes', 'Rotten Tomatoes Video Downloader', 'rottentomatoes-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('hotsflix', 'HotsFlix', 'HD HLS & Embed Stream Extractor', 'video', '#EF4444', 'vimeo', NULL, '["hotsflix.net"]', 'https://hotsflix.net/', 'hotsflix-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-hotsflix', 'HotsFlix Video Downloader', 'hotsflix-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('fmovies_org', 'FMovies Org', 'Multi-Server HLS/MP4 Movie Sniffer', 'video', '#0EA5E9', 'vimeo', NULL, '["fmovies-co.org"]', 'https://fmovies-co.org/', 'fmovies-org-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-fmovies_org', 'FMovies Org Video Downloader', 'fmovies-org-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('fawesome_tv', 'Fawesome TV', 'Free Full Movies & TV Shows HLS', 'video', '#F97316', 'play', NULL, '["fawesome.tv"]', 'https://fawesome.tv/', 'fawesome-tv-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-fawesome_tv', 'Fawesome TV Video Downloader', 'fawesome-tv-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('shemaroome', 'ShemarooMe Free', 'Free Bollywood & Classic Hindi Movies', 'video', '#E11D48', 'play', NULL, '["shemaroome.com"]', 'https://shemaroome.com/', 'shemaroome-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-shemaroome', 'ShemarooMe Free Video Downloader', 'shemaroome-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('watch_movies_pk_2025', 'Watch-Movies PK (2025)', 'Indian & Bollywood HD Embed Extractor', 'video', '#22C55E', 'play', NULL, '["watch-movies.com.pk/category/"]', 'https://watch-movies.com.pk/category//', 'watch-movies-pk-2025-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Pakistan Hub', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-watch_movies_pk_2025', 'Watch-Movies PK (2025) Video Downloader', 'watch-movies-pk-2025-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('watch_movies_pk', 'Watch-Movies.com.pk', 'Pakistani & South Asian Movie Portal', 'video', '#16A34A', 'play', NULL, '["watch-movies.com.pk"]', 'https://watch-movies.com.pk/', 'watch-movies-pk-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Pakistan Hub', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-watch_movies_pk', 'Watch-Movies.com.pk Video Downloader', 'watch-movies-pk-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('movies123_go4u', '123MoviesGo4U', 'Fast Iframe & M3U8 Movie Sniffer', 'video', '#84CC16', 'vimeo', NULL, '["123moviesgo4u.com"]', 'https://123moviesgo4u.com/', 'movies123-go4u-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-movies123_go4u', '123MoviesGo4U Video Downloader', 'movies123-go4u-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('mewatch_sg', 'mewatch Movies', 'Free Non-DRM Asian Movies & Series', 'video', '#A855F7', 'vimeo', NULL, '["mewatch.sg"]', 'https://mewatch.sg/', 'mewatch-sg-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-mewatch_sg', 'mewatch Movies Video Downloader', 'mewatch-sg-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('onlinemovies7', 'OnlineMovies7', 'Direct & Embedded HD Movie Extractor', 'video', '#06B6D4', 'vimeo', NULL, '["onlinemovies7.info"]', 'https://onlinemovies7.info/', 'onlinemovies7-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-onlinemovies7', 'OnlineMovies7 Video Downloader', 'onlinemovies7-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('tubi_tv', 'Tubi TV Free', 'Free Ad-Supported Movies (Non-DRM)', 'video', '#F59E0B', 'play', NULL, '["tubi.tv","gdpr.tubi.tv"]', 'https://tubi.tv/', 'tubi-tv-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-tubi_tv', 'Tubi TV Free Video Downloader', 'tubi-tv-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('moviesfoundonline', 'MoviesFoundOnline', 'Free Public Domain & Indie Full Films', 'video', '#3B82F6', 'play', NULL, '["moviesfoundonline.com"]', 'https://moviesfoundonline.com/', 'moviesfoundonline-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-moviesfoundonline', 'MoviesFoundOnline Video Downloader', 'moviesfoundonline-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('media_io_movies', 'Media.io Movie Hub', 'Web Media & Stream Link Extractor', 'video', '#8B5CF6', 'globe', NULL, '["media.io"]', 'https://media.io/', 'media-io-movies-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-media_io_movies', 'Media.io Movie Hub Video Downloader', 'media-io-movies-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('sunnxt_free', 'Sun NXT Free', 'Free South Indian Movies & Clips', 'video', '#EA580C', 'play', NULL, '["sunnxt.com"]', 'https://sunnxt.com/', 'sunnxt-free-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-sunnxt_free', 'Sun NXT Free Video Downloader', 'sunnxt-free-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('vimeo', 'Vimeo 4K', '4K/1080p Player Bypass + Subtitles', 'video', '#1AB7EA', 'vimeo', NULL, '["vimeo.com","player.vimeo.com"]', 'https://vimeo.com/76979871', 'vimeo-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-vimeo', 'Vimeo 4K Video Downloader', 'vimeo-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('dailymotion', 'Dailymotion HD', '1080p60 HLS & MP4 Movie/Drama Saver', 'video', '#00AAFF', 'dailymotion', NULL, '["dailymotion.com","dai.ly"]', 'https://dailymotion.com/', 'dailymotion-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-dailymotion', 'Dailymotion HD Video Downloader', 'dailymotion-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('twitch', 'Twitch VOD & Clips', '1080p60 Stream VODs & Highlights', 'video', '#9146FF', 'twitch', NULL, '["twitch.tv","clips.twitch.tv"]', 'https://twitch.tv/', 'twitch-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-twitch', 'Twitch VOD & Clips Video Downloader', 'twitch-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('kick', 'Kick Streams', 'Full HD Live Replays & Stream Clips', 'video', '#53FC18', 'kick', NULL, '["kick.com"]', 'https://kick.com/', 'kick-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-kick', 'Kick Streams Video Downloader', 'kick-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('rumble', 'Rumble 4K', 'Uncensored 4K/1080p MP4 Video Saver', 'video', '#85C742', 'rumble', NULL, '["rumble.com"]', 'https://rumble.com/', 'rumble-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-rumble', 'Rumble 4K Video Downloader', 'rumble-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('bilibili', 'Bilibili Anime & Film', '1080p Anime, Donghua & Cinema Muxer', 'video', '#00A1D6', 'vimeo', NULL, '["bilibili.com","bilibili.tv"]', 'https://bilibili.com/', 'bilibili-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-bilibili', 'Bilibili Anime & Film Video Downloader', 'bilibili-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('odysee', 'Odysee Cinema', 'Decentralized Full-Length MP4 Streams', 'video', '#F2416B', 'odysee', NULL, '["odysee.com"]', 'https://odysee.com/', 'odysee-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-odysee', 'Odysee Cinema Video Downloader', 'odysee-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('bitchute', 'BitChute Video', 'Direct MP4 Channel Stream Extractor', 'video', '#EF4136', 'play', NULL, '["bitchute.com"]', 'https://bitchute.com/', 'bitchute-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-bitchute', 'BitChute Video Video Downloader', 'bitchute-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('archive_cinema', 'Internet Archive Films', '10,000+ Full Classic Movies MP4/MKV', 'video', '#64748B', 'globe', NULL, '["archive.org/details"]', 'https://archive.org/details/BigBuckBunny_124', 'archive-cinema-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-archive_cinema', 'Internet Archive Films Video Downloader', 'archive-cinema-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('ok_ru_movies', 'OK.ru Full Movies', 'Popular Hindi/Urdu Dubbed HD Movies', 'video', '#EE8208', 'play', NULL, '["ok.ru","odnoklassniki.ru"]', 'https://ok.ru/', 'ok-ru-movies-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'PK Popular', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-ok_ru_movies', 'OK.ru Full Movies Video Downloader', 'ok-ru-movies-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('soundcloud', 'SoundCloud Studio', '320kbps MP3 & Native M4A Audio Engine', 'video', '#FF5500', 'play', NULL, '["soundcloud.com"]', 'https://soundcloud.com/forss/flickermood', 'soundcloud-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-soundcloud', 'SoundCloud Studio Video Downloader', 'soundcloud-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('peertube', 'PeerTube / Framatube', 'Multi-Resolution 240p–1080p Fast MP4', 'video', '#F1680D', 'play', NULL, '["framatube.org","tilvids.com"]', 'https://framatube.org/videos/watch/9c9de5e8-0a1e-484a-b099-e80766180a6d', 'peertube-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-peertube', 'PeerTube / Framatube Video Downloader', 'peertube-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('plex_free', 'Plex Free Movies', 'Non-DRM Free Trailers & Web Streams', 'video', '#E5A00D', 'play', NULL, '["watch.plex.tv","plex.tv"]', 'https://watch.plex.tv/', 'plex-free-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-plex_free', 'Plex Free Movies Video Downloader', 'plex-free-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('pluto_tv', 'Pluto TV Clips', 'Free Non-DRM Channels & VOD Clips', 'video', '#FDE047', 'play', NULL, '["pluto.tv"]', 'https://pluto.tv/', 'pluto-tv-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-pluto_tv', 'Pluto TV Clips Video Downloader', 'pluto-tv-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('mx_player', 'MX Player Free', 'Free Hindi Web Series & Movie Streams', 'video', '#0284C7', 'play', NULL, '["mxplayer.in"]', 'https://mxplayer.in/', 'mx-player-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-mx_player', 'MX Player Free Video Downloader', 'mx-player-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('ary_zap_pk', 'Pakistani Drama Portals', 'ARY / Hum / Geo Web Embed Extractor', 'video', '#10B981', 'play', NULL, '["aryzap.com","hum.tv","harpalgeo.tv"]', 'https://aryzap.com/', 'ary-zap-pk-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Pakistan Hub', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-ary_zap_pk', 'Pakistani Drama Portals Video Downloader', 'ary-zap-pk-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('direct_hls', 'Direct MP4 / MKV / M3U8', '16-Thread IDM Parallel Stream Engine', 'video', '#38BDF8', 'globe', NULL, '["commondatastorage.googleapis.com","test-streams.mux.dev","interactive-examples.mdn.mozilla.net"]', 'https://interactive-examples.mdn.mozilla.net/media/cc0-videos/flower.mp4', 'direct-hls-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-direct_hls', 'Direct MP4 / MKV / M3U8 Video Downloader', 'direct-hls-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('coursera', 'Coursera (Free & Enrolled)', 'Open Previews + Enrolled Cookie Video/SRT', 'education', '#0056D2', 'coursera', NULL, '["coursera.org"]', 'https://coursera.org/', 'coursera-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-coursera', 'Coursera (Free & Enrolled) Video Downloader', 'coursera-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('udemy', 'Udemy (Open & Enrolled)', 'Free Previews + Enrolled Non-DRM via Cookie', 'education', '#A435F0', 'udemy', NULL, '["udemy.com"]', 'https://udemy.com/', 'udemy-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-udemy', 'Udemy (Open & Enrolled) Video Downloader', 'udemy-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('edx', 'edX University Courses', 'Open Audit & Enrolled HD Lecture MP4', 'education', '#02262B', 'education', NULL, '["edx.org","courses.edx.org"]', 'https://edx.org/', 'edx-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-edx', 'edX University Courses Video Downloader', 'edx-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('mit_ocw', 'MIT OpenCourseWare', '100% Free Full University Video Lectures', 'education', '#A31F34', 'education', NULL, '["ocw.mit.edu"]', 'https://ocw.mit.edu/', 'mit-ocw-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-mit_ocw', 'MIT OpenCourseWare Video Downloader', 'mit-ocw-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('harvard_cs50', 'Harvard CS50 Portal', 'Free 4K Computer Science Lectures & SRT', 'education', '#C41230', 'education', NULL, '["cs50.harvard.edu","cs50.tv"]', 'https://cs50.harvard.edu/', 'harvard-cs50-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-harvard_cs50', 'Harvard CS50 Portal Video Downloader', 'harvard-cs50-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('khan_academy', 'Khan Academy', 'Free Math, Science & SAT Video Lessons', 'education', '#14BF96', 'education', NULL, '["khanacademy.org"]', 'https://khanacademy.org/', 'khan-academy-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-khan_academy', 'Khan Academy Video Downloader', 'khan-academy-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('freecodecamp', 'freeCodeCamp.org', 'Full 10-Hour Coding Bootcamps in HD', 'education', '#0A0A23', 'education', NULL, '["freecodecamp.org"]', 'https://freecodecamp.org/', 'freecodecamp-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-freecodecamp', 'freeCodeCamp.org Video Downloader', 'freecodecamp-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('nptel_swayam', 'NPTEL / SWAYAM', 'Free Engineering & University Lectures', 'education', '#FF6B00', 'education', NULL, '["nptel.ac.in","swayam.gov.in"]', 'https://nptel.ac.in/', 'nptel-swayam-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-nptel_swayam', 'NPTEL / SWAYAM Video Downloader', 'nptel-swayam-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('vu_pakistan', 'Virtual University PK', 'VU OpenCourseWare & Lecture Videos PK', 'education', '#059669', 'education', NULL, '["ocw.vu.edu.pk","vu.edu.pk"]', 'https://ocw.vu.edu.pk/', 'vu-pakistan-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Pakistan Edu', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-vu_pakistan', 'Virtual University PK Video Downloader', 'vu-pakistan-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('digiskills_pk', 'DigiSkills Pakistan', 'Free Freelancing & IT Training Videos', 'education', '#16A34A', 'education', NULL, '["digiskills.pk","lms.digiskills.pk"]', 'https://digiskills.pk/', 'digiskills-pk-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Pakistan Edu', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-digiskills_pk', 'DigiSkills Pakistan Video Downloader', 'digiskills-pk-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('stanford_online', 'Stanford Online', 'Public AI & CS Lecture Video Extractor', 'education', '#8C1515', 'education', NULL, '["online.stanford.edu"]', 'https://online.stanford.edu/', 'stanford-online-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-stanford_online', 'Stanford Online Video Downloader', 'stanford-online-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('yale_courses', 'Open Yale Courses', 'Full Free Humanities & Science Courses', 'education', '#00356B', 'education', NULL, '["oyc.yale.edu"]', 'https://oyc.yale.edu/', 'yale-courses-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-yale_courses', 'Open Yale Courses Video Downloader', 'yale-courses-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('ted_talks', 'TED Talks & TED-Ed', '1080p Talks + Multi-Language Subtitles', 'education', '#E62B1E', 'education', NULL, '["ted.com"]', 'https://ted.com/', 'ted-talks-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-ted_talks', 'TED Talks & TED-Ed Video Downloader', 'ted-talks-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('linkedin_learning', 'LinkedIn Learning', 'Preview + Enrolled Cookie Video Saver', 'education', '#0A66C2', 'education', NULL, '["linkedin.com/learning"]', 'https://linkedin.com/learning/', 'linkedin-learning-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-linkedin_learning', 'LinkedIn Learning Video Downloader', 'linkedin-learning-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('skillshare', 'Skillshare Classes', 'Preview + Non-DRM Class Stream Extractor', 'education', '#00FF84', 'education', NULL, '["skillshare.com"]', 'https://skillshare.com/', 'skillshare-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-skillshare', 'Skillshare Classes Video Downloader', 'skillshare-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('pluralsight', 'Pluralsight Tech', 'Preview + Cookie Authenticated Courses', 'education', '#F15B2A', 'education', NULL, '["pluralsight.com"]', 'https://pluralsight.com/', 'pluralsight-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-pluralsight', 'Pluralsight Tech Video Downloader', 'pluralsight-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('teachable', 'Teachable Courses', ' Wistia/HLS Free & Enrolled Course Saver', 'education', '#1EA69A', 'education', NULL, '["teachable.com","fast.wistia.net"]', 'https://teachable.com/', 'teachable-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-teachable', 'Teachable Courses Video Downloader', 'teachable-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('thinkific', 'Thinkific Academy', 'Free Lessons & Enrolled Student Videos', 'education', '#2B6CB0', 'education', NULL, '["thinkific.com"]', 'https://thinkific.com/', 'thinkific-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-thinkific', 'Thinkific Academy Video Downloader', 'thinkific-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('kajabi', 'Kajabi Creator Courses', 'Embedded Wistia/Vimeo Course Extractor', 'education', '#2563EB', 'education', NULL, '["kajabi.com","mykajabi.com"]', 'https://kajabi.com/', 'kajabi-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-kajabi', 'Kajabi Creator Courses Video Downloader', 'kajabi-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('skool_classroom', 'Skool Classroom', 'Community Course Loom/Mux Video Saver', 'education', '#F59E0B', 'education', NULL, '["skool.com"]', 'https://skool.com/', 'skool-classroom-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-skool_classroom', 'Skool Classroom Video Downloader', 'skool-classroom-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('podia', 'Podia Courses', 'Free Webinars & Enrolled Course Videos', 'education', '#6366F1', 'education', NULL, '["podia.com"]', 'https://podia.com/', 'podia-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-podia', 'Podia Courses Video Downloader', 'podia-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('gumroad_courses', 'Gumroad Video Tutorials', 'Purchased & Free Creator Video Streams', 'education', '#FF90E8', 'education', NULL, '["gumroad.com","app.gumroad.com"]', 'https://gumroad.com/', 'gumroad-courses-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-gumroad_courses', 'Gumroad Video Tutorials Video Downloader', 'gumroad-courses-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('domestika', 'Domestika Creative', 'Open Previews & Non-DRM Lesson Saver', 'education', '#F02D00', 'education', NULL, '["domestika.org"]', 'https://domestika.org/', 'domestika-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-domestika', 'Domestika Creative Video Downloader', 'domestika-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('hotmart_club', 'Hotmart Academy', 'Creator Course Embedded Stream Sniffer', 'education', '#F04E23', 'education', NULL, '["hotmart.com"]', 'https://hotmart.com/', 'hotmart-club-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-hotmart_club', 'Hotmart Academy Video Downloader', 'hotmart-club-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('loom_lectures', 'Loom Class Recordings', 'Instant 1080p Screen & Lecture Saver', 'education', '#625DF5', 'loom', NULL, '["loom.com"]', 'https://loom.com/', 'loom-lectures-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-loom_lectures', 'Loom Class Recordings Video Downloader', 'loom-lectures-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('panopto', 'Panopto University LMS', 'Public & Authenticated Campus Recordings', 'education', '#047857', 'education', NULL, '["panopto.com"]', 'https://panopto.com/', 'panopto-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-panopto', 'Panopto University LMS Video Downloader', 'panopto-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('kaltura_edu', 'Kaltura Campus Media', 'University MediaSpace HLS/MP4 Extractor', 'education', '#0284C7', 'education', NULL, '["kaltura.com"]', 'https://kaltura.com/', 'kaltura-edu-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-kaltura_edu', 'Kaltura Campus Media Video Downloader', 'kaltura-edu-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('echo360', 'Echo360 Lecture Capture', 'Recorded Classroom Stream Downloader', 'education', '#0EA5E9', 'education', NULL, '["echo360.org","echo360.ca"]', 'https://echo360.org/', 'echo360-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-echo360', 'Echo360 Lecture Capture Video Downloader', 'echo360-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('zoom_cloud', 'Zoom Cloud Recordings', 'Shared Meeting & Webinar MP4 Extractor', 'education', '#2D8CFF', 'loom', NULL, '["zoom.us/rec"]', 'https://zoom.us/rec/', 'zoom-cloud-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-zoom_cloud', 'Zoom Cloud Recordings Video Downloader', 'zoom-cloud-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('bigbluebutton', 'BigBlueButton LMS', 'Open-Source University Lecture Saver', 'education', '#1D4ED8', 'education', NULL, '["bigbluebutton.org"]', 'https://bigbluebutton.org/', 'bigbluebutton-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-bigbluebutton', 'BigBlueButton LMS Video Downloader', 'bigbluebutton-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('alison_openlearn', 'OpenLearn & Alison', 'Free Certificate Course Video Sniffer', 'education', '#0D9488', 'education', NULL, '["open.edu","alison.com"]', 'https://open.edu/', 'alison-openlearn-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-alison_openlearn', 'OpenLearn & Alison Video Downloader', 'alison-openlearn-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('laracasts_scrimba', 'Laracasts & Dev Casts', 'Full HD Developer Screencast Extractor', 'education', '#EF4444', 'education', NULL, '["laracasts.com","egghead.io"]', 'https://laracasts.com/', 'laracasts-scrimba-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-laracasts_scrimba', 'Laracasts & Dev Casts Video Downloader', 'laracasts-scrimba-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('terabox_app', 'TeraBox.app (Official)', 'Free Native 16x Turbo Stream + Full MP4', 'cloud_terabox', '#0EA5E9', 'terabox', NULL, '["terabox.app","www.terabox.ap"]', 'https://www.terabox.app/sharing/link?surl=IRHSOPX5IEPgJT7l9IoNlg', 'terabox-app-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-terabox_app', 'TeraBox.app (Official) Video Downloader', 'terabox-app-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('terabox_com', 'TeraBox.com', '100% Free No-Key Full Video & Folder Saver', 'cloud_terabox', '#1D6FF2', 'terabox', NULL, '["terabox.com"]', 'https://www.terabox.app/sharing/link?surl=IRHSOPX5IEPgJT7l9IoNlg', 'terabox-com-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-terabox_com', 'TeraBox.com Video Downloader', 'terabox-com-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('teraviralhub', 'TeraViralHub.com', 'Auto Unwraps Viral Share Posts -> MP4', 'cloud_terabox', '#06B6D4', 'terabox', NULL, '["teraviralhub.com"]', 'https://teraviralhub.com/', 'teraviralhub-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-teraviralhub', 'TeraViralHub.com Video Downloader', 'teraviralhub-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('iteraplay_free', 'iTeraPlay.com (Free Engine)', 'Built-In 100% Free iTeraPlay Link Resolver', 'cloud_terabox', '#38BDF8', 'terabox', NULL, '["iteraplay.com","iteraplayvideo.com"]', 'https://iteraplay.com/', 'iteraplay-free-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-iteraplay_free', 'iTeraPlay.com (Free Engine) Video Downloader', 'iteraplay-free-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('mirrobox', 'MirroBox (ww & www)', 'Supports ww.mirrobox.com & mirrobox.com', 'cloud_terabox', '#0284C7', 'terabox', NULL, '["mirrobox.com","ww.mirrobox.com"]', 'https://mirrobox.com/', 'mirrobox-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-mirrobox', 'MirroBox (ww & www) Video Downloader', 'mirrobox-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('nephobox', 'NephoBox.com', 'Full Cloud Player + 16x Fast MP4 Download', 'cloud_terabox', '#2563EB', 'terabox', NULL, '["nephobox.com"]', 'https://nephobox.com/', 'nephobox-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-nephobox', 'NephoBox.com Video Downloader', 'nephobox-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('freeterabox', 'FreeTeraBox.com', 'Instant Free HLS Stream + MP4 Muxer', 'cloud_terabox', '#0EA5E9', 'terabox', NULL, '["freeterabox.com"]', 'https://freeterabox.com/', 'freeterabox-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-freeterabox', 'FreeTeraBox.com Video Downloader', 'freeterabox-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('tera1024', '1024Tera (.com & .co)', 'Supports 1024tera.com & www.1024tera.co', 'cloud_terabox', '#06B6D4', 'terabox', NULL, '["1024tera.com","1024tera.co"]', 'https://1024tera.com/', 'tera1024-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-tera1024', '1024Tera (.com & .co) Video Downloader', 'tera1024-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('funbox4', '4FunBox (.com & .co)', 'Supports 4funbox.co & www.4funbox.com', 'cloud_terabox', '#3B82F6', 'terabox', NULL, '["4funbox.com","4funbox.co"]', 'https://4funbox.com/', 'funbox4-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-funbox4', '4FunBox (.com & .co) Video Downloader', 'funbox4-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('momerybox', 'MomeryBox.com', 'Supports momerybox.com & www.momerybox.com', 'cloud_terabox', '#0EA5E9', 'terabox', NULL, '["momerybox.com"]', 'https://momerybox.com/', 'momerybox-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-momerybox', 'MomeryBox.com Video Downloader', 'momerybox-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('tibibox', 'TibiBox.com', 'Supports tibibox.com & www.tibibox.com', 'cloud_terabox', '#0284C7', 'terabox', NULL, '["tibibox.com"]', 'https://tibibox.com/', 'tibibox-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-tibibox', 'TibiBox.com Video Downloader', 'tibibox-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('terabox_fun', 'TeraBox.fun', 'Instant Share Link Player & MP4 Saver', 'cloud_terabox', '#38BDF8', 'terabox', NULL, '["terabox.fun"]', 'https://terabox.fun/', 'terabox-fun-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-terabox_fun', 'TeraBox.fun Video Downloader', 'terabox-fun-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('teraboxapp_com', 'TeraBoxApp.com', 'Supports teraboxapp.com & Mobile Shares', 'cloud_terabox', '#1D6FF2', 'terabox', NULL, '["teraboxapp.com"]', 'https://teraboxapp.com/', 'teraboxapp-com-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-teraboxapp_com', 'TeraBoxApp.com Video Downloader', 'teraboxapp-com-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('terabox1024', '1024TeraBox.com', 'Direct Mirror Share Folder & Video Engine', 'cloud_terabox', '#0891B2', 'terabox', NULL, '["1024terabox.com"]', 'https://1024terabox.com/', 'terabox1024-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-terabox1024', '1024TeraBox.com Video Downloader', 'terabox1024-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('terasharelink', 'TeraShareLink.com', 'Shared Cloud Link Online Player & Saver', 'cloud_terabox', '#06B6D4', 'terashare', NULL, '["terasharelink.com"]', 'https://terasharelink.com/', 'terasharelink-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-terasharelink', 'TeraShareLink.com Video Downloader', 'terasharelink-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('terasharefile', 'TeraShareFile.com', 'Cloud Video Mirror Fast Stream Resolver', 'cloud_terabox', '#0284C7', 'terashare', NULL, '["terasharefile.com"]', 'https://terasharefile.com/', 'terasharefile-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-terasharefile', 'TeraShareFile.com Video Downloader', 'terasharefile-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('terafileshare', 'TeraFileShare.com', 'Zero-Login Cloud Video Extractor', 'cloud_terabox', '#0EA5E9', 'terashare', NULL, '["terafileshare.com"]', 'https://terafileshare.com/', 'terafileshare-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-terafileshare', 'TeraFileShare.com Video Downloader', 'terafileshare-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('teraboxlink', 'TeraBoxLink & URL', 'Shortened Cloud Share Link Unwrapper', 'cloud_terabox', '#2563EB', 'terashare', NULL, '["teraboxlink.com","teraboxurl.com","teraboxshare.com"]', 'https://teraboxlink.com/', 'teraboxlink-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-teraboxlink', 'TeraBoxLink & URL Video Downloader', 'teraboxlink-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('gdrive', 'Google Drive Public', 'Shared MP4/MKV Large File Bypass Saver', 'cloud_terabox', '#10B981', 'gdrive', NULL, '["drive.google.com","docs.google.com"]', 'https://drive.google.com/', 'gdrive-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-gdrive', 'Google Drive Public Video Downloader', 'gdrive-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('mediafire', 'MediaFire Cloud', 'Direct High-Speed 16x IDM File Extractor', 'cloud_terabox', '#0070F3', 'terashare', NULL, '["mediafire.com"]', 'https://mediafire.com/', 'mediafire-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-mediafire', 'MediaFire Cloud Video Downloader', 'mediafire-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('dropbox', 'Dropbox Shared Video', 'Raw Binary Stream & Fast MP4 Download', 'cloud_terabox', '#0061FF', 'terashare', NULL, '["dropbox.com"]', 'https://dropbox.com/', 'dropbox-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-dropbox', 'Dropbox Shared Video Video Downloader', 'dropbox-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('onedrive_share', 'OneDrive Shared Link', 'Microsoft Cloud Shared Video Streamer', 'cloud_terabox', '#0078D4', 'gdrive', NULL, '["1drv.ms","onedrive.live.com"]', 'https://1drv.ms/', 'onedrive-share-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-onedrive_share', 'OneDrive Shared Link Video Downloader', 'onedrive-share-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('pixeldrain', 'PixelDrain Cloud', 'Full Gigabit 16x Parallel Cloud Download', 'cloud_terabox', '#8B5CF6', 'gdrive', NULL, '["pixeldrain.com"]', 'https://pixeldrain.com/', 'pixeldrain-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-pixeldrain', 'PixelDrain Cloud Video Downloader', 'pixeldrain-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('gofile_io', 'GoFile.io Cloud', 'High-Speed Shared Video Folder Extractor', 'cloud_terabox', '#14B8A6', 'terashare', NULL, '["gofile.io"]', 'https://gofile.io/', 'gofile-io-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-gofile_io', 'GoFile.io Cloud Video Downloader', 'gofile-io-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('streamtape', 'Streamtape Cloud', 'Movie Embed Cloud Stream Unwrapper', 'cloud_terabox', '#F59E0B', 'terashare', NULL, '["streamtape.com","streamtape.to"]', 'https://streamtape.com/', 'streamtape-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-streamtape', 'Streamtape Cloud Video Downloader', 'streamtape-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('doodstream', 'DoodStream / MyVidPlay', 'Viral Cloud Video Embed Extractor', 'cloud_terabox', '#EF4444', 'terashare', NULL, '["doodstream.com","dood.li","myvidplay.com"]', 'https://doodstream.com/', 'doodstream-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-doodstream', 'DoodStream / MyVidPlay Video Downloader', 'doodstream-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('mixdrop', 'MixDrop Cloud', 'Embedded Cloud MP4 Video Resolver', 'cloud_terabox', '#EC4899', 'terashare', NULL, '["mixdrop.ag","mixdrop.co"]', 'https://mixdrop.ag/', 'mixdrop-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-mixdrop', 'MixDrop Cloud Video Downloader', 'mixdrop-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('voe_cloud', 'VOE.sx Cloud', 'HLS Cloud Movie Host Stream Saver', 'cloud_terabox', '#6366F1', 'terashare', NULL, '["voe.sx"]', 'https://voe.sx/', 'voe-cloud-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-voe_cloud', 'VOE.sx Cloud Video Downloader', 'voe-cloud-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('filemoon', 'FileMoon HD Cloud', '1080p HLS Cloud Stream Extractor', 'cloud_terabox', '#F97316', 'terashare', NULL, '["filemoon.sx","filemoon.in"]', 'https://filemoon.sx/', 'filemoon-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-filemoon', 'FileMoon HD Cloud Video Downloader', 'filemoon-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('krakenfiles', 'KrakenFiles Audio/Video', 'Instant Cloud MP4 & MP3 Fast Saver', 'cloud_terabox', '#06B6D4', 'gdrive', NULL, '["krakenfiles.com"]', 'https://krakenfiles.com/', 'krakenfiles-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-krakenfiles', 'KrakenFiles Audio/Video Video Downloader', 'krakenfiles-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('pcloud_yandex', 'pCloud & Yandex Disk', 'Public Cloud Drive Stream Extractor', 'cloud_terabox', '#22C55E', 'gdrive', NULL, '["pcloud.link","disk.yandex.com","yadi.sk"]', 'https://pcloud.link/', 'pcloud-yandex-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-pcloud_yandex', 'pCloud & Yandex Disk Video Downloader', 'pcloud-yandex-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('sendvid_cloud', 'SendVid & Catbox', 'Instant Direct Cloud MP4 Host Saver', 'cloud_terabox', '#38BDF8', 'terashare', NULL, '["sendvid.com","files.catbox.moe"]', 'https://sendvid.com/', 'sendvid-cloud-video-downloader', 0, 0, 1, 1, 1, 1, 'operational', 'Global', '2026-10-23T00:00:00.000Z');
INSERT INTO `seo_keywords` VALUES ('seo-sendvid_cloud', 'SendVid & Catbox Video Downloader', 'sendvid-cloud-video-downloader', 0, 0, '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_ph', 'Pornhub', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#F97316', 'adult_ph', NULL, '["pornhub.com"]', 'https://pornhub.com/', 'adult-ph-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_xh', 'xHamster', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#EC4899', 'adult_ph', NULL, '["xhamster.com"]', 'https://xhamster.com/', 'adult-xh-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_xv', 'XVideos', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#EF4444', 'adult_ph', NULL, '["xvideos.com"]', 'https://xvideos.com/', 'adult-xv-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_xnxx', 'XNXX HD', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#2563EB', 'adult_ph', NULL, '["xnxx.com"]', 'https://xnxx.com/', 'adult-xnxx-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_redtube', 'RedTube', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#DC2626', 'adult_ph', NULL, '["redtube.com"]', 'https://redtube.com/', 'adult-redtube-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_youporn', 'YouPorn', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#F43F5E', 'adult_ph', NULL, '["youporn.com"]', 'https://youporn.com/', 'adult-youporn-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_spankbang', 'SpankBang 4K', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#F97316', 'adult_ph', NULL, '["spankbang.com"]', 'https://spankbang.com/', 'adult-spankbang-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_eporner', 'Eporner 4K 60fps', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#EF4444', 'adult_ph', NULL, '["eporner.com"]', 'https://eporner.com/', 'adult-eporner-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_tube8', 'Tube8 HD', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#E11D48', 'adult_ph', NULL, '["tube8.com"]', 'https://tube8.com/', 'adult-tube8-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_tnaflix', 'TNAFlix', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#DB2777', 'adult_ph', NULL, '["tnaflix.com"]', 'https://tnaflix.com/', 'adult-tnaflix-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_sunporno', 'SunPorno', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#F59E0B', 'adult_ph', NULL, '["sunporno.com"]', 'https://sunporno.com/', 'adult-sunporno-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_motherless', 'Motherless Media', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#991B1B', 'adult_ph', NULL, '["motherless.com"]', 'https://motherless.com/', 'adult-motherless-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_thumbzilla', 'Thumbzilla HD', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#FB7185', 'adult_ph', NULL, '["thumbzilla.com"]', 'https://thumbzilla.com/', 'adult-thumbzilla-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_beeg', 'Beeg 4K', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#F43F5E', 'adult_ph', NULL, '["beeg.com"]', 'https://beeg.com/', 'adult-beeg-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_hclips', 'HClips', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#EC4899', 'adult_ph', NULL, '["hclips.com"]', 'https://hclips.com/', 'adult-hclips-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_txxx', 'TXXX HD', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#EF4444', 'adult_ph', NULL, '["txxx.com"]', 'https://txxx.com/', 'adult-txxx-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_upornia', 'UPornia', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#D946EF', 'adult_ph', NULL, '["upornia.com"]', 'https://upornia.com/', 'adult-upornia-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_vjav', 'VJav HD', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#EC4899', 'adult_ph', NULL, '["vjav.com"]', 'https://vjav.com/', 'adult-vjav-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_javhd', 'JavHD Clips', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#F43F5E', 'adult_ph', NULL, '["javhd.com"]', 'https://javhd.com/', 'adult-javhd-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_missav', 'MissAV HLS', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#E11D48', 'adult_ph', NULL, '["missav.com"]', 'https://missav.com/', 'adult-missav-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_thisav', 'ThisAV', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#FB7185', 'adult_ph', NULL, '["thisav.com"]', 'https://thisav.com/', 'adult-thisav-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_fuq', 'Fuq Aggregator', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#F97316', 'adult_ph', NULL, '["fuq.com"]', 'https://fuq.com/', 'adult-fuq-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_drtuber', 'DrTuber', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#EF4444', 'adult_ph', NULL, '["drtuber.com"]', 'https://drtuber.com/', 'adult-drtuber-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_nuvid', 'NuVid HD', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#EC4899', 'adult_ph', NULL, '["nuvid.com"]', 'https://nuvid.com/', 'adult-nuvid-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_pornone', 'PornOne', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#F59E0B', 'adult_ph', NULL, '["pornone.com"]', 'https://pornone.com/', 'adult-pornone-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_porntrex', 'PornTrex 4K', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#E11D48', 'adult_ph', NULL, '["porntrex.com"]', 'https://porntrex.com/', 'adult-porntrex-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_hqporner', 'HQPorner 1080p', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#DC2626', 'adult_ph', NULL, '["hqporner.com"]', 'https://hqporner.com/', 'adult-hqporner-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_4tube', '4Tube HD', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#F43F5E', 'adult_ph', NULL, '["4tube.com"]', 'https://4tube.com/', 'adult-4tube-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_pornmd', 'PornMD', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#FB7185', 'adult_ph', NULL, '["pornmd.com"]', 'https://pornmd.com/', 'adult-pornmd-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_empflix', 'EmpFlix', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#EC4899', 'adult_ph', NULL, '["empflix.com"]', 'https://empflix.com/', 'adult-empflix-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_redgifs', 'RedGifs HD Sound', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#A855F7', 'adult_ph', NULL, '["redgifs.com"]', 'https://redgifs.com/', 'adult-redgifs-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_erome', 'EroMe Albums', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#EC4899', 'adult_ph', NULL, '["erome.com"]', 'https://erome.com/', 'adult-erome-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_bunkr', 'Bunkr Vault', '18+ USA Direct · PK Open/DoH · Fast MP4/HLS', 'adult_18', '#8B5CF6', 'adult_ph', NULL, '["bunkr.si"]', 'https://bunkr.si/', 'adult-bunkr-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK Open/DoH', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_cyberdrop', 'Cyberdrop Media', '18+ USA Direct · PK Open/DoH · Fast MP4/HLS', 'adult_18', '#6366F1', 'adult_ph', NULL, '["cyberdrop.me"]', 'https://cyberdrop.me/', 'adult-cyberdrop-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK Open/DoH', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_coomer', 'Coomer Party', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#EC4899', 'adult_ph', NULL, '["coomer.su"]', 'https://coomer.su/', 'adult-coomer-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_rule34', 'Rule34Video', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#10B981', 'adult_ph', NULL, '["rule34video.com"]', 'https://rule34video.com/', 'adult-rule34-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_hanime', 'Hanime 1080p', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#F43F5E', 'adult_ph', NULL, '["hanime.tv"]', 'https://hanime.tv/', 'adult-hanime-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_hentaihaven', 'HentaiHaven', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#EF4444', 'adult_ph', NULL, '["hentaihaven.xxx"]', 'https://hentaihaven.xxx/', 'adult-hentaihaven-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_iwara', 'Iwara 3D HD', '18+ USA Direct · PK Open/DoH · Fast MP4/HLS', 'adult_18', '#EC4899', 'adult_ph', NULL, '["iwara.tv"]', 'https://iwara.tv/', 'adult-iwara-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK Open/DoH', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_newgrounds', 'Newgrounds 18+', '18+ USA Direct · PK Open · Fast MP4/HLS', 'adult_18', '#F59E0B', 'adult_ph', NULL, '["newgrounds.com"]', 'https://newgrounds.com/', 'adult-newgrounds-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK Open', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_chaturbate', 'Chaturbate Clips', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#F97316', 'adult_ph', NULL, '["chaturbate.com"]', 'https://chaturbate.com/', 'adult-chaturbate-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_stripchat', 'Stripchat Stream', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#E11D48', 'adult_ph', NULL, '["stripchat.com"]', 'https://stripchat.com/', 'adult-stripchat-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_bongacams', 'BongaCams Stream', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#EC4899', 'adult_ph', NULL, '["bongacams.com"]', 'https://bongacams.com/', 'adult-bongacams-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_cam4', 'Cam4 Live/Clips', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#FB923C', 'adult_ph', NULL, '["cam4.com"]', 'https://cam4.com/', 'adult-cam4-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_myfreecams', 'MyFreeCams Clips', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#22C55E', 'adult_ph', NULL, '["myfreecams.com"]', 'https://myfreecams.com/', 'adult-myfreecams-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_livejasmin', 'LiveJasmin Clips', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#EF4444', 'adult_ph', NULL, '["livejasmin.com"]', 'https://livejasmin.com/', 'adult-livejasmin-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_onlyfans_free', 'OnlyFans Public', '18+ Cookie/Preview · USA/PK · Fast MP4/HLS', 'adult_18', '#00AFF0', 'adult_ph', NULL, '["onlyfans.com"]', 'https://onlyfans.com/', 'adult-onlyfans-free-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'Cookie/Preview · USA/PK', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_fansly', 'Fansly Public', '18+ Cookie/Preview · USA/PK · Fast MP4/HLS', 'adult_18', '#38BDF8', 'adult_ph', NULL, '["fansly.com"]', 'https://fansly.com/', 'adult-fansly-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'Cookie/Preview · USA/PK', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_manyvids', 'ManyVids Trailers', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#EC4899', 'adult_ph', NULL, '["manyvids.com"]', 'https://manyvids.com/', 'adult-manyvids-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_clips4sale', 'Clips4Sale Previews', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#F43F5E', 'adult_ph', NULL, '["clips4sale.com"]', 'https://clips4sale.com/', 'adult-clips4sale-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_loyalfans', 'LoyalFans Clips', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#FB7185', 'adult_ph', NULL, '["loyalfans.com"]', 'https://loyalfans.com/', 'adult-loyalfans-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_justforfans', 'JustForFans Clips', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#A855F7', 'adult_ph', NULL, '["justfor.fans"]', 'https://justfor.fans/', 'adult-justforfans-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_brazzers', 'Brazzers Trailers', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#FACC15', 'adult_ph', NULL, '["brazzers.com"]', 'https://brazzers.com/', 'adult-brazzers-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_bangbros', 'BangBros Trailers', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#F97316', 'adult_ph', NULL, '["bangbros.com"]', 'https://bangbros.com/', 'adult-bangbros-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_realitykings', 'RealityKings Clips', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#EAB308', 'adult_ph', NULL, '["realitykings.com"]', 'https://realitykings.com/', 'adult-realitykings-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_naughtyamerica', 'NaughtyAmerica Clips', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#EF4444', 'adult_ph', NULL, '["naughtyamerica.com"]', 'https://naughtyamerica.com/', 'adult-naughtyamerica-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_mofos', 'Mofos Trailers', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#EC4899', 'adult_ph', NULL, '["mofos.com"]', 'https://mofos.com/', 'adult-mofos-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_teamskeet', 'TeamSkeet Clips', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#0EA5E9', 'adult_ph', NULL, '["teamskeet.com"]', 'https://teamskeet.com/', 'adult-teamskeet-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_adulttime', 'AdultTime Trailers', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#F43F5E', 'adult_ph', NULL, '["adulttime.com"]', 'https://adulttime.com/', 'adult-adulttime-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_digitalplayground', 'DigitalPlayground', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#E11D48', 'adult_ph', NULL, '["digitalplayground.com"]', 'https://digitalplayground.com/', 'adult-digitalplayground-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_babes', 'Babes Network', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#FB7185', 'adult_ph', NULL, '["babes.com"]', 'https://babes.com/', 'adult-babes-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_evilangel', 'EvilAngel Trailers', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#DC2626', 'adult_ph', NULL, '["evilangel.com"]', 'https://evilangel.com/', 'adult-evilangel-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_kink', 'Kink Trailers', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#991B1B', 'adult_ph', NULL, '["kink.com"]', 'https://kink.com/', 'adult-kink-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_pornflip', 'PornFlip HD', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#F97316', 'adult_ph', NULL, '["pornflip.com"]', 'https://pornflip.com/', 'adult-pornflip-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_pornhat', 'PornHat', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#EF4444', 'adult_ph', NULL, '["pornhat.com"]', 'https://pornhat.com/', 'adult-pornhat-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_porndoe', 'PornDoe HD', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#EC4899', 'adult_ph', NULL, '["porndoe.com"]', 'https://porndoe.com/', 'adult-porndoe-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_porn00', 'Porn00', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#F43F5E', 'adult_ph', NULL, '["porn00.org"]', 'https://porn00.org/', 'adult-porn00-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_porngo', 'PornGo 1080p', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#E11D48', 'adult_ph', NULL, '["porngo.com"]', 'https://porngo.com/', 'adult-porngo-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_pornhits', 'PornHits', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#FB7185', 'adult_ph', NULL, '["pornhits.com"]', 'https://pornhits.com/', 'adult-pornhits-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_porntop', 'PornTop', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#F59E0B', 'adult_ph', NULL, '["porntop.com"]', 'https://porntop.com/', 'adult-porntop-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_porndig', 'PornDig 4K', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#EF4444', 'adult_ph', NULL, '["porndig.com"]', 'https://porndig.com/', 'adult-porndig-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_porntube', 'PornTube HD', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#DC2626', 'adult_ph', NULL, '["porntube.com"]', 'https://porntube.com/', 'adult-porntube-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_pornhd', 'PornHD 1080p', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#F97316', 'adult_ph', NULL, '["pornhd.com"]', 'https://pornhd.com/', 'adult-pornhd-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_pornvibe', 'PornVibe', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#EC4899', 'adult_ph', NULL, '["pornvibe.org"]', 'https://pornvibe.org/', 'adult-pornvibe-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_xozilla', 'Xozilla HD', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#F43F5E', 'adult_ph', NULL, '["xozilla.com"]', 'https://xozilla.com/', 'adult-xozilla-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_xxxbunker', 'XXXBunker', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#991B1B', 'adult_ph', NULL, '["xxxbunker.com"]', 'https://xxxbunker.com/', 'adult-xxxbunker-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_anysex', 'AnySex Video', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#FB7185', 'adult_ph', NULL, '["anysex.com"]', 'https://anysex.com/', 'adult-anysex-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_bravotube', 'BravoTube', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#E11D48', 'adult_ph', NULL, '["bravotube.net"]', 'https://bravotube.net/', 'adult-bravotube-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_alphaporno', 'AlphaPorno', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#EC4899', 'adult_ph', NULL, '["alphaporno.com"]', 'https://alphaporno.com/', 'adult-alphaporno-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_analdin', 'Analdin HD', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#EF4444', 'adult_ph', NULL, '["analdin.com"]', 'https://analdin.com/', 'adult-analdin-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_gotporn', 'GotPorn', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#F97316', 'adult_ph', NULL, '["gotporn.com"]', 'https://gotporn.com/', 'adult-gotporn-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_hdzog', 'HDZog 1080p', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#E11D48', 'adult_ph', NULL, '["hdzog.com"]', 'https://hdzog.com/', 'adult-hdzog-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_hotmovs', 'HotMovs', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#F43F5E', 'adult_ph', NULL, '["hotmovs.com"]', 'https://hotmovs.com/', 'adult-hotmovs-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_iceporn', 'IcePorn', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#38BDF8', 'adult_ph', NULL, '["iceporn.com"]', 'https://iceporn.com/', 'adult-iceporn-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_jizzbunker', 'JizzBunker', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#FB7185', 'adult_ph', NULL, '["jizzbunker.com"]', 'https://jizzbunker.com/', 'adult-jizzbunker-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_lovehomeporn', 'LoveHomePorn', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#EC4899', 'adult_ph', NULL, '["lovehomeporn.com"]', 'https://lovehomeporn.com/', 'adult-lovehomeporn-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_movs4k', 'Movs4K Ultra', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#A855F7', 'adult_ph', NULL, '["movs4k.com"]', 'https://movs4k.com/', 'adult-movs4k-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_netfapx', 'NetFapX', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#EF4444', 'adult_ph', NULL, '["netfapx.com"]', 'https://netfapx.com/', 'adult-netfapx-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_newsyporn', 'NewsyPorn', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#F97316', 'adult_ph', NULL, '["newsyporn.com"]', 'https://newsyporn.com/', 'adult-newsyporn-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_nonstoppartner', 'NonStopPartner', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#E11D48', 'adult_ph', NULL, '["nonstoppartner.com"]', 'https://nonstoppartner.com/', 'adult-nonstoppartner-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_okxxx', 'okXXX HD', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#EC4899', 'adult_ph', NULL, '["ok.xxx"]', 'https://ok.xxx/', 'adult-okxxx-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_pervclips', 'PervClips', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#F43F5E', 'adult_ph', NULL, '["pervclips.com"]', 'https://pervclips.com/', 'adult-pervclips-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_plusone8', 'PlusOne8', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#FB7185', 'adult_ph', NULL, '["plusone8.com"]', 'https://plusone8.com/', 'adult-plusone8-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_pornlib', 'PornLib', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#EF4444', 'adult_ph', NULL, '["pornlib.com"]', 'https://pornlib.com/', 'adult-pornlib-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_pornovoisines', 'PornoVoisines', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#EC4899', 'adult_ph', NULL, '["pornovoisines.com"]', 'https://pornovoisines.com/', 'adult-pornovoisines-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_sexu', 'Sexu HD', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#E11D48', 'adult_ph', NULL, '["sexu.com"]', 'https://sexu.com/', 'adult-sexu-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_sxyprn', 'SxyPrn Full HD', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#A855F7', 'adult_ph', NULL, '["sxyprn.com"]', 'https://sxyprn.com/', 'adult-sxyprn-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_trendyporn', 'TrendyPorn', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#F97316', 'adult_ph', NULL, '["trendyporn.com"]', 'https://trendyporn.com/', 'adult-trendyporn-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_heavyr', 'Heavy-R Video', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#DC2626', 'adult_ph', NULL, '["heavy-r.com"]', 'https://heavy-r.com/', 'adult-heavyr-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_biqle', 'Biqle HD', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#3B82F6', 'adult_ph', NULL, '["biqle.ru"]', 'https://biqle.ru/', 'adult-biqle-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_fapello', 'Fapello Video', '18+ USA Direct · PK DoH/Proxy · Fast MP4/HLS', 'adult_18', '#EC4899', 'adult_ph', NULL, '["fapello.com"]', 'https://fapello.com/', 'adult-fapello-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK DoH/Proxy', '2026-10-23T00:00:00.000Z');
INSERT INTO `platforms` VALUES ('adult_imgur_nsfw', 'NSFW GIF/MP4 Mirrors', '18+ USA Direct · PK Open/DoH · Fast MP4/HLS', 'adult_18', '#8B5CF6', 'adult_ph', NULL, '["gifdeliverynetwork.com"]', 'https://gifdeliverynetwork.com/', 'adult-imgur-nsfw-video-downloader', 1, 0, 1, 1, 1, 1, 'operational', 'USA Direct · PK Open/DoH', '2026-10-23T00:00:00.000Z');
INSERT INTO `ad_waterfall_zones` VALUES ('native_banner', 0, 20, '{"enabled":false,"title":"","subtitle":"","ctaText":"Visit Partner","targetUrl":""}', '2026-10-23T00:00:00.000Z');
INSERT INTO `ad_waterfall_zones` VALUES ('player_preroll_vast', 0, 20, '{"enabled":false,"skipAfterSeconds":4,"sponsorBrand":"","headline":""}', '2026-10-23T00:00:00.000Z');
INSERT INTO `ad_waterfall_zones` VALUES ('download_click_direct_tab', 0, 20, '{"enabled":false,"cooldownMinutes":20,"triggerMode":"on_download_click","directUrl":""}', '2026-10-23T00:00:00.000Z');
INSERT INTO `ad_waterfall_zones` VALUES ('progress_modal_sponsor', 0, 20, '{"enabled":false,"title":"","subtitle":""}', '2026-10-23T00:00:00.000Z');
INSERT INTO `system_settings` VALUES ('global', '{"guestDailyDownloadLimit":50,"userDailyDownloadLimit":500,"guestMaxFileSizeMb":8192,"vaultMaxStorageGb":200,"allowAdultSources":true,"storageGateMode":"three_button_admin_gate","idmConnections":16,"dnsOverHttpsBypass":true,"autoUnwrapIteraplay":true}', '2026-10-23T00:00:00.000Z');
