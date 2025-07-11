#!/bin/bash

cd /home/ec2-user/deploy-temp

# تحديث composer
composer install --no-dev --optimize-autoloader

# إعداد الصلاحيات
chmod -R 775 storage
chmod -R 775 bootstrap/cache

# إعداد .env و Key
cp .env.example .env
php artisan key:generate

# تأكد أن السيرفر يعمل مثلاً:
sudo systemctl restart apache2