APP_NAME = wordpress

tools_path = ../vendor/marketplace-tools

include $(tools_path)/gcloud.Makefile

include $(tools_path)/crd.Makefile
include $(tools_path)/app.Makefile
include $(tools_path)/ubbagent.Makefile

# TODO(ruela) Double check the correct registry to use here.
APP_TESTER_IMAGE = $(REGISTRY)/tester:latest

define APP_PARAMETERS
{ \
  "APP_INSTANCE_NAME": "$(APP_INSTANCE_NAME)", \
  "NAMESPACE": "$(NAMESPACE)", \
  "IMAGE_WORDPRESS": "$(APP_REGISTRY):$(APP_TAG)", \
  "IMAGE_INIT": "$(APP_REGISTRY)/init:$(APP_TAG)", \
  "IMAGE_MYSQL": "$(APP_REGISTRY)/mysql:$(APP_TAG)", \
  "IMAGE_UBBAGENT": "$(APP_REGISTRY)/ubbagent:$(APP_TAG)" \
}
endef

define TEST_PARAMETERS
{ \
  "APP_TESTER_IMAGE": "$(APP_TESTER_IMAGE)" \
}
endef

export APP_PARAMETERS
app/build:: .build/deployer .build/wordpress .build/init .build/mysql .build/ubbagent

app/build-test:: app/build .build/tester

.build/deployer: deployer/* manifest/* manifest-test/* $(MARKETPLACE_BASE_BUILD)/deployer-kubectl $(APP_BUILD)/registry_prefix | app/setup
	docker build \
	    --build-arg REGISTRY="$(APP_REGISTRY)" \
	    --build-arg TAG="$(APP_TAG)" \
	    --build-arg MARKETPLACE_REGISTRY="$(MARKETPLACE_REGISTRY)" \
	    --tag "$(APP_DEPLOYER_IMAGE)" \
	    -f deployer/Dockerfile \
	    .
	gcloud docker -- push "$(APP_DEPLOYER_IMAGE)"
	@touch "$@"

.build/tester: apptest/* $(APP_BUILD)/registry_prefix | app/setup
	docker build \
	    --tag "$(APP_TESTER_IMAGE)" \
	    -f apptest/Dockerfile \
	    .
	gcloud docker -- push "$(APP_TESTER_IMAGE)"
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

# Relocate public mysql image to $APP_REGISTRY.
.build/mysql: $(APP_BUILD)/registry_prefix | app/setup
	gcloud docker -- pull launcher.gcr.io/google/mysql5
	docker tag launcher.gcr.io/google/mysql5 "$(APP_REGISTRY)/mysql:$(APP_TAG)"
	gcloud docker -- push "$(APP_REGISTRY)/mysql:$(APP_TAG)"
	@touch "$@"

# Relocate public ubbagent image to $APP_REGISTRY.
.build/ubbagent: $(APP_BUILD)/registry_prefix $(UBBAGENT_BUILD)/ubbagent | app/setup
	gcloud docker -- pull "$(MARKETPLACE_REGISTRY)/ubbagent"
	docker tag "$(MARKETPLACE_REGISTRY)/ubbagent" "$(APP_REGISTRY)/ubbagent:$(APP_TAG)"
	gcloud docker -- push "$(APP_REGISTRY)/ubbagent:$(APP_TAG)"
	@touch "$@"
