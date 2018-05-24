ARG MARKETPLACE_REGISTRY
FROM launcher.gcr.io/google/debian9 AS build

RUN apt-get update \
    && apt-get install -y --no-install-recommends gettext

ADD wordpress /tmp/wordpress/chart
RUN cd /tmp/wordpress \
    && tar -czvf /tmp/wordpress.tar.gz chart

ADD apptest/deployer/chart /tmp/test/chart
RUN cd /tmp/test \
    && tar -czvf /tmp/test/wordpress.tar.gz chart/

FROM ${MARKETPLACE_REGISTRY}/deployer_helm_base
COPY --from=build /tmp/wordpress.tar.gz /data/chart/
COPY --from=build /tmp/test/wordpress.tar.gz /data-test/chart/
COPY apptest/deployer/config.yaml /data-test/
COPY apptest/deployer/schema.yaml /data-test/
COPY schema.yaml /data/schema.yaml
