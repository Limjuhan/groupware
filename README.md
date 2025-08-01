<img src="./screenshots/main.png" alt="메인화면" width="3000"/>
# LDBSOFT Groupware

기업용 웹 그룹웨어 시스템

## 📌 기술 스택

* **Language**: Java 21
* **Framework**: Spring Boot 3.5.3 (MVC 기반)
* **View**: JSP (SiteMesh + Bootstrap + FontAwesome)
* **ORM**: MyBatis
* **Database**: MariaDB
* **Build Tool**: Maven

## 🛠 개발 도구

* **IDE**: IntelliJ IDEA
* **Database Client**: HeidiSQL
* **Version Control**: Fork (Git 클라이언트)

## 🗓️ 프로젝트 일정

* **개발 시작**: 2025년 7월 14일
* **예정 마감**: **2025년 8월 14일**
* **배포 계획**:

  * Docker 기반 컨테이너화
  * AWS EC2 또는 Lightsail 배포 예정

## 📁 패키지 구조

```
src/main/java/
├── com.ldbsoft.groupware
│   ├── config            # 설정 관련 (DB, Interceptor 등)
│   ├── controller        # 웹 요청 처리 (예: NoticeController)
│   ├── service           # 비즈니스 로직 처리
│   ├── mapper            # MyBatis 매퍼 인터페이스
│   ├── dto               # 데이터 전송 객체
│   ├── entity            # DB 매핑용 엔티티
│   └── util              # 공통 유틸 클래스

src/main/webapp/
├── WEB-INF
│   ├── jsp               # JSP View 페이지
│   └── decorators        # SiteMesh layout.jsp 등
├── static
│   ├── img               # 정적 이미지
│   ├── css               # 사용자 정의 CSS (옵션)
│   └── js                # JS 스크립트 (옵션)
```

## ⚙ 주요 기능

* 📄 전자결재: 기안/결재/반려/결재선 관리
* 📢 게시판: 공지사항, 질문, FAQ 관리
* 🧑‍💼 사원정보: 개인정보 및 부서, 직급 관리
* 📆 일정관리: 회사 일정 캘린더
* 🚗 설비예약: 차량, 회의실, 비품 등 예약 관리
* 📧 메일: 내부 메일 수발신
* 🔔 알림: 결재 요청, 공지, 메일 도착 알림
* 🛠 관리자 메뉴:
  *   사원 관리: 사원 등록, 수정, 삭제 및 권한 관리
  *   부서 관리: 부서 생성, 수정, 삭제 및 조직도 관리
  *   공통 코드 관리: 시스템 내 공통 코드 등록 및 관리
  *  연차 사용률 대시보드: 사원별/부서별 연차 사용률 시각화

## 💾 DB 연동 설정 (application.properties)

```properties
spring.datasource.url=jdbc:mariadb://localhost:3306/groupware
spring.datasource.username=your_id
spring.datasource.password=your_pw
mybatis.mapper-locations=classpath:/mapper/**/*.xml
mybatis.configuration.map-underscore-to-camel-case=true
spring.mvc.view.prefix=/WEB-INF/jsp/
spring.mvc.view.suffix=.jsp
```

## 🧪 테스트

* JUnit 5 + SpringBootTest 기반 단위 및 통합 테스트 작성 예정

## 🚀 실행 방법

```bash
mvn clean install
java -jar target/groupware-0.0.1-SNAPSHOT.war
```

또는 IDE에서 Boot Run

## 📦 향후 배포 전략

* Dockerfile 작성 및 이미지 생성
* Docker Compose 구성 (DB 포함)
* AWS EC2 또는 Lightsail 배포 예정
* 환경 변수 및 보안 설정 분리 (application-prod.properties 등 활용)

## 📌 참고 사항

* `src/main/resources/templates` 디렉토리는 사용하지 않음 (JSP 기반)
* 레이아웃은 SiteMesh를 통해 공통 관리 (`layout.jsp`)
* 정적 리소스는 `/static/` 내에 배치하여 사용

---



