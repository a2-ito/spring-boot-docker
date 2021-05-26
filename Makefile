DOCKER      = docker
DOCKERFILE  = Dockerfile
PORT			  = 8080
TAG				  = sample-kotlin
LINT_IGNORE = "DL3007"
GRADLEW     = ./gradlew
PACK        = pack
BUILDER_CNF = ./builder/builder.toml
BUILDER_IMG = my-builder:bionic

all: build

hadolint:
	$(DOCKER) run --rm -i hadolint/hadolint hadolint - --ignore ${LINT_IGNORE} < $(DOCKERFILE)

build:
	$(GRADLEW) bootBuildImage	

docker-build: hadolint
	$(DOCKER) build -t $(TAG) .

create-builder:
	$(PACK) builder create $(BUILDER_IMG) --config $(BUILDER_CNF)

run:
	$(DOCKER) run -itd --name $(TAG) --env "REVIEW_CONFIG_FILE=hogehoge" --rm $(TAG)

contener=`docker ps -a -q`
image=`docker images | awk '/^<none>/ { print $$3 }'`

clean:
	@if [ "$(image)" != "" ] ; then \
    docker rmi $(image); \
  fi
	@if [ "$(contener)" != "" ] ; then \
    docker rm -f $(contener); \
  fi
