$(shell mkdir -p .build/)

build: .build/app

.build/app: Makefile deployer/*
	docker build \
	    --build-arg REGISTRY="$(REGISTRY)" \
	    --tag "$(REGISTRY)/postgresql/deployer" \
	    -f deployer/Dockerfile \
	    .
	gcloud docker -- push "$(REGISTRY)/postgresql/deployer"
	touch "$@"

clean:
	rm -rf .build/
