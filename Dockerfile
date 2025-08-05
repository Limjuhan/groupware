FROM openjdk:17-jdk-slim
WORKDIR /app
COPY target/groupware-0.0.1-SNAPSHOT.war app.war
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.war"]

# WAR 압축 해제
RUN mkdir /app/unpacked \
    && cd /app/unpacked \
    && jar -xf /app/app.war

ENTRYPOINT ["java", "-cp", "/app/unpacked", "org.springframework.boot.loader.launch.WarLauncher"]