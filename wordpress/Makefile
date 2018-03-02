AGENT_REPO ?= ../../ubbagent

$(shell mkdir -p .build/)

.PHONY: build
build: .build/deployer .build/init .build/marketplace-ubbagent

.PHONY: clean
clean:
	rm -rf .build/

.build/deployer: Makefile $(wildcard deployer/* manifest/*) | check-env
	docker build \
	    --build-arg REGISTRY="$(REGISTRY)" \
	    --tag "$(REGISTRY)/wordpress/deployer" \
	    -f deployer/Dockerfile \
	    .
	gcloud docker -- push "$(REGISTRY)/wordpress/deployer"
	touch "$@"

.build/init: Makefile $(wildcard init/*) | check-env
	cd init; \
	docker build \
	    --tag "$(REGISTRY)/wordpress/init" \
	    .
	gcloud docker -- push "$(REGISTRY)/wordpress/init"
	touch "$@"

.build/marketplace-ubbagent: Makefile $(wildcard $(AGENT_REPO)/* $(AGENT_REPO)/**/*) | check-env
	@if [ ! -d "$(AGENT_REPO)" ]; then \
	    echo "Expected metering agent repo (github.com/GoogleCloudPlatform/ubbagent) at $(AGENT_REPO)"; \
	    exit 1; \
	fi
	cd "$(AGENT_REPO)"; \
	docker build \
	    --tag "$(REGISTRY)/marketplace/ubbagent" \
	    .
	gcloud docker -- push "$(REGISTRY)/marketplace/ubbagent"
	touch "$@"

.PHONY: check-env
check-env:
ifndef REGISTRY
  $(error REGISTRY var must be set to a Docker registry)
endif
