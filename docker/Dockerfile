FROM php:8.1-apache

# Install PHP extensions
RUN apt-get update && apt-get install -y \
    git unzip zip libicu-dev libzip-dev \
    && docker-php-ext-install intl pdo pdo_mysql zip

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Copy app to /var/www/html
COPY ./app/ /var/www/html/

# Set working dir and permissions
WORKDIR /var/www/html
RUN chown -R www-data:www-data /var/www/html

