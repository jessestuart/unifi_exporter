FROM golang:1.10-alpine3.7 as builder

ENV GOPATH /go
ENV PATH $PATH:$GOPATH/bin
ENV CGO_ENABLED 0

RUN  \
  apk add --no-cache ca-certificates curl && \
  apk add --no-cache --virtual .build-deps git && \
  go get github.com/mdlayher/unifi_exporter/cmd/unifi_exporter

# =============================================================================

FROM alpine:3.7
LABEL maintainer="Jesse Stuart <hi@jessestuart.com>"

RUN apk add --update --no-cache ca-certificates

COPY --from=builder /go/bin/unifi_exporter /bin/unifi_exporter

EXPOSE 9130
USER nobody
ENTRYPOINT ["/bin/unifi_exporter"]
