FROM openjdk:17.0.1-jdk-slim AS base

WORKDIR /app

COPY build/libs/*.jar app.jar

# Expose the application port
EXPOSE 8081

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]