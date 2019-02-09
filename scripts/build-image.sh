#!/usr/bin/env bash
set -e
CURL="curl -sSf"
FLANNEL_CNI_ROOT=$(git rev-parse --show-toplevel)
IMAGE_NAME=quay.io/coreos/flannel-cni
VERSION=$($FLANNEL_CNI_ROOT/scripts/git-version)
CNI_VERSION="v0.6.0"
ARCH=$(uname -m)

case $ARCH in
       aarch64)
               ARCHITECTURE=arm64
	       VERSION_ARCH=$VERSION-$ARCHITECTURE
               ;;
       x86_64)
               ARCHITECTURE=amd64
	       VERSION_ARCH=$VERSION
               ;;
       *)
               ARCHITECTURE=$ARCH
	       VERSION_ARCH=$VERSION-$ARCHITECTURE
               ;;
esac

mkdir -p dist
$CURL -L --retry 5 https://github.com/containernetworking/cni/releases/download/$CNI_VERSION/cni-$ARCHITECTURE-$CNI_VERSION.tgz | tar -xz -C dist/
$CURL -L --retry 5 https://github.com/containernetworking/plugins/releases/download/$CNI_VERSION/cni-plugins-$ARCHITECTURE-$CNI_VERSION.tgz | tar -xz -C dist/

docker build --no-cache -t $IMAGE_NAME:$VERSION_ARCH .
docker push $IMAGE_NAME:$VERSION_ARCH
