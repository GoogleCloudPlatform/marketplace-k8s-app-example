# Overview

This repository contains third party Kubernetes Applications that can
be listed in (and deployed via) Google Cloud Marketplace.

The marketplace-k8s-app-tools repository contains utilities that interact
with Applications in this repository in an analogous manner to Google
Cloud Marketplace, and can be used for rapid iteration.

## Implementation Overview

### Launcher Integrations

The root level Makefile in this repository is only intended to be invoked
from a marketplace-k8s-app-tools repository, and it only serves to
dispatch build targets to Application specific subdirectories. An
illustrative wordpress example Application is provided by default.

The following integration points are necesseary to facilitate integration
with Google Cloud Marketplace.

#### Deployer

Applications must create a deployer container is based on the
deployer_kubectl_base image in marketplace-k8s-app-tools and include
relevant manifest templates.

This deployer container will be created by Cloud Marketplace, and will
be passed the following environment variables:

* APPLICATION_NAME
  * the name that uniquely identifies the Application
* NAMESPACE
  * the namespace in which the Application's resources will be created
* REGISTRY
  * the registry in which Application image resources will reside

The Application's manfiest templates should include $APPLICATION_NAME
in all resource names in order prevent naming collisions.

#### Controller

Manifest templates must include a Deployment based on the controller
image in marketplace-k8s-app-tools.

This controller Deployment will monitor the health status of all manifest
resources and assign owner references.

### Command Line Installation

TODO(trironkk): Fill me in.
