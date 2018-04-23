ARG MARKETPLACE_REGISTRY
FROM launcher.gcr.io/google/debian9 AS build

RUN apt-get update \
    && apt-get install -y --no-install-recommends gettext

ADD chart /tmp/chart
RUN cd /tmp \
    && tar -czvf /tmp/nginx.tar.gz chart/

FROM ${MARKETPLACE_REGISTRY}/deployer_helm_base
COPY --from=build /tmp/nginx.tar.gz /data/chart/
COPY schema.yaml /data/schema.yaml
