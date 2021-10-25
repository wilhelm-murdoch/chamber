# FROM alpine:latest
FROM openresty/openresty:alpine

LABEL author="wilhelm@devilmayco.de"

WORKDIR /etc/nginx

RUN rm /etc/nginx/conf.d/default.conf

ADD config/openresty/.htpasswd    /etc/nginx/.htpasswd
ADD config/openresty/chamber.conf /etc/nginx/conf.d/chamber.conf
ADD config/openresty/nginx.conf   /etc/nginx/nginx.conf
ADD config/sysctl.conf            /etc/sysctl.conf
ADD config/limits.conf            /etc/security/limits.conf

EXPOSE 8000