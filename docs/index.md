---
order: 1100
icon: home
label: Welcome to Chamber
---

!!!warning Just a quick FYI!
This project, while feature-complete in it's current state, is still quite new, so you may find a :icon-bug: here or there. If you do, it'd be a great help if you could [create an issue](https://github.com/wilhelm-murdoch/chamber/issues) for it over on :icon-mark-github: !
!!!

[![Docker](https://github.com/wilhelm-murdoch/chamber/actions/workflows/docker.yml/badge.svg)](https://github.com/wilhelm-murdoch/chamber/actions/workflows/docker.yml) [![Retype](https://github.com/wilhelm-murdoch/chamber/actions/workflows/retype.yml/badge.svg)](https://github.com/wilhelm-murdoch/chamber/actions/workflows/retype.yml)

## Hi, there! :wave: :grimacing:

[Chamber](https://chamber.wilhelm.codes) is a fully-featured echo server that can be used for end-to-end testing of proxies and web-based clients. All components have been written using a vanilla implementation of the [OpenResty](https://openresty.org/en/) web platform.

Some of chamber's more advanced functionality is written using inline-Lua code as shown in the following code block.

:::code source="../config/openresty/conf.d/chamber.conf" title="GET /latency/degrading" region="/latency/degrading" :::

## Great! ... What's an "Echo Server"? :thinking_face:

In it's most basic form, an echo server is one that just spits back whatever a client sends it. In other words, it "echoes" a request back to the sender. Chamber does just that — specifically the [`/echo`](/general-endpoints/location-echo) endpoint — and heaps more.

## Oh, I get it. "Echo _Chamber_". :neutral_face:

Yep. Very clever. :smile:

## So, Why Would I Use This? :face_with_raised_eyebrow:

1. Are you writing an SDK for a 3rd-party service and want to test how it responds to various HTTP error codes?
2. Are you building out a test suite that requires various stubbed requests?
3. Are you testing proxy connections?
4. Are you learning how to simulate load and want a throw-away service to test against locally?
5. Are you learning how to interact with websockets and server-sent events?
6. Are you troubleshooting slow endpoints in a project and need a test target that provides consistently-slow responses?

If you've answered "Yes!" to any of these questions, then an echo server is a great tool to have in your belt!
