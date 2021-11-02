---
order: 100
icon: code
label: /now
---

## Demonstration

Returns a JSON response containing the servers current time.

+++ Command
```bash # Respond with JSON:
curl -s http://localhost:8000/now | jq -r '.'
```
```bash # Respond with headers:
curl -I http://localhost:8000/now
```
+++ Headers
``` #
HTTP/1.1 200 OK
Date: Mon, 25 Oct 2021 15:02:45 GMT
Content-Type: application/json
Connection: close
```
+++ JSON
```json # The current time as reported by the server.
{
  "now": 1635174165.878
}
```
+++ 

## Nginx Directive

This is the directive responsible for this endpoint's behaviour. You can read the entirety of the configuration [here](https://github.com/wilhelm-murdoch/chamber/blob/main/config/openresty/conf.d/chamber.conf).

:::code source="../../config/openresty/conf.d/chamber.conf" title="config/openresty/conf.d/chamber.conf" region="/now" :::