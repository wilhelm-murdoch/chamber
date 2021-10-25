# FROM alpine:latest
FROM openresty/openresty:alpine

LABEL org.opencontainers.image.title       "chamber"
LABEL org.opencontainers.image.description "An OpenResty-based echo server."
LABEL org.opencontainers.image.licenses    "The Unlicense"
LABEL org.opencontainers.image.authors     "wilhelm@devilmayco.de"
LABEL org.opencontainers.image.source      "https://github.com/wilhelm-murdoch/chamber"
LABEL org.opencontainers.image.url         "https://github.com/wilhelm-murdoch/chamber"
LABEL org.opencontainers.image.docs        "https://github.com/wilhelm-murdoch/chamber/blob/main/README.md"
LABEL org.opencontainers.image.version     "latest"

WORKDIR /etc/nginx

RUN rm /etc/nginx/conf.d/default.conf

ADD config/openresty/.htpasswd    /etc/nginx/.htpasswd
ADD config/openresty/chamber.conf /etc/nginx/conf.d/chamber.conf
ADD config/openresty/nginx.conf   /etc/nginx/nginx.conf
ADD config/sysctl.conf            /etc/sysctl.conf
ADD config/limits.conf            /etc/security/limits.conf

EXPOSE 8000