$(shell mkdir -p .build/)

build: .build/app

.build/app: Makefile deployer/*
	docker build \
	    --build-arg REGISTRY="$(REGISTRY)" \
	    --tag "$(REGISTRY)/wordpress/deployer" \
	    -f deployer/Dockerfile \
	    .
	gcloud docker -- push "$(REGISTRY)/wordpress/deployer"
	touch "$@"

clean:
	rm -rf .build/
