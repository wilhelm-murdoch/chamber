---
order: 700
icon: browser
label: Response Sizes
---
The following endpoints are used for testing response bodies of various sizes:

1. `location /size/smallest`: `echo` repeated `150` times.
2. `location /size/small`: `echo` repeated `1,500` times.
3. `location /size/medium`: `echo` repeated `15,000` times.
4. `location /size/large`: `echo` repeated `150,000` times.
5. `location /size/larger`: `echo` repeated `1,500,000` times.
6. `location /size/largest`: `echo` repeated `15,000,000` times.

These endpoints will return the following type of response:

```bash
$  curl -i http://localhost:8000/size/smallest
HTTP/1.1 200 OK
Date: Mon, 25 Oct 2021 15:10:44 GMT
Content-Type: text/html
Connection: close

echo echo echo echo echo echo ... heaps more ... echo echo
```