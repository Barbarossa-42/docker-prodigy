# copied prooph/php:7.4-fpm - 2d596a4
FROM php:7.4-fpm-alpine3.12

ENV PHPIZE_DEPS \
    autoconf \
    cmake \
    file \
    g++ \
    gcc \
    libc-dev \
    pcre-dev \
    make \
    git \
    pkgconf \
    re2c \
    # for GD
    freetype-dev \
    libpng-dev  \
    libjpeg-turbo-dev \
    # for xslt
    libxslt-dev \
    # for intl extension
    icu-dev \
    openssl-dev

RUN apk add --no-cache --virtual .persistent-deps \
    npm bash git \
    # for intl extension
    icu-libs \
    # for mongodb
    libssl1.1 \
    # for soap
    libxml2-dev \
    # for amqp
    libressl-dev \
    # for GD
    freetype \
    libpng \
    libwebp-dev \
    libjpeg-turbo \
    libxslt \
    # for mbstring
    oniguruma-dev \
    libgcrypt gmp-dev

RUN set -xe \
    # workaround for rabbitmq linking issue
    && ln -s /usr/lib /usr/local/lib64 \
    # hack to link libgcrypt
    && ln -s /usr/lib/libgcrypt.so.20 /usr/lib/libgcrypt.so \
    && ln -s /usr/lib/libgpg-error.so.0 /usr/lib/libgpg-error.so \
    && apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
    && docker-php-ext-configure gd --enable-gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ --with-webp=/usr/include/ \
    && docker-php-ext-configure bcmath --enable-bcmath \
    && docker-php-ext-configure intl --enable-intl \
    && docker-php-ext-configure pcntl --enable-pcntl \
    && docker-php-ext-configure mysqli --with-mysqli \
    && docker-php-ext-configure pdo_mysql --with-pdo-mysql \
    && docker-php-ext-configure mbstring --enable-mbstring \
    && docker-php-ext-configure soap --enable-soap \
    && docker-php-ext-configure opcache --enable-opcache \
    && docker-php-ext-install -j$(nproc) gd bcmath intl pcntl mysqli pdo_mysql mbstring soap iconv opcache sockets xsl gmp

# Redis
ENV PHP_REDIS_VERSION 5.3.1
RUN git clone --branch ${PHP_REDIS_VERSION} https://github.com/phpredis/phpredis /tmp/phpredis \
        && cd /tmp/phpredis \
        && phpize  \
        && ./configure  \
        && make  \
        && make install \
        && make test

### fix work iconv library with alpine ###
RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ --allow-untrusted gnu-libiconv
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

# composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

# Clean
RUN apk del .build-deps \
    && rm -rf /tmp/* \
    && rm -rf /app \
    && mkdir /app

COPY ./build-app/php-fpm/config/base.ini /usr/local/etc/php/conf.d/
COPY ./build-app/php-fpm/config/fpm/php-fpm.conf /usr/local/etc/
COPY ./build-app/php-fpm/config/fpm/pool.d /usr/local/etc/pool.d
