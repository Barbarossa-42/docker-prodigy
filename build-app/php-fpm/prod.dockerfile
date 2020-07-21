FROM lukasprudil/prodigy:app-mini

COPY ./build-app/php-fpm/config/opcache.ini $PHP_INI_DIR/conf.d/

WORKDIR /app
