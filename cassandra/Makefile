APP_NAME = cassandra

tools_path = ../vendor/marketplace-tools

include $(tools_path)/gcloud.Makefile

include $(tools_path)/crd.Makefile
include $(tools_path)/app.Makefile

app/build:: .build/deployer

.build/deployer: deployer/* manifest/* $(MARKETPLACE_BASE_BUILD)/deployer-kubectl $(MARKETPLACE_BASE_BUILD)/controller $(APP_BUILD)/registry_prefix | app/setup
	docker build \
	    --build-arg MARKETPLACE_REGISTRY="$(MARKETPLACE_REGISTRY)" \
	    --tag "$(APP_DEPLOYER_IMAGE)" \
	    -f deployer/Dockerfile \
	    .
	gcloud docker -- push "$(APP_DEPLOYER_IMAGE)"
	@touch "$@"

