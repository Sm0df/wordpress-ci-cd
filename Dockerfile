# Dockerfile
FROM wordpress:6.5-php8.2-apache

# Instalar dependencias para análisis estático
RUN apt-get update && apt-get install -y \
    git \
    curl \
    unzip \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Instalar Composer para dependencias PHP
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copiar scripts personalizados
COPY scripts/ /usr/local/bin/
RUN chmod +x /usr/local/bin/*.sh

# Copiar configuración de WordPress
COPY wordpress/wp-config.php /usr/src/wordpress/

# Establecer permisos
RUN chown -R www-data:www-data /usr/src/wordpress

WORKDIR /var/www/html
