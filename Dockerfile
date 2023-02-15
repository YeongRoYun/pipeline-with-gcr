# Multi-stage build
FROM amazoncorretto:17 AS builder
ENV APP_HOME=/usr/app
WORKDIR $APP_HOME
COPY build.gradle settings.gradle gradlew $APP_HOME/
COPY gradle $APP_HOME/
COPY . .
RUN ./gradlew test
RUN ./gradlew -x test build

FROM amazoncorretto:17
ENV ARTIFACT_NAME=test.jar
ENV APP_HOME=/usr/app
WORKDIR $APP_HOME
COPY --from=builder $APP_HOME/build/libs/$ARTIFACT_NAME .

EXPOSE 8080
ENTRYPOINT java -jar $ARTIFACT_NAME