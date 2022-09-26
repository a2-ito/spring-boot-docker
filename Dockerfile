#########################################################################################################
# Build Application
#########################################################################################################
#FROM gradle:jdk11 AS builder
FROM openjdk:11-jdk-slim AS builder
WORKDIR /app
COPY . /app
RUN ./gradlew build

#########################################################################################################
# Build Docker Image
#########################################################################################################
FROM amazoncorretto:11.0.11-al2 as runner

RUN yum install -y shadow-utils \
 && rm -rf /var/cache/yum/* \
 && yum clean all
RUN groupadd spring && useradd spring -g spring

USER spring:spring

WORKDIR /app
COPY --from=builder /app/build/libs/spring-boot-docker-0.0.1-SNAPSHOT.jar .
#ENTRYPOINT ["java","-jar","spring-boot-docker-0.0.1-SNAPSHOT.jar"]
ENTRYPOINT ["java","-jar","spring-boot-docker-0.0.1-SNAPSHOT.jar","-Dorg.apache.coyote.http11.Http11Protocol.MAX_KEEP_ALIVE_REQUESTS=1"]

