TAG ?= latest

# Convenience makefiles.
include ../gcloud.Makefile
include ../var.Makefile

RELEASE ?= 0.1.1
APP_DEPLOYER_IMAGE ?= $(REGISTRY)/example/wordpress/deployer:$(TAG)
APP_DEPLOYER_IMAGE_TRACK_TAG ?= $(REGISTRY)/$(APP_ID)/deployer:$(TRACK)
APP_GCS_PATH ?= $(GCS_URL)/$(APP_ID)/$(TRACK)
NAME ?= wordpress-1
REPORTING_SECRET ?= gs://cloud-marketplace-ops-test-kokoro/reporting_secrets/wordpress.yaml
APP_PARAMETERS ?= { \
  "name": "$(NAME)", \
  "namespace": "$(NAMESPACE)", \
  "reportingSecret": "$(REPORTING_SECRET)" \
}
TESTER_IMAGE ?= $(REGISTRY)/example/wordpress/tester:$(TAG)

# app_v2.Makefile provides the main targets for installing the
# application.
# It requires several APP_* variables defined above, and thus
# must be included after.
include ../app_v2.Makefile


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

.build/wordpress/deployer: .build/var/APP_DEPLOYER_IMAGE \
                           .build/var/MARKETPLACE_TOOLS_TAG \
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
	    --build-arg MARKETPLACE_TOOLS_TAG="$(MARKETPLACE_TOOLS_TAG)" \
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
	docker pull marketplace.gcr.io/google/wordpress5-php7-apache
	docker tag marketplace.gcr.io/google/wordpress5-php7-apache "$(REGISTRY)/example/wordpress:$(TAG)"
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
	docker pull marketplace.gcr.io/google/mysql5
	docker tag marketplace.gcr.io/google/mysql5 "$(REGISTRY)/example/wordpress/mysql:$(TAG)"
	docker push "$(REGISTRY)/example/wordpress/mysql:$(TAG)"
	@touch "$@"

# Relocate ubbagent image to $REGISTRY.
.build/wordpress/ubbagent: .build/var/REGISTRY \
                           .build/var/TAG \
                           | .build/wordpress
	$(call print_target, $@)
	docker pull "gcr.io/cloud-marketplace-tools/metering/ubbagent"
	docker tag "gcr.io/cloud-marketplace-tools/metering/ubbagent" "$(REGISTRY)/example/wordpress/ubbagent:$(TAG)"
	docker push "$(REGISTRY)/example/wordpress/ubbagent:$(TAG)"
	@touch "$@"
