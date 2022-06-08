# Copyright 2022 Aoxn.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Simple makefile to build wdrip quickly and reproducibly in a container
# Only requires docker on the host

OS_TYPE :=$(shell echo `uname`|tr '[A-Z]' '[a-z]')

# settings
REPO_ROOT:=${CURDIR}
# autodetect host GOOS and GOARCH by default, even if go is not installed
#GOOS?=$(shell hack/util/goos.sh)
#GOARCH?=$(shell hack/util/goarch.sh)
REGISTRY=registry.cn-hangzhou.aliyuncs.com/aoxn/blog
TAG?=$(shell hack/tag.sh)
NOCACHE?=
# make install will place binaries here
# the default path attempst to mimic go install
#INSTALL_DIR?=$(shell hack/util/goinstalldir.sh)

# the output binary name, overridden when cross compiling
KIND_BINARY_NAME?=hexo
# use the official module proxy by default
GOPROXY?=https://mirrors.aliyun.com/goproxy
# default build image
GO_VERSION?=1.14.3
GO_IMAGE?=golang:$(GO_VERSION)
# docker volume name, used as a go module / build cache
CACHE_VOLUME?=wdrip-build-cache

# variables for consistent logic, don't override these
CONTAINER_REPO_DIR=/src/wdrip
CONTAINER_OUT_DIR=$(CONTAINER_REPO_DIR)/bin
OUT_DIR=$(REPO_ROOT)/build/bin
UID:=$(shell id -u)
GID:=$(shell id -g)

# standard "make" target -> builds
all: build

# creates the output directory
out-dir:
	@echo + Ensuring build output directory exists
	mkdir -p $(OUT_DIR)

# cleans the output directory
clean-output:
	@echo + Removing build output directory
	rm -rf $(OUT_DIR)/

image:
	# NOCACHE=--no-cache
	@echo + Build blog image [$(REGISTRY):$(TAG)] [NOCACHE=$(NOCACHE)]
	docker build $(NOCACHE) -t $(REGISTRY):$(TAG) .

push: image
	@echo + Push to registry [$(REGISTRY):$(TAG)]
	docker push $(REGISTRY):$(TAG)

dev:
	@echo + Build dev env
	bash hack/dev.sh

generate:
	@echo + Generate post
	hexo g

.PHONY: all make-cache clean-cache out-dir clean-output wdrip build install clean
