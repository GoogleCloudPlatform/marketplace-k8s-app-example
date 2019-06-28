# Overview

This repository contains example Kubernetes applications ("apps") that meet the
requirements for integration with Google Cloud Marketplace. For a complete
description of those requirements, see the technical onboarding guide.
*TODO: add link*

The related [marketplace-k8s-app-tools](https://github.com/GoogleCloudPlatform/marketplace-k8s-app-tools)
repository contains utilities for testing the integration of an app with
Marketplace, including a test harness for simulating UI-based deployment.
The repository is submoduled under `/vendor/marketplace-tools`.

# Getting started

## Updating git submodules

You can run the following commands to make sure submodules
are populated with proper code.

```shell
git submodule sync --recursive
git submodule update --recursive --init --force
```

## Setting up your cluster and environment

See [Getting Started](https://github.com/GoogleCloudPlatform/marketplace-k8s-app-tools/blob/master/README.md#getting-started)

## Installing WordPress

Run the following commands from within `wordpress` folder.

Run app/doctor to determine any necessary setup steps for the cluster:

```shell
make app/doctor
```

Build and install WordPress onto your cluster:

```shell
export REPORTING_SECRET=gs://cloud-marketplace-tools/reporting_secrets/fake_reporting_secret.yaml
make app/install
```

This will build the containers and install the application. Note that the
reporting secret installed for usage reporting is structurally correct, but
the keys are fake. Usage reports will fail.

To delete the installation, run:

```shell
make app/uninstall
```

## Overriding context values (Optional)

By default `make` derives docker registry and k8s namespace
from your local configurations of `gcloud` and `kubectl`.

You can see these values using

```shell
kubectl config view
```

If you want to use values that differ from the local context of `gcloud` and `kubectl`,
you can override them by exporting the appropriate environment variables:

```shell
export REGISTRY=gcr.io/your-registry
export NAMESPACE=your-namespace
export APP_INSTANCE_NAME=your-installation-name
export APP_TAG=your-tag
```

# Marketplace Integration Requirements

Briefly, apps must support two modes of installation:
- **CLI**: via a Kubernetes client tool like kubectl or helm
- **Marketplace UI**: via the deployment container ("deployer") mechanism.

A few additional Marketplace requirements are described below.

## Application resource and controller

Apps must supply an Application resource conforming to the
[Kubernetes community proposal](https://github.com/kubernetes/community/pull/1629).
The proposal describes the Application resource, as well as a corresponding
controller that would be responsible for application-generic functionality such
as assigning owner references to application components.

**Temporary Note**: the public source repository associated with the proposal is
not yet available. In the interim, we have an equivalent CRD and controller in
the marketplace-k8s-app-tools repository. Expect changes once the public repo is
available.

## Deployer

Apps must supply a deployment container image ("deployer") which is used in
UI-based deployment. This image should extend from one of the base images
provided in the marketplace-k8s-app-tools repository.
