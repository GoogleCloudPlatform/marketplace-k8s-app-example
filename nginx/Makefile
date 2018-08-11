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

# Extend the target as defined in app.Makefile to
# include real dependencies.
app/build:: .build/nginx/deployer
# app/build:: .build/nginx/deployer \
#             .build/nginx/nginx \
#             .build/nginx/tester


app/verify: .build/nginx/verify


.build/nginx/verify: | .build/nginx
	$(call print_target)
	docker run \
	    --volume "/var/run/docker.sock:/var/run/docker.sock:ro" \
	    --volume "$(HOME)/.kube:/root/mount/.kube:ro" \
	    --volume "$(HOME)/.config/gcloud:/root/mount/.config/gcloud:ro" \
	    --rm \
	    "gcr.io/cloud-marketplace-tools/k8s/dev:latest" \
	    -x \
	    -c \
	    "kubectl get namespace"
	@touch "$@"


.build/nginx: | .build
	mkdir -p "$@"

.build/nginx/deployer: apptest/deployer/* \
                       apptest/deployer/nginx/* \
                       apptest/deployer/nginx/templates/* \
                       deployer/* \
                       nginx/* \
                       nginx/templates/* \
                       schema.yaml \
                       .build/marketplace/deployer/helm \
                       .build/var/APP_DEPLOYER_IMAGE \
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
