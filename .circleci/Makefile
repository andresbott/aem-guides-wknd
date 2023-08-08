SHELL := /bin/bash
IMAGE_NAME := "ghcr.io/andresbott/aem-guides-wknd/ci-image"
GIT_SHA := $(shell git rev-parse HEAD | cut -c 1-12)

# ======================================================================================
default: help;

build: ## build the Image that circleCi uses to run the pipeline
	@docker build -t ${IMAGE_NAME}:${GIT_SHA} .

login: check-login-env ## login to GH container registry ( only for maintainers )
	@echo $$GH_CONTAINER_REGISTRY | docker login ghcr.io -u andresbott --password-stdin

push: build ## push newly build image to github registry ( only for maintainers )
	@docker push ${IMAGE_NAME}:${GIT_SHA}

check-login-env:  # check if the appropriate environment variable is defined
ifndef GH_CONTAINER_REGISTRY
	$(error Environment variable GH_CONTAINER_REGISTRY is undefined)
endif

help: ## Show this help
	@egrep '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST)  | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m·%-20s\033[0m %s\n", $$1, $$2}'