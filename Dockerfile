# Use the official PHP image as the base image
FROM php:8.1-fpm-alpine

# Set the working directory to /var/www/html
WORKDIR /var/www/html

# Install required PHP extensions
RUN docker-php-ext-install pdo pdo_mysql sockets

ENV COMPOSER_ALLOW_SUPERUSER=1

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy only the composer files first for better caching
COPY ./composer.json /var/www/html/

# Install dependencies using Composer
RUN composer install --no-scripts --no-autoloader

# Copy the rest of the application
COPY . /var/www/html

# Generate autoload files
RUN composer dump-autoload --optimize

# Set permissions for Laravel
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Expose port 8000 for Laravel development server
EXPOSE 8000

# Start the Laravel development server
CMD ["php", "artisan", "serve", "--host=127.0.0.0", "--port=8000"]
