# NoVa Game Database

بانک اطلاعاتی بازی اسم و فامیل

## 📁 فایل‌ها:

| فایل | توضیح | تعداد |
|------|-------|-------|
| `persian_names.txt` | اسامی کامل ایرانی | ۶,۹۷۹ |
| `surnames.txt` | فامیل‌ها | ۹۵ |
| `fruits.txt` | میوه‌ها | ۵۸ |
| `colors.txt` | رنگ‌ها | ۶۵ |
| `cities.txt` | شهرها | ۸۴ |
| `countries.txt` | کشورها | ۱۹۶ |
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
with open('persian_names.txt', 'r', encoding='utf-8') as f:
    names = [line.strip() for line in f]
```

## 📊 جمع کل:
- **اسامی:** ۶,۹۷۹
- **کشورها:** ۱۹۶
- **دسته‌بندی‌ها:** ۱۳
