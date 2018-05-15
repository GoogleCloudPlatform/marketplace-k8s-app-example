APP_TESTER_IMAGE = $(REGISTRY)/nginx/tester:latest

NAME ?= nginx-1
NAMESPACE ?= default

######################
# Required Variables #
######################

MARKETPLACE_TOOLS_PATH = ../vendor/marketplace-tools/
APP_DEPLOYER_IMAGE ?= $(REGISTRY)/nginx/deployer:latest
APP_PARAMETERS ?= { \
  "APP_INSTANCE_NAME": "$(NAME)", \
  "NAMESPACE": "$(NAMESPACE)", \
  "IMAGE_NGINX": "$(REGISTRY)/nginx:latest" \
}
APP_TEST_PARAMETERS ?= { \
  "APP_TESTER_IMAGE": "$(APP_TESTER_IMAGE)" \
}

##########################
# End Required Variables #
##########################

# TODO(trironkk/dev/c): Remove.
APP_INSTANCE_NAME = $(NAME)

include ../vendor/marketplace-tools/app.Makefile
include ../vendor/marketplace-tools/crd.Makefile
include ../vendor/marketplace-tools/ubbagent.Makefile
include ../vendor/marketplace-tools/gcloud.Makefile

app/build:: .build/deployer .build/nginx

app/build-test:: app/build .build/tester

.build/deployer: schema.yaml deployer/* nginx/* apptest/deployer/* $(MARKETPLACE_BASE_BUILD)/deployer-helm | app/setup
	docker build \
	    --build-arg REGISTRY="$(REGISTRY_FOR_DEPLOYER)" \
	    --build-arg MARKETPLACE_REGISTRY="$(MARKETPLACE_REGISTRY)" \
	    --tag "$(APP_DEPLOYER_IMAGE)" \
	    -f deployer/Dockerfile \
	    .
	gcloud docker -- push "$(APP_DEPLOYER_IMAGE)"
	@touch "$@"

.build/tester: apptest/* | app/setup
	docker build \
	    --tag "$(APP_TESTER_IMAGE)" \
	    -f apptest/tester/Dockerfile \
	    .
	gcloud docker -- push "$(APP_TESTER_IMAGE)"
	@touch "$@"

# Simulate building of primary app image. Actually just copying public image to
# local registry.
.build/nginx: | app/setup
	gcloud docker -- pull launcher.gcr.io/google/nginx1
	docker tag launcher.gcr.io/google/nginx1 "$(REGISTRY)/nginx:latest"
	gcloud docker -- push "$(REGISTRY)/nginx:latest"
	@touch "$@"
