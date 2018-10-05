FROM gcr.io/cloud-marketplace-tools/k8s/deployer_helm:sha_7c70bcd83a8c490a11f93abfc4ec7a5f39c61ab6

# Provide registry prefix and tag for default values for images.
ARG REGISTRY
ARG TAG

ADD deployer/nginx /tmp/chart
RUN cd /tmp \
    && tar -czvf /tmp/nginx.tar.gz chart \
    && mv /tmp/nginx.tar.gz /data/chart/

ADD deployer/apptest/deployer/nginx /tmp/test/chart
RUN cd /tmp/test \
    && tar -czvf /tmp/test/nginx.tar.gz chart/ \
    && mv /tmp/test/nginx.tar.gz /data-test/chart/

ADD deployer/apptest/deployer/schema.yaml /tmp/test-schema.yaml
ADD schema.yaml /tmp/schema.yaml

RUN cat /tmp/schema.yaml \
        | env -i "REGISTRY=$REGISTRY" "TAG=$TAG" envsubst \
    > /tmp/schema.yaml.new \
    && mv /tmp/schema.yaml.new /data/schema.yaml \
    && cat /tmp/test-schema.yaml \
        | env -i "REGISTRY=$REGISTRY" "TAG=$TAG" envsubst \
    > /tmp/test-schema.yaml.new \
    && mv /tmp/test-schema.yaml.new /data-test/schema.yaml
