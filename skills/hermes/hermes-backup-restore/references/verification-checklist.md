# Backup Restoration Verification Checklist

Use this checklist after restoring a Hermes backup to ensure nothing was missed.

## Pre-Restoration (Survey)
- [ ] List archive contents: `tar -tzf backup.tar.gz | head -80`
- [ ] Identify key files: .env, config.yaml, memories/, skills/, state.db, cron/, sessions/, auth.json
- [ ] Note archive date to assess staleness of state.db and sessions

## Post-Restoration (Verify)

### Critical Files
- [ ] .env exists and is mode 600
- [ ] config.yaml exists and model settings are unchanged from pre-restore
- [ ] memories/USER.md exists and content is intact
- [ ] memories/MEMORY.md exists and content is intact

### Skills
- [ ] Custom skills copied (not overwritten)
- [ ] Curator metadata restored (.curator_state, .bundled_manifest, .usage.json)
- [ ] Total SKILL.md count matches expected: `find ~/.hermes/skills -name "SKILL.md" | wc -l`

### State Files
- [ ] state.db exists and is readable
- [ ] kanban.db exists
- [ ] verification_evidence.db exists
- [ ] auth.json exists and is mode 600
- [ ] channel_directory.json exists
- [ ] .initialized flag exists

### Sessions and Cron
- [ ] sessions/sessions.json exists
- [ ] Request dumps copied (if desired)
- [ ] cron/jobs.json exists
- [ ] cron/executions.db exists

### Other
- [ ] scripts/ directory and files restored with execute permissions
- [ ] gateway/ directory restored
- [ ] state/gateway.heartbeat exists
- [ ] sandboxes/ directory restored (if present)

## Automated Verification

### Step 1: Run `hermes doctor --fix` (MANDATORY)
This migrates config version, adds new settings, and auto-fixes what it can:
```bash
/opt/venv/bin/hermes doctor --fix
```
Always run this FIRST after restore. It fixes config version mismatches automatically.

### Step 2: Run `hermes doctor` and check
- Config version: should show "up to date" after --fix
- SQLite: version warnings are non-critical (see `references/sqlite-wal-fix.md` for optional fix)
- Tools: web/browser/vision may need env vars
- Memory provider: should show as active
- Sessions: count should be > 0

### Step 3: Install ripgrep (optional but recommended)
```bash
apt-get install -y ripgrep
```
Speeds up file search significantly. Doctor will flag if missing.

## Common Issues After Restore
1. **Config version mismatch**: Run `hermes doctor --fix` (Step 1 above)
2. **Missing API keys**: Run `hermes setup` or check .env
3. **Gateway not responding**: Restart with `hermes restart`
4. **Skills not loading**: Check file permissions on skill directories
5. **Session conflicts**: Old state.db may have stale sessions; this is usually fine
6. **SQLite WAL bug**: See `references/sqlite-wal-fix.md` — optional, non-critical
