---
order: 100
icon: code
label: /up
---
This is an endpoint suitable for healthchecks. It will return a `200 OK` response as well as the currently-running release of the server:

```bash
$ curl -i http://localhost:8000/up
HTTP/1.1 200 OK
Date: Mon, 25 Oct 2021 14:50:45 GMT
Content-Type: text/html
Content-Length: 26
Last-Modified: Mon, 25 Oct 2021 13:43:19 GMT
Connection: keep-alive
ETag: "6176b477-1a"
Accept-Ranges: bytes

chamber release: a5fecbfa
```