FROM prodigy:nginx-global

COPY /build-app/nginx/site/dev.conf /etc/nginx/conf.d/default.conf
