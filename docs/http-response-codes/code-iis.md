---
order: 40
icon: code
label: /code/iis
---

## Demonstration

> Microsoft's Internet Information Services (IIS) web server expands the 4xx error space to signal errors with the client's request.

[!ref text="From Wikipedia" icon="mortar-board" target="blank"](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes)

+++ Command
```bash # Respond with JSON:
for code in {449,440}; do 
  curl -s http://localhost:8000/code/$code | jq -r '.'
done
```
```bash # Respond with headers:
for code in {449,440}; do 
  curl -I http://localhost:8000/code/$code
done
```
+++ Headers
``` #
HTTP/1.1 449 
Date: Wed, 03 Nov 2021 09:43:23 GMT
Content-Type: application/json
Content-Length: 152
Connection: keep-alive

HTTP/1.1 440 
Date: Wed, 03 Nov 2021 09:43:23 GMT
Content-Type: application/json
Content-Length: 115
Connection: keep-alive
```
+++ JSON
```json # Various response bodies:
{
  "code": 449,
  "message": "Retry With",
  "description": "The server cannot honour the request because the user has not provided the required information."
}
{
  "code": 440,
  "message": "Login Time-out",
  "description": "The client's session has expired and must log in again."
}
```
+++ 

## Nginx Directive

This is the directive responsible for this endpoint's behaviour. You can read the entirety of the configuration [here](https://github.com/wilhelm-murdoch/chamber/blob/main/config/openresty/conf.d/chamber.conf).

:::code source="../../config/openresty/conf.d/chamber.conf" title="config/openresty/conf.d/chamber.conf" region="/code/iis" :::