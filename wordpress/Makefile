###########################################################
# Define convenience parameters (if not already defined). #
###########################################################

NAME ?= wordpress
TAG ?= latest

REGISTRY_FOR_DEPLOYER ?= $(REGISTRY)
# TODO(ruela) Double check the correct registry to use here.
APP_TESTER_IMAGE ?= $(REGISTRY)/tester:latest

########################################
# Include marketplace-tools Makefiles. #
########################################

include ../vendor/marketplace-tools/app.Makefile
include ../vendor/marketplace-tools/crd.Makefile
include ../vendor/marketplace-tools/gcloud.Makefile
include ../vendor/marketplace-tools/marketplace.Makefile
include ../vendor/marketplace-tools/ubbagent.Makefile
include ../vendor/marketplace-tools/var.Makefile

##############################################
# Define variables required by app.Makefile. #
##############################################

APP_DEPLOYER_IMAGE ?= $(REGISTRY)/deployer:latest
APP_PARAMETERS ?= { \
  "APP_INSTANCE_NAME": "$(NAME)", \
  "NAMESPACE": "$(NAMESPACE)", \
  "IMAGE_WORDPRESS": "$(REGISTRY):$(TAG)", \
  "IMAGE_INIT": "$(REGISTRY)/init:$(TAG)", \
  "IMAGE_MYSQL": "$(REGISTRY)/mysql:$(TAG)", \
  "IMAGE_UBBAGENT": "$(REGISTRY)/ubbagent:$(TAG)" \
}
APP_TEST_PARAMETERS ?= { \
  "APP_TESTER_IMAGE": "$(APP_TESTER_IMAGE)" \
}

#######################################
# Define extensions for app.Makefile. #
#######################################

.PHONY: .build/wordpress
.build/wordpress:
	mkdir -p "$@"

app/build:: .build/wordpress/deployer \
            .build/wordpress/wordpress \
            .build/wordpress/init \
            .build/wordpress/mysql \
            .build/wordpress/ubbagent

app/build-test:: app/build \
                 .build/wordpress/tester

.build/wordpress/deployer: schema.yaml deployer/* manifest/* apptest/deployer/* \
                           .build/marketplace/deployer/envsubst \
                           .build/var/APP_DEPLOYER_IMAGE \
                           .build/var/REGISTRY \
                           .build/var/REGISTRY_FOR_DEPLOYER \
                           .build/var/TAG \
                           | .build/wordpress
	docker build \
	    --build-arg REGISTRY="$(REGISTRY_FOR_DEPLOYER)" \
	    --build-arg TAG="$(TAG)" \
	    --build-arg REGISTRY="$(REGISTRY)" \
	    --tag "$(APP_DEPLOYER_IMAGE)" \
	    -f deployer/Dockerfile \
	    .
	gcloud docker -- push "$(APP_DEPLOYER_IMAGE)"
	@touch "$@"

.build/wordpress/tester: apptest/* \
                         .build/var/REGISTRY \
                         .build/var/APP_TESTER_IMAGE \
                         | .build/wordpress
	docker build \
	    --tag "$(APP_TESTER_IMAGE)" \
	    -f apptest/tester/Dockerfile \
	    .
	gcloud docker -- push "$(APP_TESTER_IMAGE)"
	@touch "$@"

# Simulate building of primary app image. Actually just copying public image to
# local registry.
.build/wordpress/wordpress: .build/var/REGISTRY \
                            .build/var/TAG \
                            | .build/wordpress
	gcloud docker -- pull launcher.gcr.io/google/wordpress4-php5-apache
	docker tag launcher.gcr.io/google/wordpress4-php5-apache "$(REGISTRY):$(TAG)"
	gcloud docker -- push "$(REGISTRY):$(TAG)"
	@touch "$@"

# Build secondary app image.
.build/wordpress/init: init/* \
                       .build/var/REGISTRY \
                       .build/var/TAG \
                       | .build/wordpress
	cd init \
	&& docker build --tag "$(REGISTRY)/init:$(TAG)" .
	gcloud docker -- push "$(REGISTRY)/init:$(TAG)"
	@touch "$@"

# Relocate public mysql image to $REGISTRY.
.build/wordpress/mysql: .build/var/REGISTRY \
                        .build/var/TAG \
                        | .build/wordpress
	gcloud docker -- pull launcher.gcr.io/google/mysql5
	docker tag launcher.gcr.io/google/mysql5 "$(REGISTRY)/mysql:$(TAG)"
	gcloud docker -- push "$(REGISTRY)/mysql:$(TAG)"
	@touch "$@"

# Relocate public ubbagent image to $REGISTRY.
.build/wordpress/ubbagent: .build/ubbagent/ubbagent \
                 .build/var/REGISTRY \
                 .build/var/TAG \
                 | .build/wordpress
	#gcloud docker -- pull "gcr.io/google-marketplace-tools/ubbagent"
	docker tag "gcr.io/google-marketplace-tools/ubbagent" "$(REGISTRY)/ubbagent:$(TAG)"
	gcloud docker -- push "$(REGISTRY)/ubbagent:$(TAG)"
	@touch "$@"
