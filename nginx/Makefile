APP_NAME = nginx

tools_path = ../vendor/marketplace-tools

include $(tools_path)/gcloud.Makefile

include $(tools_path)/crd.Makefile
include $(tools_path)/app.Makefile
include $(tools_path)/ubbagent.Makefile

APP_TESTER_IMAGE = $(REGISTRY)/tester:latest

define APP_PARAMETERS
{ \
  "APP_INSTANCE_NAME": "$(APP_INSTANCE_NAME)", \
  "NAMESPACE": "$(NAMESPACE)", \
  "imageNginx.image": "$(APP_REGISTRY):$(APP_TAG)" \
}
endef

define TEST_PARAMETERS
{ \
  "tester.image": "$(APP_TESTER_IMAGE)" \
}
endef

app/build:: .build/deployer .build/nginx

app/build-test:: app/build .build/tester

.build/deployer: schema.yaml deployer/* nginx/* apptest/deployer/* $(MARKETPLACE_BASE_BUILD)/deployer-helm $(APP_BUILD)/registry_prefix $(APP_BUILD)/tag | app/setup
	docker build \
	    --build-arg MARKETPLACE_REGISTRY="$(MARKETPLACE_REGISTRY)" \
	    --tag "$(APP_DEPLOYER_IMAGE)" \
	    -f deployer/Dockerfile \
	    .
	gcloud docker -- push "$(APP_DEPLOYER_IMAGE)"
	@touch "$@"

.build/tester: apptest/* $(APP_BUILD)/registry_prefix | app/setup
	docker build \
	    --tag "$(APP_TESTER_IMAGE)" \
	    -f apptest/tester/Dockerfile \
	    .
	gcloud docker -- push "$(APP_TESTER_IMAGE)"
	@touch "$@"

# Simulate building of primary app image. Actually just copying public image to
# local registry.
.build/nginx: $(APP_BUILD)/registry_prefix $(APP_BUILD)/tag | app/setup
	gcloud docker -- pull launcher.gcr.io/google/nginx1
	docker tag launcher.gcr.io/google/nginx1 "$(APP_REGISTRY):$(APP_TAG)"
	gcloud docker -- push "$(APP_REGISTRY):$(APP_TAG)"
	@touch "$@"
