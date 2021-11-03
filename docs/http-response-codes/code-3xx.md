---
order: 80
icon: code
label: /code/3xx
---

## Demonstration

Demonstrates server responses from the `HTTP/1.1 3xx` series of codes.

### Definition

> This class of status code indicates the client must take additional action to complete the request. Many of these status codes are used in URL redirection.

[!ref text="From Wikipedia" icon="mortar-board" target="blank"](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes)

+++ Command
```bash # Respond with JSON:
curl -s http://localhost:8000/code/300 | jq -r '.'
```
```bash # Respond with headers:
curl -I http://localhost:8000/code/300
```
+++ Headers
``` #
HTTP/1.1 300 
Date: Wed, 03 Nov 2021 09:34:53 GMT
Content-Type: application/json
Content-Length: 150
Connection: keep-alive
```
+++ JSON
```json # Various response bodies:
{
  "code": 300,
  "message": "Multiple Choices",
  "description": "A link list. The user can select a link and go to that location. Maximum five addresses."
}
```
+++ 

## Nginx Directive

This is the directive responsible for this endpoint's behaviour. You can read the entirety of the configuration [here](https://github.com/wilhelm-murdoch/chamber/blob/main/config/openresty/conf.d/chamber.conf).

:::code source="../../config/openresty/conf.d/chamber.conf" title="config/openresty/conf.d/chamber.conf" region="/code/3xx" :::