#!/bin/bash

set -e

echo "✅ Updating system..."
sudo yum update -y

echo "📦 Installing Apache, PHP, and required extensions..."
sudo amazon-linux-extras enable php8.2
sudo yum clean metadata
sudo yum install -y php php-mbstring php-xml php-bcmath php-curl php-mysqlnd php-opcache php-pdo php-cli php-common php-gd php-intl
sudo yum install -y httpd git unzip

echo "🚀 Starting Apache..."
sudo systemctl start httpd
sudo systemctl enable httpd

echo "📂 Creating Laravel directory..."
sudo mkdir -p /var/www/laravel-app
sudo cp -r * /var/www/laravel-app
cd /var/www/laravel-app

echo "👤 Setting permissions..."
sudo chown -R apache:apache .
sudo chmod -R 775 storage bootstrap/cache

echo "🧰 Installing Composer..."
EXPECTED_SIGNATURE="$(curl -s https://composer.github.io/installer.sig)"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_SIGNATURE="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]; then
    >&2 echo 'ERROR: Invalid Composer installer signature'
    rm composer-setup.php
    exit 1
fi

php composer-setup.php --install-dir=/usr/local/bin --filename=composer
rm composer-setup.php

echo "📦 Installing Laravel dependencies..."
sudo -u apache /usr/local/bin/composer install --no-dev --prefer-dist --optimize-autoloader

echo "⚙️ Running Laravel commands..."
sudo -u apache php artisan config:cache
sudo -u apache php artisan route:cache
sudo -u apache php artisan view:cache

echo "✅ Restarting Apache..."
sudo systemctl restart httpd
