FROM nginx:1.16-alpine

COPY /build-app/nginx/conf/nginx.conf /etc/nginx/
