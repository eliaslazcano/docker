FROM php:8.4-fpm

# Atualiza a lista de pacotes e instalações iniciais
RUN apt-get -yqq update && apt-get -yqq install iputils-ping libicu-dev libpq-dev zlib1g-dev libzip-dev libpng-dev libjpeg62-turbo-dev libwebp-dev libfreetype6-dev libgd-dev exiftool locales && apt-get clean

# Configuração da localidade
RUN echo "pt_BR.UTF-8 UTF-8" >> /etc/locale.gen && locale-gen && update-locale LANG=pt_BR.UTF-8

# Definição de variáveis de ambiente
ENV LC_ALL=pt_BR.UTF-8 LANG=pt_BR.UTF-8 LANGUAGE=pt_BR.UTF-8

# Instalação de extensões PHP
RUN docker-php-ext-configure zip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-configure exif \
    && docker-php-ext-configure intl \
    && docker-php-ext-configure opcache \
    && docker-php-ext-install -j$(nproc) opcache pdo pdo_mysql zip gd exif intl

RUN echo 'intl.default_locale = "pt_BR"' >> /usr/local/etc/php/conf.d/docker-php-ext-intl.ini

EXPOSE 9000/tcp

CMD ["php-fpm"]
