# === Stage 1: Build the Maven project ===
FROM maven:3.9.6-eclipse-temurin-17 AS builder

WORKDIR /app

# Copy POM and download dependencies
COPY pom.xml .
COPY src ./src

# Build and skip tests for faster dependency caching
RUN mvn clean install -DskipTests

# === Stage 2: Test Execution ===
FROM eclipse-temurin:17-jdk

WORKDIR /app

# Install curl (optional, helpful for debugging)
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Copy the built project
COPY --from=builder /app /app

# Default command: Run tests
CMD ["mvn", "test"]
