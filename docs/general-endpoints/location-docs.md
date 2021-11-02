---
order: 100
icon: code
label: /docs
---

## Demonstration

This endpoint will redirect you straight to this documentation site.

+++ Command
```bash # Respond with HTML:
curl http://localhost:8000/docs
```
```bash # Respond with headers:
curl -I http://localhost:8000/docs
```
```bash # Optionally, follow the redirect:
curl -L http://localhost:8000/docs
```
+++ Headers
``` #
HTTP/1.1 301 Moved Permanently
Date: Tue, 02 Nov 2021 15:52:51 GMT
Content-Type: text/html
Content-Length: 166
Connection: keep-alive
Location: https://chamber.wilhelm.codes
```
+++ HTML
```html # Output when not following redirects.
<html>
  <head>
    <title>301 Moved Permanently</title>
  </head>
  <body>
    <center>
      <h1>301 Moved Permanently</h1>
    </center>
    <hr>
    <center>openresty</center>
  </body>
</html>
```
+++ 

## Nginx Directive

This is the directive responsible for this endpoint's behaviour. You can read the entirety of the configuration [here](https://github.com/wilhelm-murdoch/chamber/blob/main/config/openresty/conf.d/chamber.conf).

:::code source="../../config/openresty/conf.d/chamber.conf" title="config/openresty/conf.d/chamber.conf" region="/docs" :::