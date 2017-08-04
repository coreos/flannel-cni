FLANNEL_CNI_ROOT:=$(shell git rev-parse --show-toplevel)

build-image:
	$(FLANNEL_CNI_ROOT)/scripts/build-image.sh