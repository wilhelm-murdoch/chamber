---
order: 100
icon: people
label: Maintainers
---
> Contributions are always welcome. Just create a PR and remember to be nice.

Perform the following steps from the root of this repository's local working copy to build and run the server image locally:

```bash
$ git@github.com:wilhelm-murdoch/chamber.git
$ cd chamber/
$ docker build --build-arg GIT_SHA=$(git rev-parse --short=8 HEAD) -t ghcr.io/wilhelm-murdoch/chamber:latest . 
```

`GIT_SHA`: We generate this release identifier with `$(git rev-parse --short=8 HEAD)` and build it into the image itself. This is where we source the content of the `/up` endpoint.


### Development Loop

If I find myself making changes to the `chamber.conf` file, I like to see these changes immediately. Invoking `docker build ...` and `docker run ...` with every incremental change can be tedious. So, I cheat by using the following loop:

#### Run

This project uses vanilla OpenResty, so I run the following command from the root of this repository's working copy:

```bash
$ docker run -it --rm \
  --name openresty \
  -v config/openresty:/etc/nginx/ \
  -p 8000:8000 \
  openresty/openresty:alpine
```

By mounting `config/openresty` to the container's `/etc/nginx` directory, it starts running with `chamber.conf` immediately.

#### Watch

I want OpenResty to reload any time I make changes to `chamber.conf`. Luckily, we can perform a "soft reload" on the OpenResty process from within the container with `openresty -s reload`. I want to execute this command every time I save my changes, so let's use `fswatch` for this:

```bash
$ fswatch -o config/openresty/conf.d/chamber.conf | xargs -n1 -I{} docker exec openresty openresty -s reload
```

I use `fswatch` as I am currently developing on MacOS. It's available on Linux, but you may want to use `inotify` for this instead.

#### Request

If I'm working on a new endpoint, I'll be hitting it with `curl` quite often. Let's automate this as well with `watch`:

```bash
$ watch -n 1 -c 'curl -s localhost:8000/my/new/endpoint'
```

These 3 steps allow me to see my changes almost immediately without leaving my editor.

### For Maintainers

This repository is configured to use Github Workflows for automated building and pushing of releases. However, if you're a maintainer of this project, you can bypass this process with the following steps:

```bash
$ git@github.com:wilhelm-murdoch/chamber.git
$ cd chamber/
$ echo "${GITHUB_TOKEN}" | docker login ghcr.io -u USERNAME --password-stdin
$ docker build --build-arg GIT_SHA=$(git rev-parse --short=8 HEAD) -t ghcr.io/wilhelm-murdoch/chamber:latest . 
$ docker push ghcr.io/wilhelm-murdoch/chamber:latest
```

`GITHUB_TOKEN`: You will need a personal development token. You can generate one [here](https://github.com/settings/tokens) with the `write:packages` scope.