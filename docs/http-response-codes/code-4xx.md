---
order: 70
icon: code
label: /code/4xx
---

## Demonstration

Demonstrates server responses from the `HTTP/1.1 4xx` series of codes.

### Definition

> This class of status code is intended for situations in which the error seems to have been caused by the client. Except when responding to a HEAD request, the server should include an entity containing an explanation of the error situation, and whether it is a temporary or permanent condition. These status codes are applicable to any request method. User agents should display any included entity to the user.

[!ref text="From Wikipedia" icon="mortar-board" target="blank"](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes)

+++ Command
```bash # Respond with JSON:
for code in {403,404}; do 
  curl -s http://localhost:8000/code/$code | jq -r '.'
done
```
```bash # Respond with headers:
for code in {403,404}; do 
  curl -I http://localhost:8000/code/$code
done
```
+++ Headers
``` #
HTTP/1.1 403 Forbidden
Date: Wed, 03 Nov 2021 09:37:21 GMT
Content-Type: application/json
Content-Length: 132
Connection: keep-alive

HTTP/1.1 404 Not Found
Date: Wed, 03 Nov 2021 09:37:21 GMT
Content-Type: application/json
Content-Length: 134
Connection: keep-alive
```
+++ JSON
```json # Various response bodies:
{
  "code": 403,
  "message": "Forbidden",
  "description": "The request was a legal request, but the server is refusing to respond to it."
}
{
  "code": 404,
  "message": "Not Found",
  "description": "The requested page could not be found but may be available again in the future."
}
```
+++ 

## Nginx Directive

This is the directive responsible for this endpoint's behaviour. You can read the entirety of the configuration [here](https://github.com/wilhelm-murdoch/chamber/blob/main/config/openresty/conf.d/chamber.conf).

:::code source="../../config/openresty/conf.d/chamber.conf" title="config/openresty/conf.d/chamber.conf" region="/code/4xx" :::