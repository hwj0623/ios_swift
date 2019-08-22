# Naver Glace Open Meet up (2019/08/21 Wed)

### Glace CIC에서 개발자가 일을 하는 방법을 소개합니다.     

- 플레이스, 예약, 호텔/항공권, 테이블 주문, 지역가이드, 일본맛집 CONOMI

##### 우리가 하는 일과 방향성 - 최승락    

- Glace = Global Place

- Place : Offline2Online

- Global : global service 출시중

  - LINE CONOMI

- 신기술 활용

  - FE 고도화, 개발 효율
    - React, RN, GraphQL
  - 가용성, JSON Storage
    - Node.js, Spring Boot, MongoDB, Elasticsearch...

- 커뮤니케이션 잘 하기

  - 기업용 깃헙 활용. 오프 미팅 최소화
  - Full stack 개발 지향
  - code == document. 별도 documentation은 최소화
  - Readable code가 중요. coding convention. double loop 피하기, identifier naming 등
  - 설명 글은 두괄식

- 생활

  - 책임근무. 장소무관. 업무단위로 책임
  - 누구나 Issue 제시, 스스로 Issue 테이킹 (not Top down)
  - 코드리뷰 등 

- 결론

  - 글로벌 서비스, 가용성, 공유 문화

  

##### 1) 플레이스에서 게으른 개발자가 부지런히 일하는 방법 -  윤영제

- React.js, Node.js 개발 // js FE / BE 
- 개발문화
  - 반복업무 자동화 —> 개발 생산성 up
  - Dev Ops 영역 자동화
  - 보고문서 없음. 단, 기술지식/사례공유 위한 문서 작성은 권장
  - 주간보고 등을 github issue로 정리
  - 동기식 커뮤(미팅/메신저)보다는 비동기식 커뮤(issue/comments) 지향
- 리뷰문화
  - 코드에 대한 책임 분산(공동 책임)
  - 누가 짜도 비슷한 코드화 —> 이해하기 쉬운 코드
  - test code < code review 
    - context에 대한 이해가 전제되어야 할 수 있는 디버깅
- 개발 생산성 & 리팩토링
  - 적은인원 & 여러업종 빠르게 개발 
  - 업종 별로 비슷한 여러 페이지 공통화 / 재사용
  - But,,
    - 바쁘게 업종이 늘어남..
    - 중복코드 양산
    - 빌드 속도 저해
  - Refactoring 
    - 기술 선택 기준
      - 성능
      - 기존 보다 개선되는 점
      - 구조화
      - API가 편해지는가
      - 사용하는 재미
      - 레퍼런스 등

##### 1) 플레이스에서 게으른 개발자가 부지런히 일하는 방법 -  이강일

- DevOps in Naver Place

- CI/CD - jenkins

