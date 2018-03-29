# Installation

## Command line instructions

Follow these instructions to install Elasticsearch from the command line.

### Commands

Set environment variables (modify if necessary):
```
export APP_INSTANCE_NAME=memcached-1
export NAMESPACE=database
```

Expand manifest template:
```
cat manifest/* | envsubst > expanded.yaml
```

Run kubectl:
```
kubectl apply -f expanded.yaml
```
