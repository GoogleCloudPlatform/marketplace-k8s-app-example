APP_NAME = nginx

tools_path = ../vendor/marketplace-tools

include $(tools_path)/gcloud.Makefile

include $(tools_path)/crd.Makefile
include $(tools_path)/app.Makefile
include $(tools_path)/ubbagent.Makefile

APP_PARAMETERS = '{ \
  "REGISTRY": "$(APP_REGISTRY)", \
  "TAG": "$(APP_TAG)", \
  "MARKETPLACE_REGISTRY": "$(MARKETPLACE_REGISTRY)", \
  "APP_INSTANCE_NAME": "$(APP_INSTANCE_NAME)"\
  }'

app/build:: .build/deployer .build/nginx

.build/deployer: \
	chart/* \
	deployer/*

	docker build \
	    --build-arg MARKETPLACE_REGISTRY="$(MARKETPLACE_REGISTRY)" \
	    --tag "$(APP_DEPLOYER_IMAGE)" \
	    -f deployer/Dockerfile \
	    .
	gcloud docker -- push "$(APP_DEPLOYER_IMAGE)"
	@touch "$@"

# Simulate building of primary app image. Actually just copying public image to
# local registry.
.build/nginx: $(APP_BUILD)/registry_prefix | app/setup
	gcloud docker -- pull launcher.gcr.io/google/nginx1
	docker tag launcher.gcr.io/google/nginx1 "$(APP_REGISTRY):$(APP_TAG)"
	gcloud docker -- push "$(APP_REGISTRY):$(APP_TAG)"
	@touch "$@"
