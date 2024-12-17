#syntax=docker/dockerfile:1.4
# Stage 1: Build with JDK (eclipse-temurin:21-jdk-jammy)
FROM docker.io/eclipse-temurin:21-jdk-jammy AS build
LABEL name="WebGoat: A deliberately insecure Web Application"
LABEL maintainer="WebGoat team"

WORKDIR /app

# Copy the necessary files for building the application
COPY .mvn/ .mvn
COPY mvnw pom.xml ./
COPY src ./src

USER root

# Create the mvn.sh script
RUN cat > mvn.sh <<'EOF'
export USR=`id -un`
echo "Container is running as user ${USR}"
echo "Maven cache directory is ..."
echo -en "/root/.m2/repository"
# During runtime fetches the maven cache directory
# ./mvnw help:evaluate -Dexpression=settings.localRepository -q -DforceStdout
echo -e "\nStarting build process"
#./mvnw clean package -DskipTests
./mvnw spotless:apply && ./mvnw -B -DskipTests clean install -e
cp -v target/webgoat-*.jar /app/webgoat.jar
echo $PWD/webgoat.jar
ls -lhr /app
rm -rf .mvn/ src/ mvnw pom.xml
echo "Build process completed successfully"
EOF

# Run the build process with Maven, using a cache mount for the maven repository
RUN --mount=type=cache,target=/root/.m2/repository bash mvn.sh

## ========================================

# STAGE 2: FINAL image with JRE (bellsoft/liberica-openjre-alpine-musl:17)
FROM bellsoft/liberica-openjre-alpine-musl:17 AS final
#FROM eclipse-temurin:21-jdk-jammy AS final

# Install the shadow package to provide useradd and groupadd
RUN apk add --no-cache shadow bash

WORKDIR /app

# Copy the built JAR from the build stage
COPY --from=build /app/target/webgoat-*.jar /app/webgoat.jar

ENV TZ=Asia/Kolkata

ARG CACHEBUST=001
RUN echo "Arg CACHEBUST effects change in the imageSha. CACHEBUST=$CACHEBUST"

# Expose the port for the application
EXPOSE 8080
EXPOSE 9090

# Command to run the application
CMD [ "java", \
   "-Duser.home=/root", \
   "-Dfile.encoding=UTF-8", \
   "--add-opens", "java.base/java.lang=ALL-UNNAMED", \
   "--add-opens", "java.base/java.util=ALL-UNNAMED", \
   "--add-opens", "java.base/java.lang.reflect=ALL-UNNAMED", \
   "--add-opens", "java.base/java.text=ALL-UNNAMED", \
   "--add-opens", "java.desktop/java.beans=ALL-UNNAMED", \
   "--add-opens", "java.desktop/java.awt.font=ALL-UNNAMED", \
   "--add-opens", "java.base/sun.nio.ch=ALL-UNNAMED", \
   "--add-opens", "java.base/java.io=ALL-UNNAMED", \
   "--add-opens", "java.base/java.util=ALL-UNNAMED", \
   "--add-opens", "java.base/sun.nio.ch=ALL-UNNAMED", \
   "--add-opens", "java.base/java.io=ALL-UNNAMED", \
   "-Drunning.in.docker=true", \
   "-jar", "webgoat.jar", "--server.address", "0.0.0.0" ]

HEALTHCHECK --interval=5s --timeout=3s \
  CMD curl --fail http://localhost:8080/WebGoat/actuator/health || exit 1
