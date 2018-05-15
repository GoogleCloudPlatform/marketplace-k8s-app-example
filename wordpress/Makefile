TAG ?= latest

NAME ?= wordpress-1
NAMESPACE ?= default

REGISTRY_FOR_DEPLOYER ?= $(REGISTRY)/wordpress

# TODO(ruela) Double check the correct registry to use here.
APP_TESTER_IMAGE = $(REGISTRY)/wordpress/tester:$(TAG)

######################
# Required Variables #
######################

MARKETPLACE_TOOLS_PATH = ../vendor/marketplace-tools/
APP_DEPLOYER_IMAGE ?= $(REGISTRY)/wordpress/deployer:$(TAG)
APP_PARAMETERS ?= { \
  "APP_INSTANCE_NAME": "$(NAME)", \
  "NAMESPACE": "$(NAMESPACE)", \
  "IMAGE_WORDPRESS": "$(REGISTRY)/wordpress:$(TAG)", \
  "IMAGE_INIT": "$(REGISTRY)/wordpress/init:$(TAG)", \
  "IMAGE_MYSQL": "$(REGISTRY)/wordpress/mysql:$(TAG)", \
  "IMAGE_UBBAGENT": "$(REGISTRY)/wordpress/ubbagent:$(TAG)" \
}
APP_TEST_PARAMETERS ?= { \
  "APP_TESTER_IMAGE": "$(APP_TESTER_IMAGE)" \
}

##########################
# End Required Variables #
##########################

# TODO(trironkk): Remove.
APP_INSTANCE_NAME = $(NAME)

include ../vendor/marketplace-tools/app.Makefile
include ../vendor/marketplace-tools/crd.Makefile
include ../vendor/marketplace-tools/ubbagent.Makefile
include ../vendor/marketplace-tools/gcloud.Makefile

app/build:: .build/deployer .build/wordpress .build/init .build/mysql .build/ubbagent

app/build-test:: app/build .build/tester

.build/deployer: schema.yaml deployer/* manifest/* apptest/deployer/* $(MARKETPLACE_BASE_BUILD)/deployer-kubectl | app/setup
	docker build \
	    --build-arg REGISTRY="$(REGISTRY_FOR_DEPLOYER)" \
	    --build-arg TAG="$(TAG)" \
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
.build/wordpress: | app/setup
	gcloud docker -- pull launcher.gcr.io/google/wordpress4-php5-apache
	docker tag launcher.gcr.io/google/wordpress4-php5-apache "$(REGISTRY)/wordpress:$(TAG)"
	gcloud docker -- push "$(REGISTRY)/wordpress:$(TAG)"
	@touch "$@"

# Build secondary app image.
.build/init: init/* | app/setup
	cd init \
	&& docker build --tag "$(REGISTRY)/wordpress/init:$(TAG)" .
	gcloud docker -- push "$(REGISTRY)/wordpress/init:$(TAG)"
	@touch "$@"

# Relocate public mysql image to $APP_REGISTRY.
.build/mysql: | app/setup
	gcloud docker -- pull launcher.gcr.io/google/mysql5
	docker tag launcher.gcr.io/google/mysql5 "$(REGISTRY)/wordpress/mysql:$(TAG)"
	gcloud docker -- push "$(REGISTRY)/wordpress/mysql:$(TAG)"
	@touch "$@"

# Relocate public ubbagent image to $APP_REGISTRY.
.build/ubbagent: $(UBBAGENT_BUILD)/ubbagent | app/setup
	gcloud docker -- pull "$(MARKETPLACE_REGISTRY)/ubbagent"
	docker tag "$(MARKETPLACE_REGISTRY)/ubbagent" "$(REGISTRY)/wordpress/ubbagent:$(TAG)"
	gcloud docker -- push "$(REGISTRY)/wordpress/ubbagent:$(TAG)"
	@touch "$@"
