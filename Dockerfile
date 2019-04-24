FROM golang:1.12-alpine3.9 as builder

RUN \
  apk add --update --virtual build-deps go git musl-dev && \
  go get github.com/mdlayher/unifi_exporter/cmd/unifi_exporter

# =============================================================================

FROM alpine:3.9
LABEL maintainer="Jesse Stuart <hi@jessestuart.com>"

RUN apk add --update --no-cache ca-certificates

COPY --from=builder /go/bin/unifi_exporter /bin/unifi_exporter

EXPOSE 9130

USER nobody
ENTRYPOINT ["/bin/unifi_exporter"]
