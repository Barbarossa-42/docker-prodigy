FROM lukasprudil/prodigy:app-global

# php files in production mode cannot be changed
ENV PHP_OPCACHE_VALIDATE_TIMESTAMPS="0"

COPY /build-app/php-fpm/config/php7.prod.ini /usr/local/etc/php/conf.d/
