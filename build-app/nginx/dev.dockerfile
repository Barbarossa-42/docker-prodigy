FROM prodigy:nginx-global

COPY ./site/dev.conf /etc/nginx/conf.d/default.conf
