ARG MARKETPLACE_REGISTRY
FROM ${MARKETPLACE_REGISTRY}/deployer_kubectl_base

# TODO: Remove environment parameters once the frontend supports parameters.
ARG REGISTRY
ARG TAG
ENV IMAGE_WORDPRESS "$REGISTRY:$TAG"
ENV IMAGE_INIT "$REGISTRY/init:$TAG"
ENV IMAGE_MYSQL "$REGISTRY/mysql:$TAG"
ENV IMAGE_UBBAGENT "$REGISTRY/ubbagent:$TAG"

ADD manifest/* /data/manifest/
ADD manifest-test/* /data-test/manifest/
COPY apptest/config.yaml /data-test/
ADD schema.yaml /data/schema.yaml
