APP_ID ?= example/nginx-updatable

# Track should be the major.minor of RELEASE.
TRACK ?= 0.1

# Check directory versions/ for all available release values.
RELEASE ?= 0.1.1
ifneq ($(shell [[ -d "versions/$(RELEASE)" ]] && echo "OK"),OK)
  $(error "Release version $(RELEASE) doesn't exist. Check versions/ directory.")
endif
TRACK ?= 0.1

# Convenience makefiles.
include ../gcloud.Makefile
include ../var.Makefile

APP_DEPLOYER_IMAGE ?= $(REGISTRY)/$(APP_ID)/deployer:$(RELEASE)
APP_DEPLOYER_IMAGE_TRACK_TAG ?= $(REGISTRY)/$(APP_ID)/deployer:$(TRACK)
APP_GCS_PATH ?= $(GCS_URL)/$(APP_ID)/$(TRACK)
NAME ?= nginx-updatable-1
APP_PARAMETERS ?= { \
  "name": "$(NAME)", \
  "namespace": "$(NAMESPACE)" \
}
APP_TEST_PARAMETERS ?= {}


# app.Makefile provides the main targets for installing the
# application.
# It requires several APP_* variables defined above, and thus
# must be included after.
include ../app_v2.Makefile


# Extend the target as defined in app.Makefile to
# include real dependencies.
app/build:: .build/nginx-updatable/deployer \
            .build/nginx-updatable/nginx


.build/nginx-updatable: | .build
	mkdir -p "$@"


.build/nginx-updatable/deployer: .build/var/APP_DEPLOYER_IMAGE \
                                 .build/var/MARKETPLACE_TOOLS_TAG \
                                 .build/var/REGISTRY \
                                 .build/var/TRACK \
                                 .build/var/RELEASE \
                                 $(shell find deployer -type f) \
                                 $(shell find versions -type f) \
                                 | .build/nginx-updatable
	$(call print_target, $@)
	docker build \
	    --tag "$(APP_DEPLOYER_IMAGE)" \
	    --build-arg MARKETPLACE_TOOLS_TAG="$(MARKETPLACE_TOOLS_TAG)" \
	    -f deployer/Dockerfile \
	    versions/$(RELEASE)
	docker tag "$(APP_DEPLOYER_IMAGE)" "$(APP_DEPLOYER_IMAGE_TRACK_TAG)"
	docker push "$(APP_DEPLOYER_IMAGE_TRACK_TAG)"
	docker push "$(APP_DEPLOYER_IMAGE)"
	@touch "$@"


# Simulate building of primary app image. Actually just copying public image to
# local registry.
.build/nginx-updatable/nginx: .build/var/APP_ID \
                              .build/var/REGISTRY \
                              .build/var/TRACK \
                              .build/var/RELEASE \
                              | .build/nginx-updatable
	$(call print_target, $@)
	docker pull launcher.gcr.io/google/nginx1
	docker tag launcher.gcr.io/google/nginx1 "$(REGISTRY)/$(APP_ID):$(RELEASE)"
	docker tag "$(REGISTRY)/$(APP_ID):$(RELEASE)" "$(REGISTRY)/$(APP_ID):$(TRACK)"
	docker push "$(REGISTRY)/$(APP_ID):$(RELEASE)"
	docker push "$(REGISTRY)/$(APP_ID):$(TRACK)"
	@touch "$@"
