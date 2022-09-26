DOCKER      = docker
DOCKERFILE  = Dockerfile
CPORT       = 8081
PORT        = 8080
TAG         = sample-kotlin
LINT_IGNORE = "DL3007"
GRADLEW     = ./gradlew
PACK        = pack
BUILDER_CNF = ./builder/builder.toml
BUILDER_IMG = my-builder:bionic

.PHONY: build

all: hadolint build run

hadolint:
	$(DOCKER) run --rm -i hadolint/hadolint hadolint - --ignore ${LINT_IGNORE} < $(DOCKERFILE)

build:
	$(GRADLEW) bootBuildImage --imageName=$(TAG)

docker-build: hadolint
	$(DOCKER) build -t $(TAG) .

create-builder:
	$(PACK) builder create $(BUILDER_IMG) --config $(BUILDER_CNF)

run:
	$(DOCKER) run -itd --name $(TAG) -p 8080:8081 --env "REVIEW_CONFIG_FILE=hogehoge" --rm $(TAG)

contener=`docker ps -a -q`
image=`docker images | awk '/^<none>/ { print $$3 }'`

stop:
	$(DOCKER) rm -f $(TAG)

clean:
	@if [ "$(contener)" != "" ] ; then \
    docker rm -f $(contener); \
  fi
	@if [ "$(image)" != "" ] ; then \
    docker rmi $(image); \
  fi
