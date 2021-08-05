ARG MARKETPLACE_TOOLS_TAG
FROM marketplace.gcr.io/google/debian10 AS build

RUN apt-get update \
    && apt-get install -y --no-install-recommends gettext

ARG TESTER_IMAGE

ADD apptest/deployer/schema.yaml /tmp/apptest/schema.yaml
RUN cat /tmp/apptest/schema.yaml \
    | env -i "TESTER_IMAGE=$TESTER_IMAGE" envsubst \
    > /tmp/apptest/schema.yaml.new \
    && mv /tmp/apptest/schema.yaml.new /tmp/apptest/schema.yaml

FROM gcr.io/cloud-marketplace-tools/k8s/deployer_envsubst:$MARKETPLACE_TOOLS_TAG

ARG RELEASE

COPY versions/$RELEASE/schema.yaml /data/schema.yaml

COPY manifest /data/manifest
COPY versions/$RELEASE/manifest /data/manifest

COPY apptest/deployer /data-test/
COPY --from=build /tmp/apptest/schema.yaml /data-test/
