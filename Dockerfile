# ---- Etapa 1: compilar el .jar ----
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn -q dependency:go-offline
COPY src ./src
RUN mvn -q clean package -DskipTests

# ---- Etapa 2: imagen liviana para correrlo ----
FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=build /app/target/futbol5-torneo-1.0.0.jar app.jar
COPY frontend ./frontend
ENV H2_CONSOLE=false
ENV JAVA_TOOL_OPTIONS="-Xmx350m"
EXPOSE 8080
CMD ["java", "-jar", "app.jar"]
