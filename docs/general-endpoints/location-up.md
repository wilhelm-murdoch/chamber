---
order: 100
icon: code
label: /up
---

## Demonstration

This is an endpoint suitable for health checks. It will return a `200 OK` response as well as the currently-running release of the server.

+++ Command
```bash # Respond with text:
curl http://localhost:8000/up
```
```bash # Respond with headers:
curl -I http://localhost:8000/up
```
+++ Headers
``` #
HTTP/1.1 200 OK
Date: Mon, 25 Oct 2021 14:50:45 GMT
Content-Type: text/html
Content-Length: 26
Last-Modified: Mon, 25 Oct 2021 13:43:19 GMT
Connection: keep-alive
ETag: "6176b477-1a"
Accept-Ranges: bytes
```
+++ Response
```text # The current release of the service.
chamber release: a5fecbfa
```
+++ 

The output is sourced from a file that is generated during build time for the associated Docker image.

:::code source="../../Dockerfile" title="Dockerfile" range="24-25" :::

## Nginx Directive

This is the directive responsible for this endpoint's behaviour. You can read the entirety of the configuration [here](https://github.com/wilhelm-murdoch/chamber/blob/main/config/openresty/conf.d/chamber.conf).

:::code source="../../config/openresty/conf.d/chamber.conf" title="config/openresty/conf.d/chamber.conf" region="/up" :::