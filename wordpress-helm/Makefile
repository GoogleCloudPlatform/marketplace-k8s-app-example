$(shell mkdir -p .build/)

build: .build/app

build/wordpress.tar.gz: chart/*
	mkdir -p build/
	tar -czvf build/wordpress.tar.gz chart/

.build/app: Makefile deployer/* build/wordpress.tar.gz
	docker build \
	    --build-arg REGISTRY="$(REGISTRY)" \
	    --tag "$(REGISTRY)/wordpress-helm/deployer" \
	    -f deployer/Dockerfile \
	    .
	gcloud docker -- push "$(REGISTRY)/wordpress-helm/deployer"
	touch "$@"

clean:
	rm -rf .build/ build/
