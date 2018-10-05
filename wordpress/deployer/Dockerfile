FROM gcr.io/cloud-marketplace-tools/k8s/deployer_envsubst:sha_7c70bcd83a8c490a11f93abfc4ec7a5f39c61ab6

# Provide registry prefix and tag for default values for images.
ARG REGISTRY
ARG TAG

COPY manifest /data/manifest
COPY apptest/deployer /data-test/

ADD schema.yaml /tmp/schema.yaml
ADD apptest/deployer/schema.yaml /tmp/test-schema.yaml
RUN cat /tmp/schema.yaml \
        | env -i "REGISTRY=$REGISTRY" "TAG=$TAG" envsubst \
    > /tmp/schema.yaml.new \
    && mv /tmp/schema.yaml.new /data/schema.yaml \
    && cat /tmp/test-schema.yaml \
        | env -i "REGISTRY=$REGISTRY" "TAG=$TAG" envsubst \
    > /tmp/test-schema.yaml.new \
    && mv /tmp/test-schema.yaml.new /data-test/schema.yaml
