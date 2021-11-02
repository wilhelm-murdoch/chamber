---
order: 100
icon: code
label: /streaming/sse
---
Exposes an endpoint for testing clients used for server sent events (SSE). You can open this endpoint directly in your browser to observe a live stream of events. You can also use curl as follows:

```bash
$ curl -N http://localhost:8000/streaming/sse
id: 5500f7b77d1c4216e2f2dd157e46ff01
event: random
data: {"message": "eUMWD65R8QIfrtvbvhYABSYY3jg07VtZENlryyzR0qK9eQ4", "elapsed": 0.000000}


id: 2fdf54658b56557f25ac5753825a0c9a
event: random
data: {"message": "YI7Gh58NjZ9G8tsT8Bdt9nU6TwMScffUCnt", "elapsed": 4.003000}


id: 02bafca1deb344e4e88bc28f4f9803b7
event: random
data: {"message": "ezD0t2QY8k", "elapsed": 8.005000}


id: 5c265d1434939c05f45d02913532c17f
event: random
data: {"message": "PrOxymfu0BRfQpPfpEGMQBMtOo", "elapsed": 10.009000}


id: c8bd592c9d068c5b7acc2eab8aa63756
event: random
data: {"message": "QkB0YIzOqnYxPpKr0UOSAJO", "elapsed": 13.016000}
```

Each event entry returns the following attributes:

1. `id`: A unique identifier per event sourced from `ngx.var.request_id`.
2. `event`: A default event type of `random`. This can be changed by adding the `?event=<string>` parameter to this endpoint.
3. `data`: A simple JSON object containing `.message` data as well as the current `.elapsed` time since the beginning of the request. You can define a custom message by adding the `?message=<string>` parameter to this endpoint.