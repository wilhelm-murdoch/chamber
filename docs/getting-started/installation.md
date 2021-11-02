---
order: 100
icon: download
label: Download & Install
---
Docker is the only hard requirement for this project. With a bit of mucking about, you can get this running without a container. However, only Docker usage is supported at the moment. Ensure your local daemon is running and execute the following command in your terminal:

```bash
$ docker run -it --rm --name chamber -p 8000:8000 ghcr.io/wilhelm-murdoch/chamber:latest
```

Ensure the server is running with:

```bash
$ curl localhost:8000/up
chamber release: a5fecbfa
```

You should now be able to open a browser and point it to http://localhost:8000 to hit the landing page.