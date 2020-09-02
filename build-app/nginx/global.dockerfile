FROM nginx:1.17-alpine

COPY /build-app/nginx/conf/nginx.conf /etc/nginx/
