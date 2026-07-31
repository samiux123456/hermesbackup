#!/bin/bash
# Hermes Backup Script - backs up critical data to GitHub
set -e

HERMES_DIR="$HOME/.hermes"
BACKUP_DIR="/tmp/hermesbackup"
DATE=$(date '+%Y-%m-%d_%H-%M')
BACKUP_FILE="hermes_backup_${DATE}.tar.gz"
REPO_URL="https://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@github.com/samiux123456/hermesbackup.git"

# Clean previous
rm -rf "$BACKUP_DIR"
mkdir -p "$BACKUP_DIR"

# Create tar.gz of critical Hermes data
cd "$HERMES_DIR"

tar czf "${BACKUP_DIR}/${BACKUP_FILE}" \
    --exclude='*.lock' \
    --exclude='gateway.pid' \
    --exclude='cache/documents/*' \
    --exclude='cache/delegation/*' \
    --exclude='cache/sessions/*' \
    --exclude='cache/skills/*' \
    --exclude='cache/text/*' \
    --exclude='cache/voice/*' \
    --exclude='cache/audio_cache/*' \
    --exclude='cache/image_cache/*' \
    --exclude='logs/*' \
    --exclude='sessions/request_dump_*' \
    memories/ \
    skills/ \
    cron/jobs.json \
    cron/executions.db \
    state.db \
    kanban.db \
    verification_evidence.db \
    channel_directory.json \
    auth.json \
    config.yaml \
    SOUL.md \
    .env \
    .initialized \
    scripts/backup.sh 2>/dev/null || true

# Check backup was created
if [ ! -f "${BACKUP_DIR}/${BACKUP_FILE}" ]; then
    echo "❌ Backup file not created!"
    exit 1
fi

echo "📦 Backup created: $(ls -lh ${BACKUP_DIR}/${BACKUP_FILE} | awk '{print $5}')"

# Clone the repo (shallow)
cd "$BACKUP_DIR"
rm -rf repo
git clone --depth 1 "$REPO_URL" repo 2>/dev/null || true
cd repo

# Remove old backup files
rm -f *.tar.gz 2>/dev/null || true

# Copy new backup
cp "${BACKUP_DIR}/${BACKUP_FILE}" .

# Commit and push
git config user.email "hermes-backup@bot"
git config user.name "Hermes Backup Bot"
git add -A
git commit -m "Backup: $DATE" 2>/dev/null || true
git push origin main 2>/dev/null

echo "✅ Backup pushed to GitHub: $BACKUP_FILE"

# Clean up
cd /
rm -rf "$BACKUP_DIR"
