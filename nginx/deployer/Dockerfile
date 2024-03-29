FROM marketplace.gcr.io/google/debian10 AS build

RUN apt-get update \
    && apt-get install -y --no-install-recommends gettext

ADD nginx /tmp/chart
RUN cd /tmp \
    && tar -czvf /tmp/nginx.tar.gz chart
ADD apptest/deployer/nginx /tmp/test/chart
RUN cd /tmp/test \
    && tar -czvf /tmp/test/nginx.tar.gz chart/

ADD schema.yaml /tmp/schema.yaml

# Provide registry prefix and tag for default values for images.
ARG REGISTRY
ARG TAG
RUN cat /tmp/schema.yaml \
    | env -i "REGISTRY=$REGISTRY" "TAG=$TAG" envsubst \
    > /tmp/schema.yaml.new \
    && mv /tmp/schema.yaml.new /tmp/schema.yaml

# Provide default value for tester image.
ARG TESTER_IMAGE
ADD apptest/deployer/schema.yaml /tmp/apptest/schema.yaml
RUN cat /tmp/apptest/schema.yaml \
    | env -i "TESTER_IMAGE=$TESTER_IMAGE" envsubst \
    > /tmp/apptest/schema.yaml.new \
    && mv /tmp/apptest/schema.yaml.new /tmp/apptest/schema.yaml


FROM gcr.io/cloud-marketplace-tools/k8s/deployer_helm
COPY --from=build /tmp/nginx.tar.gz /data/chart/
COPY --from=build /tmp/test/nginx.tar.gz /data-test/chart/
COPY apptest/deployer/schema.yaml /data-test/
COPY --from=build /tmp/apptest/schema.yaml /data-test/
COPY --from=build /tmp/schema.yaml /data/