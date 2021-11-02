---
order: 100
icon: code
label: /latency/degrading
---
Response times will increase with the overall active connection count. This can be tested with the following `siege` command:

```bash
$ siege -c 150 -r 1 --no-parser http://localhost:8000/latency/degrading
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