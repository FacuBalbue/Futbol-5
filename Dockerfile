# Etapa de compilación con Maven y Java 17
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app
COPY . .

# Copiar la carpeta frontend a la ruta donde Spring Boot espera los archivos estáticos
RUN mkdir -p src/main/resources/static && cp -r frontend/* src/main/resources/static/

# Compilar el proyecto empaquetando todo
RUN mvn clean package -DskipTests

# Etapa de ejecución ligera
FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=build /app/target/futbol5-torneo-1.0.0.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
