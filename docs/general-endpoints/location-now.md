---
order: 100
icon: code
label: /now
---
Returns a JSON response containing a current Unix timestamp:

```bash
$ curl -i http://localhost:8000/now
HTTP/1.1 200 OK
Date: Mon, 25 Oct 2021 15:02:45 GMT
Content-Type: application/json
Connection: close

{"now": 1635174165.878}
```