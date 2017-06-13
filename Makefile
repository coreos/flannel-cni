CURL=curl -sSf

IMAGE_NAME := quay.io/coreos/flannel-cni
VERSION ?= latest
TAG ?= 0.1
CNI_VERSION ?= v0.5.2


all: dist build tag push

dist:
	mkdir -p dist
	$(CURL) -L --retry 5 https://github.com/containernetworking/cni/releases/download/$(CNI_VERSION)/cni-amd64-$(CNI_VERSION).tgz | tar -xz -C dist/
	# For now we've get a checked in version of the plugin from calico.  Eventually
	# this should pull from upstream releases.
	$(CURL) -L https://github.com/projectcalico/cni-plugin/releases/download/v1.9.0/portmap -o dist/portmap
	chmod +x dist/portmap

build:
	docker build --no-cache -t $(IMAGE_NAME):$(VERSION) .

tag:
	docker tag $(IMAGE_NAME):$(VERSION) $(IMAGE_NAME):$(TAG)

push:
	docker push $(IMAGE_NAME):$(TAG)

