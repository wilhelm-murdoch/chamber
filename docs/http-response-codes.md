---
order: 800
icon: browser
label: HTTP Response Codes
---
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
