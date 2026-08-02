# Hermes Backup & Game Database

## 📦 Hermes Backup
فایل بک‌آپ کامل Hermes Agent برای بازیابی روی سرور جدید.

**نحوه بازیابی:**
```bash
wget https://raw.githubusercontent.com/samiux123456/hermesbackup/main/hermes-full-backup-2026-08-02_08-50.tar.gz
tar -xzf hermes-full-backup-2026-08-02_08-50.tar.gz
cp -r hermes-full-backup/* ~/.hermes/
chmod 600 ~/.hermes/.env ~/.hermes/auth.json
hermes setup && hermes gateway restart
```

**⚠️ هشدار:** فایل بک‌آپ حاوی توکن‌ها و کلیدهای API است. آن را خصوصی نگه دارید.

## 🎮 دیتابیس بازی اسم و فامیل
دیتابیس کلمات فارسی برای بازی اسم و فامیل.

**دسته‌بندی‌ها:**

| فایل | دسته | تعداد |
|------|------|-------|
| `persian_names.txt` | اسامی ایرانی | ۱,۴۴۹ |
| `surnames.txt` | فامیلی‌ها | ۱,۰۸۵ |
| `cities.txt` | شهرها | ۷۷۹ |
| `jobs.txt` | مشاغل | ۸۵۰ |
| `objects.txt` | اشیاء | ۹۸۵ |
| `foods.txt` | غذاها | ۴۶۸ |
| `cars.txt` | ماشین‌ها | ۴۴۱ |
| `flowers.txt` | گل‌ها | ۴۲۲ |
| `animals.txt` | حیوانات | ۳۴۸ |
| `fruits.txt` | میوه‌ها | ۱۹۷ |
| `countries.txt` | کشورها | ۱۹۶ |
| `colors.txt` | رنگ‌ها | ۱۸۱ |

**مجموع: ~۷,۴۰۰ کلمه فارسی**

## 🤖 اتوماسیون
Hermes Agent به‌صورت خودکار کلمات جدید را از بازی جمع‌آوری و به دیتابیس اضافه می‌کند.
