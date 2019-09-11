ARG target

FROM golang:1.13-alpine as builder

ARG goarch
ENV GOARCH $goarch

ENV GO111MODULE off

RUN \
  apk add --update --virtual build-deps go git musl-dev && \
  go get -d github.com/mdlayher/unifi_exporter && \
  GOOS=linux GOARCH=$GOARCH go build -o /go/bin/unifi_exporter github.com/mdlayher/unifi_exporter/cmd/unifi_exporter

# =============================================================================

FROM $target/alpine
COPY qemu-* /usr/bin/

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL \
  maintainer="Jesse Stuart <hi@jessestuart.com>" \
  org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.url="https://hub.docker.com/r/jessestuart/unifi_exporter" \
  org.label-schema.vcs-url="https://github.com/jessestuart/unifi_exporter" \
  org.label-schema.vcs-ref=$VCS_REF \
  org.label-schema.version=$VERSION \
  org.label-schema.schema-version="1.0"

RUN apk add --no-cache ca-certificates

COPY --from=builder /go/bin/unifi_exporter /bin/unifi_exporter

EXPOSE 9130

USER nobody
ENTRYPOINT ["/bin/unifi_exporter"]
