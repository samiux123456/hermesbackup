# Running Python Projects on Android (Termux)

## Common Issues & Fixes

### 1. Permission Denied when creating venv on /sdcard/
**Problem:** Android doesn't allow symlinks on external storage.
**Fix:** Copy project to Termux internal storage first:
```bash
cp -r /sdcard/project_name ~/
cd ~/project_name
python -m venv venv
source venv/bin/activate
```

### 2. Dependency Conflicts (e.g., httpx version)
**Problem:** `python-telegram-bot==21.8` requires `httpx~=0.27` but requirements.txt has `httpx==0.26.0`.
**Fix:** Update requirements.txt:
```bash
sed -i 's/httpx==0.26.0/httpx>=0.27.0/' requirements.txt
pip install -r requirements.txt
```

### 3. Termux Storage Access
```bash
termux-setup-storage
```

### 4. Missing Build Dependencies
```bash
pkg install build-essential libxml2 libxslt
```

### 5. Running in Background
```bash
nohup python main.py > bot.log 2>&1 &
```

## Project Structure Check
Always verify project files exist before running:
```bash
ls -la
find . -name "*.py" -not -path "./venv/*"
```

## Note
- Termux Python is usually 3.11+
- venv creation fails on /sdcard/ due to symlink restrictions
- Always copy project to ~/ before setting up venv
