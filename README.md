# Overview

This repository contains example Kubernetes applications ("apps") that meet the
requirements for integration with Google Cloud Marketplace. For a complete
description of those requirements, see the technical onboarding guide.
*TODO: add link*

The related [marketplace-k8s-app-tools](https://github.com/GoogleCloudPlatform/marketplace-k8s-app-tools)
repository contains utilities for testing the integration of an app with
Marketplace, including a test harness for simulating UI-based deployment.
See instructions in that repository.

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
