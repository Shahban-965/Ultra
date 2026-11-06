import fs from 'node:fs';
import path from 'node:path';
import { BACKEND_ROOT } from '../config/env.js';

// ============================================================================
// AUTHORIZED DOWNLOAD LIBRARY (single source of truth)
// - Files are resolved ONLY through this registry (never by user input path).
// - Filename + MIME type come from trusted metadata, never from the request.
// - Every path is verified to stay inside FILES_ROOT (no path traversal).
// ============================================================================

export const FILES_ROOT = path.resolve(BACKEND_ROOT, 'storage/files');

const LIBRARY = [
  {
    fileId: 'sample_pdf',
    fileName: 'ShakeelProject_Sample_Guide.pdf',
    mimeType: 'application/pdf',
    title: 'ShakeelProject Sample Guide (PDF)',
    requiresAuth: false,
  },
  {
    fileId: 'sample_zip',
    fileName: 'ShakeelProject_Sample_Pack.zip',
    mimeType: 'application/zip',
    title: 'ShakeelProject Sample Pack (ZIP)',
    requiresAuth: false,
  },
  {
    fileId: 'pro_pack_zip',
    fileName: 'ShakeelProject_Pro_Pack.zip',
    mimeType: 'application/zip',
    title: 'ShakeelProject Pro Pack (account required)',
    requiresAuth: true,
  },
];

function assertInsideRoot(absolutePath) {
  const normalizedRoot = FILES_ROOT.endsWith(path.sep) ? FILES_ROOT : `${FILES_ROOT}${path.sep}`;
  if (!absolutePath.startsWith(normalizedRoot)) {
    const err = new Error('Resolved file path escapes the download storage root.');
    err.code = 'PATH_TRAVERSAL_BLOCKED';
    throw err;
  }
  return absolutePath;
}

export function getLibraryEntry(fileId) {
  const cleanId = String(fileId || '').trim();
  const entry = LIBRARY.find((item) => item.fileId === cleanId);
  if (!entry) return null;

  // Build the absolute path from trusted metadata only.
  const absolutePath = assertInsideRoot(path.resolve(FILES_ROOT, entry.fileName));
  let exists = false;
  let sizeBytes = 0;
  try {
    const stat = fs.statSync(absolutePath);
    exists = stat.isFile();
    sizeBytes = exists ? stat.size : 0;
  } catch {
    exists = false;
  }

  return { ...entry, absolutePath, exists, sizeBytes };
}

export function listLibraryFiles({ includeProtected = false } = {}) {
  return LIBRARY.filter((item) => includeProtected || !item.requiresAuth).map((item) => {
    const resolved = getLibraryEntry(item.fileId);
    return {
      fileId: resolved.fileId,
      fileName: resolved.fileName,
      mimeType: resolved.mimeType,
      title: resolved.title,
      requiresAuth: resolved.requiresAuth,
      sizeBytes: resolved.sizeBytes,
      available: resolved.exists,
      downloadPath: `/api/v1/files/${resolved.fileId}/download`,
    };
  });
}

export const ALLOWED_DOWNLOAD_EXTENSIONS = Object.freeze([
  'pdf',
  'zip',
  'mp4',
  'mkv',
  'webm',
  'mp3',
  'm4a',
  'ts',
  'wav',
  'png',
  'jpg',
  'jpeg',
  'txt',
  'csv',
  'json',
]);

export const MIME_BY_EXTENSION = Object.freeze({
  pdf: 'application/pdf',
  zip: 'application/zip',
  mp4: 'video/mp4',
  mkv: 'video/x-matroska',
  webm: 'video/webm',
  mp3: 'audio/mpeg',
  m4a: 'audio/mp4',
  ts: 'video/mp2t',
  wav: 'audio/wav',
  png: 'image/png',
  jpg: 'image/jpeg',
  jpeg: 'image/jpeg',
  txt: 'text/plain; charset=utf-8',
  csv: 'text/csv; charset=utf-8',
  json: 'application/json; charset=utf-8',
});

export function mimeFromExtension(ext) {
  return MIME_BY_EXTENSION[String(ext || '').toLowerCase()] || 'application/octet-stream';
}
