$(shell mkdir -p .build/)

build: .build/app

build/nginx.tar.gz: chart/*
	mkdir -p build/
	tar -czvf build/nginx.tar.gz chart/

.build/app: Makefile deployer/* build/nginx.tar.gz
	docker build \
	    --build-arg REGISTRY="$(REGISTRY)" \
	    --tag "$(REGISTRY)/nginx/deployer" \
	    -f deployer/Dockerfile \
	    .
	gcloud docker -- push "$(REGISTRY)/nginx/deployer"
	touch "$@"

clean:
	rm -rf .build/ build/
