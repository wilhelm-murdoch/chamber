---
order: 100
icon: code
label: /rate-limit
---
An endpoint dedicated to isolated rate limit testing. This is configured within the `http { ... }` directive in `./config/openrest/chamber.conf`:

```
limit_req_zone $binary_remote_addr zone=chamber:1m rate=5r/s;
...
location "/rate-limit" {
  limit_req zone=chamber burst=10 nodelay;
  ...
}
```

Effectively, rate limit up to 160k unique IP addresses to 5 requests per second, burstable up to 10. This can be demonstrated using the `siege` command:

```bash
$ siege -c 15 -r 1 --no-parser http://localhost:8000/rate-limit
** SIEGE 4.1.1
** Preparing 15 concurrent users for battle.
The server is now under siege...
HTTP/1.1 200     0.02 secs:      21 bytes ==> GET  /rate-limit
HTTP/1.1 200     0.02 secs:      21 bytes ==> GET  /rate-limit
HTTP/1.1 200     0.03 secs:      21 bytes ==> GET  /rate-limit
HTTP/1.1 200     0.03 secs:      21 bytes ==> GET  /rate-limit
HTTP/1.1 200     0.03 secs:      21 bytes ==> GET  /rate-limit
HTTP/1.1 200     0.03 secs:      21 bytes ==> GET  /rate-limit
HTTP/1.1 200     0.03 secs:      21 bytes ==> GET  /rate-limit
HTTP/1.1 200     0.03 secs:      21 bytes ==> GET  /rate-limit
HTTP/1.1 503     0.03 secs:     194 bytes ==> GET  /rate-limit
HTTP/1.1 200     0.03 secs:      21 bytes ==> GET  /rate-limit
HTTP/1.1 200     0.03 secs:      21 bytes ==> GET  /rate-limit
HTTP/1.1 503     0.03 secs:     194 bytes ==> GET  /rate-limit
HTTP/1.1 503     0.03 secs:     194 bytes ==> GET  /rate-limit
HTTP/1.1 200     0.03 secs:      21 bytes ==> GET  /rate-limit
HTTP/1.1 503     0.03 secs:     194 bytes ==> GET  /rate-limit

Transactions:		               11 hits
Availability:		            73.33 %
Elapsed time:		            0.03 secs
Data transferred:	            0.00 MB
Response time:		            0.04 secs
Transaction rate:	          366.67 trans/sec
Throughput:		                0.03 MB/sec
Concurrency:		           14.33
Successful transactions:          11
Failed transactions:	           4
Longest transaction:	        0.03
Shortest transaction:	        0.02
```

A `HTTP/1.1 503 Service Unavailable` is the standard response to passing a threshold and can also be observed via the server's logs as:

```
172.17.0.1 - - [25/Oct/2021:23:58:22 +0000] "GET /rate-limit HTTP/1.1" 200 21 "-" "Mozilla/5.0 (apple-x86_64-darwin20.4.0) Siege/4.1.1"
2021/10/25 23:58:22 [error] 8#8: *71 limiting requests, excess: 10.950 by zone "chamber", client: 172.17.0.1, server: _, request: "GET /rate-limit HTTP/1.1", host: "localhost:8000"
172.17.0.1 - - [25/Oct/2021:23:58:22 +0000] "GET /rate-limit HTTP/1.1" 503 194 "-" "Mozilla/5.0 (apple-x86_64-darwin20.4.0) Siege/4.1.1"
2021/10/25 23:58:22 [error] 8#8: *74 limiting requests, excess: 10.950 by zone "chamber", client: 172.17.0.1, server: _, request: "GET /rate-limit HTTP/1.1", host: "localhost:8000"
172.17.0.1 - - [25/Oct/2021:23:58:22 +0000] "GET /rate-limit HTTP/1.1" 503 194 "-" "Mozilla/5.0 (apple-x86_64-darwin20.4.0) Siege/4.1.1"
```