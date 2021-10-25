<img src="chamber.gif" alt="drawing" style="width: 100%;" />

[![Docker](https://github.com/wilhelm-murdoch/chamber/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/wilhelm-murdoch/chamber/actions/workflows/docker-publish.yml)

Another echo server, but exclusively-using [OpenResty](https://openresty.org/) with built-in Lua support!

## Installation

Currently, this project can only be started using [Docker](). Ensure your local daemon is running and execute the following command in your terminal:

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

Returns a JSON response containing a Unix timestamp:

```bash
$ curl -i http://localhost:8000/now
HTTP/1.1 200 OK
Date: Mon, 25 Oct 2021 15:02:45 GMT
Content-Type: application/json
Connection: close

{"now": "1635174165.878"}
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

These will be picked up just before starting OpenResty and will be temporarily stored in `/etc/nginx/.htpasswd`.

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

#### `location /params/get`

### Testing Latency

The following endpoints are used for testing long-running requests:

1. `location /latency/slow`: 5-second delay
2. `location /latency/slower`: 10-second delay
3. `location /latency/slowest`: 20-second delay

These endpoints will return the following type of response:

```bash
$ curl -i http://localhost:8000/slow
HTTP/1.1 200 OK
Date: Mon, 25 Oct 2021 14:47:20 GMT
Content-Type: application/json
Connection: close

{"elapsed": "4.975"}
```

### Testing Download Size

The following endpoints are used for testing response bodies of various sizes:

1. `location /body/smallest`: `echo` repeated `150` times.
2. `location /body/small`: `echo` repeated `1,500` times.
3. `location /body/medium`: `echo` repeated `15,000` times.
4. `location /body/large`: `echo` repeated `150,000` times.
5. `location /body/larger`: `echo` repeated `1,500,000` times.
6. `location /body/largest`: `echo` repeated `15,000,000` times.

These endpoints will return the following type of response:

```bash
$  curl -i http://localhost:8000/body/smallest
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
