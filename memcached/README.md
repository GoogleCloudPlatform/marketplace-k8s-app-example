*This directory contains an example Kubernetes application (app) based on
Memcached for the purpose of demonstrating app integration with
Google Cloud Marketplace. **Not intended for actual use!***

*Content below is intended as a template for end-user documentation. Work in
progress.*

# Overview

Memcached is distributed memory caching system that is meant to accelerate retrival of data from database tier by applications.

# Installation

## Quick install with Google Cloud Marketplace

Deploy Memcached solution to your Google Kubernetes Engine cluster using Google Cloud Marketplace with just a few clicks.

Follow the link below, tune configuration parameters and run the solution.

*TODO (update the link) https://cloud.google.com/launcher/*


### Prerequisites

- Kubernetes cluster with appropriate permissions assigned to a user/process deploying Memcached solution

*TODO: add details above*

### Commands

Set environment variables (modify if necessary):
```
export APP_INSTANCE_NAME=memcached-1
export NAMESPACE=default
```

Expand manifest template:
```
cat manifest/* | envsubst > expanded.yaml
```

Run kubectl:
```
kubectl apply -f expanded.yaml
```

# Backups

Memcached cluster solution doesn't need any specific backup procedure.

# Upgrades

*TODO: instructions for upgrades*
