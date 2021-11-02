---
order: 60
icon: code
label: /size/larger
---

## Demonstration

Demonstrates a response body of a predetermined size. This is useful for testing endpoints which which respond with various content lengths.

+++ Command
```bash # Respond with text:
curl -s http://localhost:8000/size/larger | jq -r '.'
```
```bash # Respond with headers:
curl -I http://localhost:8000/size/larger
```
+++ Headers
``` #
HTTP/1.1 200 OK
Date: Tue, 02 Nov 2021 13:46:10 GMT
Content-Type: application/json
Connection: keep-alive
```
+++ Response
```text # String "echo" repeated 1,500,000 times.
echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo 
```
+++ 

## Nginx Directive

This is the directive responsible for this endpoint's behaviour. You can read the entirety of the configuration [here](https://github.com/wilhelm-murdoch/chamber/blob/main/config/openresty/conf.d/chamber.conf).

:::code source="../../config/openresty/conf.d/chamber.conf" title="config/openresty/conf.d/chamber.conf" region="/size/larger" :::