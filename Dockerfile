FROM openresty/openresty:alpine

RUN    apk -Uuv add apache2-utils \
    && rm /var/cache/apk/*

LABEL org.opencontainers.image.title       "chamber"                                                        \
      org.opencontainers.image.description "An OpenResty-based echo server."                                \
      org.opencontainers.image.licenses    "The Unlicense"                                                  \
      org.opencontainers.image.authors     "wilhelm@devilmayco.de"                                          \
      org.opencontainers.image.source      "https://github.com/wilhelm-murdoch/chamber"                     \
      org.opencontainers.image.url         "https://github.com/wilhelm-murdoch/chamber"                     \
      org.opencontainers.image.docs        "https://github.com/wilhelm-murdoch/chamber/blob/main/README.md" \
      org.opencontainers.image.version     "latest"

WORKDIR /etc/nginx

ARG GIT_SHA
RUN echo "${GIT_SHA}" > /.git_sha

RUN mkdir -p /etc/security
RUN {                          \
      echo "soft nofile 4096"; \
      echo "hard nofile 4096"; \
    } > /etc/security/limits.conf

RUN {                                                   \
      echo "fs.file-max=65536";                         \
      echo "vm.swappiness = 0";                         \
      echo "net.ipv4.ip_local_port_range = 1024 65000"; \
      echo "net.core.netdev_max_backlog = 65536";       \
      echo "net.core.somaxconn=65536";                  \
      echo "net.ipv4.tcp_timestamps = 0";               \
      echo "net.ipv4.tcp_sack = 1";                     \
      echo "net.ipv4.tcp_window_scaling = 1";           \
      echo "net.ipv4.tcp_fin_timeout = 15";             \
      echo "net.ipv4.tcp_keepalive_intvl = 30";         \
      echo "net.ipv4.tcp_tw_reuse = 1";                 \
      echo "net.ipv4.tcp_max_tw_buckets = 1440000";     \
      echo "net.ipv4.tcp_max_syn_backlog = 3240000";    \
    } > /etc/sysctl.conf

ADD etc/nginx/ /etc/nginx/

EXPOSE 8000

ENTRYPOINT [ "/usr/local/openresty/bin/openresty", "-g", "daemon off;" ]