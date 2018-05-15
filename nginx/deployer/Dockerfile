ARG MARKETPLACE_REGISTRY
FROM launcher.gcr.io/google/debian9 AS build

RUN apt-get update \
    && apt-get install -y --no-install-recommends gettext

ADD nginx /tmp/chart
RUN cd /tmp \
    && tar -czvf /tmp/nginx.tar.gz chart
ADD apptest/deployer/nginx /tmp/test/chart
RUN cd /tmp/test \
    && tar -czvf /tmp/test/nginx.tar.gz chart/

FROM ${MARKETPLACE_REGISTRY}/deployer_helm_base
COPY --from=build /tmp/nginx.tar.gz /data/chart/
COPY --from=build /tmp/test/nginx.tar.gz /data-test/chart/
COPY apptest/deployer/config.yaml /data-test/
COPY apptest/deployer/schema.yaml /data-test/
COPY schema.yaml /data/schema.yaml
