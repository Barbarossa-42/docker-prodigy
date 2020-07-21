FROM nginx:1.18-alpine

COPY /build-app/nginx/conf/nginx.conf /etc/nginx/
