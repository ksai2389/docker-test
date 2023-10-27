SHELL := /bin/bash
REPO ?= vnc

VERSIONS = base \
           xdu

all:
	for name in ${VERSIONS}; do \
		pushd $$name; \
	    docker build -t $(REPO):$$name . ; \
	    popd ; \
	done

.NOTPARALLEL:
.PHONY: all
