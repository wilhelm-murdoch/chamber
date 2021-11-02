---
order: 100
icon: code
label: /latency/degrading
---

## Demonstration

Demonstrates how response times can increase while a target service is under load. The more active connections, the slower the overall response.

+++ Command
```bash # Respond with JSON:
curl -s http://localhost:8000/latency/degrading | jq -r '.'
```
```bash # Respond with headers:
curl -I http://localhost:8000/latency/degrading
```
+++ Headers
``` #
HTTP/1.1 200 OK
Date: Tue, 02 Nov 2021 13:46:10 GMT
Content-Type: application/json
Connection: keep-alive
```
+++ JSON
```json # The duration of the request.
{
  "elapsed": 1.101
}
```
+++ 

## Simulating Load

Simulating high traffic can be difficult to do manually. Luckily, there are plenty of tools out there to assist. `siege` is one of the more popular options. Installation instructions are a bit out of scope for this document, but there is broad support for it on most operating systems. You can read more about it [here](https://github.com/JoeDog/siege).

Once installed, you should be able to perform the following simulation.

+++ Command
```bash # Run this test once for 150 concurrent users.
siege -c 150 -r 1 --no-parser http://localhost:8000/latency/degrading
```
+++ Response
```bash # The final siege report.
** SIEGE 4.1.1
** Preparing 150 concurrent users for battle.
The server is now under siege...
HTTP/1.1 200     1.31 secs:      22 bytes ==> GET  /latency/degrading
HTTP/1.1 200     1.31 secs:      22 bytes ==> GET  /latency/degrading
HTTP/1.1 200     1.42 secs:      22 bytes ==> GET  /latency/degrading
HTTP/1.1 200     1.42 secs:      22 bytes ==> GET  /latency/degrading
HTTP/1.1 200     1.72 secs:      22 bytes ==> GET  /latency/degrading
HTTP/1.1 200     1.82 secs:      22 bytes ==> GET  /latency/degrading
HTTP/1.1 200     1.82 secs:      22 bytes ==> GET  /latency/degrading
HTTP/1.1 200     2.12 secs:      22 bytes ==> GET  /latency/degrading
HTTP/1.1 200     2.12 secs:      22 bytes ==> GET  /latency/degrading
HTTP/1.1 200     2.12 secs:      22 bytes ==> GET  /latency/degrading
HTTP/1.1 200     2.23 secs:      22 bytes ==> GET  /latency/degrading
HTTP/1.1 200     2.23 secs:      22 bytes ==> GET  /latency/degrading
... heaps more requests ...
HTTP/1.1 200    16.16 secs:      23 bytes ==> GET  /latency/degrading
HTTP/1.1 200    16.16 secs:      23 bytes ==> GET  /latency/degrading
HTTP/1.1 200    16.16 secs:      23 bytes ==> GET  /latency/degrading

Transactions:		             150 hits
Availability:		          100.00 %
Elapsed time:		           16.16 secs
Data transferred:	            0.00 MB
Response time:		           11.29 secs
Transaction rate:	            9.28 trans/sec
Throughput:		                0.00 MB/sec
Concurrency:		          104.76
Successful transactions:         150
Failed transactions:	           0
Longest transaction:	       16.16
Shortest transaction:	        1.31
```
+++ 

## Nginx Directive

This is the directive responsible for this endpoint's behaviour. You can read the entirety of the configuration [here](https://github.com/wilhelm-murdoch/chamber/blob/main/config/openresty/conf.d/chamber.conf).

:::code source="../../config/openresty/conf.d/chamber.conf" title="config/openresty/conf.d/chamber.conf" region="/latency/degrading" :::