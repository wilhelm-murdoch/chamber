---
order: 100
icon: code
label: /latency/erratic
---

## Demonstration

Demonstrates how response times can be in flux while a target service is behaving erratically. This endpoint will respond between `1` and `10` seconds.

+++ Command
```bash # Respond with JSON:
curl http://localhost:8000/latency/erratic
```
```bash # Respond with headers:
curl -I http://localhost:8000/latency/erratic
```
+++ Headers
``` #
HTTP/1.1 200 OK
Date: Tue, 02 Nov 2021 13:58:53 GMT
Content-Type: application/json
Connection: keep-alive
```
+++ JSON
```json # The duration of the request.
{
  "elapsed": 6.973
}
```
+++ 

## Nginx Directive

This is the directive responsible for this endpoint's behaviour. You can read the entirety of the configuration [here](https://github.com/wilhelm-murdoch/chamber/blob/main/config/openresty/conf.d/chamber.conf).

:::code source="../../config/openresty/conf.d/chamber.conf" title="config/openresty/conf.d/chamber.conf" region="/latency/erratic" :::