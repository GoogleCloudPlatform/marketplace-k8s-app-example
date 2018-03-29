APP_NAME = wordpress

tools_path = ../vendor/marketplace-tools

include $(tools_path)/gcloud.Makefile

include $(tools_path)/crd.Makefile
include $(tools_path)/app.Makefile
include $(tools_path)/ubbagent.Makefile

app/build:: .build/deployer .build/wordpress .build/init .build/mysql $(UBBAGENT_BUILD)/ubbagent

.build/deployer: deployer/* manifest/* $(MARKETPLACE_BASE_BUILD)/deployer-kubectl $(MARKETPLACE_BASE_BUILD)/controller $(APP_BUILD)/registry_prefix | app/setup
	docker build \
	    --build-arg REGISTRY="$(APP_REGISTRY)" \
	    --build-arg TAG="$(APP_TAG)" \
	    --build-arg MARKETPLACE_REGISTRY="$(MARKETPLACE_REGISTRY)" \
	    --tag "$(APP_DEPLOYER_IMAGE)" \
	    -f deployer/Dockerfile \
	    .
	gcloud docker -- push "$(APP_DEPLOYER_IMAGE)"
	@touch "$@"

# Simulate building of primary app image. Actually just copying public image to
# local registry.
.build/wordpress: $(APP_BUILD)/registry_prefix | app/setup
	gcloud docker -- pull launcher.gcr.io/google/wordpress4-php5-apache
	docker tag launcher.gcr.io/google/wordpress4-php5-apache "$(APP_REGISTRY):$(APP_TAG)"
	gcloud docker -- push "$(APP_REGISTRY):$(APP_TAG)"
	@touch "$@"

# Build secondary app image.
.build/init: init/* $(APP_BUILD)/registry_prefix | app/setup
	cd init \
	&& docker build --tag "$(APP_REGISTRY)/init:$(APP_TAG)" .
	gcloud docker -- push "$(APP_REGISTRY)/init:$(APP_TAG)"
	@touch "$@"


# Relocate public mysql image to $MARKETPLACE_REGISTRY.
# TODO: Remove this and pull directly from public marketplace.
.build/mysql: $(APP_BUILD)/registry_prefix | app/setup
	gcloud docker -- pull launcher.gcr.io/google/mysql5
	docker tag launcher.gcr.io/google/mysql5 "$(MARKETPLACE_REGISTRY)/mysql"
	gcloud docker -- push "$(MARKETPLACE_REGISTRY)/mysql"
	@touch "$@"
