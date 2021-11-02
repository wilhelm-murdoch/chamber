---
order: 100
icon: code
label: /docs
---
If you hit [this](http://localhost:8000/docs) endpoint in your browser, you will be redirected to this `README.md` file:

```bash
$ curl -i http://localhost:8000/docs
HTTP/1.1 301 Moved Permanently
Date: Mon, 25 Oct 2021 15:04:50 GMT
Content-Type: text/html
Content-Length: 166
Connection: keep-alive
Location: https://github.com/wilhelm-murdoch/chamber/blob/main/README.md
```