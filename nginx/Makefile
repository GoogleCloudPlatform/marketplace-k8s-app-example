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
  "IMAGE_NGINX": "$(APP_REGISTRY):$(APP_TAG)" \
}
endef

define TEST_PARAMETERS
{ \
  "APP_TESTER_IMAGE": "$(APP_TESTER_IMAGE)" \
}
endef

app/build:: .build/deployer .build/nginx

app/build-test:: app/build .build/tester

.build/deployer: \
	$(APP_BUILD)/registry_prefix \
	$(APP_BUILD)/tag \
	$(MARKETPLACE_BASE_BUILD)/deployer-helm \
	apptest/deployer/* \
	apptest/deployer/nginx/* \
	apptest/deployer/nginx/templates/* \
	deployer/* \
	nginx/* \
	nginx/templates/* \
	schema.yaml \
	| app/setup
	docker build \
	    --build-arg MARKETPLACE_REGISTRY="$(MARKETPLACE_REGISTRY)" \
	    --tag "$(APP_DEPLOYER_IMAGE)" \
	    -f deployer/Dockerfile \
	    .
	gcloud docker -- push "$(APP_DEPLOYER_IMAGE)"
	@touch "$@"

.build/testrunner: ../vendor/marketplace-tools/testrunner/*
	gcloud container builds submit \
	  --config ../vendor/marketplace-tools/testrunner/cloudbuild.yaml \
	  ../vendor/marketplace-tools/testrunner
	@touch "$@"

.build/tester: \
	$(APP_BUILD)/registry_prefix \
	$(APP_BUILD)/tag \
	.build/testrunner \
	apptest/tester/* \
	apptest/tester/testspecs/* \
	| app/setup
	docker build \
	    --build-arg REGISTRY="$(REGISTRY)" \
	    --tag "$(APP_TESTER_IMAGE)" \
	    -f apptest/tester/Dockerfile \
	    apptest/tester
	gcloud docker -- push "$(APP_TESTER_IMAGE)"
	@touch "$@"

# Simulate building of primary app image. Actually just copying public image to
# local registry.
.build/nginx: $(APP_BUILD)/registry_prefix $(APP_BUILD)/tag | app/setup
	gcloud docker -- pull launcher.gcr.io/google/nginx1
	docker tag launcher.gcr.io/google/nginx1 "$(APP_REGISTRY):$(APP_TAG)"
	gcloud docker -- push "$(APP_REGISTRY):$(APP_TAG)"
	@touch "$@"
