TAG ?= local

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

PROJECT_ID ?= $(shell gcloud config get-value project)
MARKETPLACE_TOOLS_TAG ?= sha_52378efdad5b9da6885f37ae53959c73464c4ffd

# Extend the target as defined in app.Makefile to
# include real dependencies.
app/build:: .build/wordpress/deployer \
            .build/wordpress/init \
            .build/wordpress/mysql \
            .build/wordpress/tester \
            .build/wordpress/ubbagent \
            .build/wordpress/wordpress


.build/wordpress: | .build
	mkdir -p "$@"

.build/wordpress/deployer: deployer/* \
                           manifest/* \
                           schema.yaml \
                           .build/var/PROJECT_ID \
                           | .build/wordpress
	$(call print_target, $@)
	PROJECT_ID="$(PROJECT_ID)" MARKETPLACE_TOOLS_TAG="$(MARKETPLACE_TOOLS_TAG)" deployer/build
	@touch "$@"


.build/wordpress/tester: tester/* \
                         .build/var/PROJECT_ID \
                         | .build/wordpress
	$(call print_target, $@)
	PROJECT_ID="$(PROJECT_ID)" tester/build
	@touch "$@"

.build/wordpress/wordpress: wordpress/* \
                            .build/var/PROJECT_ID \
                            | .build/wordpress
	$(call print_target, $@)
	PROJECT_ID="$(PROJECT_ID)" wordpress/build
	@touch "$@"

# Build secondary app image.
.build/wordpress/init: init/* \
                       .build/var/PROJECT_ID \
                       | .build/wordpress
	$(call print_target, $@)
	PROJECT_ID="$(PROJECT_ID)" init/build
	@touch "$@"

.build/wordpress/mysql: mysql/* \
                        .build/var/PROJECT_ID \
                        | .build/wordpress
	$(call print_target, $@)
	PROJECT_ID="$(PROJECT_ID)" mysql/build
	@touch "$@"

.build/wordpress/ubbagent: .build/ubbagent/ubbagent \
                           .build/var/PROJECT_ID \
                           ubbagent/* \
                           | .build/wordpress
	$(call print_target, $@)
	PROJECT_ID="$(PROJECT_ID)" ubbagent/build
	@touch "$@"
