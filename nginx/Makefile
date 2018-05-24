###########################################################
# Define convenience parameters (if not already defined). #
###########################################################

NAME ?= nginx-1
NAMESPACE ?= default
NGINX_IMAGE ?= $(REGISTRY)/nginx:latest

########################################
# Include marketplace-tools Makefiles. #
########################################

include ../vendor/marketplace-tools/app.Makefile
include ../vendor/marketplace-tools/base_containers.Makefile
include ../vendor/marketplace-tools/crd.Makefile
include ../vendor/marketplace-tools/gcloud.Makefile
include ../vendor/marketplace-tools/ubbagent.Makefile

##############################################
# Define variables required by app.Makefile. #
##############################################

APP_DEPLOYER_IMAGE ?= $(REGISTRY)/deployer:latest
APP_PARAMETERS ?= { \
  "APP_INSTANCE_NAME": "$(NAME)", \
  "NAMESPACE": "$(NAMESPACE)", \
  "imageNginx.image": "$(NGINX_IMAGE)" \
}
APP_TEST_PARAMETERS ?= { \
  "tester.image": "$(REGISTRY)/tester:latest" \
}

#######################################
# Define extensions for app.Makefile. #
#######################################

app/build:: .build/deployer .build/nginx

app/build-test:: app/build .build/tester

.build/deployer: schema.yaml deployer/* nginx/* apptest/deployer/* base/build/deployer/helm | gcloud/REGISTRY
	docker build \
	    --build-arg MARKETPLACE_REGISTRY="$(MARKETPLACE_REGISTRY)" \
	    --tag "$(APP_DEPLOYER_IMAGE)" \
	    -f deployer/Dockerfile \
	    .
	gcloud docker -- push "$(APP_DEPLOYER_IMAGE)"
	@touch "$@"

.build/tester: apptest/* | gcloud/REGISTRY
	docker build \
	    --tag "$(REGISTRY)/tester:latest" \
	    -f apptest/tester/Dockerfile \
	    .
	gcloud docker -- push "$(REGISTRY)/tester:latest"
	@touch "$@"

# Simulate building of primary app image. Actually just copying public image to
# local registry.
.build/nginx: | gcloud/REGISTRY
	gcloud docker -- pull launcher.gcr.io/google/nginx1
	docker tag launcher.gcr.io/google/nginx1 "$(NGINX_IMAGE)"
	gcloud docker -- push "$(NGINX_IMAGE)"
	@touch "$@"