- serverless function —> lamdba 사용

  ##### master*

  - 정기 배포, hotfix 모두 github 기능 중 release 를 통해 `tag`생성 후 배포
  - hotfix 브랜치의 base 가 된다.
  - **PR 없이 merge 불가**, 필요한 리뷰어 수는 탄력적으로 조정  (e.g 2명)
  - 업데이트 되면 image build/test/push
  - 미리 image 보안 검수 요청함
  - Production 환경에 배포할 image 준비

  ##### develop*

  - 개발 완료된 코드가 merge
  - 배포 시엔 **master에 merge 후 배포**
    - docker image를 미리 build - test 후에 dev 브랜치를 추가하여 배포
    - branch code에 대한 보안 검수도 자동화
  - 정기 배포 브랜치의 base

  ##### test

  - Test 환경에 CD
  - 자유롭게 merge하고 overwrite 가능
  - 업데이트 되면 image build/test/push
  - Test 환경에 image 배포
  - CD pipeline 결과 DB

  ##### PR 생성 시

  ​	integration test, unit test, eslint & prettier 검사

  ##### aws lambda 사용의 예

  - 다음의 조치들을 lambda로 구현!!

    <u>To PR owner</u>

    ​	Approve 또는 Request changes 등 리뷰 결과 DM	

    ​	Merge 가능한 상태가 되면 DM

    <u>To PR reviewer</u>

    ​		리뷰어 지정이 되면 DM

    ​		리뷰하지 않은 PR 목록이 주기적으로 DM, 활발한 코드 리뷰 장려

  ​		<u>To Team</u>	

  ​			master CI pipeline 장애시 Echo

  ​			PR이 새로 생성되면 (by lambda) Echo

  ​		<u>Etc</u>

  ​			`tag 생성되면 develop에 merge, conflict 발생 시 PR 생성

  ​			PR base chain 해소

  

##### 2)  React Native를 활용한 Cross Platform 앱개발 성공기 - 전병민

- 일본 맛집 리뷰 서비스 (영수증, OCR) 추천으로 실제 리뷰 쓰고 보상받고(라인페이 리워드)

**시작 - WEB**

- React Typescript, Node.js, Koa, MongoDB, Restful API

**단점**

- 리뷰 쓰는데 웹이 불편



Web -> App

- 웹뷰는 지양.

- Cross-Platform Learning Curve Webview
  - **<u>RN</u>**
  - Flutter
  - Xamarin
  - Cordova
  - ...
- Data - Apollo&GraphQL
- 테스트 - Jest, enzyme



앱 만의 경험

- HIG
- Launch Screen 만들어야 하고,
- System UI: Picker, Action Sheets
- Pull to Refresh 
- Push 

성능 이슈

- Bridge (Single Thread / Async)
  - CPU 사용이 높은 작업에 취약
  - 바이너리 파일에 대한 Base64 encoding 
  - 등...
- Hermes 
  - 안드 성능 개선을 위한..지원툴

문제점 



### (5분 세션, 네이버 개발자들은 어플리케이션 성능 테스트를 어떻게 할까요? - 이경일) 

- nGrinder 오픈소스로 개발 / 운영 중 



### 네이버 여행 오픈하다 오픈소스 만든 이야기 (feat. GraphQL) - 김한석

- N 패키지 여행 서비스 (패키지 / 항공 / 현지 투어)

  - Restful API

    - HTTP request / response

  - GraphQL

    - HTTP Method = "POST" 로 고정
    - request body를 설정하여 사용

    ```javascript
    /// Types
    type Event {	// 일종의 DTO로 이를 세분화 하여 작업
      	title: Stirng
        photoUrl: String
    }
    
    /// Resolver
    export default {
      Query: {
        event: async (root, {id}) => await getEvent(id)
      }
    }
    ```

  - resolver 하나에 모든 데이터를 쿼리하나로?

    - 패키지투어 비교하기 예
      - 타입에 대한 공통/세부사항 추출

  - Chain of Responsibility

    - 타입 처리를 책임지는 Resolver에게 책임 떠넘기기
    - 책임별로 처리로직을 분리하기 때문에 수정사항 발생시 어느 부분을 봐야하는지 파악하기 쉽다.
      - side effect 발생을 막는 격리 구조로!!

  - REST API 처럼 별도의 api를 작성해야 하는 것이 아님

    - 요청할 type 정보만 변경

  - N+1 Problem

    - 한번 DB 요청할 것을 N번 요청하게 되는 문제가 생김

  - `GraphQL Dataloader` 를 통해 위 이슈를 해결

    - Promise, Node.js Event loop의 micro ..를 통해 한번에 묶어서 처리하도록 DB 콜을 줄임
    - But, 새로운 api 생성에 대한 이슈 ==> 개발자가 api 리팩토링하여 개선



### Spring Boot 기반의 네이버 예약 서버에 Kotlin 적용하기 - 정상영

- 네이버 예약 서버에 코틀린 적용하기
- server-side 

#### Contents

- 코틀린 소개

  jvm, Android, Browser, Native 환경에서 동작

  정적 타입 지정 언어(+타입 추론) == swift

  객체 지향 + 함수형 프로그래밍 == swift

  

- 장점

  간결성 

  ```kotlin
  class Person(val name:String, val age: Int)	// 클래스 선언
  val person = Person2("John", 30)
  val person2 = Person2("John", 30)
  print(person == person2)	// true (== is equals())
  println(person.hashCode() == person2.hashCode())	// true
  print(person) // Person(name=John, age=30)
  ```

  - Java에서 lombok 등을 사용하거나, equals , hashCode, toString override 하는 것을 간결하게 지원함

  

  **Null Check** 

  - null check를 위한 NPE 처리코드 대신 swift의 Optional 과 유사한 ? operator를 사용하여 nullable로 체크

  **Collection**

  - java에서 데이터 집어넣는 것은 collection api를 호출하든, stream을 사용하든(java8)
  - 코틀린의 경우, 함수형으로 초기화 가능.
    - `extension` 기능으로 기존 클래스 자료구조에 확장하여 기능 추가 가능

  안전성

  - java에 비해 null 처리 안정적
  - null값이 불가능한 확정 데이터 타입에 null선언을 하거나, null값인 ? 데이터 타입에서 데이터에 접근하려고 하는 경우,  complie time에 에러를 발생시킨다.

  - Immutability

    

  

  

  Java와 상호운용성

  - Java <-> 상호 호출 제약 없음
  - Java 기반 라이브러리 사용 가능..

  IDE 지원

  - 인텔리제이 플러그인 업데이트 주기적으로..
  - Java -> Kotlin 변환작업

  Coroutine

  - 손쉬운 비동기 프로그래밍 (async / await)

- 도입 과정 및 이슈

  - Spring Boot 2.0.x 
  - Java 83% / Kotlin 17%

  도입 순서

  - Core - Gradle setup
  - Service1, Service2 - test code ( Java -> Kotlin으로 포팅)
  - Service3 - 신규 구현 (kotlin 100%)
  - Core - Delombok (lombok 제거)

  Lombok 이슈

  - lombok이 생성한 코드를 코틀린에서 접근할 수 없다.

  - 원인
    - 코틀린 코드가 자바코드보다 컴파일이 먼저 되므로 롬복이 생성한 코드에 접근이 불가
    - D2에 작성한 글 참고
  - 해결방법
    - 빌드 순서 조정...
    - java와 코틀린을 별도 모듈로 분리
    - 빌드 전처리 과정에서 Delombok 진행

- QueryDSL

  - 이슈

- Coding Style Guide

  - 공식 컨벤션을 따르는 것을 원칙으로
  - intellij의 추천을 최대한 참고
  -  ktlint 설정
    - intellij에서 설정 파일 반영
    - Gradle plugin 활용하여 CI에서 formatting 검사





