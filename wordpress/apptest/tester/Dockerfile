ARG REGISTRY
FROM ${REGISTRY}/testrunner
COPY testspecs/basic_tests.yaml /tester/testspecs/
CMD ["-logtostderr", "--test_spec=/tester/testspecs/basic_tests.yaml", "--test_spec_values=/tester/config"]
