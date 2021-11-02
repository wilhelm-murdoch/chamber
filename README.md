<img src="chamber.gif" alt="drawing" style="width: 100%;" />

[![Docker](https://github.com/wilhelm-murdoch/chamber/actions/workflows/docker.yml/badge.svg)](https://github.com/wilhelm-murdoch/chamber/actions/workflows/docker.yml) [![Retype](https://github.com/wilhelm-murdoch/chamber/actions/workflows/retype.yml/badge.svg)](https://github.com/wilhelm-murdoch/chamber/actions/workflows/retype.yml)

An [OpenResty](https://openresty.org/)-based echo server for proxy and HTTP client testing.

## Contents

- [Contents](#contents)
- [Installation](#installation)
- [Usage](#usage)
  - [General Endpoints](#general-endpoints)
    - [`location /`](#location-)
    - [`location /echo`](#location-echo)
    - [`location /up`](#location-up)
    - [`location /status`](#location-status)
    - [`location /now`](#location-now)
    - [`location /hostname`](#location-hostname)
    - [`location /docs`](#location-docs)
    - [`location /auth`](#location-auth)
    - [`location /hello-world`](#location-hello-world)
    - [`location /rate-limit`](#location-rate-limit)
  - [HTTP Response Codes](#http-response-codes)
  - [Latency](#latency)
    - [`location /latency/degrading`](#location-latencydegrading)
    - [`location /latency/erratic`](#location-latencyerratic)
  - [Streaming Support](#streaming-support)
    - [`location /streaming/ws`](#location-streamingws)
    - [`location /streaming/sse`](#location-streamingsse)
  - [Response Size](#response-size)
- [Building & Contributing](#building--contributing)
  - [Development Loop](#development-loop)
    - [Run](#run)
    - [Watch](#watch)
    - [Request](#request)
  - [For Maintainers](#for-maintainers)
- [License](#license)

## Installation

Docker is the only hard requirement for this project. With a bit of mucking about, you can get this running without a container. However, only Docker usage is supported at the moment. Ensure your local daemon is running and execute the following command in your terminal:

```bash
$ docker run -it --rm --name chamber -p 8000:8000 ghcr.io/wilhelm-murdoch/chamber:latest
```

Ensure the server is running with:

```bash
$ curl localhost:8000/up
chamber release: a5fecbfa
```

You should now be able to open a browser and point it to http://localhost:8000 to hit the landing page.

## Usage

### General Endpoints

#### `location /`

This is the landing page of the server:

```bash
$ curl -I localhost:8000/
HTTP/1.1 200 OK
Date: Mon, 25 Oct 2021 14:36:50 GMT
Content-Type: text/html
Connection: keep-alive
```

#### `location /echo`

Will return a JSON object containing the following values:

1. Request headers.
2. Any `GET` parameters.
3. Any `POST` parameters.
4. The raw `POST` body, if present.

```bash
$ curl -i http://localhost:8000/echo?param=foo&param=bar&merp&flakes=meep --data "email=me@mysite.com&password=***"
HTTP/1.1 200 OK
Date: Mon, 25 Oct 2021 14:56:43 GMT
Content-Type: text/html
Connection: close

{
  "headers": [
    {
      "key": "USER-AGENT",
      "value": "curl/7.64.1"
    },
    {
      "key": "ACCEPT",
      "value": "*/*"
    },
    {
      "key": "CONTENT-LENGTH",
      "value": "32"
    },
    {
      "key": "CONTENT-TYPE",
      "value": "application/x-www-form-urlencoded"
    },
    {
      "key": "HOST",
      "value": "localhost:8000"
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

For `GET` and `POST` requests, multiple values assigned to the same key will be represented as a list of values.

If you wish to tell the server to echo back a string, you can do something like the following:

```bash
$ curl -s http://localhost:8000/echo --data 'Hello, world!' | jq -r '.body'
Hello, world!
```

#### `location /up`

This is an endpoint suitable for healthchecks. It will return a `200 OK` response as well as the currently-running release of the server:

```bash
$ curl -i http://localhost:8000/up
HTTP/1.1 200 OK
Date: Mon, 25 Oct 2021 14:50:45 GMT
Content-Type: text/html
Content-Length: 26
Last-Modified: Mon, 25 Oct 2021 13:43:19 GMT
Connection: keep-alive
ETag: "6176b477-1a"
Accept-Ranges: bytes

chamber release: a5fecbfa
```

#### `location /status`

Returns a live counting of the following server stats:

```bash
$ curl -i http://localhost:8000/status
HTTP/1.1 200 OK
Date: Mon, 25 Oct 2021 14:52:44 GMT
Content-Type: text/plain
Content-Length: 100
Connection: keep-alive

{
  "connection": 14078,
  "connection_requests": 1,
  "connections_active": 1,
  "connections_reading": 0,
  "connections_writing": 1,
  "connections_waiting": 0
}
```

You can read more about what this information means [here](http://nginx.org/en/docs/http/ngx_http_stub_status_module.html#stub_status).

#### `location /now`

Returns a JSON response containing a current Unix timestamp:

```bash
$ curl -i http://localhost:8000/now
HTTP/1.1 200 OK
Date: Mon, 25 Oct 2021 15:02:45 GMT
Content-Type: application/json
Connection: close

{"now": 1635174165.878}
```

#### `location /hostname`

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

#### `location /docs`

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

#### `location /auth`

A test endpoint for [basic authentication](https://developer.mozilla.org/en-US/docs/Web/HTTP/Authentication). The default username and password are both `chamber`. A succesful attempt will display the landing page.

```bash
$ curl -u chamber:chamber -I http://localhost:8000/auth
HTTP/1.1 200 OK
Date: Mon, 25 Oct 2021 14:37:21 GMT
Content-Type: text/html
Connection: keep-alive
```

An unsuccessful attempt will result in the following response:

```bash
$ curl -u derp:herp -I http://localhost:8000/auth
HTTP/1.1 401 Unauthorized
Date: Mon, 25 Oct 2021 14:36:28 GMT
Content-Type: text/html
Content-Length: 176
Connection: keep-alive
WWW-Authenticate: Basic realm="Enter the Chamber"
```

You can customise the username and password using the following environmental variables:

`CHAMBER_BASIC_AUTH_USER`: The custom username.  
`CHAMBER_BASIC_AUTH_PASSWORD`: The custom password.

Pass them through with the `-e` flag when running the server like so:

```bash
$ docker run -it --rm \
    --name chamber \
    -p 8000:8000 \
    -e CHAMBER_BASIC_AUTH_USER=wilhelm \
    -e CHAMBER_BASIC_AUTH_PASSWORD=mypassword \
    ghcr.io/wilhelm-murdoch/chamber:latest
```

These will be picked up just before starting OpenResty and will be temporarily stored in `/etc/nginx/.htpasswd`. Restarting the container without these variables will restore this file to its default state.

#### `location /hello-world`

Returns a text response for "Hello, world!" in all google-supported languages:
```bash
$ for i in {1..100}; do curl http://localhost:8000/hello-world; done
Ahoj svete!
你好，世界！
Hello, World!
Բարեւ աշխարհ!
Dia duit, a shaoghail!
... heaps of other languages, bro ...
ສະບາຍດີຊາວໂລກ!
```

#### `location /rate-limit`

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

### HTTP Response Codes

All HTTP response codes listed on [this Wikipedia](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes) page are supported. You may cycle through all codes by using the `/code/$http_response_code` URL format. For example, the following endpoints will return the associated response code:

1. `location /code/201` responds with `HTTP/1.1 201 Created`.
2. `location /code/405` response with `HTTP/1.1 405 Method Not Allowed`.
3. `location /code/418` response with `HTTP/1.1 418 I'm a teapot`.

An example of the response headers of a request:

```bash
$ curl -I http://localhost:8000/code/415
HTTP/1.1 451
Date: Mon, 25 Oct 2021 15:24:15 GMT
Content-Type: application/json
Content-Length: 212
Connection: keep-alive
```

You will also be provided with a JSON response similar to the following:

```json
{
  "code": 451,
  "message": "Unavailable For Legal Reasons",
  "description": "A server operator has received a legal demand to deny access to a resource or to a set of resources that includes the requested resource."
}
```

### Latency

The following endpoints are used for testing long-running requests:

1. `location /latency/slow`: 5-second delay
2. `location /latency/slower`: 10-second delay
3. `location /latency/slowest`: 20-second delay

All endpoints in this namespace will return the following JSON response containing elapsed time:

```bash
$ curl http://localhost:8000/slow
{"elapsed": 4.975}
```

#### `location /latency/degrading`

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

#### `location /latency/erratic`

Response times between 1 to 10 seconds will be randomly selected:

```bash
$ curl http://localhost:8000/latency/erratic
{"elapsed": 2.006}
$ curl http://localhost:8000/latency/erratic
{"elapsed": 5.003}
$ curl http://localhost:8000/latency/erratic
{"elapsed": 1.920}
```

### Streaming Support

#### `location /streaming/ws`

Exposes a websocket server endpoint used for echoing back data for testing. This can be used for end-to-end testing of new clients.

Using curl you can recieve a stream of JSON-formatted data until you terminate the connection:

```bash
$ curl \
    --include \
    --no-buffer \
    --header "Connection: Upgrade" \
    --header "Upgrade: websocket" \
    --header "Host: localhost:8000" \
    --header "Origin: http://localhost:8000" \
    --header "Sec-WebSocket-Key: SGVsbG8sIHdvcmxkIQAAAA==" \
    --header "Sec-WebSocket-Version: 13" \
    http://localhost:8000/streaming/ws
HTTP/1.1 101 Switching Protocols
Date: Mon, 01 Nov 2021 07:28:23 GMT
Connection: upgrade
Upgrade: websocket
Sec-WebSocket-Accept: 5Tz1rM6Lpj3X4PQub3+HhJRM11s=

{"type": "info", "id": "034d246aed02e1f20cbfc3d7bcea33d9", "time": 1635751704.823}
{"type": "info", "id": "22d34562bd93f247463791a1e45cec2c", "time": 1635751705.831}
{"type": "info", "id": "24bab0ad4039e931b37ac587e5d8a3b1", "time": 1635751706.838}
{"type": "info", "id": "16fb6c6b47da79648102d1ca7e66587e", "time": 1635751707.844}
{"type": "info", "id": "3b7e4d51a8c5bb48460ffedfc2d07b1d", "time": 1635751708.848}
{"type": "info", "id": "24ec12a9d0ceb8f845ce551726672239", "time": 1635751709.852}
{"type": "info", "id": "11430f7e525d40b2da5aa3e4ff1a1aea", "time": 1635751710.855}
{"type": "info", "id": "ebc30ab1048c6b05f6534e2c21d235c4", "time": 1635751711.862}
```

You can also use [`websocat`](https://github.com/vi/websocat) as a command line websocket client to echo back messages:

```bash
$ echo 'Hello, world!' | websocat ws://localhost:8000/streaming/ws
{"type": "info", "id": "7a1331c5c1416b72116fc29c5c1577e4", "time": 1635751909.352}
{"type": "message", "Hello, world! "}
{"type": "info", "id": "0b587cc77c47399864d9a4dbd0854dbd", "time": 1635751909.352}
```

#### `location /streaming/sse`

Exposes an endpoint for testing clients used for server sent events (SSE). You can open this endpoint directly in your browser to observe a live stream of events. You can also use curl as follows:

```bash
$ curl -N http://localhost:8000/streaming/sse
id: 5500f7b77d1c4216e2f2dd157e46ff01
event: random
data: {"message": "eUMWD65R8QIfrtvbvhYABSYY3jg07VtZENlryyzR0qK9eQ4", "elapsed": 0.000000}


id: 2fdf54658b56557f25ac5753825a0c9a
event: random
data: {"message": "YI7Gh58NjZ9G8tsT8Bdt9nU6TwMScffUCnt", "elapsed": 4.003000}


id: 02bafca1deb344e4e88bc28f4f9803b7
event: random
data: {"message": "ezD0t2QY8k", "elapsed": 8.005000}


id: 5c265d1434939c05f45d02913532c17f
event: random
data: {"message": "PrOxymfu0BRfQpPfpEGMQBMtOo", "elapsed": 10.009000}


id: c8bd592c9d068c5b7acc2eab8aa63756
event: random
data: {"message": "QkB0YIzOqnYxPpKr0UOSAJO", "elapsed": 13.016000}
```

Each event entry returns the following attributes:

1. `id`: A unique identifier per event sourced from `ngx.var.request_id`.
2. `event`: A default event type of `random`. This can be changed by adding the `?event=<string>` parameter to this endpoint.
3. `data`: A simple JSON object containing `.message` data as well as the current `.elapsed` time since the beginning of the request. You can define a custom message by adding the `?message=<string>` parameter to this endpoint.
### Response Size

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

## Building & Contributing

> Contributions are always welcome. Just create a PR and remember to be nice.

Perform the following steps from the root of this repository's local working copy to build and run the server image locally:

```bash
$ git@github.com:wilhelm-murdoch/chamber.git
$ cd chamber/
$ docker build --build-arg GIT_SHA=$(git rev-parse --short=8 HEAD) -t ghcr.io/wilhelm-murdoch/chamber:latest . 
```

`GIT_SHA`: We generate this release identifier with `$(git rev-parse --short=8 HEAD)` and build it into the image itself. This is where we source the content of the `/up` endpoint.

### Development Loop

If I find myself making changes to the `chamber.conf` file, I like to see these changes immediately. Invoking `docker build ...` and `docker run ...` with every incremental change can be tedious. So, I cheat by using the following loop:

#### Run

This project uses vanilla OpenResty, so I run the following command from the root of this repository's working copy:

```bash
$ docker run -it --rm \
  --name openresty \
  -v config/openresty:/etc/nginx/ \
  -p 8000:8000 \
  openresty/openresty:alpine
```

By mounting `config/openresty` to the container's `/etc/nginx` directory, it starts running with `chamber.conf` immediately.

#### Watch

I want OpenResty to reload any time I make changes to `chamber.conf`. Luckily, we can perform a "soft reload" on the OpenResty process from within the container with `openresty -s reload`. I want to execute this command every time I save my changes, so let's use `fswatch` for this:

```bash
$ fswatch -o config/openresty/conf.d/chamber.conf | xargs -n1 -I{} docker exec openresty openresty -s reload
```

I use `fswatch` as I am currently developing on MacOS. It's available on Linux, but you may want to use `inotify` for this instead.

#### Request

If I'm working on a new endpoint, I'll be hitting it with `curl` quite often. Let's automate this as well with `watch`:

```bash
$ watch -n 1 -c 'curl -s localhost:8000/my/new/endpoint'
```

These 3 steps allow me to see my changes almost immediately without leaving my editor.

### For Maintainers

This repository is configured to use Github Workflows for automated building and pushing of releases. However, if you're a maintainer of this project, you can bypass this process with the following steps:

```bash
$ git@github.com:wilhelm-murdoch/chamber.git
$ cd chamber/
$ echo "${GITHUB_TOKEN}" | docker login ghcr.io -u USERNAME --password-stdin
$ docker build --build-arg GIT_SHA=$(git rev-parse --short=8 HEAD) -t ghcr.io/wilhelm-murdoch/chamber:latest . 
$ docker push ghcr.io/wilhelm-murdoch/chamber:latest
```

`GITHUB_TOKEN`: You will need a personal development token. You can generate one [here](https://github.com/settings/tokens) with the `write:packages` scope.

## License

[Unlicense](https://choosealicense.com/licenses/unlicense/)
