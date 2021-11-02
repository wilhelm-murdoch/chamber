---
order: 100
icon: code
label: /status
---

## Demonstration

Returns a live counting of various running server statistics.

+++ Command
```bash # Respond with JSON:
curl http://localhost:8000/status
```
```bash # Respond with headers:
curl -I http://localhost:8000/status
```
+++ Headers
``` #
HTTP/1.1 200 OK
Date: Mon, 25 Oct 2021 14:52:44 GMT
Content-Type: text/plain
Content-Length: 100
Connection: keep-alive
```
+++ JSON
```json # The current status of the running server.
{
  "connection": 14078,
  "connection_requests": 1,
  "connections_active": 1,
  "connections_reading": 0,
  "connections_writing": 1,
  "connections_waiting": 0
}
```
+++ 

You can read more about what this information means [here](http://nginx.org/en/docs/http/ngx_http_stub_status_module.html#stub_status).

## Nginx Directive

This is the directive responsible for this endpoint's behaviour. You can read the entirety of the configuration [here](https://github.com/wilhelm-murdoch/chamber/blob/main/config/openresty/conf.d/chamber.conf).

:::code source="../../config/openresty/conf.d/chamber.conf" title="config/openresty/conf.d/chamber.conf" region="/status" :::