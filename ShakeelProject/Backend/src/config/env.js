import dotenv from 'dotenv';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __filename = fileURLToPath(import.meta.url);
export const BACKEND_ROOT = path.resolve(path.dirname(__filename), '../..');

dotenv.config({ path: path.join(BACKEND_ROOT, '.env') });

const rawOrigins = process.env.CORS_ORIGINS || 'http://localhost:5173,http://127.0.0.1:5173';

const RAW_NODE_ENV = process.env.NODE_ENV || 'development';
const IS_PROD = RAW_NODE_ENV === 'production';

// In production every secret MUST come from .env — no silent public fallbacks.
function requiredSecret(name, devFallback) {
  const value = process.env[name];
  if (!value) {
    if (IS_PROD) {
      console.error(`[ShakeelProject] Missing required environment variable: ${name} (production mode). Set it in .env and restart.`);
      process.exit(1);
    }
    return devFallback;
  }
  return value;
}

export const ENV = {
  NODE_ENV: RAW_NODE_ENV,
  PORT: Number(process.env.PORT || 4000),
  HOST: process.env.HOST || '0.0.0.0',
  PUBLIC_SITE_URL: process.env.PUBLIC_SITE_URL || 'http://localhost:5173',
  CORS_ORIGINS: rawOrigins
    .split(',')
    .map((o) => o.trim())
    .filter(Boolean),

  // XAMPP MySQL Connection (Default XAMPP: 127.0.0.1:3306, user=root, password="")
  DB_HOST: process.env.DB_HOST || '127.0.0.1',
  DB_PORT: Number(process.env.DB_PORT || 3306),
  DB_USER: process.env.DB_USER || 'root',
  DB_PASSWORD: process.env.DB_PASSWORD ?? '',
  DB_NAME: process.env.DB_NAME || 'shakeelproject_db',

  // Storage Directories
  VAULT_STORAGE_DIR: path.resolve(
    BACKEND_ROOT,
    process.env.VAULT_STORAGE_DIR || './storage/vault'
  ),
  TEMP_EPHEMERAL_DIR: path.resolve(
    BACKEND_ROOT,
    process.env.TEMP_EPHEMERAL_DIR || './storage/tmp'
  ),

  EXTRACTOR_TIMEOUT_MS: Number(process.env.EXTRACTOR_TIMEOUT_MS || 25000),

  JWT_ADMIN_SECRET: requiredSecret('JWT_ADMIN_SECRET', 'shakeel_dev_jwt_admin_8Kq2mZx9Lp4wR7nTvB'),
  JWT_USER_SECRET: requiredSecret('JWT_USER_SECRET', 'shakeel_dev_jwt_user_3Ht7yNc6Qm1sK8dWzA'),
  PADLOCK_TICKET_SECRET: requiredSecret('PADLOCK_TICKET_SECRET', 'shakeel_dev_padlock_5Rv9bXm2Jf6pL3wTgC'),
  AES_256_VAULT_KEY: requiredSecret(
    'AES_256_VAULT_KEY',
    'a1b2c3d4e5f60718293a4b5c6d7e8f90a1b2c3d4e5f60718293a4b5c6d7e8f90'
  ),
  // Master admin identity (seeded into the DB on first start — change in .env!)
  ADMIN_MASTER_PIN: process.env.ADMIN_MASTER_PIN || '741925',
  ADMIN_MASTER_EMAIL: process.env.ADMIN_MASTER_EMAIL || 'shakeel@shakeelproject.local',
  ADMIN_MASTER_PASSWORD: process.env.ADMIN_MASTER_PASSWORD || 'Shakeel@2026#Admin',
  // Real TOTP secret (base32). In production the dev code below is disabled.
  ADMIN_TOTP_SECRET: requiredSecret('ADMIN_TOTP_SECRET', 'JBSWY3DPEHPK3PXP'),
  ADMIN_ALLOW_DEV_TOTP_CODE: IS_PROD ? '' : process.env.ADMIN_ALLOW_DEV_TOTP_CODE || '123456',

  ADMIN_IP_ALLOWLIST: (process.env.ADMIN_IP_ALLOWLIST || '')
    .split(',')
    .map((ip) => ip.trim())
    .filter(Boolean),
  ADMIN_MAX_FAILED_ATTEMPTS: Number(process.env.ADMIN_MAX_FAILED_ATTEMPTS || 3),
  ADMIN_BAN_DURATION_MINUTES: Number(process.env.ADMIN_BAN_DURATION_MINUTES || 30),

  GUEST_DAILY_DOWNLOAD_LIMIT: Number(process.env.GUEST_DAILY_DOWNLOAD_LIMIT || 50),
  USER_DAILY_DOWNLOAD_LIMIT: Number(process.env.USER_DAILY_DOWNLOAD_LIMIT || 500),
};
