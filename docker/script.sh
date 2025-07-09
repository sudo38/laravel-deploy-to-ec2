#!/bin/bash

set -e

echo "🧰 Running Laravel entrypoint script..."

# نسخ ملف env إذا لم يكن موجودًا
if [ ! -f .env ]; then
  echo "⚙️  .env not found. Creating from .env.example..."
  cp .env.example .env
fi

# تثبيت الاعتماديات
echo "📦 Running composer install..."
composer install --no-interaction --prefer-dist --optimize-autoloader

# إعداد صلاحيات مجلدات Laravel
echo "🔐 Setting permissions for storage and bootstrap/cache..."
chown -R www-data:www-data storage bootstrap/cache
chmod -R 775 storage bootstrap/cache

# توليد مفتاح التطبيق
echo "🔑 Generating app key..."
php artisan key:generate

# تشغيل apache في المقدمة
echo "🚀 Starting Apache..."
exec apache2-foreground