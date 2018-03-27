$(shell mkdir -p .build/)

build: .build/app

.build/app: Makefile deployer/*
	docker build \
	    --build-arg REGISTRY="$(REGISTRY)" \
	    --tag "$(REGISTRY)/memcached/deployer" \
	    -f deployer/Dockerfile \
	    .
	gcloud docker -- push "$(REGISTRY)/memcached/deployer"
	touch "$@"

clean:
	rm -rf .build/
