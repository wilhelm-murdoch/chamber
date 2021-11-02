---
order: 100
icon: code
label: /hello-world
---

## Demonstration

Returns a text response for "Hello, world!" in all languages supported by Google Translate.

+++ Command
```bash # Respond with text:
for i in {1..5}; do curl http://localhost:8000/hello-world; done
```
```bash # Respond with headers:
curl -I http://localhost:8000/hello-world
```
+++ Headers
``` #
HTTP/1.1 200 OK
Date: Tue, 02 Nov 2021 16:12:38 GMT
Content-Type: text/html
Connection: keep-alive
```
+++ Text
```bash #
Ahoj svete!
你好，世界！
Hello, World!
Բարեւ աշխարհ!
Dia duit, a shaoghail!
```
+++ 

## Nginx Directive

This is the directive responsible for this endpoint's behaviour. You can read the entirety of the configuration [here](https://github.com/wilhelm-murdoch/chamber/blob/main/config/openresty/conf.d/chamber.conf).

:::code source="../../config/openresty/conf.d/chamber.conf" title="config/openresty/conf.d/chamber.conf" region="/hello-world" :::