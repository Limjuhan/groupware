# 1. JDK 베이스 이미지
FROM openjdk:17-jdk-slim

# 2. 작업 디렉토리 생성
WORKDIR /app

# 3. WAR 파일 복사
COPY target/groupware-0.0.1-SNAPSHOT.war app.war

# 4. WAR 파일 압축 해제 (exploded)
RUN mkdir exploded && \
    cd exploded && \
    jar -xf ../app.war

# 5. 내장 톰캣 + exploded 모드 실행
CMD ["java", "-cp", "exploded/WEB-INF/classes:exploded/WEB-INF/lib/*", "ldb.groupware.GroupwareApplication"]
