FROM ubuntu:22.04

# Install Java & Maven & Git
RUN apt update -y && \
    apt install -y openjdk-21-jdk maven git

WORKDIR /app

# Clone the GitHub repo
RUN git clone https://github.com/Siva825/spring-petclinic.git .

# Build the Spring app
RUN mvn clean package -DskipTests -Dcheckstyle.skip=true

EXPOSE 8080

CMD ["java", "-jar", "/app/target/spring-petclinic-3.5.0-SNAPSHOT.jar"]
