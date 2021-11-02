---
order: 100
icon: code
label: /echo
---
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