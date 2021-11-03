---
order: 90
icon: code
label: /code/2xx
---

## Demonstration

Demonstrates server responses from the `HTTP/1.1 2xx` series of codes.

### Definition

> This class of status codes indicates the action requested by the client was received, understood, and accepted.

[!ref text="From Wikipedia" icon="mortar-board" target="blank"](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes)

+++ Command
```bash # Respond with JSON:
for code in {200,205}; do 
  curl -s http://localhost:8000/code/$code | jq -r '.'
done
```
```bash # Respond with headers:
for code in {200,205}; do 
  curl -I http://localhost:8000/code/$code
done
```
+++ Headers
``` #
HTTP/1.1 200 OK
Date: Wed, 03 Nov 2021 09:28:00 GMT
Content-Type: application/json
Content-Length: 127
Connection: keep-alive

HTTP/1.1 205 
Date: Wed, 03 Nov 2021 09:28:00 GMT
Content-Type: application/json
Content-Length: 194
Connection: keep-alive
```
+++ JSON
```json # Various response bodies:
{
  "code": 200,
  "message": "OK",
  "description": "The request is OK (this is the standard response for successful HTTP requests)."
}
{
  "code": 205,
  "message": "Reset Content",
  "description": "The request has been successfully processed, but is not returning any content, and requires that the requester reset the document view."
}
```
+++ 

## Nginx Directive

This is the directive responsible for this endpoint's behaviour. You can read the entirety of the configuration [here](https://github.com/wilhelm-murdoch/chamber/blob/main/config/openresty/conf.d/chamber.conf).

:::code source="../../config/openresty/conf.d/chamber.conf" title="config/openresty/conf.d/chamber.conf" region="/code/2xx" :::