APP_ID ?= example/wordpress-updatable

# Track should be the major.minor of RELEASE.
TRACK ?= 0.1

# Check directory versions/ for all available release values.
RELEASE ?= 0.1.1
ifneq ($(shell [ -d "versions/$(RELEASE)" ] && echo "OK"),OK)
  $(error "Release version $(RELEASE) doesn't exist. Check versions/ directory.")
endif

# Convenience makefiles.
include ../gcloud.Makefile
include ../var.Makefile

APP_DEPLOYER_IMAGE ?= $(REGISTRY)/$(APP_ID)/deployer:$(RELEASE)
APP_DEPLOYER_IMAGE_TRACK_TAG ?= $(REGISTRY)/$(APP_ID)/deployer:$(TRACK)
APP_GCS_PATH ?= $(GCS_URL)/$(APP_ID)/$(TRACK)
NAME ?= wordpress-updatable-1
REPORTING_SECRET ?= gs://cloud-marketplace-ops-test-kokoro/reporting_secrets/wordpress.yaml
APP_PARAMETERS ?= { \
  "name": "$(NAME)", \
  "namespace": "$(NAMESPACE)", \
  "reportingSecret": "$(REPORTING_SECRET)" \
}
# TODO(huyhg): Fix tester image.
TESTER_IMAGE ?= $(REGISTRY)/$(APP_ID)/tester:$(RELEASE)
APP_TEST_PARAMETERS ?= { \
  "imageTester": "$(TESTER_IMAGE)" \
}


# app_v2.Makefile provides the main targets for installing the
# application.
# It requires several APP_* variables defined above, and thus
# must be included after.
include ../app_v2.Makefile


# Extend the target as defined in app.Makefile to
# include real dependencies.
app/build:: .build/wordpress-updatable/deployer \
            .build/wordpress-updatable/init \
            .build/wordpress-updatable/mysql \
            .build/wordpress-updatable/tester \
            .build/wordpress-updatable/ubbagent \
            .build/wordpress-updatable/wordpress


.build/wordpress-updatable: | .build
	mkdir -p "$@"

.build/wordpress-updatable/deployer: .build/var/APP_DEPLOYER_IMAGE \
                                     .build/var/MARKETPLACE_TOOLS_TAG \
                                     .build/var/REGISTRY \
                                     .build/var/TRACK \
                                     .build/var/RELEASE \
                                     $(shell find apptest/deployer -type f) \
                                     $(shell find apptest/deployer/manifest -type f) \
                                     $(shell find deployer -type f) \
                                     $(shell find manifest -type f) \
                                     $(shell find versions -type f) \
                                     | .build/wordpress-updatable
	$(call print_target, $@)
	docker build \
	    --build-arg RELEASE="$(RELEASE)" \
	    --build-arg MARKETPLACE_TOOLS_TAG="$(MARKETPLACE_TOOLS_TAG)" \
	    --tag "$(APP_DEPLOYER_IMAGE)" \
	    -f deployer/Dockerfile \
	    .
	docker tag "$(APP_DEPLOYER_IMAGE)" "$(APP_DEPLOYER_IMAGE_TRACK_TAG)"
	docker push "$(APP_DEPLOYER_IMAGE_TRACK_TAG)"
	docker push "$(APP_DEPLOYER_IMAGE)"
	@touch "$@"


.build/wordpress-updatable/tester: .build/var/TESTER_IMAGE
	$(call print_target, $@)
	docker pull cosmintitei/bash-curl
	docker tag cosmintitei/bash-curl "$(TESTER_IMAGE)"
	docker push "$(TESTER_IMAGE)"
	@touch "$@"

# Simulate building of primary app image. Actually just copying public image to
# local registry.
.build/wordpress-updatable/wordpress: .build/var/REGISTRY \
                                      .build/var/TRACK \
                                      .build/var/RELEASE \
                                      | .build/wordpress-updatable
	$(call print_target, $@)
	docker pull launcher.gcr.io/google/wordpress4-php5-apache
	docker tag launcher.gcr.io/google/wordpress4-php5-apache "$(REGISTRY)/$(APP_ID):$(TRACK)"
	docker tag "$(REGISTRY)/$(APP_ID):$(TRACK)" "$(REGISTRY)/$(APP_ID):$(RELEASE)"
	docker push "$(REGISTRY)/$(APP_ID):$(TRACK)"
	docker push "$(REGISTRY)/$(APP_ID):$(RELEASE)"
	@touch "$@"

# Build secondary app image.
.build/wordpress-updatable/init: init/* \
                                 .build/var/REGISTRY \
                                 .build/var/TRACK \
                                 .build/var/RELEASE \
                                 | .build/wordpress-updatable
	$(call print_target, $@)
	cd init \
	&& docker build --tag "$(REGISTRY)/$(APP_ID)/init:$(TRACK)" .
	docker tag "$(REGISTRY)/$(APP_ID)/init:$(TRACK)" "$(REGISTRY)/$(APP_ID)/init:$(RELEASE)"
	docker push "$(REGISTRY)/$(APP_ID)/init:$(TRACK)"
	docker push "$(REGISTRY)/$(APP_ID)/init:$(RELEASE)"
	@touch "$@"

# Relocate public mysql image to $REGISTRY.
.build/wordpress-updatable/mysql: .build/var/REGISTRY \
                                  .build/var/TRACK \
                                  .build/var/RELEASE \
                                  | .build/wordpress-updatable
	$(call print_target, $@)
	docker pull launcher.gcr.io/google/mysql5
	docker tag launcher.gcr.io/google/mysql5 "$(REGISTRY)/$(APP_ID)/mysql:$(TRACK)"
	docker tag "$(REGISTRY)/$(APP_ID)/mysql:$(TRACK)" "$(REGISTRY)/$(APP_ID)/mysql:$(RELEASE)"
	docker push "$(REGISTRY)/$(APP_ID)/mysql:$(TRACK)"
	docker push "$(REGISTRY)/$(APP_ID)/mysql:$(RELEASE)"
	@touch "$@"

# Relocate ubbagent image to $REGISTRY.
.build/wordpress-updatable/ubbagent: .build/var/REGISTRY \
                                     .build/var/TRACK \
                                     .build/var/RELEASE \
                                     | .build/wordpress-updatable
	$(call print_target, $@)
	docker pull "gcr.io/cloud-marketplace-tools/metering/ubbagent:sha_dfb8b727bd23a7e48b6b4904f4fa2aad43634607"
	docker tag "gcr.io/cloud-marketplace-tools/metering/ubbagent:sha_dfb8b727bd23a7e48b6b4904f4fa2aad43634607" "$(REGISTRY)/$(APP_ID)/ubbagent:$(TRACK)"
	docker tag "$(REGISTRY)/$(APP_ID)/ubbagent:$(TRACK)" "$(REGISTRY)/$(APP_ID)/ubbagent:$(RELEASE)"
	docker push "$(REGISTRY)/$(APP_ID)/ubbagent:$(TRACK)"
	docker push "$(REGISTRY)/$(APP_ID)/ubbagent:$(RELEASE)"
	@touch "$@"
