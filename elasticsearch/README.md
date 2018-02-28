# Installation

## Command line instructions

Follow these instructions to install Elasticsearch from the command line.

### Commands

Set environment variables (modify if necessary):
```
export APPLICATION_NAME=elasticsearch-1
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
