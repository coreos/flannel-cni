#!/usr/bin/env bash
set -e
CURL="curl -sSf"
FLANNEL_CNI_ROOT=$(git rev-parse --show-toplevel)
IMAGE_NAME=quay.io/coreos/flannel-cni
VERSION=$($FLANNEL_CNI_ROOT/scripts/git-version)
CNI_VERSION="v0.8.2"

mkdir -p dist
$CURL -L --retry 5 https://github.com/containernetworking/cni/releases/download/$CNI_VERSION/cni-amd64-$CNI_VERSION.tgz | tar -xz -C dist/
$CURL -L --retry 5 https://github.com/containernetworking/plugins/releases/download/$CNI_VERSION/cni-plugins-amd64-$CNI_VERSION.tgz | tar -xz -C dist/

docker build --no-cache -t $IMAGE_NAME:$VERSION .
docker push $IMAGE_NAME:$VERSION
