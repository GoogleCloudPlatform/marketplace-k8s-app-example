ARG MARKETPLACE_REGISTRY
FROM launcher.gcr.io/google/debian9 AS build

RUN apt-get update \
    && apt-get install -y --no-install-recommends gettext

ADD wordpress /tmp/wordpress/chart
RUN cd /tmp/wordpress \
    && tar -czvf /tmp/wordpress.tar.gz chart

FROM ${MARKETPLACE_REGISTRY}/deployer_helm_base
COPY --from=build /tmp/wordpress.tar.gz /data/chart/
COPY schema.yaml /data/schema.yaml
