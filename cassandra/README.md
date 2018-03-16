*This directory contains an example Kubernetes application (app) based on
Cassandra for the purpose of demonstrating app integration with
Google Cloud Marketplace. **Not intended for actual use!***

*Content below is intended as a template for end-user documentation. Work in
progress.*

# Overview

Cassandra is a NoSQL database with masterless replication for high availability...

# Installation

## Quick install with Google Cloud Marketplace

Get up and running with a few clicks! Install this Cassandra app to a
Google Kubernetes Engine cluster using Google Cloud Marketplace. Follow the
on-screen instructions:
*TODO: link to solution details page*

## Command line instructions

Follow these instructions to install Cassandra from the command line.

### Prerequisites

- Setup cluster
  - Permissions
- Setup kubectl
- Install Application Resource
- Acquire License

*TODO: add details above*

### Commands

Set environment variables (modify if necessary):
```
export APP_INSTANCE_NAME=cassandra-1
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

*TODO: fix instructions*

# Backups

*TODO: instructions for backups*

# Upgrades

*TODO: instructions for upgrades*
