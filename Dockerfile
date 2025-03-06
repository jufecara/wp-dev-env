# Usa la imagen oficial de WordPress con PHP
FROM wordpress:latest

# Instala dependencias necesarias
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    unzip \
    nano \
    git \
    vim \
    default-mysql-client \
    && rm -rf /var/lib/apt/lists/*

# Instala WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Instala Node.js LTS y npm
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g npm

# Instala paquetes globales de desarrollo de WordPress
RUN npm install -g @wordpress/scripts @wordpress/create-block @wordpress/env

# Configurar Apache para usar /var/www en lugar de /var/www/html
RUN sed -i 's|/var/www/html|/var/www|' /etc/apache2/sites-available/000-default.conf && \
    sed -i 's|/var/www/html|/var/www|' /etc/apache2/apache2.conf && \
    mkdir -p /var/www && chown -R www-data:www-data /var/www

# Exponer el nuevo DocumentRoot
ENV APACHE_DOCUMENT_ROOT /var/www

# Reiniciar Apache para aplicar cambios
RUN service apache2 restart

# Establece el directorio de trabajo
WORKDIR /var/www

# Asigna permisos correctos
RUN chown -R www-data:www-data /var/www

# Define usuario por defecto como www-data (el usuario de Apache en WordPress)
USER www-data
