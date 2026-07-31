# Telegram Group Configuration for Hermes

## Correct Config Keys (from source code inspection)

When user wants Hermes to behave differently in Telegram groups, use these **verified** config keys:

### `telegram.require_mention` (boolean)
- **Default:** `false` (responds to all messages)
- **Set to `true`:** Only respond when @mentioned in groups
- **Correct key:** `require_mention`, NOT `reply_mode`, NOT `group_reply_mode`

```bash
hermes config set telegram.require_mention true
```

### `telegram.allow_from` (string — comma-separated user IDs)
- Restrict bot to only respond to specific users
- Works in both DMs and groups
- **Correct key:** `allow_from`, NOT `allowed_users`

```bash
hermes config set telegram.allow_from 8599705796
```

## ⚠️ Critical Pitfalls

### Wrong Config Keys (DO NOT USE)
These keys get saved but **Hermes ignores them**:
- `telegram.group_reply_mode` → WRONG, use `require_mention`
- `telegram.group_policy` → Not documented for this purpose
- `send_errors_to_chat` → Not a valid key

### How to Find Correct Keys
When unsure about a config key:
1. Check source: `grep -n "config_key" /opt/hermes-agent/plugins/platforms/telegram/adapter.py`
2. Look for `_GENERIC_MERGE_KEYS` set — those are the valid telegram config keys
3. Or: `cd /opt/venv/bin && ./hermes config show` to see what's actually recognized

### After Config Changes
Always restart the gateway:
```bash
kill -TERM 2
```

## Common Group Scenarios

| Scenario | Config |
|----------|--------|
| Only respond when mentioned | `require_mention: true` |
| Only respond to specific user | `allow_from: <user_id>` |
| Both: only Sami, only when mentioned | Set both keys |
| Respond to everyone in group | Leave defaults (no config needed) |
| Never respond in groups | Remove bot from group |

## Finding User IDs
To find a Telegram user ID:
1. Send any message to @userinfobot
2. Or use @RawDataBot in a group
3. The user ID appears in the bot response
