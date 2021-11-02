---
order: 100
icon: code
label: /hostname
---

## Demonstration

Returns a JSON response containing the servers current time.

+++ Command
```bash # Respond with JSON:
curl -s http://localhost:8000/hostname | jq -r '.'
```
```bash # Respond with headers:
curl -I http://localhost:8000/hostname
```
+++ Headers
``` #
HTTP/1.1 200 OK
Date: Mon, 25 Oct 2021 15:03:47 GMT
Content-Type: application/json
Connection: close
```
+++ JSON
```json # The server's hostname.
{
  "hostname": "localhost"
}
```
+++ 

This will almost always return `localhost` unless you're running outside of a container.

## Nginx Directive

This is the directive responsible for this endpoint's behaviour. You can read the entirety of the configuration [here](https://github.com/wilhelm-murdoch/chamber/blob/main/config/openresty/conf.d/chamber.conf).

:::code source="../../config/openresty/conf.d/chamber.conf" title="config/openresty/conf.d/chamber.conf" region="/hostname" :::