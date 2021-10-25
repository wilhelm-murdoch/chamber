#!/usr/bin/env sh

set -eo pipefail

[[ -n "${VERBOSE}" ]] && set -x

if [[ -n "${CHAMBER_BASIC_AUTH_USER}" && -n "${CHAMBER_BASIC_AUTH_PASSWORD}" ]]; then
  htpasswd -dbc /etc/nginx/.htpasswd "${CHAMBER_BASIC_AUTH_USER}" "${CHAMBER_BASIC_AUTH_PASSWORD}"
fi

/usr/local/openresty/bin/openresty -g "daemon off;"
