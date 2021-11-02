---
order: 100
icon: code
label: /rate-limit
---

## Demonstration

Demonstrates using an endpoint dedicated to isolated rate limit testing. You can observe the configurations as follows.

:::code source="../../config/openresty/conf.d/chamber.conf" title="Define the zone 'chamber' for our requests." region="zone" :::

:::code source="../../config/openresty/conf.d/chamber.conf" title="Configure location to route requests through the zone." region="/rate-limit" :::

You can read this as rate limiting up to 160k unique IP addresses to 5 requests per second, burstable up to 10.

## Simulating Rate Limiting

Simulating high traffic to trigger rate limiting rules can be difficult to do manually. Luckily, there are plenty of tools out there to assist. `siege` is one of the more popular options. Installation instructions are a bit out of scope for this document, but there is broad support for it on most operating systems. You can read more about it [here](https://github.com/JoeDog/siege).

Once installed, you should be able to perform the following simulation.

+++ Command
```bash # Simulate 15 concurrent user requests.
siege -c 15 -r 1 --no-parser http://localhost:8000/rate-limit
```
+++ Results
```bash # The final siege report.
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
+++ 

You may have noticed a few `503` responses in the `siege` results. These would correspond to the following server logs.

```bash # Logs sent to stdout from the server.
172.17.0.1 - - [25/Oct/2021:23:58:22 +0000] "GET /rate-limit HTTP/1.1" 200 21 "-" "Mozilla/5.0 (apple-x86_64-darwin20.4.0) Siege/4.1.1"
2021/10/25 23:58:22 [error] 8#8: *71 limiting requests, excess: 10.950 by zone "chamber", client: 172.17.0.1, server: _, request: "GET /rate-limit HTTP/1.1", host: "localhost:8000"
172.17.0.1 - - [25/Oct/2021:23:58:22 +0000] "GET /rate-limit HTTP/1.1" 503 194 "-" "Mozilla/5.0 (apple-x86_64-darwin20.4.0) Siege/4.1.1"
2021/10/25 23:58:22 [error] 8#8: *74 limiting requests, excess: 10.950 by zone "chamber", client: 172.17.0.1, server: _, request: "GET /rate-limit HTTP/1.1", host: "localhost:8000"
172.17.0.1 - - [25/Oct/2021:23:58:22 +0000] "GET /rate-limit HTTP/1.1" 503 194 "-" "Mozilla/5.0 (apple-x86_64-darwin20.4.0) Siege/4.1.1"
```

## Nginx Directive

This is the directive responsible for this endpoint's behaviour. You can read the entirety of the configuration [here](https://github.com/wilhelm-murdoch/chamber/blob/main/config/openresty/conf.d/chamber.conf).

:::code source="../../config/openresty/conf.d/chamber.conf" title="config/openresty/conf.d/chamber.conf" region="/latency/degrading" :::