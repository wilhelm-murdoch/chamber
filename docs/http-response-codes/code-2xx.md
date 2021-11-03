---
order: 90
icon: code
label: /code/2xx
---

## Demonstration

Demonstrates server responses from the `HTTP/1.1 1xx` series of codes.

### Definition

> This class of status codes indicates the action requested by the client was received, understood, and accepted.

[!ref text="From Wikipedia" icon="mortar-board" target="blank"](https://shorturl.at/gtvzL)

+++ Command
```bash # Respond with JSON:
for code in {100,102}; do 
  curl -s http://localhost:8000/code/$code | jq -r '.'
done
```
```bash # Respond with headers:
for code in {100,102}; do 
  curl -I http://localhost:8000/code/$code
done
```
+++ Headers
``` #
HTTP/1.1 100 
Date: Wed, 03 Nov 2021 04:06:49 GMT
Content-Type: application/json
Content-Length: 154
Connection: keep-alive

HTTP/1.1 102 
Date: Wed, 03 Nov 2021 04:07:03 GMT
Content-Type: application/json
Content-Length: 290
Connection: keep-alive
```
+++ JSON
```json # Various response bodies:
{
  "code": 100,
  "message": "Continue",
  "description": "The server has received the request headers, and the client should proceed to send the request body."
}
{
  "code": 102,
  "message": "Processing",
  "description": "A WebDAV request may contain many sub-requests involving file operations, requiring a long time to complete the request. This code indicates that the server has received and is processing the request, but no response is available yet."
}
```
+++ 

## Nginx Directive

This is the directive responsible for this endpoint's behaviour. You can read the entirety of the configuration [here](https://github.com/wilhelm-murdoch/chamber/blob/main/config/openresty/conf.d/chamber.conf).

:::code source="../../config/openresty/conf.d/chamber.conf" title="config/openresty/conf.d/chamber.conf" region="/code/2xx" :::