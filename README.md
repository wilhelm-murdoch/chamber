# Chamber
[![Docker](https://github.com/wilhelm-murdoch/chamber/actions/workflows/docker.yml/badge.svg)](https://github.com/wilhelm-murdoch/chamber/actions/workflows/docker.yml)

- [Chamber](#chamber)
  - [Why?](#why)
  - [Requirements](#requirements)
    - [Recommended](#recommended)
  - [Getting Started](#getting-started)
    - [Helm](#helm)
  - [Endpoints](#endpoints)
    - [General](#general)
      - [Apex / Root](#apex--root)
      - [Basic Auth](#basic-auth)
      - [Documentation](#documentation)
      - [Echo](#echo)
      - [Hello World!](#hello-world)
      - [Hostname](#hostname)
      - [Now](#now)
      - [Rate Limiting](#rate-limiting)
      - [Status](#status)
      - [Up](#up)
    - [HTTP Status Codes](#http-status-codes)
      - [`1xx` Codes](#1xx-codes)
      - [`2xx` Codes](#2xx-codes)
      - [`3xx` Codes](#3xx-codes)
      - [`4xx` Codes](#4xx-codes)
      - [`5xx` Codes](#5xx-codes)
      - [AWS Codes](#aws-codes)
      - [Cloudflare Codes](#cloudflare-codes)
      - [IIS Codes](#iis-codes)
      - [Nginx Codes](#nginx-codes)
      - [Unofficial Codes](#unofficial-codes)
    - [Latency](#latency)
      - [Degrading Performance](#degrading-performance)
      - [Erratic Response Times](#erratic-response-times)
      - [Slow, Slower & Slowest](#slow-slower--slowest)
    - [Response Sizes](#response-sizes)
    - [Streaming](#streaming)
      - [Server-Sent Events (SSE)](#server-sent-events-sse)
      - [Web Sockets](#web-sockets)
  - [License](#license)

Chamber is a fully-featured echo server that can be used for end-to-end testing of proxies and web-based clients. All components have been written using a vanilla implementation of the [OpenResty](https://openresty.org/en/) web platform. While most of the endpoints are written using vanilla Nginx directives, some of the more advanced functionality is written using inline-Lua code. This is the primary reason behind choosing OpenResty for this project.

## Why?

In it's most basic form, an echo server is one that just spits back whatever a client sends it. In other words, it "echoes" a request back to the sender. Chamber does just that — specifically with the `/echo` endpoint — and heaps more.

That being said:

1. Are you writing an SDK for a 3rd-party service and want to test how it responds to various HTTP error codes?
2. Are you building out a test suite that requires various stubbed requests?
3. Are you testing proxy connections?
4. Are you learning how to simulate load and want a throw-away service to test against locally?
5. Are you learning how to interact with websockets and server-sent events?
6. Are you troubleshooting slow endpoints in a project and need a test target that provides consistently-slow responses?

This tool may be of value to you if you've answered "Yes." to any of these questions.

## Requirements

The only requirement to run Chamber in both local and remote environments is [Docker](https://docker.com) or [Podman](https://podman.io/). You can attempt to run it outside of a container, but OS support for some of the directives used here isn't universal. You're on your own if you wish to roll any other way.

### Recommended

Optionally, use some of the following tools to play around with chamber:

1. [`jq`](https://stedolan.github.io/jq/) is used to easily parse and query JSON blobs.
2. [`curl`](https://curl.se/) is used to interact with chamber directly from the command line.
3. [`siege`](https://github.com/JoeDog/siege) is used to simulate high traffic events locally against chamber.
4. [`websocat`](https://github.com/vi/websocat) is used to interact with chamber's websocket server.

## Getting Started

Chamber is meant to run in a containerised environment, so all you need to do to run locally is:

```bash
$ docker run -it --rm -p 8000:8000 --name chamber ghcr.io/wilhelm-murdoch/chamber:latest
$ curl localhost:8000/up
cd12aa0e
```

### Helm
Helm support is coming soon!

## Endpoints
What follows is a list of supported endpoints and how to interact with them.

### General
These are various general-purpose endpoints that cover a wide range of uses.

#### Apex / Root
This is simply the default landing page of the service.

#### Basic Auth
Demonstrates an endpoint which supports [basic authentication](https://developer.mozilla.org/en-US/docs/Web/HTTP/Authentication). The default username and password are both `chamber` and a succesful attempt will display the landing page.

An authorised request:
```bash
$ curl -I -u chamber:chamber http://localhost:8000/auth
HTTP/1.1 200 OK
Date: Thu, 29 Sep 2022 04:04:44 GMT
Content-Type: text/html
Connection: keep-alive
```

An unauthorised request:
```bash
$ curl -I -u herp:derp http://localhost:8000/auth
HTTP/1.1 401 Unauthorized
Date: Thu, 29 Sep 2022 04:05:18 GMT
Content-Type: text/html
Content-Length: 176
Connection: keep-alive
WWW-Authenticate: Basic realm="Enter the Chamber"
```
#### Documentation
This endpoint will redirect you straight to the project's README file ( this one ).
```bash
$ curl -LI http://localhost:8000/docs
HTTP/1.1 301 Moved Permanently
Date: Thu, 29 Sep 2022 04:06:31 GMT
Content-Type: text/html
Content-Length: 166
Connection: keep-alive
Location: https://github.com/wilhelm-murdoch/chamber/blob/main/README.md
```
#### Echo
Arguably the most important feature of an echo server is to actually support _echoing_ with the most common types of requests; `GET`, `POST` and the rest. Responds with a JSON object containing the requests `.headers`, `.params.get`, `params.post` and raw `.body` values.

```bash
$ curl -s --data "email=me@mysite.com&password=***" http://localhost:8000/echo?param=foo&param=bar&merp&flakes=meep | jq -r '.'

{
  "headers": [
    {
      "key": "ACCEPT",
      "value": "*/*"
    },
    {
      "key": "CONTENT-LENGTH",
      "value": "32"
    },
    {
      "key": "HOST",
      "value": "localhost:8000"
    },
    {
      "key": "USER-AGENT",
      "value": "curl/7.64.1"
    },
    {
      "key": "CONTENT-TYPE",
      "value": "application/x-www-form-urlencoded"
    }
  ],
  "params": {
    "get": [
      {
        "key": "merp",
        "value": "true"
      },
      {
        "key": "param",
        "value": [
          "foo",
          "bar"
        ]
      },
      {
        "key": "flakes",
        "value": "meep"
      }
    ],
    "post": [
      {
        "key": "email",
        "value": "me@mysite.com"
      },
      {
        "key": "password",
        "value": "***"
      }
    ]
  },
  "body": "email=me@mysite.com&password=***"
}
```
#### Hello World!
Returns a text response for "Hello, world!" in all languages supported by Google Translate.
```bash
$ for i in {1..15}; do curl http://localhost:8000/hello-world; done
ہیلو دنیا!
Tere, Maailm!
你好，世界！
Salute, mondu !
ሰላም ልዑል!
Dia duit, a shaoghail!
Hello, mundo!
Ciao mondo!
Salam, dünya!
Hallo Wereld!
Lefatše Lumela!
Mo ki O Ile Aiye!
Përshendetje Botë!
Helló Világ!
Hàlo a Shaoghail!
```
#### Hostname
Returns a JSON response containing the server's hostname.
```bash
$ curl -s http://localhost:8000/hostname | jq -r '.'
{
  "hostname": "localhost"
}
```
#### Now
Returns a JSON response containing the server's current time.
```bash
$ curl -s http://localhost:8000/now | jq -r '.'
{
  "now": 1635174165.878
}
```
#### Rate Limiting
Demonstrates using an endpoint dedicated to isolated rate limit testing. 

Simulating high traffic to trigger rate limiting rules can be difficult to do manually. Luckily, there are plenty of tools out there to assist. `siege` is one of the more popular options. Installation instructions are a bit out of scope for this document, but there is broad support for it on most operating systems. You can read more about it [here](https://github.com/JoeDog/siege).

Once installed, you should be able to perform the following simulation.
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
You will noticed a few `503` responses in the `siege` results. These would correspond to the following server logs.

```bash # Logs sent to stdout from the server.
172.17.0.1 - - [25/Oct/2021:23:58:22 +0000] "GET /rate-limit HTTP/1.1" 200 21 "-" "Mozilla/5.0 (apple-x86_64-darwin20.4.0) Siege/4.1.1"
2021/10/25 23:58:22 [error] 8#8: *71 limiting requests, excess: 10.950 by zone "chamber", client: 172.17.0.1, server: _, request: "GET /rate-limit HTTP/1.1", host: "localhost:8000"
172.17.0.1 - - [25/Oct/2021:23:58:22 +0000] "GET /rate-limit HTTP/1.1" 503 194 "-" "Mozilla/5.0 (apple-x86_64-darwin20.4.0) Siege/4.1.1"
2021/10/25 23:58:22 [error] 8#8: *74 limiting requests, excess: 10.950 by zone "chamber", client: 172.17.0.1, server: _, request: "GET /rate-limit HTTP/1.1", host: "localhost:8000"
172.17.0.1 - - [25/Oct/2021:23:58:22 +0000] "GET /rate-limit HTTP/1.1" 503 194 "-" "Mozilla/5.0 (apple-x86_64-darwin20.4.0) Siege/4.1.1"
```
#### Status
Returns a live counting of various running server statistics.
```bash
$ curl -s http://localhost:8000/status | jq -r '.'
{
  "connection": 55,
  "connection_requests": 1,
  "connections_active": 4,
  "connections_reading": 0,
  "connections_writing": 4,
  "connections_waiting": 0
}
```
#### Up
This is an endpoint suitable for health checks. It will return a `200 OK` response as well as the currently-running release of the server.
```bash
$ curl http://localhost:8000/up
cd12aa0e
```
The release should correspond to the first 8 characters of the commit SHA associated with the merge into the `main` branch.

### HTTP Status Codes
Included is support for all HTTP status codes as covered by this [Wikipedia](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes) page. There are a handful of duplicate codes that are not included in favour of more popular ones.

The following JSON object represents a standard response - in this case `404 Not Found` - for all requests hitting this series of endpoints:
```json
{
  "code": 404, 
  "message": "Not Found", 
  "description": "The requested page could not be found but may be available again in the future."
}
```

You can test any of these endpoints using the `/code/XXX` pattern where `XXX` is the desired code to test. For example:
```bash
$ curl -I localhost:8000/code/404
HTTP/1.1 404 Not Found
Date: Thu, 29 Sep 2022 02:34:23 GMT
Content-Type: application/json
Content-Length: 135
Connection: keep-alive
```
#### `1xx` Codes
Demonstrates server responses from the `HTTP/1.1 1xx` series of codes. 
> An informational response indicates that the request was received and understood. It is issued on a provisional basis while request processing continues. It alerts the client to wait for a final response. The message consists only of the status line and optional header fields, and is terminated by an empty line.  

Supports: `100-103`
#### `2xx` Codes
Demonstrates server responses from the `HTTP/1.1 2xx` series of codes.
> This class of status codes indicates the action requested by the client was received, understood, and accepted.

Supports: `200-208` & `226`
#### `3xx` Codes
Demonstrates server responses from the `HTTP/1.1 3xx` series of codes.
> This class of status code indicates the client must take additional action to complete the request. Many of these status codes are used in URL redirection.

Supports: `300-308`
#### `4xx` Codes
Demonstrates server responses from the `HTTP/1.1 4xx` series of codes.
> This class of status code is intended for situations in which the error seems to have been caused by the client. Except when responding to a HEAD request, the server should include an entity containing an explanation of the error situation, and whether it is a temporary or permanent condition. These status codes are applicable to any request method. User agents should display any included entity to the user.

Supports: `400-418`, `421-429`, `431` & `451`
#### `5xx` Codes
Demonstrates server responses from the `HTTP/1.1 5xx` series of codes.
> The server failed to fulfil a request.
> 
> Response status codes beginning with the digit "5" indicate cases in which the server is aware that it has encountered an error or is otherwise incapable of performing the request. Except when responding to a HEAD request, the server should include an entity containing an explanation of the error situation, and indicate whether it is a temporary or permanent condition. Likewise, user agents should display any included entity to the user. These response codes are applicable to any request method.

Supports: `500-508` & `510-511`
#### AWS Codes
> Amazon's Elastic Load Balancing adds a few custom return codes.

Supports: `460`, `463` & `561`
#### Cloudflare Codes
> Cloudflare's reverse proxy service expands the 5xx series of errors space to signal issues with the origin server.

Supports: `520-527` & `530`
#### IIS Codes
> Microsoft's Internet Information Services (IIS) web server expands the 4xx error space to signal errors with the client's request.

Supports: `440`, `449` & `451`
#### Nginx Codes
> The nginx web server software expands the 4xx error space to signal issues with the client's request.

Supports: `444`, `494-497` & `499`
#### Unofficial Codes
> The following codes are not specified by any standard.

Supports: `419-420`, `430`, `450`, `498-499`, `509`, `529-530` & `598-599`
### Latency
Chamber supports testing against various types of latency. You can use `curl` commands to hit these endpoints, but it's recommended to use a simple load generating tool like `siege` to get a better idea of how latency can affect performance.

The following endpoints are located within the `latency/` namespace. 
#### Degrading Performance
Demonstrates how response times can increase while a target service is under load. The more active connections, the slower the overall response.
```bash
$ curl -i http://localhost:8000/latency/degrading
HTTP/1.1 200 OK
Date: Tue, 02 Nov 2021 13:46:10 GMT
Content-Type: application/json
Connection: keep-alive

{
  "elapsed": 1.101
}
```

Simulating high traffic can be difficult to do manually. Luckily, there are plenty of tools out there to assist. `siege` is one of the more popular options. Installation instructions are a bit out of scope for this document, but there is broad support for it on most operating systems. You can read more about it [here](https://github.com/JoeDog/siege).

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
As you can see above, an increase in active requests leads to slower response times.
#### Erratic Response Times
Demonstrates how response times can be in flux while a target service is behaving erratically. This endpoint will respond between 1 and 10 seconds.
```bash
$ curl -i http://localhost:8000/latency/erratic
HTTP/1.1 200 OK
Date: Tue, 02 Nov 2021 13:46:10 GMT
Content-Type: application/json
Connection: keep-alive

{
  "elapsed": 6.141
}
```
#### Slow, Slower & Slowest
Demonstrates a hard-coded response times of `5`, `10` and `20` seconds respectively. This is useful for testing consistently-long-running requests. Use any of the `latency/slow`, `latency/slower` or `latency/slowest` endpoints to simulate slow responses as shown below.
```bash
$ curl -i http://localhost:8000/latency/slowest
HTTP/1.1 200 OK
Date: Tue, 02 Nov 2021 13:46:10 GMT
Content-Type: application/json
Connection: keep-alive

{
  "elapsed": 20.001
}
```

### Response Sizes
Endpoints within the `size/` namespace are used to demonstrate how HTTP response bodies of various size can affect client-side performance. Included in this category are 6 different endpoints with increasingly large response bodies containing the word `echo` repeatedly.

```bash
$ curl -i localhost:8000/size/smallest
HTTP/1.1 200 OK
Date: Thu, 29 Sep 2022 03:28:12 GMT
Content-Type: text/html
Connection: close

echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo
```
Below is the list of endpoints and the number of times `echo` appears in the response body:
| Endpoint         | "echo" Count | Estimated Size |
| ---              | ---          | ---            |
| `size/smallest`  | 150          | ~750B          |
| `size/small`     | 1,500        | ~7.5KB         |
| `size/medium`    | 15,000       | ~75KB          |
| `size/large`     | 150,000      | ~750KB         |
| `size/larger`    | 1,500,000    | ~7.5MB         |
| `size/largest`   | 15,000,000   | ~75MB          |
### Streaming
Endpoints within the `streaming/` namespace are used to demonstrate various ways to interact with "streaming" connections.

#### Server-Sent Events (SSE)
Exposes an endpoint for testing clients used for [server-sent events](https://developer.mozilla.org/en-US/docs/Web/API/Server-sent_events). You can open this endpoint directly in your browser to observe a live stream of events, or use curl from the command line. A resulting stream of events will appear at random intervals.

Use the `-N` flag with `curl` to disable buffering of the request:
```bash
$ curl -N http://localhost:8000/streaming/sse
id: a46c9328a2690b870750daf299ed6645
event: random
data: {"message": "wWNvSbwAFVQTygvNmXAkqCK7X2GTbaawJ", "elapsed": 0.000000}


id: 89967b354ed3b945d2d70e403f965a48
event: random
data: {"message": "X2anNIwhnpEZQy46Pt21kHdKpDDpVJRx5b4K8LXRVx0", "elapsed": 1.004000}


id: 28c24b074fe0755f8f021f102a25e9b8
event: random
data: {"message": "GglibY3F2vffFPqTfYRfl6", "elapsed": 3.010000}
```
If you wish to see the header block:
```bash
$ curl -I http://localhost:8000/streaming/sse
HTTP/1.1 200 OK
Date: Thu, 29 Sep 2022 03:43:19 GMT
Content-Type: application/octet-stream
Connection: keep-alive
Cache-Control: no-cache
Connection: keep-alive
Content-Type: text/event-stream
Access-Control-Allow-Origin: *
```
#### Web Sockets
Exposes a websocket server endpoint used for echoing back data for testing. This can be used for end-to-end testing of new clients. Hitting this endpoint will yield a stream of events spaced `1` second apart. When it comes to testing websockets within a terminal, I prefer to use [`websocat`](https://github.com/vi/websocat) to echo back messages.

To demonstrate the WS server waiting for a connection:
```bash
$ websocat ws://localhost:8000/streaming/ws
{"type": "info", "id": "206ddc2f424421ffc0515cdf0a29e574", "time": 1664423546.107}
{"type": "info", "id": "e94104cd549afed3c5477fcac933ea95", "time": 1664423551.11}
{"type": "info", "id": "fec85e20e6b72f5945090cd56d252f2f", "time": 1664423556.112}
```
To demonstrate the server echoing back a message:
```bash
$ echo 'Hello, world!' | websocat ws://localhost:8000/streaming/ws
{"type": "info", "id": "8e0aaa12841cd8b18ce654981e0bedae", "time": 1664423517.169}
{"type": "message", "Hello, world! "}
{"type": "info", "id": "8df5849fb7a8af5198e98257c74086e4", "time": 1664423517.169}
```

Event entries contain the following values:
| Attribute | Description                                                                          |
| ---     | ---                                                                                    |
| `type`  | The type of event being returned. `default: info`                                      |
| `id`    | A unique identifier representing the current request id. `default: ngx.var.request_id` |
| `time`  | A timestamp representing the server's current time. `default: ngx.now()`               |

## License

[Unlicense](https://choosealicense.com/licenses/unlicense/)