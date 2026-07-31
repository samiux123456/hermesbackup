# Railway CLI Token Authentication

## Token Types

Railway has two token types with different scopes:

| Token Type | Scope | Use Case |
|-----------|-------|----------|
| **Account Token** | Full account access | CLI login, usage queries, all API calls |
| **Project Token** | Single project only | Limited API access |

## Creating Tokens

1. Go to [railway.com/account/tokens](https://railway.com/account/tokens)
2. Click "Create Token"
3. **Important:** Choose "Account Token" for full access

## CLI Authentication

```bash
# Method 1: Environment variable (recommended for scripts)
export RAILWAY_TOKEN="your-token-here"
railway whoami

# Method 2: Interactive login (requires browser)
railway login
```

## Checking Usage

```bash
# Check current user
railway whoami

# List projects
railway list

# Check usage via GraphQL API
railway api "query { usage(measurements: [CPU_USAGE, MEMORY_USAGE_GB]) { measurement value } }"
```

## Common Errors

| Error | Cause | Fix |
|-------|-------|-----|
| `Not Authorized` | Token lacks permissions | Use Account Token, not Project Token |
| `Unauthorized` | Invalid or expired token | Generate new token at railway.com/account/tokens |
| `unexpected argument '--token'` | Wrong CLI syntax | Use `RAILWAY_TOKEN=xxx railway command` |

## Available Metrics

```
CPU_USAGE, CPU_USAGE_2, CPU_LIMIT
MEMORY_USAGE_GB, MEMORY_LIMIT_GB
NETWORK_RX_GB, NETWORK_TX_GB
DISK_USAGE_GB, EPHEMERAL_DISK_USAGE_GB
BACKUP_USAGE_GB
```

## Project Info from Environment

When running inside Railway, these env vars are available:
```
RAILWAY_PROJECT_NAME
RAILWAY_ENVIRONMENT_NAME
RAILWAY_GIT_BRANCH
RAILWAY_GIT_REPO_OWNER
```
