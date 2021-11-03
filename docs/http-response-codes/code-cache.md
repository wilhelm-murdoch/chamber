---
order: 10
icon: code
label: /code/cache
---

## Demonstration

> The following caching related warning codes are specified under RFC 7234. Unlike the other status codes above, these are not sent as the response status in the HTTP protocol, but as part of the "Warning" HTTP header.[93][94] Since this header is often neither sent by servers nor acknowledged by clients, it will soon be obsoleted by the HTTP Working Group.

[!ref text="From Wikipedia" icon="mortar-board" target="blank"](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes)

+++ Command
```bash # Respond with JSON:
for code in {112,199}; do 
  curl -s http://localhost:8000/code/$code | jq -r '.'
done
```
```bash # Respond with headers:
for code in {112,199}; do 
  curl -I http://localhost:8000/code/$code
done
```
+++ Headers
``` #
HTTP/1.1 112 
Date: Wed, 03 Nov 2021 09:40:59 GMT
Content-Type: application/json
Content-Length: 137
Connection: keep-alive

HTTP/1.1 199 
Date: Wed, 03 Nov 2021 09:40:59 GMT
Content-Type: application/json
Content-Length: 137
Connection: keep-alive
```
+++ JSON
```json # Various response bodies:
{
  "code": 112,
  "message": "Disconnected Operation",
  "description": "The cache is intentionally disconnected from the rest of the network."
}
{
  "code": 199,
  "message": "Miscellaneous Warning",
  "description": "Arbitrary, non-specific warning. The warning text may be logged or presented to the user."
}
```
+++ 

## Nginx Directive

This is the directive responsible for this endpoint's behaviour. You can read the entirety of the configuration [here](https://github.com/wilhelm-murdoch/chamber/blob/main/config/openresty/conf.d/chamber.conf).

:::code source="../../config/openresty/conf.d/chamber.conf" title="config/openresty/conf.d/chamber.conf" region="/code/cache" :::