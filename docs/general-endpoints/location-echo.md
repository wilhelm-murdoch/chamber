---
order: 100
icon: code
label: /echo
---

## Demonstration

Arguably the most important feature of an echo server is to actually support _echoing_ with the most common types of requests; `GET`, `POST` and the rest. 

+++ Command
```bash # Respond with JSON:
curl -s \
  --data "email=me@mysite.com&password=***"\
  http://localhost:8000/echo?param=foo&param=bar&merp&flakes=meep | jq -r '.'
```
```bash # Respond with headers:
curl -I \
  --data "email=me@mysite.com&password=***" \
  http://localhost:8000/echo?param=foo&param=bar&merp&flakes=meep 
```
+++ Headers
``` #
HTTP/1.1 200 OK
Date: Mon, 25 Oct 2021 14:56:43 GMT
Content-Type: text/html
Connection: close
```
+++ JSON
```json #
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
+++ 

## Response Details

This endpoint will respond to any request with the following data represented as a JSON object:

1. All original request headers.
2. Any `GET` parameters.
3. Any `POST` parameters.
4. The raw `POST` body, if present.

```json # A response will conform to some variation of the following structure:
{
  "headers": [ 
    { "key": "<name>", "value": "<value>" }, // An object for each request header
  ], 
  "params": {
    "get": [ // An object for each get param
      { "key": "<name>", "value": true|false },
      { "key": "<name>", "value": "<value>" },
      { "key": "<name>", "value": [ "<value>", "<value>" ] },
    ],
    "post": [ // An object for each post param
      { "key": "<name>", "value": true|false },
      { "key": "<name>", "value": "<value>" },
      { "key": "<name>", "value": [ "<value>", "<value>" ] },
    ]
  },
  "body": "<value>" // The raw post body if there is one
}
```

### Parameter Variations

The structure of the response body will vary based on the format of your `POST` and `GET` parameters. The following examples will use `GET` parameters, but the same rules apply for `POST` bodies.

+++ Command
Assigning multiple distinct values to the same key.
```bash #
curl -s http://localhost:8000/echo?foo=one&foo=two | jq -r '.params.get'
```
+++ Response
Assigning multiple distinct values to the same key.
```json #
[
  {
    "key": "foo",
    "value": [
      "one",
      "two"
    ]
  }
]
```
+++

+++ Command
Assigning no values to a key will result in a boolean value.
```bash #
curl -s http://localhost:8000/echo?foo&bar | jq -r '.params.get'
```
+++ Response
Assigning no values to a key will result in a boolean value.
```json #
[
  {
    "key": "foo",
    "value": "true"
  },
  {
    "key": "bar",
    "value": "true"
  }
]
```
+++

+++ Command
You can, of course, mix and match parameters.
```bash #
curl -s http://localhost:8000/echo?foo&bar&baz=one&baz=two&merp=flakes | jq -r '.params.get'
```
+++ Response
You can, of course, mix and match parameters.
```json #
[
  {
    "key": "foo",
    "value": "true"
  },
  {
    "key": "bar",
    "value": "true"
  },
  {
    "key": "baz",
    "value": [
      "one",
      "two"
    ]
  },
  {
    "key": "merp",
    "value": "flakes"
  }
]
```
+++

## Nginx Directive

This is the directive responsible for this endpoint's behaviour. You can read the entirety of the configuration [here](https://github.com/wilhelm-murdoch/chamber/blob/main/config/openresty/conf.d/chamber.conf).

:::code source="../../config/openresty/conf.d/chamber.conf" title="config/openresty/conf.d/chamber.conf" region="/echo" :::