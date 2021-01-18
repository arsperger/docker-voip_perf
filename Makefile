IMAGE_NAME := arsperger/voip_perf
RELEASE_VERSION := $(shell cat VERSION)
DISTRO_VERSION = buster

no-cache ?= no

comma := ,
empty :=
space := $(empty) $(empty)
eq = $(if $(or $(1),$(2)),$(and $(findstring $(1),$(2)),\
                                $(findstring $(2),$(1))),1)

no-cache-arg = $(if $(call eq, $(no-cache), yes), --no-cache, $(empty))


all: build

# Build Docker image.
#
# Usage:
#       make build [no-cache=(yes|no)]
build:
	docker build $(no-cache-arg) --build-arg DISTRO_VERSION=${DISTRO_VERSION} --build-arg RELEASE_VERSION=${RELEASE_VERSION} \
				--tag ${IMAGE_NAME}:${RELEASE_VERSION} -f $(PWD)/debian/$(DISTRO_VERSION)/Dockerfile \
				 .

# Start docker-compose test container
#
# Usage:
#       make test
test: build
	@docker-compose -f docker-compose.test.yml up


#
# TODO: Fix Release image tags
#
# 1. build the image
#
# Usage:
#       make release
release:
	docker tag ${IMAGE_NAME}:${RELEASE_VERSION} ${IMAGE_NAME}:latest
	docker push ${IMAGE_NAME}:${RELEASE_VERSION}
	docker push ${IMAGE_NAME}:latest


# Clean up
#
# Remove all stopped containers
prune:
	@docker container prune -f

# Remove all dangling images
clean: prune
	@docker rmi $(shell docker images --filter "dangling=true" -q --no-trunc)



.PHONY: all build test prune clean release
