# Stage 1: Build
FROM eclipse-temurin:21-jdk AS build

WORKDIR /app


COPY .mvn .mvn
COPY mvnw .
RUN sed -i 's/\r$//' mvnw && chmod +x mvnw
COPY pom.xml .
RUN ./mvnw dependency:go-offline -B
COPY src ./src
RUN ./mvnw clean package -DskipTests

# Stage 2: Run
FROM eclipse-temurin:21-jre 

WORKDIR /app

COPY --from=build /app/target/*.jar ./toto.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "toto.jar"]