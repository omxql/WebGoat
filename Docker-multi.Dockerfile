# Stage 1: Build with JDK (eclipse-temurin:21-jdk-jammy)
FROM eclipse-temurin:21-jdk-jammy AS build

WORKDIR /app

# Copy the necessary files for building the application
COPY .mvn/ .mvn
COPY mvnw pom.xml ./
COPY src ./src

# Create the mvn.sh script
RUN cat > mvn.sh <<'EOF'
export USR=`id -un`
echo "Container is running as user ${USR}"
echo "Maven cache directory is ..."
echo -en "/root/.m2/repository"
# During runtime fetches the maven cache directory
# ./mvnw help:evaluate -Dexpression=settings.localRepository -q -DforceStdout
echo -e "\nStarting build process"
./mvnw clean package -DskipTests
cp -v ./target/spring-petclinic-*.jar spring-petclinic.jar
echo $PWD/spring-petclinic.jar
rm -rf .mvn/ src/ target/ mvnw pom.xml
echo "Build process completed successfully"
EOF

# Run the build process with Maven, using a cache mount for the maven repository
RUN --mount=type=cache,target=/root/.m2/repository bash mvn.sh

# Stage 2: Final image with JRE (bellsoft/liberica-openjre-alpine-musl:17)
FROM bellsoft/liberica-openjre-alpine-musl:17 AS final
#FROM openjdk:17-jdk-alpine AS final
#FROM eclipse-temurin:21-jdk-jammy AS final

WORKDIR /app

# Copy the built JAR from the build stage
COPY --from=build /app/spring-petclinic.jar /app/spring-petclinic.jar


ARG CACHEBUST=001
RUN echo "Arg CACHEBUST effects change in the imageSha. CACHEBUST=$CACHEBUST"

# Expose the port for the application
EXPOSE 8080

# Command to run the application
CMD ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "spring-petclinic.jar"]
