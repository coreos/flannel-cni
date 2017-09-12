#!/usr/bin/env bash
set -e
FLANNEL_CNI_ROOT=$(git rev-parse --show-toplevel)
IMAGE_NAME=quay.io/coreos/flannel-cni
VERSION=$($FLANNEL_CNI_ROOT/scripts/git-version)

docker build --no-cache -t $IMAGE_NAME:$VERSION .
docker push $IMAGE_NAME:$VERSION
