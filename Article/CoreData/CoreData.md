

memory - Data structure

storage - DB



## 코어 데이터

- Apple의 데이터베이스

- CoreData - 기본적으로 SQLite DB를 사용함

CoreData Framework



### Entity

- `Entity` 는 일반적인 RDB에서 말하는 `테이블` 의 개념과 유사
  - (Entity 추가 -> `CREATE TABLE` 과 비슷한 효과)



### Attribute

- Attribute는 Table의 Column을 구성하는 엔티티 속성을 의미한다.
- Core Data에서는 `property` 용어로 언급



### Relationship

- 코어 데이터 엔티티(Entity) 간의 `관계` 를 표현

- 사람은 여러 종류의 연락처를 보유 (전화번호, 이메일, 주소, 직장번호 등)
- 사람은 연락처와 1:N의 관계에 있음
- Core Data에서는 `property` 용어로 언급



### 기존 스키마 변경하려면?

- DB의 기존 구조를 변경하고, 그에 맞게 데이터를 변경하는 마이그레이션을 진행
- Lightweight Migration 이라는 방법을 제공



### 참고

[What Are Core Data Entities And Attributes](https://cocoacasts.com/what-are-core-data-entities-and-attributes)



