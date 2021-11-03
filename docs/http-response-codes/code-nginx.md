---
order: 30
icon: code
label: /code/nginx
---

## Demonstration

> The nginx web server software expands the 4xx error space to signal issues with the client's request.

[!ref text="From Wikipedia" icon="mortar-board" target="blank"](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes)

+++ Command
```bash # Respond with JSON:
for code in {495,499}; do 
  curl -s http://localhost:8000/code/$code | jq -r '.'
done
```
```bash # Respond with headers:
for code in {495,499}; do 
  curl -I http://localhost:8000/code/$code
done
```
+++ Headers
``` #
HTTP/1.1 495 
Date: Wed, 03 Nov 2021 09:44:42 GMT
Content-Type: application/json
Content-Length: 182
Connection: keep-alive

HTTP/1.1 499 
Date: Wed, 03 Nov 2021 09:44:42 GMT
Content-Type: application/json
Content-Length: 157
Connection: keep-alive
```
+++ JSON
```json # Various response bodies:
{
  "code": 495,
  "message": "SSL Certificate Error",
  "description": "An expansion of the 400 Bad Request response code, used when the client has provided an invalid client certificate."
}
{
  "code": 499,
  "message": "Token Required",
  "description": "Returned by ArcGIS for Server. Code 499 indicates that a token is required but was not submitted."
}
```
+++ 

## Nginx Directive

This is the directive responsible for this endpoint's behaviour. You can read the entirety of the configuration [here](https://github.com/wilhelm-murdoch/chamber/blob/main/config/openresty/conf.d/chamber.conf).

:::code source="../../config/openresty/conf.d/chamber.conf" title="config/openresty/conf.d/chamber.conf" region="/code/nginx" :::