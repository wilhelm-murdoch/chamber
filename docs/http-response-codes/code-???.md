---
order: 50
icon: code
label: /code/???
---

## Demonstration

> The following codes are not specified by any standard.

[!ref text="From Wikipedia" icon="mortar-board" target="blank"](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes)

+++ Command
```bash # Respond with JSON:
for code in {498,420}; do 
  curl -s http://localhost:8000/code/$code | jq -r '.'
done
```
```bash # Respond with headers:
for code in {498,420}; do 
  curl -I http://localhost:8000/code/$code
done
```
+++ Headers
``` #
HTTP/1.1 498 
Date: Wed, 03 Nov 2021 09:26:33 GMT
Content-Type: application/json
Content-Length: 147
Connection: keep-alive

HTTP/1.1 420 
Date: Wed, 03 Nov 2021 09:26:33 GMT
Content-Type: application/json
Content-Length: 236
Connection: keep-alive
```
+++ JSON
```json # Various response bodies:
{
  "code": 498,
  "message": "Invalid Token",
  "description": "Returned by ArcGIS for Server. Code 498 indicates an expired or otherwise invalid token."
}
{
  "code": 420,
  "message": "Enhance Your Calm",
  "description": "Returned by version 1 of the Twitter Search and Trends API when the client is being rate limited; versions 1.1 and later use the 429 Too Many Requests response code instead."
}
```
+++ 

## Nginx Directive

This is the directive responsible for this endpoint's behaviour. You can read the entirety of the configuration [here](https://github.com/wilhelm-murdoch/chamber/blob/main/config/openresty/conf.d/chamber.conf).

:::code source="../../config/openresty/conf.d/chamber.conf" title="config/openresty/conf.d/chamber.conf" region="/code/???" :::