# Use the official PHP image as the base image
FROM php:8.2-fpm

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    unzip \
    git \
    curl \
    lua-zlib-dev \
    libmemcached-dev \
    nginx



ENV COMPOSER_ALLOW_SUPERUSER=1

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

#ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

# Install php extensions
#RUN chmod +x /usr/local/bin/install-php-extensions && sync && \
    #install-php-extensions mbstring pdo_mysql zip exif pcntl gd memcached bcmath

# Install required PHP extensions
RUN docker-php-ext-install pdo pdo_mysql sockets

# Copy only the composer files first for better caching
COPY . /var/www/html/

# SET current directory
WORKDIR /var/www/html

# Install dependencies using Composer
RUN composer install

# Set permissions for Laravel
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Expose port 8000 for Laravel development server
EXPOSE 8000

# Start the Laravel development server
CMD ["php", "artisan", "serve", "--host=127.0.0.0", "--port=8000"]
