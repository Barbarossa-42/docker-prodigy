FROM prodigy:app-global

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
    && pecl install xdebug \
    && apk del .build-deps

# Copy xdebug configuration
COPY /build-app/php-fpm/config/xdebug.ini /usr/local/etc/php/conf.d/

# blackfire setup
#RUN set -xeo pipefail \
#    && version=$(php -r "echo PHP_MAJOR_VERSION, PHP_MINOR_VERSION;") \
#    && curl -sSL -D - -A "Docker" -o /tmp/blackfire-probe.tar.gz https://blackfire.io/api/v1/releases/probe/php/alpine/amd64/${version} \
#    && for file in /tmp/blackfire-*.tar.gz; do tar zxfp "${file}" -C /tmp; done \
#    && for file in /tmp/blackfire-*.sha*; do echo "$(cat ${file})  ${file/.sha1/}"; done | sed 's/\.sha/.so/' | sha1sum -c - \
#    && mv /tmp/blackfire-*.so "$(php -r "echo ini_get('extension_dir');")/blackfire.so" \
#    && printf "extension=blackfire.so\nblackfire.agent_socket=tcp://blackfire:8707\n" > ${PHP_INI_DIR}/conf.d/blackfire.ini \
#    && rm -rf /tmp/blackfire* \
#    && php-fpm -m | grep "^blackfire$" > /dev/null
