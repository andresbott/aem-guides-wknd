SHELL := /bin/bash

# ======================================================================================
default: help;

build: ## build the project locally using maven; call with SKIPTESTS=true to skip tests"
	@if [ ! -z "$(SKIPTESTS)" ]; then SKIP="-DskipTests"; else SKIP=""; fi && \
	mvn clean package $$SKIP;

local-it: ## run ITs locally
	source secrets.sh && \
	cd it.tests && \
	mvn clean verify \
	-Plocal \
	-Dit.author.url="$${AUTHOR_URL}" \
	-Dit.author.user="$${AUTHOR_USER}" \
	-Dit.author.password="$${AUTHOR_PASSWORD}" \
	-Dit.publish.url="$${PUBLISH_URL}" \
	-Dit.publish.user="$${PUBLISH_USER}" \
	-Dit.publish.password="$${PUBLISH_PASSWORD}" \
	-Dmaven.javadoc.skip=true \
	-Dmaven.surefire.debug

clean: ## clean the build environment
	echo "TODO clean"

help: ## Show this help
	@egrep '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST)  | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m·%-20s\033[0m %s\n", $$1, $$2}'