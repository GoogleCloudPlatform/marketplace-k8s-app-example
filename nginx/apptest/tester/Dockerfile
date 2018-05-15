ARG REGISTRY
FROM ${REGISTRY}/testrunner
COPY testspecs/basic_tests.yaml /tester/testspecs/basic_tests.yaml
CMD ["-logtostderr", "--test_spec=/tester/testspecs/basic_tests.yaml"]
