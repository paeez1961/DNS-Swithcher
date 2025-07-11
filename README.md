# 🔧 DNS Switcher | اسکریپت تغییر DNS در لینوکس

A simple interactive Bash script to quickly switch between popular DNS providers on Linux.  
It allows users to change system DNS settings easily via a terminal menu, with automatic backup and restore of the original configuration.

یک اسکریپت ساده و تعاملی Bash برای تغییر سریع بین DNSهای محبوب در لینوکس.  
با منوی ترمینالی، DNS سیستم را تغییر دهید و تنظیمات قبلی به‌صورت خودکار بک‌آپ گرفته و قابل بازیابی است.

---

## 🚀 Installation | نصب

To install and run:

برای نصب و اجرا:

```bash
git clone https://github.com/paeez1961/dns-switcher.git
cd dns-switcher
chmod +x dns-switcher.sh
sudo ./dns-switcher.sh
```

> ⚠️ Requires **sudo/root access** to modify `/etc/resolv.conf`.  
> ⚠️ نیاز به دسترسی روت دارد چون فایل `/etc/resolv.conf` را تغییر می‌دهد.

---

## 🌐 Included DNS Providers | لیست DNSهای موجود

This script currently supports the following DNS services:

این اسکریپت در حال حاضر از DNSهای زیر پشتیبانی می‌کند:

| Name (نام)       | IP Addresses (آدرس‌ها)              |
|------------------|-------------------------------------|
| Shecan 🇮🇷        | 178.22.122.100, 185.51.200.2        |
| Electro 🇮🇷       | 78.157.42.100, 78.157.42.101        |
| Begzar 🇮🇷        | 185.55.226.26, 185.55.226.25        |
| DNS Pro 🇮🇷       | 87.107.110.109, 87.107.110.110      |
| Google DNS        | 8.8.8.8, 8.8.4.4                    |
| Cloudflare        | 1.1.1.1, 1.0.0.1                    |
| Quad9             | 9.9.9.9, 149.112.112.112            |
| OpenDNS           | 208.67.222.222, 208.67.220.220      |
| AlternateTest 🧪  | 5.5.5.5, 6.6.6.6 (برای تست)         |
| Reset to Default  | 127.0.0.53 (بازگشت به حالت پیش‌فرض) |

---

## 🛠️ Features | قابلیت‌ها

- Interactive terminal menu with color output  
  منوی تعاملی ترمینالی با خروجی رنگی

- Automatic backup of your existing DNS settings  
  بک‌آپ‌گیری خودکار از تنظیمات قبلی DNS

- Supports fallback to system default (`127.0.0.53`)  
  امکان بازگشت به حالت پیش‌فرض DNS سیستم

- Preserves existing `search` and `options` lines  
  حفظ خطوط `search` و `options` در resolv.conf

- Fully editable and extendable with custom DNS  
  قابلیت ویرایش کامل برای افزودن DNS دلخواه

---

## 💡 Usage Notes | نکات استفاده

- Works on most Debian/Ubuntu-based systems using `/etc/resolv.conf`  
  روی اغلب توزیع‌های مبتنی بر دبیان و اوبونتو که از `/etc/resolv.conf` استفاده می‌کنند کار می‌کند

- Not for `systemd-resolved` with symlinked resolv.conf unless modified  
  روی سیستم‌هایی که از symlink به systemd-resolved استفاده می‌کنند ممکن است نیاز به تنظیم دستی باشد

- Add your own DNS by editing `dns_servers` in the script  
  برای اضافه‌کردن DNS دلخواه، آرایه `dns_servers` را در اسکریپت ویرایش کنید

---

## 👤 Author | نویسنده

- Original Author: [Linuxmaster14](https://github.com/Linuxmaster14)  
  نویسنده اصلی

- Modified & Maintained by: [paeez1961](https://github.com/paeez1961)  
  توسعه و نگهداری توسط شما

---

## 📜 License | مجوز

This project is licensed under the [MIT License](https://opensource.org/licenses/MIT)  
این پروژه تحت مجوز MIT منتشر شده — استفاده، ویرایش و اشتراک آزاد است.

---
