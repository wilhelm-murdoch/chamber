---
order: 100
icon: code
label: /latency/slow
---

## Demonstration

Demonstrates a hard-coded response time of `5` seconds. This is useful for testing consistently-long-running requests.

+++ Command
```bash # Respond with JSON:
curl -s http://localhost:8000/latency/slow | jq -r '.'
```
```bash # Respond with headers:
curl -I http://localhost:8000/latency/slow
```
+++ Headers
``` #
HTTP/1.1 200 OK
Date: Tue, 02 Nov 2021 13:46:10 GMT
Content-Type: application/json
Connection: keep-alive
```
+++ JSON
```json # The duration of the request.
{
  "elapsed": 5.011
}
```
+++ 

## Nginx Directive

This is the directive responsible for this endpoint's behaviour. You can read the entirety of the configuration [here](https://github.com/wilhelm-murdoch/chamber/blob/main/config/openresty/conf.d/chamber.conf).

:::code source="../../config/openresty/conf.d/chamber.conf" title="config/openresty/conf.d/chamber.conf" region="/latency/slow" :::