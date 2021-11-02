---
order: 100
icon: code
label: /auth
---
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