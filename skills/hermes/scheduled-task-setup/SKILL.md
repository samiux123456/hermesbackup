---
name: scheduled-task-setup
description: "Create and debug Hermes cron jobs for backups."
version: 1.0.0
author: Hermes Agent
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [cron, scheduled-tasks, backup, automation]
    related_skills: [hermes-agent]
---

# Scheduled Task Setup (Hermes Cron Jobs)

How to create, configure, and debug scheduled tasks using the `cronjob` tool.

## Trigger

Use this skill when:
- User wants to schedule recurring tasks (backups, monitoring, reports)
- Cron job fails with "no model configured" error
- Setting up automated GitHub backups
- Any `cronjob` tool usage

## Creating a Cron Job

### Minimal Example

```
cronjob(action="create", schedule="every 12h", prompt="Run the backup script at /path/to/script.sh using bash. Report success or failure.")
```

### With Model (RECOMMENDED)

Always specify a model to avoid failures:

```
cronjob(
    action="create",
    schedule="every 12h",
    prompt="...",
    model={"model": "mimohermes", "provider": "openai-api"}
)
```

### Full Example with Script

```
cronjob(
    action="create",
    schedule="0 9 * * *",
    name="daily-backup",
    prompt="Run the backup script and report results.",
    model={"model": "mimohermes", "provider": "openai-api"},
    enabled_toolsets=["terminal"]
)
```

## ⚠️ Critical Pitfall: Missing Model

**The #1 cause of cron job failures.**

If you create a cron job without specifying a model AND no default model is configured in `config.yaml`, the job will fail with:

```
RuntimeError: Cron job 'xxx' has no model configured
(job.model=None, HERMES_MODEL='', config.yaml model.default missing or empty)
```

**Fix:**
```
cronjob(action="update", job_id="THE_JOB_ID", model={"model": "mimohermes", "provider": "openai-api"})
```

**Prevention:** Always pass `model=` when creating cron jobs.

## Pitfall: Fresh System Git Config

When creating backup scripts that use `git commit/push` on a fresh system:

```bash
# MUST run git config first, or commits will fail:
git config --global user.email "bot@nova"
git config --global user.name "Hermes Backup"
```

## Schedule Formats

| Format | Example | Description |
|--------|---------|-------------|
| Duration | `"30m"`, `"2h"` | Every N minutes/hours |
| Every phrase | `"every monday 9am"` | Natural language |
| Cron expression | `"0 9 * * *"` | Standard 5-field cron |
| ISO timestamp | `"2026-06-01T09:00:00"` | One-shot |

## Managing Jobs

```
# List all jobs
cronjob(action="list")

# Run a job immediately
cronjob(action="run", job_id="THE_JOB_ID")

# Pause/resume
cronjob(action="pause", job_id="THE_JOB_ID")
cronjob(action="resume", job_id="THE_JOB_ID")

# Remove
cronjob(action="remove", job_id="THE_JOB_ID")

# Update model on existing job
cronjob(action="update", job_id="THE_JOB_ID", model={"model": "mimohermes", "provider": "openai-api"})
```

## Backup Script Pattern

For GitHub-based backups (port 22 blocked):

```bash
#!/bin/bash
set -e

BACKUP_DIR="/tmp/hermesbackup"
HERMES_DIR="$HOME/.hermes"
DATE=$(date '+%Y-%m-%d_%H-%M')
BACKUP_FILE="backup_${DATE}.tar.gz"

# Ensure git is configured
git config --global user.email "bot@backup" 2>/dev/null || true
git config --global user.name "Hermes Backup" 2>/dev/null || true

# Create backup archive
cd "$HERMES_DIR"
tar czf "/tmp/$BACKUP_FILE" \
    --exclude='*.lock' \
    --exclude='audio_cache' \
    --exclude='image_cache' \
    --exclude='cache' \
    --exclude='logs' \
    .

# Push to GitHub
mv "/tmp/$BACKUP_FILE" "$BACKUP_DIR/"
cd "$BACKUP_DIR"
git add -A
git commit -m "Backup: ${DATE}" || echo "No changes"
git push origin main
```

