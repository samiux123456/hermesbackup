# SQLite WAL Bug Fix

Hermes Doctor may report: `SQLite X.Y.Z (WAL-reset bug)`. This guide covers diagnosis and fix options.

## Diagnosis

```bash
# Check system SQLite version (what Python loads)
/opt/venv/bin/python3 -c "import sqlite3; print(sqlite3.sqlite_version)"

# Check CLI version
sqlite3 --version 2>/dev/null || /usr/local/bin/sqlite3 --version

# Check shared library
ldconfig -p | grep sqlite3
```

**Fixed versions:** 3.51.3+ / 3.50.7 / 3.44.6
**Buggy range:** 3.44.7 through 3.50.6, and 3.51.0–3.51.2

## Fix Options (easiest → hardest)

### Option 1: pysqlite3-binary (no compilation)
```bash
/opt/venv/bin/pip install pysqlite3-binary
# Verify:
/opt/venv/bin/python3 -c "import pysqlite3; print(pysqlite3.sqlite_version)"
```
**Note:** This installs a separate module. Python's `import sqlite3` still uses the system library. Hermes would need code changes to use pysqlite3 — not practical as a user fix.

### Option 2: Replace system shared library (recommended for containers)
```bash
# 1. Install build tools (if missing)
apt-get install -y gcc make libc6-dev

# 2. Download SQLite autoconf source
cd /tmp
curl -sL -o sqlite-autoconf.tar.gz https://www.sqlite.org/2025/sqlite-autoconf-3510100.tar.gz
tar xzf sqlite-autoconf.tar.gz
cd sqlite-autoconf-3510100

# 3. Compile and install to /usr
./configure --prefix=/usr --quiet
make -j$(nproc)
make install
ldconfig

# 4. Replace the old system library
OLD_LIB=$(find /lib /usr/lib -name "libsqlite3.so.0*" -type f | head -1)
cp /usr/lib/libsqlite3.so.3.* "$OLD_LIB"
ldconfig

# 5. Verify
/opt/venv/bin/python3 -c "import sqlite3; print(sqlite3.sqlite_version)"
```

### Option 3: hermes update
```bash
hermes update
```
May upgrade SQLite if the Hermes bundle includes a newer version.

### Option 4: Upgrade system packages
```bash
apt-get update && apt-get upgrade libsqlite3-0
```
Only works if the distro repo has a fixed version (Debian 13 has 3.46.1 — not fixed).

## Pitfalls

1. **No C compiler in containers** — `gcc` and `make` are often missing. Install them first: `apt-get install -y gcc make libc6-dev`

2. **No wget/unzip** — containers may lack these. Use `curl` + Python's `zipfile` module:
   ```bash
   /opt/venv/bin/python3 -c "
   import zipfile, shutil
   with zipfile.ZipFile('file.zip') as z: z.extractall('.')
   shutil.copy('dir/sqlite3', '/usr/local/bin/sqlite3')
   "
   ```

3. **Library path matters** — After compiling, the new .so goes to `/usr/lib/libsqlite3.so.3.*`. The old one is typically at `/lib/x86_64-linux-gnu/libsqlite3.so.0.*`. You must copy the new over the old AND run `ldconfig`.

4. **CLI vs library** — Installing the SQLite CLI binary (`sqlite3`) does NOT update the library Python uses. You must replace the `.so` shared library file.

5. **The WAL bug is minor** — It only affects WAL reset operations (rare). If the fix is complex, it's safe to leave as-is. The doctor warning is informational, not critical.

## When to Skip

- The bug only affects `wal_checkpoint(RESET)` which is rare in normal Hermes usage
- If compilation fails or takes too long, move on — Hermes works fine with older SQLite
- The doctor explicitly says "non-critical"
