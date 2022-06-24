FROM openjdk:8-jre-slim
WORKDIR /home
COPY target/spring-petclinic-2.4.2.war spring-petclinic-2.4.2.war
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "spring-petclinic-2.4.2.war"]
