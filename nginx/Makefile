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

APP_DEPLOYER_IMAGE ?= $(REGISTRY)/nginx/deployer:$(TAG)
NAME ?= nginx-1
APP_PARAMETERS ?= { \
  "name": "$(NAME)", \
  "namespace": "$(NAMESPACE)", \
  "imageNginx.image": "$(REGISTRY)/nginx:$(TAG)" \
}
TESTER_IMAGE ?= $(REGISTRY)/nginx/tester:$(TAG)
APP_TEST_PARAMETERS ?= { \
  "tester.image": "$(TESTER_IMAGE)" \
}

# Extend the target as defined in app.Makefile to
# include real dependencies.
app/build:: .build/nginx/deployer \
            .build/nginx/nginx

# Extend the target as defined in app.Makefile to
# include real dependencies.
app/build-test:: app/build \
                 .build/nginx/tester

.build/nginx: | .build
	mkdir -p "$@"

.build/nginx/deployer: apptest/deployer/* \
                       deployer/* \
                       nginx/* \
                       schema.yaml \
                       .build/marketplace/deployer/helm \
                       .build/var/APP_DEPLOYER_IMAGE \
                       .build/var/REGISTRY \
                       .build/var/TAG \
                       | .build/nginx
	docker build \
	    --build-arg REGISTRY="$(REGISTRY)" \
	    --build-arg TAG="$(TAG)" \
	    --tag "$(APP_DEPLOYER_IMAGE)" \
	    -f deployer/Dockerfile \
	    .
	docker push "$(APP_DEPLOYER_IMAGE)"
	@touch "$@"

.build/nginx/tester: apptest/* \
                     .build/var/REGISTRY \
                     .build/var/TAG \
                     | .build/nginx
	docker build \
	    --tag "$(REGISTRY)/nginx/tester:$(TAG)" \
	    -f apptest/tester/Dockerfile \
	    .
	docker push "$(REGISTRY)/nginx/tester:latest"
	@touch "$@"

# Simulate building of primary app image. Actually just copying public image to
# local registry.
.build/nginx/nginx: .build/var/REGISTRY \
                    .build/var/TAG \
                    | .build/nginx
	docker pull launcher.gcr.io/google/nginx1
	docker tag launcher.gcr.io/google/nginx1 "$(REGISTRY)/nginx:$(TAG)"
	docker push "$(REGISTRY)/nginx:$(TAG)"
	@touch "$@"
