# Termux Python Project Setup

## Common Issues & Solutions

### 1. Permission Denied on /sdcard/
**Problem:** `venv` fails with symlink error on `/sdcard/`
**Solution:** Copy project to Termux home directory first:
```bash
cp -r /sdcard/project_name ~/
cd ~/project_name
python -m venv venv
source venv/bin/activate
```

### 2. httpx Version Conflict
**Problem:** `python-telegram-bot==21.8` requires `httpx~=0.27`, but project has `httpx==0.26.0`
**Solution:** Update requirements.txt:
```
httpx>=0.27.0
```
Or use sed:
```bash
sed -i 's/httpx==0.26.0/httpx>=0.27.0/' requirements.txt
```

### 3. Storage Permission
**Problem:** Can't access `/sdcard/`
**Solution:**
```bash
termux-setup-storage
```

### 4. Missing Build Dependencies
**Problem:** Compilation errors for some packages
**Solution:**
```bash
pkg install build-essential libxml2 libxslt
```

### 5. Running in Background
```bash
nohup python main.py > bot.log 2>&1 &
```

## Complete Setup Script
```bash
# Update packages
pkg update && pkg upgrade
pkg install python git

# Setup storage access
termux-setup-storage

# Copy project
cp -r /sdcard/my_project ~/
cd ~/my_project

# Create venv
python -m venv venv
source venv/bin/activate

# Fix dependencies if needed
sed -i 's/httpx==0.26.0/httpx>=0.27.0/' requirements.txt

# Install
pip install -r requirements.txt

# Run
python main.py
```
