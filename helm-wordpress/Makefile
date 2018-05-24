# This name should uniquely identify your application
APP_NAME = helm-example-wordpress


# A relative path to a submodule with marketplace tools repository.
# It will deliver generic Makefiles to be extended here and base container images specifications.
tools_path = ../vendor/marketplace-tools


# Include generic Makefiles from the marketplace-tools repository, ideally linked as
# a git submodule of the current repository.
include $(tools_path)/gcloud.Makefile
include $(tools_path)/crd.Makefile
include $(tools_path)/app.Makefile


# Define the image reference for the integration testing container.
APP_TESTER_IMAGE = $(REGISTRY)/tester:latest


# Define all the properties that will be populated to the deployment process.
# The list should cover all the required properties of the schema.yaml file.
define APP_PARAMETERS
{ \
  "APP_INSTANCE_NAME": "$(APP_INSTANCE_NAME)", \
  "NAMESPACE": "$(NAMESPACE)", \
  "image.WordPress.fullReference": "$(APP_REGISTRY):$(APP_TAG)", \
  "mariadb.image": "$(APP_REGISTRY)-mariadb:$(APP_TAG)" \
}
endef


# Define any additional properties that should be combined with APP_PARAMETERS to run
# a verification deployment (executing integration tests after the app installation).
define TEST_PARAMETERS
{ \
  "tester.image": "$(APP_TESTER_IMAGE)" \
}
endef


# Define all the dependencies that should be executed before running the application installation.
app/build:: .build/deployer .build/wordpress .build/mariadb


# Define all the dependencies that should be executed before running the verification (installation
# followed by the integration testing).
app/build-test:: app/build .build/tester


# Dependencies and actual instructions that should be executed to build your application's Deployer.
.build/deployer: schema.yaml deployer/* wordpress/* $(MARKETPLACE_BASE_BUILD)/deployer-helm $(APP_BUILD)/registry_prefix $(APP_BUILD)/tag | app/setup
	docker build \
	    --build-arg MARKETPLACE_REGISTRY="$(MARKETPLACE_REGISTRY)" \
	    --tag "$(APP_DEPLOYER_IMAGE)" \
	    -f deployer/Dockerfile \
	    .
	gcloud docker -- push "$(APP_DEPLOYER_IMAGE)"
	@touch "$@"


# Dependencies and actual instructions that should be executed to build your application's
# integration testing container image.
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