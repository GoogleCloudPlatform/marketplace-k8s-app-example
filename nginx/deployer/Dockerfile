ARG MARKETPLACE_REGISTRY
FROM launcher.gcr.io/google/debian9 AS build

#TODO(ruela) try without this
RUN apt-get update \
    && apt-get install -y --no-install-recommends gettext


#TODO(ruela) try without ADD commands 
ADD chart /tmp/chart
RUN cd /tmp \
    && tar -czvf /tmp/nginx.tar.gz chart
ADD chart-test /tmp/test/chart
RUN cd /tmp/test \
    && tar -czvf /tmp/test/nginx.tar.gz chart/

FROM ${MARKETPLACE_REGISTRY}/deployer_helm_base
COPY --from=build /tmp/nginx.tar.gz /data/chart/
COPY --from=build /tmp/test/nginx.tar.gz /data-test/chart/
COPY apptest/* /data-test/
COPY schema.yaml /data/schema.yaml
