FROM launcher.gcr.io/google/debian9 AS build

RUN apt-get update \
    && apt-get install -y --no-install-recommends gettext

ADD wordpress /tmp/wordpress/chart
RUN cd /tmp/wordpress \
    && tar -czvf /tmp/wordpress.tar.gz chart

ADD apptest/deployer/chart /tmp/test/chart
RUN cd /tmp/test \
    && tar -czvf /tmp/test/wordpress.tar.gz chart/

ADD schema.yaml /tmp/schema.yaml

# Provide registry prefix and tag for default values for images.
ARG REGISTRY
ARG TAG
RUN cat /tmp/schema.yaml \
    | env -i "REGISTRY=$REGISTRY" "TAG=$TAG" envsubst \
    > /tmp/schema.yaml.new \
    && mv /tmp/schema.yaml.new /tmp/schema.yaml

FROM gcr.io/google-marketplace-tools/k8s/deployer_helm
COPY --from=build /tmp/wordpress.tar.gz /data/chart/
COPY --from=build /tmp/test/wordpress.tar.gz /data-test/chart/
COPY apptest/deployer/config.yaml /data-test/
COPY apptest/deployer/schema.yaml /data-test/
COPY --from=build /tmp/schema.yaml /data/
