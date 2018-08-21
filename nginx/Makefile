TAG ?= local-$(USER)

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

APP_DEPLOYER_IMAGE ?= $(REGISTRY)/example/nginx/deployer:$(TAG)
NAME ?= nginx-1
APP_PARAMETERS ?= { \
  "name": "$(NAME)", \
  "namespace": "$(NAMESPACE)", \
  "imageNginx.image": "$(REGISTRY)/example/nginx:$(TAG)" \
}
TESTER_IMAGE ?= $(REGISTRY)/example/nginx/tester:$(TAG)
APP_TEST_PARAMETERS ?= { \
  "tester.image": "$(TESTER_IMAGE)" \
}

PROJECT_ID ?= $(shell gcloud config get-value project)

# Extend the target as defined in app.Makefile to
# include real dependencies.
app/build:: \
		.build/nginx/deployer \
		.build/nginx/nginx \
		.build/nginx/tester


.build/nginx: \
		| .build
	mkdir -p "$@"

.build/nginx/deployer: \
		deployer/* \
		deployer/apptest/deployer/* \
		deployer/apptest/deployer/nginx/* \
		deployer/apptest/deployer/nginx/templates/* \
		deployer/nginx/* \
		deployer/nginx/templates/* \
		schema.yaml \
		.build/var/APP_DEPLOYER_IMAGE \
		.build/var/REGISTRY \
		.build/var/TAG \
		| .build/nginx
	$(call print_target, $@)
	deployer/build \
	  --project_id=$(PROJECT_ID) \
	  --tag=$(TAG)
	@touch "$@"


.build/nginx/tester: \
		tester/* \
		.build/var/PROJECT_ID \
		.build/var/TAG \
		| .build/nginx
	$(call print_target, $@)
	tester/build \
	  --project_id=$(PROJECT_ID) \
	  --tag=$(TAG)
	@touch "$@"


.build/nginx/nginx: \
		nginx/* \
		.build/var/REGISTRY \
		.build/var/TAG \
		| .build/nginx
	$(call print_target, $@)
	nginx/build \
	  --project_id=$(PROJECT_ID) \
	  --tag=$(TAG)
	@touch "$@"
