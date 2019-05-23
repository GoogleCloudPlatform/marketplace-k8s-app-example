ARG MARKETPLACE_TOOLS_TAG
FROM gcr.io/cloud-marketplace-tools/k8s/deployer_envsubst:$MARKETPLACE_TOOLS_TAG

ARG RELEASE

COPY versions/$RELEASE/schema.yaml /data/schema.yaml

COPY manifest /data/manifest
COPY versions/$RELEASE/manifest /data/manifest

COPY apptest/deployer /data-test/
