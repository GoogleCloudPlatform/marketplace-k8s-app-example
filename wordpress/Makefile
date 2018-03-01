$(shell mkdir -p .build/)

.PHONY: build
build: .build/app

.PHONY: clean
clean:
	rm -rf .build/

.build/app: Makefile deployer/* | check-env
	docker build \
	    --build-arg REGISTRY="$(REGISTRY)" \
	    --tag "$(REGISTRY)/wordpress/deployer" \
	    -f deployer/Dockerfile \
	    .
	gcloud docker -- push "$(REGISTRY)/wordpress/deployer"
	touch "$@"

.PHONY: check-env
check-env:
ifndef REGISTRY
  $(error REGISTRY var must be set to a Docker registry)
endif
