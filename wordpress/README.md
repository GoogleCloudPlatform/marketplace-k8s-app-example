*This directory contains an example Kubernetes application (app) based on
WordPress for the purpose of demonstrating app integration with
Google Cloud Marketplace. **Not intended for actual use!***

*Content below is intended as a template for end-user documentation. Work in
progress.*

# Overview

WordPress is a free and open-source content management system (CMS) based on PHP
and MySQL...

# Installation

## Quick install with Google Cloud Marketplace

Get up and running with a few clicks! Install this WordPress app to a
Google Kubernetes Engine cluster using Google Cloud Marketplace. Follow the
on-screen instructions:
*TODO: link to solution details page*

## Command line instructions

Follow these instructions to install WordPress from the command line.

### Prerequisites

- Setup cluster
  - Permissions
- Setup kubectl
- Install Application Resource
- Acquire and apply license key in the target namespace (from "Deploy via command line" tab")

*TODO: add details above*

### Commands

Set environment variables (modify if necessary):
```
export name=wordpress-1
export namespace=default
export imageWordpress=launcher.gcr.io/google/wordpress:4
export imageInit=launcher.gcr.io/google/wordpress/init:4
export imageMysql=launcher.gcr.io/google/mysql:5
export imageUbbagent=launcher.gcr.io/google/ubbagent

# Use the name of the secret created for the license key
export reportingSecret=<license-key-secret-name>
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
