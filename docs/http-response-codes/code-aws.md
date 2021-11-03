---
order: 20
icon: code
label: /code/aws
---

## Demonstration

> Amazon's Elastic Load Balancing adds a few custom return codes.

[!ref text="From Wikipedia" icon="mortar-board" target="blank"](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes)

+++ Command
```bash # Respond with JSON:
for code in {460,463}; do 
  curl -s http://localhost:8000/code/$code | jq -r '.'
done
```
```bash # Respond with headers:
for code in {460,463}; do 
  curl -I http://localhost:8000/code/$code
done
```
+++ Headers
``` #
HTTP/1.1 460 
Date: Wed, 03 Nov 2021 09:39:59 GMT
Content-Type: application/json
Content-Length: 222
Connection: keep-alive

HTTP/1.1 463 
Date: Wed, 03 Nov 2021 09:39:59 GMT
Content-Type: application/json
Content-Length: 141
Connection: keep-alive
```
+++ JSON
```json # Various response bodies:
{
  "code": 460,
  "message": "???",
  "description": "Client closed the connection with the load balancer before the idle timeout period elapsed. Typically when client timeout is sooner than the Elastic Load Balancer's timeout."
}
{
  "code": 463,
  "message": "???",
  "description": "The load balancer received an X-Forwarded-For request header with more than 30 IP addresses."
}
```
+++ 

## Nginx Directive

This is the directive responsible for this endpoint's behaviour. You can read the entirety of the configuration [here](https://github.com/wilhelm-murdoch/chamber/blob/main/config/openresty/conf.d/chamber.conf).

:::code source="../../config/openresty/conf.d/chamber.conf" title="config/openresty/conf.d/chamber.conf" region="/code/aws" :::