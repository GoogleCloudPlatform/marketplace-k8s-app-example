TAG ?= latest

# crd.Makefile provides targets to install Application CRD.
include ../vendor/marketplace-tools/crd.Makefile

# gcloud.Makefile provides default values for
# REGISTRY and NAMESPACE derived from local
# gcloud and kubectl environments.
include ../vendor/marketplace-tools/gcloud.Makefile

# marketplace.Makefile provides targets such as
# ".build/marketplace/deployer/envsubst" to build the base
# deployer images locally.
include ../vendor/marketplace-tools/marketplace.Makefile

# ubbagent.Makefile provides ".build/ubbagent/ubbagent"
# target to build the ubbagent image locally.
include ../vendor/marketplace-tools/ubbagent.Makefile
include ../vendor/marketplace-tools/var.Makefile

# app.Makefile provides the main targets for installing the
# application.
# It requires several APP_* variables defined as followed.
include ../vendor/marketplace-tools/app.Makefile

APP_DEPLOYER_IMAGE ?= $(REGISTRY)/example/wordpress/deployer:$(TAG)
NAME ?= wordpress-1
APP_PARAMETERS ?= { \
  "name": "$(NAME)", \
  "namespace": "$(NAMESPACE)", \
  "imageWordpress": "$(REGISTRY)/example/wordpress:$(TAG)", \
  "imageInit": "$(REGISTRY)/example/wordpress/init:$(TAG)", \
  "imageMysql": "$(REGISTRY)/example/wordpress/mysql:$(TAG)", \
  "imageUbbagent": "$(REGISTRY)/example/wordpress/ubbagent:$(TAG)", \
  "reportingSecret": "$(NAME)-reporting-secret" \
}
TESTER_IMAGE ?= $(REGISTRY)/example/wordpress/tester:$(TAG)
APP_TEST_PARAMETERS ?= { \
  "imageTester": "$(TESTER_IMAGE)" \
}

# Extend the target as defined in app.Makefile to
# include real dependencies.
app/build:: .build/wordpress
# app/build:: .build/marketplace/dev \
#             .build/wordpress/deployer \
#             .build/wordpress/init \
#             .build/wordpress/mysql \
#             .build/wordpress/tester \
#             .build/wordpress/ubbagent \
#             .build/wordpress/wordpress


app/verify: .build/wordpress/verify


.build/wordpress/verify: | .build/wordpress
	$(call print_target)
	docker run \
	    --volume "/var/run/docker.sock:/var/run/docker.sock:ro" \
	    --volume "$(HOME)/.kube:/root/mount/.kube:ro" \
	    --volume "$(HOME)/.config/gcloud:/root/mount/.config/gcloud:ro" \
	    --rm \
	    "gcr.io/cloud-marketplace-tools/k8s/dev:latest" \
	    -x \
	    -c \
	    "gcloud auth list; kubectl get namespace"
	@touch "$@"

.build/wordpress: | .build
	mkdir -p "$@"

.build/wordpress/deployer: .build/marketplace/deployer/envsubst \
                           .build/var/APP_DEPLOYER_IMAGE \
                           .build/var/REGISTRY \
                           .build/var/TAG \
                           apptest/deployer/* \
                           apptest/deployer/manifest/* \
                           deployer/* \
                           manifest/* \
                           schema.yaml \
                           | .build/wordpress
	$(call print_target, $@)
	docker build \
	    --build-arg REGISTRY="$(REGISTRY)/example/wordpress" \
	    --build-arg TAG="$(TAG)" \
	    --tag "$(APP_DEPLOYER_IMAGE)" \
	    -f deployer/Dockerfile \
	    .
	docker push "$(APP_DEPLOYER_IMAGE)"
	@touch "$@"


.build/wordpress/tester: .build/var/TESTER_IMAGE
	$(call print_target, $@)
	docker pull cosmintitei/bash-curl
	docker tag cosmintitei/bash-curl "$(TESTER_IMAGE)"
	docker push "$(TESTER_IMAGE)"
	@touch "$@"

# Simulate building of primary app image. Actually just copying public image to
# local registry.
.build/wordpress/wordpress: .build/var/REGISTRY \
                            .build/var/TAG \
                            | .build/wordpress
	$(call print_target, $@)
	docker pull launcher.gcr.io/google/wordpress4-php5-apache
	docker tag launcher.gcr.io/google/wordpress4-php5-apache "$(REGISTRY)/example/wordpress:$(TAG)"
	docker push "$(REGISTRY)/example/wordpress:$(TAG)"
	@touch "$@"

# Build secondary app image.
.build/wordpress/init: init/* \
                       .build/var/REGISTRY \
                       .build/var/TAG \
                       | .build/wordpress
	$(call print_target, $@)
	cd init \
	&& docker build --tag "$(REGISTRY)/example/wordpress/init:$(TAG)" .
	docker push "$(REGISTRY)/example/wordpress/init:$(TAG)"
	@touch "$@"

# Relocate public mysql image to $REGISTRY.
.build/wordpress/mysql: .build/var/REGISTRY \
                        .build/var/TAG \
                        | .build/wordpress
	$(call print_target, $@)
	docker pull launcher.gcr.io/google/mysql5
	docker tag launcher.gcr.io/google/mysql5 "$(REGISTRY)/example/wordpress/mysql:$(TAG)"
	docker push "$(REGISTRY)/example/wordpress/mysql:$(TAG)"
	@touch "$@"

# Relocate ubbagent image to $REGISTRY.
.build/wordpress/ubbagent: .build/ubbagent/ubbagent \
                           .build/var/REGISTRY \
                           .build/var/TAG \
                           | .build/wordpress
	$(call print_target, $@)
	docker tag "gcr.io/cloud-marketplace-tools/ubbagent" "$(REGISTRY)/example/wordpress/ubbagent:$(TAG)"
	docker push "$(REGISTRY)/example/wordpress/ubbagent:$(TAG)"
	@touch "$@"
