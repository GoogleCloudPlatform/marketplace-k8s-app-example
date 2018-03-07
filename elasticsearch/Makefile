$(shell mkdir -p .build/)

build: .build/app

.build/app: Makefile deployer/* manifest/*
	docker build \
	    --build-arg REGISTRY="$(REGISTRY)" \
	    --tag "$(REGISTRY)/elasticsearch/deployer" \
	    -f deployer/Dockerfile \
	    .
	gcloud docker -- push "$(REGISTRY)/elasticsearch/deployer"
	touch "$@"

clean:
	rm -rf .build/