## Restore from Backup

See `references/restore-process.md` for step-by-step restore instructions. User asked about this explicitly — always mention restore capability when discussing backups.

## Railway CLI Setup

If backup target is on Railway, you may need to check usage/balance. See `references/railway-cli-auth.md` for token setup and usage queries.

**Key pitfall:** Railway tokens must be **Account Tokens** (full access), not Project Tokens. Project-scoped tokens return "Not Authorized" for usage queries.

## Diagnosing Failures

Check cron output logs:
```bash
ls ~/.hermes/cron/output/<job_id>/
cat ~/.hermes/cron/output/<job_id>/*.log | tail -50
```

Common errors:
| Error | Cause | Fix |
|-------|-------|-----|
| `no model configured` | Missing model param | `cronjob action=update model=...` |
| `Author identity unknown` | Git not configured | `git config --global user.email/name` |
| `Permission denied` (push) | Bad token or repo | Check token scopes, repo URL |

## Suppressing Error Messages in Chat

When Hermes sends technical error messages (like "Provider authentication failed") to the Telegram chat, it exposes the AI nature of the bot.

### Root Cause
The error comes from **auxiliary models** (title generation, vision, compression) trying to use OpenRouter without an API key. The fix is NOT `send_errors_to_chat: false` (this key is NOT recognized by Hermes). The real fix is configuring auxiliary models to use the same provider as the main model.

### Correct Fix (use `hermes config set`, NOT hand-editing config.yaml)

```bash
# Configure each auxiliary task to use the main model provider
hermes config set auxiliary.title_generation.provider openai-api
hermes config set auxiliary.title_generation.model mimohermes
hermes config set auxiliary.title_generation.base_url https://9router-production-0d4c.up.railway.app/v1

hermes config set auxiliary.vision.provider openai-api
hermes config set auxiliary.vision.model mimohermes
hermes config set auxiliary.vision.base_url https://9router-production-0d4c.up.railway.app/v1

hermes config set auxiliary.compression.provider openai-api
hermes config set auxiliary.compression.model mimohermes
hermes config set auxiliary.compression.base_url https://9router-production-0d4c.up.railway.app/v1
```

### ⚠️ Critical Pitfalls

1. **NEVER hand-edit `config.yaml`** — use `hermes config set` only. Hand-editing can corrupt the file and break the live gateway.

2. **`send_errors_to_chat` is NOT a valid config key** — it gets saved but Hermes ignores it. The errors come from auxiliary model auth failures, not a chat-send setting.

3. **After config changes, restart the gateway:**
   ```bash
   kill -TERM $(cat ~/.hermes/gateway.pid | python3 -c "import sys,json;print(json.load(sys.stdin)['pid'])")
   ```

**Pitfall:** Some auxiliary keys like `auxiliary.summarization.*` are not recognized — they get saved but may not be read. Focus on `title_generation`, `vision`, and `compression`.

## Telegram Group Configuration

When user wants Hermes to only respond to specific people or only when mentioned in groups:

### Quick Setup
```bash
# Only respond when @mentioned
hermes config set telegram.require_mention true

# Only respond to specific user (Sami's ID)
hermes config set telegram.allow_from 8599705796
```

### ⚠️ CRITICAL: Wrong Config Keys
- `telegram.group_reply_mode` → **WRONG** (gets saved but ignored)
- `telegram.require_mention` → **CORRECT** ✅
- `telegram.allow_from` → **CORRECT** ✅

**Pitfall:** I wasted many turns setting `group_reply_mode` before finding the correct key by reading source code at `/opt/hermes-agent/plugins/platforms/telegram/adapter.py`.

See `references/telegram-group-config.md` for full details, including how to find correct config keys from source.

## Running Projects on Android (Termux)

See `references/termux-setup.md` for common issues when running Python projects on Android via Termux, including venv permission errors, dependency conflicts, and background execution.
