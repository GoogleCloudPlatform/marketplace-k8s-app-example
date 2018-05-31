APP_NAME = nginx

tools_path = ../vendor/marketplace-tools

include $(tools_path)/gcloud.Makefile

include $(tools_path)/crd.Makefile
include $(tools_path)/app.Makefile
include $(tools_path)/ubbagent.Makefile

define APP_PARAMETERS
{ \
  "APP_INSTANCE_NAME": "$(APP_INSTANCE_NAME)", \
  "NAMESPACE": "$(NAMESPACE)", \
  "imageNginx.image": "$(APP_REGISTRY):$(APP_TAG)" \
}
endef

define TEST_PARAMETERS
{ \
  "tester.image": "cosmintitei/bash-curl" \
}
endef

app/build:: .build/deployer .build/nginx

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

# Simulate building of primary app image. Actually just copying public image to
# local registry.
.build/nginx: $(APP_BUILD)/registry_prefix $(APP_BUILD)/tag | app/setup
	gcloud docker -- pull launcher.gcr.io/google/nginx1
	docker tag launcher.gcr.io/google/nginx1 "$(APP_REGISTRY):$(APP_TAG)"
	gcloud docker -- push "$(APP_REGISTRY):$(APP_TAG)"
	@touch "$@"
