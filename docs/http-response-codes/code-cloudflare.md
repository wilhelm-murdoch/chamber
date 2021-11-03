---
order: 20
icon: code
label: /code/cloudflare
---

## Demonstration

> Cloudflare's reverse proxy service expands the 5xx series of errors space to signal issues with the origin server.

[!ref text="From Wikipedia" icon="mortar-board" target="blank"](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes)

+++ Command
```bash # Respond with JSON:
for code in {523,530}; do 
  curl -s http://localhost:8000/code/$code | jq -r '.'
done
```
```bash # Respond with headers:
for code in {523,530}; do 
  curl -I http://localhost:8000/code/$code
done
```
+++ Headers
``` #
HTTP/1.1 523 
Date: Wed, 03 Nov 2021 09:42:31 GMT
Content-Type: application/json
Content-Length: 192
Connection: keep-alive

HTTP/1.1 530 
Date: Wed, 03 Nov 2021 09:42:31 GMT
Content-Type: application/json
Content-Length: 152
Connection: keep-alive
```
+++ JSON
```json # Various response bodies:
{
  "code": 523,
  "message": "Origin Is Unreachable",
  "description": "Cloudflare could not reach the origin server; for example, if the DNS records for the origin server are incorrect or missing."
}
{
  "code": 530,
  "message": "Site is frozen",
  "description": "Used by the Pantheon web platform to indicate a site that has been frozen due to inactivity."
}
```
+++ 

## Nginx Directive

This is the directive responsible for this endpoint's behaviour. You can read the entirety of the configuration [here](https://github.com/wilhelm-murdoch/chamber/blob/main/config/openresty/conf.d/chamber.conf).

:::code source="../../config/openresty/conf.d/chamber.conf" title="config/openresty/conf.d/chamber.conf" region="/code/cloudflare" :::