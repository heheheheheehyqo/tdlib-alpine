ARG ALPINE_VERSION
FROM alpine:${ALPINE_VERSION} as build

ARG TDLIB_COMMIT
RUN apk update && apk upgrade --update-cache --available && \
    apk add --update alpine-sdk linux-headers git zlib-dev openssl-dev gperf cmake && \
    git clone https://github.com/tdlib/td.git /td && \
    cd /td && \
    git reset --hard ${TDLIB_COMMIT} && \
    rm -rf build && mkdir build && \
    cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr/local .. && \
    cmake --build . --target install

FROM scratch as artifact

ARG TDLIB_VERSION
COPY --from=build /usr/local/lib/libtdjson.so /v${TDLIB_VERSION}/libtdjson.so
