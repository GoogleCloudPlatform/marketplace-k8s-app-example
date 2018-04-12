APP_NAME = nginx

tools_path = ../vendor/marketplace-tools

include $(tools_path)/gcloud.Makefile

include $(tools_path)/crd.Makefile
include $(tools_path)/app.Makefile
include $(tools_path)/ubbagent.Makefile

app/build:: .build/deployer .build/nginx

.build/deployer: \
  $(APP_BUILD)/registry_prefix \
  $(MARKETPLACE_BASE_BUILD)/deployer-helm \
  chart/* \
  deployer/* \
  | app/setup

	docker build \
      --build-arg REGISTRY="$(APP_REGISTRY)" \
	    --build-arg TAG="$(APP_TAG)" \
	    --build-arg MARKETPLACE_REGISTRY="$(MARKETPLACE_REGISTRY)" \
	    --tag "$(APP_DEPLOYER_IMAGE)" \
	    -f deployer/Dockerfile \
	    .
	gcloud docker -- push "$(APP_DEPLOYER_IMAGE)"
	@touch "$@"


app/build/integ:: \
	.build/deployer/integ \
	.build/nginx

.build/deployer/integ: \
	.build/deployer \
	chart-integ/* \
	| app/setup

	docker build \
	    --build-arg APP_DEPLOYER_IMAGE="$(APP_DEPLOYER_IMAGE)" \
	    --tag "$(APP_DEPLOYER_IMAGE_INTEG)" \
	    -f deployer/Dockerfile-integ \
	    .
	gcloud docker -- push "$(APP_DEPLOYER_IMAGE_INTEG)"
	@touch "$@"


# Simulate building of primary app image. Actually just copying public image to
# local registry.
.build/nginx: $(APP_BUILD)/registry_prefix | app/setup
	gcloud docker -- pull launcher.gcr.io/google/nginx1
	docker tag launcher.gcr.io/google/nginx1 "$(APP_REGISTRY):$(APP_TAG)"
	gcloud docker -- push "$(APP_REGISTRY):$(APP_TAG)"
	@touch "$@"
