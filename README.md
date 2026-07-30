# NoVa Game Database

بانک اطلاعاتی بازی اسم و فامیل

## 📁 فایل‌ها:

| فایل | توضیح | تعداد |
|------|-------|-------|
| `names.txt` | اسامی رایج | ۱۱۹ |
| `surnames.txt` | فامیل‌ها | ۹۵ |
| `persian_names.txt` | اسامی کامل ایرانی | ۶,۹۷۹ |
| `fruits.txt` | میوه‌ها | ۵۸ |
| `colors.txt` | رنگ‌ها | ۶۵ |
| `cities.txt` | شهرها | ۸۴ |
| `countries.txt` | کشورها | ۸۰ |
| `cars.txt` | ماشین‌ها | ۷۴ |
| `animals.txt` | حیوانات | ۹۱ |
| `objects.txt` | اشیا | ۷۵ |
| `body_parts.txt` | اعضای بدن | ۶۸ |
| `flowers.txt` | نام گل‌ها | ۵۳ |
| `foods.txt` | غذاها | ۱۰۸ |
| `jobs.txt` | مشاغل | ۱۱۷ |

## 📝 استفاده در کد:

```python
# لود کردن اسامی
with open('names.txt', 'r', encoding='utf-8') as f:
    names = [line.strip() for line in f]
```

## 📊 جمع کل:
- **اسامی:** ۶,۹۷۹
- **دسته‌بندی‌ها:** ۱۳
- **مجموع آیتم‌ها:** ~۱,۱۰۰+
