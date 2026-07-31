# Backup Restore Process

Restoring a Hermes backup from a GitHub-hosted tar.gz archive. Covers full restore and selective merge.

## Full Restore Steps

```bash
# 1. Clone the backup repo (use PAT for private repos)
git clone https://<PAT>@github.com/<user>/<repo>.git /tmp/hermesbackup

# 2. Find and inspect the backup
ls /tmp/hermesbackup/*.tar.gz
tar -tzf /tmp/hermesbackup/hermes_backup_*.tar.gz | head -50  # preview contents

# 3. Extract
mkdir -p /tmp/hermesbackup/extracted
tar -xzf /tmp/hermesbackup/hermes_backup_*.tar.gz -C /tmp/hermesbackup/extracted

# 4. Restore piece by piece (see selective merge below)
```

## Selective Config Merge (CRITICAL)

**Never blindly overwrite `config.yaml`** — the backup's model/provider settings may be for a different setup (e.g. mimohermes on Railway vs HermesAiUx on OpenAI). Overwriting breaks the live gateway.

Instead, merge specific settings using `hermes config set`:

```bash
# Find the hermes CLI (may not be in PATH)
which hermes || find / -name "hermes" -type f 2>/dev/null | head -5
# Common location: /opt/venv/bin/hermes

# Merge useful settings from backup config
/opt/venv/bin/hermes config set telegram.require_mention true
/opt/venv/bin/hermes config set telegram.allow_from <user_id>
/opt/venv/bin/hermes config set platforms.telegram.enabled true
/opt/venv/bin/hermes config set platforms.telegram.home_channel.chat_id <chat_id>
```

**What to merge from backup config.yaml:**
- `telegram.*` settings (require_mention, allow_from)
- `platforms.telegram.*` (home_channel, enabled)
- `onboarding.seen.*` (progress flags)

**What NOT to merge:**
- `model.*` settings (keep current working model)
- `auxiliary.*` model overrides (keep current provider)
- Any provider-specific URLs (Railway, OpenRouter, etc.)

## File-by-File Restore

| File/Dir | Restore? | Notes |
|----------|----------|-------|
| `memories/USER.md` | ✅ Always | User profile data |
| `memories/MEMORY.md` | ✅ Always | Session notes |
| `.env` | ✅ Always | API keys (can't read, just copy) |
| `skills/` | ✅ Selective | Only custom skills not already installed |
| `config.yaml` | ⚠️ Merge | Selective merge only (see above) |
| `state.db` | ✅ Usually | Session database |
| `sessions/` | ✅ Optional | Old session data |
| `cron/` | ✅ Usually | Scheduled jobs |
| `kanban.db` | ✅ Optional | Kanban board state |
| `auth.json` | ✅ Usually | OAuth tokens |
| `SOUL.md` | ⚠️ Check | Only if customized |
| `scripts/` | ✅ Usually | User scripts (backup.sh etc.) |
| `gateway/` | ✅ Usually | Gateway state |

## Custom Skills Detection

Check which skills from backup are missing locally:

```bash
# Compare backup skills vs installed
for dir in /tmp/hermesbackup/extracted/skills/*/; do
  name=$(basename "$dir")
  if [ ! -d "$HOME/.hermes/skills/$name" ]; then
    echo "MISSING: $name"
  fi
done
```

Copy missing custom skills:
```bash
cp -r /tmp/hermesbackup/extracted/skills/<custom-skill> ~/.hermes/skills/
```

## ⚠️ Pitfalls

1. **hermes CLI not in PATH** — On some installs, hermes lives at `/opt/venv/bin/hermes`. Use full path for `hermes config set` commands.

2. **Overwriting config.yaml breaks gateway** — The backup config may reference a different model/provider. Always merge selectively.

3. **`.env` blocked from reading** — The read_file tool blocks `.env` for security. Use `cp` directly instead of trying to read then write.

4. **User-owned skills from backup** — Skills like `persian-user-interaction` or `scheduled-task-setup` that came from the user's backup are user-owned. After restore, they become editable. Don't confuse with bundled skills (like `hermes-agent`) which are protected.

5. **State.db conflicts** — If the current instance has an active `state.db`, restoring an old one may lose recent sessions. Only restore if the user explicitly wants full restore.

## Post-Restore Checklist

```bash
# Verify key files exist
ls -la ~/.hermes/memories/USER.md ~/.hermes/memories/MEMORY.md
ls -la ~/.hermes/.env ~/.hermes/config.yaml

# Verify config is valid
cat ~/.hermes/config.yaml  # sanity check

# Verify custom skills
ls ~/.hermes/skills/persian-user-interaction/ 2>/dev/null
ls ~/.hermes/skills/hermes/scheduled-task-setup/ 2>/dev/null
```

## Safety

Always keep the current state before restoring. The backup only covers:
- memories/, skills/, sessions/sessions.json, cron/
- config.yaml, SOUL.md, state.db, kanban.db, auth.json, .env, channel_directory.json

Excluded (regenerable): cache/, logs/, audio_cache/, image_cache/, *.lock, gateway.pid, large cache JSONs.
