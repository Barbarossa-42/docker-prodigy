FROM lukasprudil/prodigy:nginx-global

COPY /build-app/nginx/site/prod.conf /etc/nginx/conf.d/default.conf
