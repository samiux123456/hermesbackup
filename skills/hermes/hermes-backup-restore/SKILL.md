---
name: hermes-backup-restore
description: "Restore Hermes from tar.gz backups safely."
---

# Hermes Backup and Restore

Restore a Hermes Agent installation from a tar.gz backup archive.

## When to Use
- User provides a backup file (tar.gz, git repo) and asks to restore
- Migrating Hermes to a new machine/container
- Recovering from a corrupted installation

## Key Paths
- ~/.hermes/.env — API keys (must be mode 600)
- ~/.hermes/config.yaml — Settings (use hermes config set, never hand-edit)
- ~/.hermes/memories/ — USER.md and MEMORY.md
- ~/.hermes/skills/ — Installed skills
- ~/.hermes/state.db — Session database
- ~/.hermes/cron/ — Scheduled tasks
- ~/.hermes/sessions/ — Session routing
- ~/.hermes/auth.json — OAuth tokens

## Workflow

### 1. Extract and Survey
```bash
mkdir -p /tmp/hermes-restore && tar -xzf backup.tar.gz -C /tmp/hermes-restore
tar -tzf backup.tar.gz | head -80
```

### 2. Restore Memories
```bash
cp extracted/memories/USER.md ~/.hermes/memories/
cp extracted/memories/MEMORY.md ~/.hermes/memories/
```

### 3. Restore .env
```bash
cp extracted/.env ~/.hermes/.env && chmod 600 ~/.hermes/.env
```

### 4. Merge Config.yaml (CRITICAL)
DO NOT blindly overwrite config.yaml. The backup may have model settings from a different environment.

1. Read both current and backup config.yaml
2. Keep current model/provider settings intact
3. Merge non-model settings using hermes config set KEY VAL
4. Use /opt/venv/bin/hermes if hermes not in PATH

Merge from backup: telegram.*, platforms.*, onboarding.seen.*
Do NOT merge: model.*, auxiliary.* (environment-specific)

### 5. Restore Custom Skills
Only copy skills that don't already exist. Also restore .curator_state, .bundled_manifest, .usage.json.

### 6. Restore State Files
Copy cron/, state.db, kanban.db, verification_evidence.db, auth.json, sessions/, channel_directory.json, .initialized, sandboxes/, kanban/, state/, gateway/, scripts/.

### 7. Verify
Run hermes doctor. Check config version, SQLite, tools, memory, sessions.

## References
- `references/verification-checklist.md` — Step-by-step verification after restore
- `references/config-merging.md` — Detailed guide for merging config.yaml safely

## Pitfalls
- Config overwrite breaks model settings — always merge selectively
- .env and auth.json must be mode 600
- Stale state.db may conflict with current sessions
- User-owned skills should not be overwritten
- In containers use /opt/venv/bin/hermes for config commands