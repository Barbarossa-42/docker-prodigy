FROM lukasprudil/prodigy:app-full

# check files for every request
ENV PHP_OPCACHE_VALIDATE_TIMESTAMPS="1"

ENV PHPIZE_DEPS \
    autoconf \
    g++ \
    gcc \
    make \
    pkgconf \
    re2c

RUN set -xe \
    && apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
    && pecl -d install xdebug \
    && apk del .build-deps

# Copy custom configuration
COPY ./build-app/php-fpm/config/xdebug.ini $PHP_INI_DIR/conf.d/

WORKDIR /srv/app
