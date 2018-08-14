FROM gcr.io/cloud-marketplace-tools/k8s/deployer_envsubst:local

# Provide registry prefix and tag for default values for images.
ARG REGISTRY
ARG TAG

ADD schema.yaml /tmp/schema.yaml
RUN cat /tmp/schema.yaml \
    | env -i "REGISTRY=$REGISTRY" "TAG=$TAG" envsubst \
    > /tmp/schema.yaml.new \
    && mv /tmp/schema.yaml.new /data/schema.yaml

COPY manifest /data/manifest
COPY apptest/deployer /data-test/
