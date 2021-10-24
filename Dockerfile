FROM alpine:latest

LABEL author="wilhelm@devilmayco.de"

ENV NGINX_VERSION                      "nginx-1.21.3"
ENV NGINX_MODULE_NGX_DEVEL_KIT_VERSION "0.3.1"
ENV NGINX_MODULE_SET_MISC_NGINX_MODULE "0.33"
ENV NGINX_MODULE_ECHO_NGINX_MODULE     "0.62"
ENV NGINX_MODULE_NGINX_LET_MODULE      "0.0.4"

RUN    apk --update add openssl-dev pcre-dev zlib-dev wget build-base \
    && mkdir -p /tmp/src \
    && cd /tmp/src \
    && wget --no-check-certificate https://github.com/simpl/ngx_devel_kit/archive/v${NGINX_MODULE_NGX_DEVEL_KIT_VERSION}.tar.gz \
    && tar -zxvf v${NGINX_MODULE_NGX_DEVEL_KIT_VERSION}.tar.gz \
    && wget --no-check-certificate https://github.com/openresty/set-misc-nginx-module/archive/v${NGINX_MODULE_SET_MISC_NGINX_MODULE}.tar.gz \
    && tar -zxvf v${NGINX_MODULE_SET_MISC_NGINX_MODULE}.tar.gz \
    && wget --no-check-certificate https://github.com/openresty/echo-nginx-module/archive/v${NGINX_MODULE_ECHO_NGINX_MODULE}.tar.gz \
    && tar -zxvf v${NGINX_MODULE_ECHO_NGINX_MODULE}.tar.gz \
    && wget --no-check-certificate https://github.com/arut/nginx-let-module/archive/v${NGINX_MODULE_NGINX_LET_MODULE}.tar.gz \
    && tar -zxvf v${NGINX_MODULE_NGINX_LET_MODULE}.tar.gz \
    && wget http://nginx.org/download/${NGINX_VERSION}.tar.gz \
    && tar -zxvf ${NGINX_VERSION}.tar.gz \
    && cd /tmp/src/${NGINX_VERSION} \
    && ./configure \
            --add-module=/tmp/src/echo-nginx-module-${NGINX_MODULE_ECHO_NGINX_MODULE} \
            --add-module=/tmp/src/ngx_devel_kit-${NGINX_MODULE_NGX_DEVEL_KIT_VERSION} \
            --add-module=/tmp/src/set-misc-nginx-module-${NGINX_MODULE_SET_MISC_NGINX_MODULE} \
            --add-module=/tmp/src/nginx-let-module-${NGINX_MODULE_NGINX_LET_MODULE} \
            --with-http_ssl_module \
            --with-http_gzip_static_module \
            --with-http_stub_status_module \
            --prefix=/etc/nginx \
            --http-log-path=/dev/stdout \
            --error-log-path=/dev/stderr \
            --sbin-path=/usr/local/sbin/nginx \
    && make \
    && make install \
    && apk del build-base \
    && rm -rf /tmp/src \
    && rm -rf /var/cache/apk/*

WORKDIR /etc/nginx

ADD config/.htpasswd   /etc/nginx/.htpasswd
ADD config/nginx.conf  /etc/nginx/conf/nginx.conf
ADD config/sysctl.conf /etc/sysctl.conf
ADD config/limits.conf /etc/security/limits.conf

EXPOSE 8000

CMD ["nginx", "-g", "daemon off;"]