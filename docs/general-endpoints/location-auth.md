---
order: 100
icon: code
label: /auth
---

## Demonstration

Demonstrates an endpoint which supports [basic authentication](https://developer.mozilla.org/en-US/docs/Web/HTTP/Authentication). The default username and password are both `chamber` and a succesful attempt will display the landing page.

+++ Command
```bash # Respond with HTML:
curl -u chamber:chamber http://localhost:8000/auth
```
```bash # Respond with headers:
curl -u chamber:chamber -I http://localhost:8000/auth
```
+++ Headers
``` #
HTTP/1.1 200 OK
Date: Mon, 25 Oct 2021 14:37:21 GMT
Content-Type: text/html
Connection: keep-alive
```
+++ HTML
```html # HTML body and css representing the landing page.
<!DOCTYPE html><html lang='en'> ... </html>
```
+++ 

However, an unsuccessful attempt will result in the following response.

+++ Command
```bash # Respond with HTML:
curl -u herp:derp http://localhost:8000/auth
```
```bash # Respond with headers:
curl -u herp:derp -I http://localhost:8000/auth
```
+++ Headers
``` #
HTTP/1.1 401 Unauthorized
Date: Mon, 25 Oct 2021 14:36:28 GMT
Content-Type: text/html
Content-Length: 176
Connection: keep-alive
WWW-Authenticate: Basic realm="Enter the Chamber"
```
+++ HTML
```html # HTML body and css representing the landing page.
<html>
  <head>
    <title>401 Authorization Required</title>
  </head>
  <body>
    <center>
      <h1>401 Authorization Required</h1>
    </center>
    <hr>
    <center>openresty</center>
  </body>
</html>
```
+++ 

## Custom Auth

You can customise the username and password using the following environmental variables:

- `CHAMBER_BASIC_AUTH_USER`: The custom username.  
- `CHAMBER_BASIC_AUTH_PASSWORD`: The custom password.

Pass them through with the `-e` flag when running the server like so:

```bash #
export CHAMBER_BASIC_AUTH_USER=wilhelm
export CHAMBER_BASIC_AUTH_PASSWORD=mypassword
docker run -it --rm               \
  --name chamber                  \
  -p 8000:8000                    \
  -e CHAMBER_BASIC_AUTH_USER      \
  -e CHAMBER_BASIC_AUTH_PASSWORD= \
  ghcr.io/wilhelm-murdoch/chamber:latest
```

These will be picked up just before starting OpenResty and will be temporarily stored in `/etc/nginx/.htpasswd`. Restarting the container without these variables will restore this file to its default state.

## Nginx Directive

This is the directive responsible for this endpoint's behaviour. You can read the entirety of the configuration [here](https://github.com/wilhelm-murdoch/chamber/blob/main/config/openresty/conf.d/chamber.conf).

:::code source="../../config/openresty/conf.d/chamber.conf" title="config/openresty/conf.d/chamber.conf" region="/auth" :::