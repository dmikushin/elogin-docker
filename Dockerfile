# Dockerfile to build elogind, based on:
# https://www.linuxfromscratch.org/blfs/view/stable/general/elogind.html
FROM ubuntu:22.04

LABEL maintainer="dmitry@kernelgen.org"

ENV DEBIAN_FRONTEND=noninteractive
ENV LC_ALL=C.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8

RUN apt-get update && \
	apt-get -y --no-install-recommends install \
	build-essential \
    libcap-dev \
    libudev-dev \
    libmount-dev \
    pkg-config \
    gperf \
    python3 \
    python3-jinja2 \
    meson \
    ninja-build \
    m4 \
    git \
    ca-certificates

COPY elogind.sh /elogind.sh

RUN git clone https://github.com/elogind/elogind.git

RUN cd elogind && \
    sh /elogind.sh && \
    mkdir build && \
    cd build && \
    meson --prefix=/usr                    \
      --buildtype=release                  \
      -Dcgroup-controller=elogind          \
      -Ddbuspolicydir=/etc/dbus-1/system.d \
      -Dman=auto                           \
      ..  && \
    ninja
