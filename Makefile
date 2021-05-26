DOCKER      = docker
DOCKERFILE  = Dockerfile
PORT			  = 8080
TAG				  = sample-kotlin
LINT_IGNORE = "DL3007"

all: hadolint build

hadolint:
	$(DOCKER) run --rm -i hadolint/hadolint hadolint - --ignore ${LINT_IGNORE} < $(DOCKERFILE)

build: hadolint
	$(DOCKER) build -t $(TAG) .

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
