#!/bin/sh

echo '
export GITHUB_REPO=mdlayher/unifi_exporter
export GOPATH=/go
export GOROOT=/usr/local/go
export IMAGE=unifi_exporter
export REGISTRY=jessestuart

export VERSION=$(curl -s https://api.github.com/repos/${GITHUB_REPO}/releases | jq -r ".[0].tag_name")
export IMAGE_ID="${REGISTRY}/${IMAGE}:${VERSION}-${TAG}"
export DIR=`pwd`
export QEMU_VERSION="v4.0.0"
' >>$BASH_ENV

. $BASH_ENV
