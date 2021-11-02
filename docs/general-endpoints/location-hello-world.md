---
order: 100
icon: code
label: /hello-world
---
Returns a text response for "Hello, world!" in all google-supported languages:

```bash
$ for i in {1..5}; do curl http://localhost:8000/hello-world; done
Ahoj svete!
你好，世界！
Hello, World!
Բարեւ աշխարհ!
Dia duit, a shaoghail!
```