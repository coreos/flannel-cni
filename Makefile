CURL:=curl -sSf

FLANNEL_CNI_ROOT:=$(shell git rev-parse --show-toplevel)
IMAGE_NAME:=quay.io/coreos/flannel-cni
VERSION:=$(shell $FLANNEL_CNI_ROOT/scripts/git-version)
CNI_VERSION?=v0.5.2

all: release

dist:
	mkdir -p dist
	$(CURL) -L --retry 5 https://github.com/containernetworking/cni/releases/download/$(CNI_VERSION)/cni-amd64-$(CNI_VERSION).tgz | tar -xz -C dist/
	# For now we've get a checked in version of the plugin from calico.  Eventually
	# this should pull from upstream releases.
	$(CURL) -L https://github.com/projectcalico/cni-plugin/releases/download/v1.9.0/portmap -o dist/portmap
	chmod +x dist/portmap

docker-image: dist
	docker build --no-cache -t $(IMAGE_NAME):$(VERSION) .

docker-push: docker-image
	docker push $(IMAGE_NAME):$(VERSION)

release: docker-push
