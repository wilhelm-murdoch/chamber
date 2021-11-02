---
order: 100
icon: code
label: /latency/erratic
---
Response times between 1 to 10 seconds will be randomly selected:

```bash
$ curl http://localhost:8000/latency/erratic
{"elapsed": 2.006}
$ curl http://localhost:8000/latency/erratic
{"elapsed": 5.003}
$ curl http://localhost:8000/latency/erratic
{"elapsed": 1.920}
```
