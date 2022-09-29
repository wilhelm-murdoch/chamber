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
      - [Landing Page](#landing-page)
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
  - [Building & Contributing](#building--contributing)
  - [Acknowledgements](#acknowledgements)
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

#### Landing Page

Request:
```bash
```
Response:

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

Below is the list of endpoints and the number of times `echo` appears in the response body:

```
Endpoint          "echo" count
--------          -----------
size/smallest     150
size/small        1,500
size/medium       15,000
size/large        150,000
size/larger       1,500,000
size/largest      15,000,000
```
For example:
```bash
$ curl -i localhost:8000/size/smallest
HTTP/1.1 200 OK
Date: Thu, 29 Sep 2022 03:28:12 GMT
Content-Type: text/html
Connection: close

echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo echo
```
### Streaming

## Building & Contributing

## Acknowledgements

This couldn't be possible without the following projects:

 - [jq](https://stedolan.github.io/jq/)
 - [Bashly](https://bashly.dannyb.co/)
 - [readme.so](https://readme.so/)

## License

[Unlicense](https://choosealicense.com/licenses/unlicense/)