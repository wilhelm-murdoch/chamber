<img src="chamber.gif" alt="drawing" style="width: 100%;" />

[![Docker](https://github.com/wilhelm-murdoch/chamber/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/wilhelm-murdoch/chamber/actions/workflows/docker-publish.yml)

Another echo server written using [OpenResty](https://openresty.org/)!

## Contents

- [Contents](#contents)
- [Installation](#installation)
- [Usage](#usage)
  - [General Endpoints](#general-endpoints)
    - [`location /`](#location-)
    - [`location /up`](#location-up)
    - [`location /status`](#location-status)
    - [`location /now`](#location-now)
    - [`location /hostname`](#location-hostname)
    - [`location /docs`](#location-docs)
    - [`location /auth`](#location-auth)
    - [`location /rate-limit`](#location-rate-limit)
  - [HTTP Response Codes](#http-response-codes)
  - [Debugging Requests](#debugging-requests)
    - [`location /echo`](#location-echo)
    - [`location /headers`](#location-headers)
    - [`location /params/post`](#location-paramspost)
    - [`location /params/get`](#location-paramsget)
  - [Latency](#latency)
    - [`location /latency/degrading`](#location-latencydegrading)
    - [`location /latency/erratic`](#location-latencyerratic)
  - [Response Size](#response-size)
- [Building & Contributing](#building--contributing)
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

Active connections: 1
server accepts handled requests
 13 13 13
Reading: 0 Writing: 1 Waiting: 0
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

### Debugging Requests

#### `location /echo`

Any content added to the `?body=` parameter will be also be the body of the response:

```bash
$ curl -i http://localhost:8000/echo?body=Abandon%20all%20hope%2C%20ye%20who%20enter.
HTTP/1.1 200 OK
Date: Mon, 25 Oct 2021 14:56:43 GMT
Content-Type: text/html
Connection: close

Abandon all hope, ye who enter here.
```

#### `location /headers`

Returns a list of objects containing key + value pairs representing all accepted request headers:

```bash
$ curl -i http://localhost:8000/headers
HTTP/1.1 200 OK
Date: Mon, 25 Oct 2021 15:01:29 GMT
Content-Type: application/json
Connection: close

[
    {
        "key": "ACCEPT-LANGUAGE",
        "value": "en-AU,en-GB;q=0.9,en-US;q=0.8,en;q=0.7"
    },
    {
        "key": "HOST",
        "value": "localhost:8000"
    },
    {
        "key": "CACHE-CONTROL",
        "value": "max-age=0"
    },
    {
        "key": "CONNECTION",
        "value": "keep-alive"
    },
    {
        "key": "ACCEPT-ENCODING",
        "value": "gzip, deflate, br"
    }
]
```

#### `location /params/post`

Accepts only `POST` requests and will respond with a JSON object representing the parsed request body:

```bash
$ curl -s -X POST http://localhost:8000/params/post --data "foo=derp&bar=merp&baz=fizz&baz=buzz" | jq -r
[
  {
    "key": "foo",
    "value": "derp"
  },
  {
    "key": "baz",
    "value": [
      "fizz",
      "buzz"
    ]
  },
  {
    "key": "bar",
    "value": "merp"
  }
]
```

Multiple values assigned to the same key will be represented as a list of values.

#### `location /params/get`

Responds with a JSON object representing the specified URI parameters:

```bash
$ curl -s "http://localhost:8000/params/get?foo=derp&bar=merp&baz=fizz&baz=buzz" | jq -r
[
  {
    "key": "foo",
    "value": "derp"
  },
  {
    "key": "baz",
    "value": [
      "fizz",
      "buzz"
    ]
  },
  {
    "key": "bar",
    "value": "merp"
  }
]
```

Multiple values assigned to the same key will be represented as a list of values.

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
