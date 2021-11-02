---
order: 100
icon: code
label: /hostname
---
Returns the hostname of the server:

```bash
$ curl -i http://localhost:8000/hostname
HTTP/1.1 200 OK
Date: Mon, 25 Oct 2021 15:03:47 GMT
Content-Type: application/json
Connection: close

{"hostname": "localhost"}
```

This will almost always return `localhost` unless you're running outside of a container.