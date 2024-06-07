FROM ruby:3.3.2-slim-bookworm as build

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
  curl \
  ca-certificates \
  autoconf \
  automake \
  cmake \
  build-essential \
  libtool \
  meson \
  nasm \
  ninja-build \
  pkg-config \
  xz-utils \
  ;

RUN apt-get install -y --no-install-recommends \
    libbz2-dev \
    libdav1d-dev \
    liblzma-dev \
    libtheora-dev \
    libmp3lame-dev \
    libopus-dev \
    libvorbis-dev \
    libvpx-dev \
    libx264-dev \
    libx265-dev \
  ;

# renovate: datasource=repology depName=ffmpeg packageName=openpkg_current/ffmpeg
ARG FFMPEG_VERSION=7.0.1
ARG FFMPEG_URL=https://ffmpeg.org/releases

WORKDIR /usr/local/src

RUN \
  curl -sSL -o ffmpeg-${FFMPEG_VERSION}.tar.xz ${FFMPEG_URL}/ffmpeg-${FFMPEG_VERSION}.tar.xz; \
  echo "$FFMPEG_SHA256 ffmpeg-${FFMPEG_VERSION}.tar.xz" | sha256sum --check || exit 1;

RUN \
  tar xf ffmpeg-${FFMPEG_VERSION}.tar.xz; \
  cd ffmpeg-${FFMPEG_VERSION}; \
  mkdir -p /opt/ffmpeg; \
  ./configure \
    --prefix=/opt/ffmpeg \
    --disable-everything \
    --enable-gpl \
    --enable-nonfree \
    --enable-ffmpeg \
    --enable-ffprobe \
    --enable-shared \
    --enable-libwebp \
    --enable-libx264 \
    --enable-libx265 \
    --enable-libvpx \
    --enable-libvorbis \
    --enable-libopus \
    --enable-libdav1d \
    --enable-libmp3lame \
    --enable-libtheora \
    --enable-decoder=alac \
    --enable-decoder=flac \
    --enable-decoder=gif \
    --enable-decoder=h264 \
    --enable-decoder=hevc \
    --enable-decoder=mpeg2video \
    --enable-decoder=mp3 \
    --enable-decoder=opus \
    --enable-decoder=theora \
    --enable-decoder=vorbis \
    --enable-decoder=vp8 \
    --enable-decoder=vp9 \
    --enable-decoder=wavpack \
    --enable-decoder=webp \
    --enable-demuxer=3gp \
    --enable-demuxer=aac \
    --enable-demuxer=flac \
    --enable-demuxer=gif \
    --enable-demuxer=h264 \
    --enable-demuxer=hevc \
    --enable-demuxer=matroska \
    --enable-demuxer=mov \
    --enable-demuxer=mp3 \
    --enable-demuxer=ogg \
    --enable-demuxer=wav \
    --enable-demuxer=webm \
    --enable-demuxer=webp \
    --enable-muxer=h264 \
    --enable-muxer=mp3 \
    --enable-muxer=aac \
    --enable-encoder=libx264 \
    --enable-encoder=libmp3lame \
    --enable-encoder=aac \
    --enable-protocol=file \
    --enable-protocol=pipe \
    --enable-protocol=fd \
    --enable-protocol=tee \
    --enable-protocol=async \
    --enable-filter=aresample \
    --disable-doc \
    --disable-network \
    --disable-static \
  ; \
  make -j$(nproc); \
  make install;

FROM ruby:3.3.2-slim-bookworm as ffmpeg

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    libdav1d6 \
    libmp3lame0 \
    libopus0 \
    libvorbis0a \
    libvorbisenc2 \
    libtheora0 \
    libvorbisfile3 \
    libvpx7 \
    libx264-164 \
    libx265-199 \
  ;

COPY --from=build /opt/ffmpeg/bin* /usr/local/bin
COPY --from=build /opt/ffmpeg/lib* /usr/local/lib

RUN ldconfig

RUN ffmpeg -version

# ENV LD_LIBRARY_PATH /usr/local/lib
# ENV PKG_CONFIG_PATH /usr/local/lib/pkgconfig