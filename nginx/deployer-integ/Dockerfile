ARG APP_DEPLOYER_IMAGE
FROM launcher.gcr.io/google/debian9 AS build

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    gettext

ADD chart-integ /tmp/chart
RUN cd /tmp \
    && tar -czvf /tmp/tester.tar.gz chart/

FROM ${APP_DEPLOYER_IMAGE}
COPY --from=build /tmp/tester.tar.gz /data/chart/
