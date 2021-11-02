---
order: 100
icon: terminal  
label: Development
---

!!!primary So, you want to help?
Contributions are always welcome. Just create a PR and remember to be nice.
!!!

## Build Locally

Perform the following steps from the root of this repository's local working copy to build and run the server image locally:

```bash # 
git@github.com:wilhelm-murdoch/chamber.git
cd chamber/
git_sha=$(git rev-parse --short=8 HEAD)
docker build --build-arg GIT_SHA="${git_sha}" -t ghcr.io/wilhelm-murdoch/chamber:latest . 
```

We pass `$(git rev-parse --short=8 HEAD)` through to the build process using a `--build-arg` to write the release to a file stored within the resulting image. This content of this file is used by the `/up` endpoint.

:::code source="../../Dockerfile" title="Dockerfile" range="24-25" :::

:::code source="../../config/openresty/conf.d/chamber.conf" title="config/openresty/conf.d/chamber.conf" region="/up" :::

## Development Loop

If I find myself making changes to the `chamber.conf` file, I like to see these changes immediately. Invoking `docker build ...` and `docker run ...` with every incremental change can be tedious.

### Run

This project uses vanilla OpenResty, so I run the following command from the root of this repository's working copy.

```bash # Running the OpenResty container.
docker run -it --rm               \
  --name openresty                \
  -v config/openresty:/etc/nginx/ \
  -p 8000:8000                    \
  openresty/openresty:alpine
```

By mounting `config/openresty` to the container's `/etc/nginx` directory, it starts running with `chamber.conf` immediately.

### Watch

I want OpenResty to reload any time I make changes to `chamber.conf`. Luckily, we can perform a "soft reload" on the OpenResty process from within the container with `openresty -s reload`. I want to execute this command every time I save my changes, so let's use `fswatch` for this:

```bash #
fswatch -o config/openresty/conf.d/chamber.conf | xargs -n1 -I{} docker exec openresty openresty -s reload
```

I use `fswatch` as I am currently developing on MacOS. It's available on Linux, but you may want to use `inotify` for this instead.

### Request

If I'm working on a new endpoint, I'll be hitting it with `curl` quite often. Let's automate this as well with `watch`:

```bash #
watch -n 1 -c 'curl -s localhost:8000/my/new/endpoint'
```

## Maintainers

This repository is configured to use Github Workflows for automated building and pushing of releases. However, if you're a maintainer of this project, you can easily bypass this process.

```bash # 
git@github.com:wilhelm-murdoch/chamber.git
cd chamber/
echo "${GITHUB_TOKEN}" | docker login ghcr.io -u USERNAME --password-stdin
git_sha=$(git rev-parse --short=8 HEAD)
docker build --build-arg GIT_SHA="${git_sha}" -t ghcr.io/wilhelm-murdoch/chamber:latest . 
docker push ghcr.io/wilhelm-murdoch/chamber:latest
```

You will need a personal development token exported to your local environment as `GITHUB_TOKEN`. You can generate one [here](https://github.com/settings/tokens) with the `write:packages` scope.