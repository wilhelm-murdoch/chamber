---
order: 1000
icon: rocket
label: Getting Started
---

!!!warning Another quick FYI!
All example code on this documentation site assume your server is running locally, accessible as `localhost` and running on port `8000`. Just keep this in mind if you need to change the default settings. Have fun! :icon-heart-fill:
!!!

## Requirements

The only hard requirement to run this project is [Docker](https://docker.com). Ensure your host has this properly installed before proceding.
   
### Optional

The following are by no means required, but can assist in learning more about how chamber works.

2. [`jq`](https://stedolan.github.io/jq/) is used to easily parse and query JSON blobs.
3. [`curl`](https://curl.se/) is used to interact with chamber directly from the command line.
4. [`siege`](https://github.com/JoeDog/siege) is used to simulate high traffic events locally against chamber.
5. [`websocat`](https://github.com/vi/websocat) is used to interact with chamber's websocket server.
6. If you're a maintainer, you will need a personal development token to interact with Github Actions and Packages. You can generate one [here](https://github.com/settings/tokens) with the `write:packages` scope.

## Starting the Server

```bash #
docker run       \
  -it            \
  --rm           \
  --name chamber \
  -p 8000:8000   \
  ghcr.io/wilhelm-murdoch/chamber:latest
```

## Testing the Connection

+++ Command
```bash # Respond with text:
curl http://localhost:8000/up
```
```bash # Respond with headers:
curl -I http://localhost:8000/up
```
+++ Headers
``` #
HTTP/1.1 200 OK
Date: Mon, 25 Oct 2021 14:50:45 GMT
Content-Type: text/html
Content-Length: 26
Last-Modified: Mon, 25 Oct 2021 13:43:19 GMT
Connection: keep-alive
ETag: "6176b477-1a"
Accept-Ranges: bytes
```
+++ Response
```text # The current release of the service.
chamber release: a5fecbfa
```
+++ 

You should also be able to open a browser and point it to [http://localhost:8000](http://localhost:8000) to hit the landing page.