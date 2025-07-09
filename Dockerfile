FROM php:8.3-apache

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    git \
    curl \
    libzip-dev \
    && docker-php-ext-install pdo_mysql mbstring zip exif pcntl

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Set working directory
WORKDIR /var/www/html

# Copy app files
COPY . .

# Set permissions
# RUN chown -R www-data:www-data /var/www/html

RUN sudo chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
RUN sudo chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Copy existing apache config
# COPY ./docker/vhost.conf /etc/apache2/sites-available/000-default.conf

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install Laravel dependencies
RUN composer install -q

# Generate app key
RUN php artisan key:generate