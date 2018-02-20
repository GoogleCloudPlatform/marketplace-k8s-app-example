APP_NAME ?= wordpress

build/$(APP_NAME): $(APP_NAME)/**/*
	$(MAKE) -C "$(APP_NAME)" build

clean/$(APP_NAME):
	$(MAKE) -C "$(APP_NAME)" clean
