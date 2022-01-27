ARG MARKETPLACE_TOOLS_TAG
FROM marketplace.gcr.io/google/debian10 AS build

RUN apt-get update \
    && apt-get install -y --no-install-recommends gettext

# Provide default value for tester image.
ARG TESTER_IMAGE
ADD apptest/deployer/schema.yaml /tmp/apptest/schema.yaml
RUN cat /tmp/apptest/schema.yaml \
    | env -i "TESTER_IMAGE=$TESTER_IMAGE" envsubst \
    > /tmp/apptest/schema.yaml.new \
    && mv /tmp/apptest/schema.yaml.new /tmp/apptest/schema.yaml

ARG RELEASE
ADD versions/$RELEASE/schema.yaml /tmp/schema.yaml
ADD .env /tmp/.env
RUN . /tmp/.env && cat /tmp/schema.yaml \
    | envsubst > /tmp/schema.yaml.new \
    && mv /tmp/schema.yaml.new /tmp/schema.yaml

FROM gcr.io/cloud-marketplace-tools/k8s/deployer_envsubst:$MARKETPLACE_TOOLS_TAG
ARG RELEASE
COPY manifest /data/manifest
COPY versions/$RELEASE/manifest /data/manifest

COPY apptest/deployer /data-test/
COPY --from=build /tmp/apptest/schema.yaml /data-test/
COPY --from=build /tmp/schema.yaml /data
