# Config Merging Guide

When restoring a Hermes backup, config.yaml requires careful merging. The backup's config may contain model/provider settings from a different environment.

## Why Blind Overwrite Breaks Things

The backup config.yaml typically has:
```yaml
model:
  default: mimohermes
  provider: openai-api
  base_url: https://some-railway-app.up.railway.app/v1
```

The current instance may use a different model entirely (e.g., HermesAiUx, Claude, GPT-4). Overwriting config.yaml with the backup's model settings breaks the active model.

## What to Merge

### Safe to Merge (environment-independent)
- `telegram.require_mention` — group chat behavior
- `telegram.allow_from` — allowed user IDs
- `platforms.telegram.enabled` — platform toggle
- `platforms.telegram.home_channel` — channel config
- `onboarding.seen.*` — UI state flags
- `terminal.backend`, `terminal.cwd`, `terminal.timeout` — if compatible
- `compression.*` — compression settings

### DO NOT Merge Blindly (environment-specific)
- `model.*` — provider, model name, base_url, fallback
- `auxiliary.*` — vision, compression, summarization model settings
- `auth.*` — OAuth provider configs (may differ by installation)

## How to Merge

Use `hermes config set` for each setting:

```bash
# If hermes not in PATH (containers):
/opt/venv/bin/hermes config set KEY VALUE

# Examples:
hermes config set telegram.require_mention true
hermes config set telegram.allow_from 8599705796
hermes config set platforms.telegram.enabled true
hermes config set platforms.telegram.home_channel.platform telegram
hermes config set platforms.telegram.home_channel.chat_id 8599705796
hermes config set platforms.telegram.home_channel.name "Display Name"
hermes config set platforms.telegram.home_channel.user_id 8599705796
```

## Reading Both Configs

To compare current vs backup:
```bash
echo "=== Current ===" && cat ~/.hermes/config.yaml
echo "=== Backup ===" && cat /tmp/hermes-restore/config.yaml
```

Identify settings present in backup but missing from current, then add them selectively.

## Post-Merge Verification

After merging, verify:
1. Read ~/.hermes/config.yaml — confirm model settings unchanged
2. Run `hermes doctor` — check for config version warnings
3. Test the agent responds — model should work as before
