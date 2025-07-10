#!/bin/bash

set -e

echo "🧰 Running Laravel entrypoint script..."

if [ ! -f .env ]; then
  echo "⚙️  .env not found. Creating from .env.example..."
  cp .env.example .env
fi

echo "📦 Running composer install..."
composer install -q

echo "🔐 Setting permissions for storage and bootstrap/cache..."
chown -R www-data:www-data storage bootstrap/cache
chmod -R 775 storage bootstrap/cache

echo "🔑 Generating app key..."
php artisan key:generate

echo "🧹 Clearing and caching config and routes..."
php artisan config:clear
php artisan config:cache
php artisan route:clear
php artisan route:cache

echo "🚀 Starting Apache..."
exec apache2-foreground