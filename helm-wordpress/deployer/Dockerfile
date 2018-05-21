ARG MARKETPLACE_REGISTRY
FROM launcher.gcr.io/google/debian9 AS build

RUN apt-get update \
    && apt-get install -y --no-install-recommends gettext

ADD mariadb /tmp/chart-mariadb
RUN cd /tmp \
    && tar -czvf /tmp/mariadb.tar.gz chart

ADD wordpress /tmp/chart-wordpress
RUN cd /tmp \
    && tar -czvf /tmp/wordpress.tar.gz chart

FROM ${MARKETPLACE_REGISTRY}/deployer_helm_base
COPY --from=build /tmp/mariadb.tar.gz /data/chart-mariadb/
COPY --from=build /tmp/wordpress.tar.gz /data/chart-wordpress/
COPY schema.yaml /data/schema.yaml
