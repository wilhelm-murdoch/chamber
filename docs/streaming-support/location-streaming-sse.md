---
order: 100
icon: code
label: /streaming/sse
---

## Demonstration

Exposes an endpoint for testing clients used for [server-sent events](https://developer.mozilla.org/en-US/docs/Web/API/Server-sent_events). You can open this endpoint directly in your browser to observe a live stream of events, or use curl from the command line. A resulting stream of events will appear at random intervals.

+++ Command
```bash # Use the -N flag to disable buffering:
curl -N http://localhost:8000/streaming/sse
```
```bash # Respond with headers:
curl -IN http://localhost:8000/latency/slow
```
+++ Headers
``` #
HTTP/1.1 200 OK
Date: Wed, 03 Nov 2021 02:06:35 GMT
Cache-Control: no-cache
Connection: keep-alive
Content-Type: text/event-stream
Access-Control-Allow-Origin: *
```
+++ Response
```bash # A list of events:
id: 5500f7b77d1c4216e2f2dd157e46ff01
event: random
data: {"message": "eUMWD65R8QIfrtvbvhYABSYY3jg07VtZENlryyzR0qK9eQ4", "elapsed": 0.000000}


id: 2fdf54658b56557f25ac5753825a0c9a
event: random
data: {"message": "YI7Gh58NjZ9G8tsT8Bdt9nU6TwMScffUCnt", "elapsed": 4.003000}


id: 02bafca1deb344e4e88bc28f4f9803b7
event: random
data: {"message": "ezD0t2QY8k", "elapsed": 8.005000}
```
+++ 

## Event Attributes

Event entries contain the following values:

| Attribute | Description                                                                                                              |
| ---     | ---                                                                                                                        |
| `id`    | A unique identifier per event sourced from `ngx.var.request_id`.                                                           |
| `event` | A default event type of `random`.                                                                                          |
| `data`  | A simple JSON object containing `.message` data as well as the current `.elapsed` time since the beginning of the request. |

### Customising Output

You may change the values of the following attributes by passing them as URL parameters.

| Parameter | Description                                                                                  |
| ---       | ---                                                                                          |
| `event`   | Pass a custom event name as a string. `default: random`                                      |
| `data`    | Pass a custom event body as a string. `default: A random string between 10 and 50 in length` |

+++ Command
```bash # Passing custom data and event:
curl -N http://localhost:8000/streaming/sse?event=greeting&data=hello
```
+++ Response
```bash # A list of custom events:
id: 29b9c920f621a7ca2175e324570dbe3f
event: greeting
data: {"message": "hello", "elapsed": 0.000000}


id: 9398cec74552df5473d538eade307339
event: greeting
data: {"message": "hello", "elapsed": 4.004000}
```
+++ 

## Nginx Directive

This is the directive responsible for this endpoint's behaviour. You can read the entirety of the configuration [here](https://github.com/wilhelm-murdoch/chamber/blob/main/config/openresty/conf.d/chamber.conf).

:::code source="../../config/openresty/conf.d/chamber.conf" title="config/openresty/conf.d/chamber.conf" region="/streaming/sse" :::