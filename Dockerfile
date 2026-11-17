# --- Étape 1 : build ---
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /build

COPY pom.xml .
RUN mvn -B dependency:go-offline

COPY src ./src
RUN mvn -B package -DskipTests

# --- Étape 2 : exécution ---
FROM eclipse-temurin:21-jre
WORKDIR /app

RUN groupadd --system loga && useradd --system --gid loga loga

COPY --from=build /build/target/*.jar app.jar
COPY entrypoint.sh entrypoint.sh
RUN chmod +x entrypoint.sh && chown -R loga:loga /app

USER loga

EXPOSE 8080

ENTRYPOINT ["./entrypoint.sh"]