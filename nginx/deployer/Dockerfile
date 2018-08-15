FROM gcr.io/cloud-marketplace-tools/k8s/deployer_helm:local

ADD deployer/nginx /tmp/chart
RUN cd /tmp \
    && tar -czvf /tmp/nginx.tar.gz chart \
    && mv /tmp/nginx.tar.gz /data/chart/

ADD deployer/apptest/deployer/nginx /tmp/test/chart
RUN cd /tmp/test \
    && tar -czvf /tmp/test/nginx.tar.gz chart/ \
    && mv /tmp/test/nginx.tar.gz /data-test/chart/

ADD deployer/apptest/deployer/schema.yaml /data-test/
ADD schema.yaml /tmp/schema.yaml

# Provide registry prefix and tag for default values for images.
ARG REGISTRY
ARG TAG
RUN cat /tmp/schema.yaml \
    | env -i "REGISTRY=$REGISTRY" "TAG=$TAG" envsubst \
    > /tmp/schema.yaml.new \
    && mv /tmp/schema.yaml.new /tmp/schema.yaml
