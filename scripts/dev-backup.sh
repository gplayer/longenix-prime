#!/usr/bin/env bash
set -euo pipefail

# Dev DB backup script for longenix-prime
# Creates timestamped backups of the DEV database with SHA256 checksums

TS=$(date +%Y%m%d-%H%M%S)
BACKUP_DIR="./backups"
BACKUP_FILE="${BACKUP_DIR}/dev-${TS}.sql"

# Create backups directory if it doesn't exist
mkdir -p "${BACKUP_DIR}"

echo "🔄 Exporting DEV database..."
npx wrangler d1 export longenix_prime_dev_db --local --output "${BACKUP_FILE}"

echo "🔐 Generating checksum..."
sha256sum "${BACKUP_FILE}" > "${BACKUP_FILE}.sha256"

FILESIZE=$(stat -c%s "${BACKUP_FILE}" 2>/dev/null || stat -f%z "${BACKUP_FILE}" 2>/dev/null || echo "unknown")

echo "✅ Backup complete!"
echo "📄 File: ${BACKUP_FILE}"
echo "📊 Size: ${FILESIZE} bytes"
echo "🔑 Checksum: ${BACKUP_FILE}.sha256"

# Verify checksum
echo "🔍 Verifying checksum..."
if sha256sum -c "${BACKUP_FILE}.sha256" --quiet 2>/dev/null || shasum -a 256 -c "${BACKUP_FILE}.sha256" 2>/dev/null; then
  echo "✅ Checksum verified successfully"
else
  echo "⚠️  Checksum verification failed or unavailable"
fi
