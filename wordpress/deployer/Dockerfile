ARG MARKETPLACE_REGISTRY
FROM ${MARKETPLACE_REGISTRY}/deployer_kubectl_base

# TODO: Remove environment parameters once the frontend supports parameters.
ARG REGISTRY
ARG TAG
ENV IMAGE_WORDPRESS "$REGISTRY:$TAG"
ENV IMAGE_INIT "$REGISTRY/init:$TAG"
ENV IMAGE_MYSQL "$REGISTRY/mysql:$TAG"
ENV IMAGE_UBBAGENT "$REGISTRY/ubbagent:$TAG"

ADD schema.yaml /data/
COPY manifest /data/manifest
COPY apptest/deployer /data-test/

RUN cat /data/schema.yaml \
    | env -i "REGISTRY=$REGISTRY" "TAG=$TAG" envsubst \
    > /data/schema.yaml.new \
    && mv /data/schema.yaml.new /data/schema.yaml
