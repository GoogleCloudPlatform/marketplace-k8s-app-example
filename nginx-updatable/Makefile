TAG ?= latest

# Convenience makefiles.
include ../gcloud.Makefile
include ../var.Makefile

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

# app.Makefile provides the main targets for installing the
# application.
# It requires several APP_* variables defined above, and thus
# must be included after.
include ../app.Makefile


# Extend the target as defined in app.Makefile to
# include real dependencies.
app/build:: .build/nginx/deployer \
            .build/nginx/nginx \
            .build/nginx/tester


.build/nginx: | .build
	mkdir -p "$@"

.build/nginx/deployer: apptest/deployer/* \
                       apptest/deployer/nginx/* \
                       apptest/deployer/nginx/templates/* \
                       deployer/* \
                       nginx/* \
                       nginx/templates/* \
                       schema.yaml \
                       .build/var/APP_DEPLOYER_IMAGE \
                       .build/var/MARKETPLACE_TOOLS_TAG \
                       .build/var/REGISTRY \
                       .build/var/TAG \
                       | .build/nginx
	$(call print_target, $@)
	docker build \
	    --build-arg REGISTRY="$(REGISTRY)" \
	    --build-arg TAG="$(TAG)" \
	    --tag "$(APP_DEPLOYER_IMAGE)" \
	    -f deployer/Dockerfile \
	    .
	docker push "$(APP_DEPLOYER_IMAGE)"
	@touch "$@"


.build/nginx/tester: .build/var/TESTER_IMAGE \
                     | .build/nginx
	$(call print_target, $@)
	docker pull cosmintitei/bash-curl
	docker tag cosmintitei/bash-curl "$(TESTER_IMAGE)"
	docker push "$(TESTER_IMAGE)"
	@touch "$@"


# Simulate building of primary app image. Actually just copying public image to
# local registry.
.build/nginx/nginx: .build/var/REGISTRY \
                    .build/var/TAG \
                    | .build/nginx
	$(call print_target, $@)
	docker pull launcher.gcr.io/google/nginx1
	docker tag launcher.gcr.io/google/nginx1 "$(REGISTRY)/example/nginx:$(TAG)"
	docker push "$(REGISTRY)/example/nginx:$(TAG)"
	@touch "$@"
