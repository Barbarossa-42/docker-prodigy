FROM prodigy:nginx-global

COPY ./site/prod.conf /etc/nginx/conf.d/default.conf
