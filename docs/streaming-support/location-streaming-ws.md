---
order: 100
icon: code
label: /streaming/ws
---

## Demonstration

Exposes a websocket server endpoint used for echoing back data for testing. This can be used for end-to-end testing of new clients. Hitting this endpoint will yield a stream of events spaced `1` second apart.

+++ Command
```bash # Use the -N flag to disable buffering:
curl                                                     \
  --no-buffer                                            \
  --header "Connection: Upgrade"                         \
  --header "Upgrade: websocket"                          \
  --header "Host: localhost:8000"                        \
  --header "Origin: http://localhost:8000"               \
  --header "Sec-WebSocket-Key: SGVsbG8sIHdvcmxkIQAAAA==" \
  --header "Sec-WebSocket-Version: 13"                   \
  http://localhost:8000/streaming/ws
```
```bash # Respond with headers:
curl                                                     \
  -I                                                     \
  --no-buffer                                            \
  --header "Connection: Upgrade"                         \
  --header "Upgrade: websocket"                          \
  --header "Host: localhost:8000"                        \
  --header "Origin: http://localhost:8000"               \
  --header "Sec-WebSocket-Key: SGVsbG8sIHdvcmxkIQAAAA==" \
  --header "Sec-WebSocket-Version: 13"                   \
  http://localhost:8000/streaming/ws
```
+++ Headers
``` #
HTTP/1.1 101 Switching Protocols
Date: Wed, 03 Nov 2021 02:33:43 GMT
Connection: upgrade
Upgrade: websocket
Sec-WebSocket-Accept: 5Tz1rM6Lpj3X4PQub3+HhJRM11s=
```
+++ Response
```bash # A list of events:
{"type": "info", "id": "034d246aed02e1f20cbfc3d7bcea33d9", "time": 1635751704.823}
{"type": "info", "id": "22d34562bd93f247463791a1e45cec2c", "time": 1635751705.831}
{"type": "info", "id": "24bab0ad4039e931b37ac587e5d8a3b1", "time": 1635751706.838}
{"type": "info", "id": "16fb6c6b47da79648102d1ca7e66587e", "time": 1635751707.844}
{"type": "info", "id": "3b7e4d51a8c5bb48460ffedfc2d07b1d", "time": 1635751708.848}
{"type": "info", "id": "24ec12a9d0ceb8f845ce551726672239", "time": 1635751709.852}
{"type": "info", "id": "11430f7e525d40b2da5aa3e4ff1a1aea", "time": 1635751710.855}
{"type": "info", "id": "ebc30ab1048c6b05f6534e2c21d235c4", "time": 1635751711.862}
```
+++ 

### Using Websocat

You can also use [`websocat`](https://github.com/vi/websocat) as a command line websocket client to echo back messages:

+++ Command
```bash # Pipe text into the command:
echo 'Hello, world!' | websocat ws://localhost:8000/streaming/ws
```
+++ Response
```bash # Your message echoed back:
{"type": "info", "id": "7a1331c5c1416b72116fc29c5c1577e4", "time": 1635751909.352}
{"type": "message", "Hello, world! "}
{"type": "info", "id": "0b587cc77c47399864d9a4dbd0854dbd", "time": 1635751909.352}
```
+++ 

## Event Attributes

Event entries contain the following values:

| Attribute | Description                                                                          |
| ---     | ---                                                                                    |
| `type`  | The type of event being returned. `default: info`                                      |
| `id`    | A unique identifier representing the current request id. `default: ngx.var.request_id` |
| `time`  | A timestamp representing the server's current time. `default: ngx.now()`               |

## Nginx Directive

This is the directive responsible for this endpoint's behaviour. You can read the entirety of the configuration [here](https://github.com/wilhelm-murdoch/chamber/blob/main/config/openresty/conf.d/chamber.conf).

:::code source="../../config/openresty/conf.d/chamber.conf" title="config/openresty/conf.d/chamber.conf" region="/streaming/ws" :::