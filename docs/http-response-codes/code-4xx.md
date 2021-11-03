---
order: 70
icon: code
label: /code/4xx
---

## Demonstration

Demonstrates server responses from the `HTTP/1.1 1xx` series of codes.

### Definition

> This class of status code is intended for situations in which the error seems to have been caused by the client. Except when responding to a HEAD request, the server should include an entity containing an explanation of the error situation, and whether it is a temporary or permanent condition. These status codes are applicable to any request method. User agents should display any included entity to the user.

[!ref text="From Wikipedia" icon="mortar-board" target="blank"](https://shorturl.at/aqCQ8)

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

:::code source="../../config/openresty/conf.d/chamber.conf" title="config/openresty/conf.d/chamber.conf" region="/code/4xx" :::