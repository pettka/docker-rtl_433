FROM amd64/ubuntu as builder

RUN export DEBIAN_FRONTEND=noninteractive \
  && apt-get -qq update \
  && apt-get -y --no-install-recommends install \
      ca-certificates \
      libtool \
      libusb-1.0-0-dev \
      librtlsdr-dev \
      rtl-sdr \
      build-essential \
      cmake \
      pkg-config \
      libssl-dev \
      git \
  && apt-get -y --purge autoremove \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && update-ca-certificates

RUN mkdir /build && cd /build \
  && git clone https://github.com/merbanan/rtl_433.git \
  && cd rtl_433/ \
  && sed -i 's/target_link_libraries(rtl_433 r_433)/target_link_libraries(rtl_433 r_433 ssl crypto)/g' src/CMakeLists.txt \
  && grep 'target_link_libraries' src/CMakeLists.txt \
  && mkdir build \
  && cd build \
  && cmake -MG_ENABLE_SSL=ON .. \
  && make \
  && make DESTDIR=/app/root/ install


FROM amd64/ubuntu

RUN export DEBIAN_FRONTEND=noninteractive \
  && apt-get -qq update \
  && apt-get -y --no-install-recommends install \
      ca-certificates \
      libusb-1.0-0-dev \
      librtlsdr-dev \
    #   rtl-sdr \
      libssl-dev \
  && apt-get -y --purge autoremove \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && update-ca-certificates

COPY --from=builder /app/root/ /

ENTRYPOINT ["/usr/local/bin/rtl_433"]