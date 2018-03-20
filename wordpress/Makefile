APP_NAME = wordpress
AGENT_REPO ?= ../../ubbagent

include ../vendor/marketplace-tools/crd.Makefile
include ../vendor/marketplace-tools/app.Makefile

app/build:: .build/deployer .build/init .build/marketplace-ubbagent

.build/deployer: deployer/* manifest/* $(MARKETPLACE_BASE_BUILD)/deployer-kubectl $(MARKETPLACE_BASE_BUILD)/controller | app/setup
	docker build \
	    --build-arg MARKETPLACE_REGISTRY="$(MARKETPLACE_REGISTRY)" \
	    --tag "$(APP_DEPLOYER_IMAGE)" \
	    -f deployer/Dockerfile \
	    .
	gcloud docker -- push "$(APP_DEPLOYER_IMAGE)"
	@touch "$@"

.build/init: init/* | app/setup
	cd init \
	&& docker build \
	      --tag "$(APP_REGISTRY)/init" \
	      .
	gcloud docker -- push "$(APP_REGISTRY)/init"
	@touch "$@"

.build/marketplace-ubbagent: $(AGENT_REPO)/* $(AGENT_REPO)/**/* | app/setup
	@if [ ! -d "$(AGENT_REPO)" ]; then \
	    echo "Expected metering agent repo (github.com/GoogleCloudPlatform/ubbagent) at $(AGENT_REPO)"; \
	    exit 1; \
	fi
	cd "$(AGENT_REPO)" \
	&& docker build \
	      --tag "$(MARKETPLACE_REGISTRY)/ubbagent" \
	      .
	gcloud docker -- push "$(MARKETPLACE_REGISTRY)/ubbagent"
	@touch "$@"
