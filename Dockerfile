FROM ubuntu:22.04 AS lokesh
RUN apt-get update && apt-get install -y openjdk-17-jdk maven git
WORKDIR /app 
RUN git clone https://github.com/spring-projects/spring-petclinic.git .
RUN mvn clean package -DskipTests -Dcheckstyle.skip=true


FROM ubuntu:22.04 
WORKDIR /app 
COPY --from=lokesh /app/target/spring-petclinic-4.0.0-SNAPSHOT.jar app.jar
EXPOSE 8080 
CMD ["java", "-jar", "app.jar"]
