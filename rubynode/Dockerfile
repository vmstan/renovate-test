# syntax=docker/dockerfile:1.7

# Please see https://docs.docker.com/engine/reference/builder for information about
# the extended buildx capabilities used in this file.
# Make sure multiarch TARGETPLATFORM is available for interpolation
# See: https://docs.docker.com/build/building/multi-platform/
ARG TARGETPLATFORM=${TARGETPLATFORM}
ARG BUILDPLATFORM=${BUILDPLATFORM}

# Ruby image to use for base image, change with [--build-arg RUBY_VERSION="3.3.x"]
# renovate: datasource=docker depName=docker.io/ruby
ARG RUBY_VERSION="3.3.3"
# # Node version to use in base image, change with [--build-arg NODE_MAJOR_VERSION="20"]
# renovate: datasource=node-version depName=node
ARG NODE_MAJOR_VERSION="20"
# Debian image to use for base image, change with [--build-arg DEBIAN_VERSION="bookworm"]
ARG DEBIAN_VERSION="bookworm"
# Node image to use for base image based on combined variables (ex: 20-bookworm-slim)
FROM docker.io/node:${NODE_MAJOR_VERSION}-${DEBIAN_VERSION}-slim as node
# Ruby image to use for base image based on combined variables (ex: 3.3.x-slim-bookworm)
FROM docker.io/ruby:${RUBY_VERSION}-slim-${DEBIAN_VERSION} as ruby