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

# Define the deployer image reference
APP_DEPLOYER_IMAGE ?= $(REGISTRY)/helm-wordpress/deployer:$(TAG)

# Define the name of the deployment, if not defined yet
NAME ?= helm-wordpress-1

# Define all the properties that will be populated to the deployment process.
# The list should cover all the required properties of the schema.yaml file.
define APP_PARAMETERS
{ \
  "name": "$(NAME)", \
  "namespace": "$(NAMESPACE)", \
  "image.WordPress.fullReference": "$(REGISTRY)/helm-wordpress:$(TAG)", \
  "mariadb.image": "$(REGISTRY)/helm-wordpress-mariadb:$(TAG)" \
}
endef

# Define the image reference for the integration testing container.
TESTER_IMAGE = $(REGISTRY)/tester:latest

# Define any additional properties that should be combined with APP_PARAMETERS to run
# a verification deployment (executing integration tests after the app installation).
define TEST_PARAMETERS
{ \
  "tester.image": "$(APP_TESTER_IMAGE)" \
}
endef


# Define all the dependencies that should be executed before running the application installation.
app/build:: .build/helm-wordpress/deployer \
            .build/helm-wordpress/wordpress \
            .build/helm-wordpress/mariadb


# Define all the dependencies that should be executed before running the verification (installation
# followed by the integration testing).
app/build-test:: app/build .build/tester


.build/helm-wordpress: | .build
	mkdir -p "$@"

# Dependencies and actual instructions that should be executed to build your application's Deployer.
.build/helm-wordpress/deployer: schema.yaml deployer/* wordpress/* \
                                .build/marketplace/deployer/helm \
                                .build/var/APP_DEPLOYER_IMAGE \
                                .build/var/REGISTRY \
                                .build/var/TAG \
                                | .build/helm-wordpress
	docker build \
		--build-arg REGISTRY="$(REGISTRY)" \
		--build-arg TAG="$(TAG)" \
		--tag "$(APP_DEPLOYER_IMAGE)" \
		-f deployer/Dockerfile \
		.
	gcloud docker -- push "$(APP_DEPLOYER_IMAGE)"
	@touch "$@"


# Dependencies and actual instructions that should be executed to build your application's
# integration testing container image.
.build/helm-wordpress/tester: apptest/* \
                              .build/var/REGISTRY \
                              .build/var/TAG \
                              | .build/helm-wordpress
	docker build \
		--tag "$(REGISTRY)/helm-wordpress/tester:$(TAG)" \
		-f apptest/tester/Dockerfile \
		.
	docker push "$(REGISTRY)/helm-wordpress/tester:latest"
	@touch "$@"


# Simulate building of primary app image. Actually just copying public image to
# local registry.
.build/helm-wordpress/wordpress: .build/var/REGISTRY \
                                 .build/var/TAG \
                                 | .build/helm-wordpress
	gcloud docker -- pull docker.io/bitnami/wordpress:4.9.5
	docker tag docker.io/bitnami/wordpress:4.9.5 "$(REGISTRY)/helm-wordpress:$(TAG)"
	gcloud docker -- push "$(REGISTRY)/helm-wordpress:$(TAG)"
	@touch "$@"


# Simulate building of primary app image. Actually just copying public image to
# local registry.
.build/helm-wordpress/mariadb: .build/var/REGISTRY \
                               .build/var/TAG \
                               | .build/helm-wordpress
	gcloud docker -- pull docker.io/bitnami/mariadb:10.1.29-r1
	docker tag docker.io/bitnami/mariadb:10.1.29-r1 "$(REGISTRY)/helm-wordpress-mariadb:$(TAG)"
	gcloud docker -- push "$(REGISTRY)/helm-wordpress-mariadb:$(TAG)"
	@touch "$@"

