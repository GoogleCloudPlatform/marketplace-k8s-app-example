APP_NAME ?= wordpress

.PHONY: submodule/init
submodule/init:
	git submodule sync --recursive
	git submodule update --init --recursive

.PHONY: build/$(APP_NAME)
build/$(APP_NAME): $(APP_NAME)/**/*
	$(MAKE) -C "$(APP_NAME)" build

.PHONY: clean/$(APP_NAME)
clean/$(APP_NAME):
	$(MAKE) -C "$(APP_NAME)" clean
