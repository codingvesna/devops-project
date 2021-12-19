FROM maven:3.8.4-jdk-11 AS build
WORKDIR /app
COPY src src
COPY pom.xml .
RUN mvn package

FROM tomcat:9
# copying from stage
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps
EXPOSE 8080

# copying from local directory
# COPY target/*.war /usr/local/tomcat/webapps
