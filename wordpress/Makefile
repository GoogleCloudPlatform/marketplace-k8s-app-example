AGENT_REPO ?= ../../ubbagent

$(shell mkdir -p .build/)

.PHONY: build
build: .build/app

.PHONY: clean
clean:
	rm -rf .build/

.build/app: .build/marketplace-ubbagent Makefile deployer/* | check-env
	docker build \
	    --build-arg REGISTRY="$(REGISTRY)" \
	    --tag "$(REGISTRY)/wordpress/deployer" \
	    -f deployer/Dockerfile \
	    .
	cd init; \
	docker build \
	    --tag "$(REGISTRY)/wordpress/init" \
	    .
	gcloud docker -- push "$(REGISTRY)/wordpress/deployer"
	gcloud docker -- push "$(REGISTRY)/wordpress/init"
	touch "$@"

.build/marketplace-ubbagent:
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
