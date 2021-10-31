FROM openresty/openresty:alpine

RUN    apk -Uuv add apache2-utils \
    && rm /var/cache/apk/*

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

ADD config/openresty/  /etc/nginx/
ADD config/sysctl.conf /etc/sysctl.conf
ADD config/limits.conf /etc/security/limits.conf
ADD entrypoint.sh      /entrypoint.sh

ARG GIT_SHA
RUN echo "chamber release: ${GIT_SHA}" > /.git_sha

EXPOSE 8000

ENTRYPOINT [ "/entrypoint.sh" ]