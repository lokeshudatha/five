# ==============================
# Stage 1: Build the application
# ==============================
FROM maven:3.9-eclipse-temurin-21 AS builder

WORKDIR /app

# Clone the source code
RUN git clone https://github.com/Siva825/spring-petclinic.git .

# Build the application
RUN mvn clean package -DskipTests -Dcheckstyle.skip=true


# ==============================
# Stage 2: Run the application
# ==============================
FROM eclipse-temurin:21-jre

WORKDIR /app

# Copy only the built JAR from builder stage
COPY --from=builder /app/target/spring-petclinic-3.5.0-SNAPSHOT.jar app.jar

EXPOSE 8080

CMD ["java", "-jar", "app.jar"]
