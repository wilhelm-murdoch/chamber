---
order: 60
icon: code
label: /code/5xx
---

## Demonstration

Demonstrates server responses from the `HTTP/1.1 5xx` series of codes.

### Definition

> The server failed to fulfil a request.
> 
> Response status codes beginning with the digit "5" indicate cases in which the server is aware that it has encountered an error or is otherwise incapable of performing the request. Except when responding to a HEAD request, the server should include an entity containing an explanation of the error situation, and indicate whether it is a temporary or permanent condition. Likewise, user agents should display any included entity to the user. These response codes are applicable to any request method.

[!ref text="From Wikipedia" icon="mortar-board" target="blank"](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes)

+++ Command
```bash # Respond with JSON:
for code in {503,504}; do 
  curl -s http://localhost:8000/code/$code | jq -r '.'
done
```
```bash # Respond with headers:
for code in {503,504}; do 
  curl -I http://localhost:8000/code/$code
done
```
+++ Headers
``` #
HTTP/1.1 503 Service Temporarily Unavailable
Date: Wed, 03 Nov 2021 09:38:12 GMT
Content-Type: application/json
Content-Length: 122
Connection: keep-alive

HTTP/1.1 504 Gateway Time-out
Date: Wed, 03 Nov 2021 09:38:12 GMT
Content-Type: application/json
Content-Length: 168
Connection: keep-alive
```
+++ JSON
```json # Various response bodies:
{
  "code": 503,
  "message": "Service Unavailable",
  "description": "The server is currently unavailable (overloaded or down)."
}
{
  "code": 504,
  "message": "Gateway Timeout",
  "description": "The server was acting as a gateway or proxy and did not receive a timely response from the upstream server."
}
```
+++ 

## Nginx Directive

This is the directive responsible for this endpoint's behaviour. You can read the entirety of the configuration [here](https://github.com/wilhelm-murdoch/chamber/blob/main/config/openresty/conf.d/chamber.conf).

:::code source="../../config/openresty/conf.d/chamber.conf" title="config/openresty/conf.d/chamber.conf" region="/code/5xx" :::