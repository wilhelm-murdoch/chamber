The following endpoints are used for testing long-running requests:

1. `location /latency/slow`: 5-second delay
2. `location /latency/slower`: 10-second delay
3. `location /latency/slowest`: 20-second delay

All endpoints in this namespace will return the following JSON response containing elapsed time:

```bash
$ curl http://localhost:8000/slow
{"elapsed": 4.975}
```