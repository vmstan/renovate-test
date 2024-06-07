FROM ruby:3.3.2-slim-bookworm as build

ENV DEBIAN_FRONTEND=noninteractive

RUN \
  apt-get update && apt-get install -y --no-install-recommends \
  curl \
  ca-certificates \
  build-essential \
  ninja-build \
  meson \
  pkg-config \
  ;

RUN \
  apt-get install -y \
  libexpat1-dev \
  # librsvg2-dev \
  libglib2.0-dev \
  libjpeg62-turbo-dev \
  libtiff-dev \
  libspng-dev \
  libexif-dev \
  libcgif-dev \
  liblcms2-dev \
  libwebp-dev \
  libheif-dev \
  libgirepository1.0-dev \
  libimagequant-dev \
  liborc-dev \
  ;

# renovate: datasource=github-releases depName=libvips packageName=libvips/libvips
ARG VIPS_VERSION=8.15.2
ARG VIPS_URL=https://github.com/libvips/libvips/releases/download

WORKDIR /usr/local/src

RUN \
  curl -sSL -o vips-${VIPS_VERSION}.tar.xz ${VIPS_URL}/v${VIPS_VERSION}/vips-${VIPS_VERSION}.tar.xz; \
  tar xf vips-${VIPS_VERSION}.tar.xz; \
  cd vips-${VIPS_VERSION}; \
  meson setup build --libdir=lib -Ddeprecated=false -Dintrospection=disabled -Dmodules=disabled -Dexamples=false; \
  cd build; \
  ninja; \
  ninja install;

FROM ruby:3.3.2-slim-bookworm as vips

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
  # librsvg2-2 \
  libexpat1 \
  libglib2.0-0 \
  libjpeg62-turbo \
  libtiff6 \
  libspng0 \
  libexif12 \
  libcgif0 \
  liblcms2-2 \
  libwebp7 \
  libwebpmux3 \
  libwebpdemux2 \
  libheif1 \
  libimagequant0 \
  liborc-0.4-0 \
  ;

COPY --from=build /usr/local/bin/vips* /usr/local/bin
COPY --from=build /usr/local/lib/libvips* /usr/local/lib
COPY --from=build /usr/local/lib/pkgconfig/vips* /usr/local/lib/pkgconfig

RUN \
  ln -sf /usr/local/lib/libvips.so.42.17.2 /usr/local/lib/libvips.so.42; \
  ln -sf /usr/local/lib/libvips.so.42.17.2 /usr/local/lib/libvips.so; \
  ln -sf /usr/local/lib/libvips-cpp.so.42.17.2 /usr/local/lib/libvips-cpp.so.42; \
  ln -sf /usr/local/lib/libvips-cpp.so.42.17.2 /usr/local/lib/libvips-cpp.so; \
  ldconfig \
  ;

# ENV LD_LIBRARY_PATH /usr/local/lib
# ENV PKG_CONFIG_PATH /usr/local/lib/pkgconfig