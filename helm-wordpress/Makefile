APP_NAME = helm-example-wordpress

tools_path = ../vendor/marketplace-tools

include $(tools_path)/gcloud.Makefile

include $(tools_path)/crd.Makefile
include $(tools_path)/app.Makefile

APP_TESTER_IMAGE = $(REGISTRY)/tester:latest

define APP_PARAMETERS
{ \
  "APP_INSTANCE_NAME": "$(APP_INSTANCE_NAME)", \
  "NAMESPACE": "$(NAMESPACE)", \
  "image.WordPress.fullReference": "$(APP_REGISTRY):$(APP_TAG)", \
  "mariadb.image": "$(APP_REGISTRY)-mariadb:$(APP_TAG)" \
}
endef

define TEST_PARAMETERS
{ \
  "tester.image": "$(APP_TESTER_IMAGE)" \
}
endef

app/build:: .build/deployer .build/wordpress .build/mariadb

app/build-test:: app/build .build/tester

.build/deployer: schema.yaml deployer/* wordpress/* $(MARKETPLACE_BASE_BUILD)/deployer-helm $(APP_BUILD)/registry_prefix $(APP_BUILD)/tag | app/setup
	docker build \
	    --build-arg MARKETPLACE_REGISTRY="$(MARKETPLACE_REGISTRY)" \
	    --tag "$(APP_DEPLOYER_IMAGE)" \
	    -f deployer/Dockerfile \
	    .
	gcloud docker -- push "$(APP_DEPLOYER_IMAGE)"
	@touch "$@"

.build/tester: apptest/* $(APP_BUILD)/registry_prefix | app/setup
	docker build \
	    --tag "$(APP_TESTER_IMAGE)" \
	    -f apptest/tester/Dockerfile \
	    .
	gcloud docker -- push "$(APP_TESTER_IMAGE)"
	@touch "$@"

# Simulate building of primary app image. Actually just copying public image to
# local registry.
.build/wordpress: $(APP_BUILD)/registry_prefix $(APP_BUILD)/tag | app/setup
	gcloud docker -- pull docker.io/bitnami/wordpress:4.9.5
	docker tag docker.io/bitnami/wordpress:4.9.5 "$(APP_REGISTRY):$(APP_TAG)"
	gcloud docker -- push "$(APP_REGISTRY):$(APP_TAG)"
	@touch "$@"

# Simulate building of primary app image. Actually just copying public image to
# local registry.
.build/mariadb: $(APP_BUILD)/registry_prefix $(APP_BUILD)/tag | app/setup
	gcloud docker -- pull docker.io/bitnami/mariadb:10.1.29-r1
	docker tag docker.io/bitnami/mariadb:10.1.29-r1 "$(APP_REGISTRY)-mariadb:$(APP_TAG)"
	gcloud docker -- push "$(APP_REGISTRY)-mariadb:$(APP_TAG)"
	@touch "$@"