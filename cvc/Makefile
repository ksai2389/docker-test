SHELL := /bin/bash
REPO ?= cvc

VERSIONS = 18.04 \
           bionic

all:
	for name in ${VERSIONS}; do \
		pushd $$name; \
	    docker build --pull=true -t $(REPO):$$name . ; \
	    popd ; \
	done ; \
	docker build -t $(REPO):ide ide

.NOTPARALLEL:
.PHONY: all
