# ============================
# Stage 1: Build dependencies
# ============================
FROM php:7.4-fpm AS development

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git curl unzip zip \
    libpng-dev libonig-dev libxml2-dev libzip-dev \
    libjpeg62-turbo-dev libfreetype6-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd xml zip

# Install Xdebug khusus untuk PHP 7.4
# RUN pecl install xdebug-2.9.8 && docker-php-ext-enable xdebug

# Install Composer
# RUN curl -sS https://getcomposer.org/installer | php
# RUN mv composer.phar /usr/bin/composer
# RUN composer --version
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Install Node.js (for Laravel Mix if needed)
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - \
    && apt-get install -y nodejs \
    && npm -v && node -v

# Workdir
WORKDIR /var/www/html

# Copy source code
COPY . /var/www/html


# Install PHP dependencies
RUN composer install --no-interaction --prefer-dist --optimize-autoloader

RUN php artisan key:generate

# Build frontend (optional, kalau pakai Laravel Mix)
# RUN npm install && npm run prod

# ============================
# Stage 2: Runtime
# ============================
#FROM php:7.4-cli
FROM php:7.4.0-fpm-alpine AS production


# Workdir
WORKDIR /var/www/html

# Copy only built files from build stage
COPY --from=development /var/www/html /var/www/html

# Expose port
EXPOSE 8080

# Jalankan Laravel development server
#CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8080"]

CMD ["php", "-S", "0.0.0.0:8080", "-t", "public/"]