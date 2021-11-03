---
order: 100
icon: code
label: /
---

## Demonstration

This is simply the default landing page of the service.

+++ Command
```bash # Respond with HTML:
curl http://localhost:8000/
```
```bash # Respond with headers:
curl -I http://localhost:8000/
```
+++ Headers
``` #
HTTP/1.1 200 OK
Date: Mon, 25 Oct 2021 14:52:44 GMT
Content-Type: text/plain
Content-Length: 100
Connection: keep-alive
```
+++ HTML
```html # HTML body and css representing the landing page.
<!DOCTYPE html><html lang='en'> ... </html>
```
+++ 

Visiting this endpoint in your browser will yield a landing page with the following glitch effect.

<img src="/static/chamber.gif" alt="drawing" style="width: 100%;" />
<br />  
<br />

## Nginx Directive

This is the directive responsible for this endpoint's behaviour. You can read the entirety of the configuration [here](https://github.com/wilhelm-murdoch/chamber/blob/main/config/openresty/conf.d/chamber.conf).

:::code source="../../config/openresty/conf.d/chamber.conf" title="config/openresty/conf.d/chamber.conf" region="/" :::