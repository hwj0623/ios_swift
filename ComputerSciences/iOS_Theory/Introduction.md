# iOS - Swift 3~5 정리

https://github.com/meetkei/BookSample-SwiftObjectiveC

### Part 1 Intro

- Objective-C vs Swift(ch03)

##### Obj-C -> Swift 언어 호환성을 위한 노력

- Nullability Annotation

- Lightweight Generics

### Part 2 관련 개념

- ##### 컴파일

  - 텍스트 작성 소스코드를 binary code로 변환하는 과정
  - Objective-C/Swift : Apple LLVM 컴파일러 또는 GCC 컴파일러 사용

- ##### 링크

  - 링커 : 컴파일 후 binary code에 라이브러리 연결하고 실행파일을 생성하는 과정을 담당
  - 컴파일 후 자동으로 수행하여 실행 가능한 파일을 생성

- ##### 빌드

  - 컴파일과 링크를 하나의 작업으로 묶어서 수행하는 것
  - 정적 분석, 단위 테스트, 설치 파일 생성 등의 부수작업이 추가되기도 함

- ##### 코코아

  - 애플이 제공하는 OOP개발 환경

  - 코코아 프레임워크 : macOS 앱 위한 API 모음

  - 코코아 터치 프레임워크 : iOS, tvOS, watchOS 앱 위한 API 모음

    

- ##### 프레임워크

  - 특정 OS 또는 개발환경에서 프로그램을 개발하는데 사용하는 클래스와 라이브러리 집합.

- ##### API

  - OS, 언어, 프레임워크가 제공하는 메소드(함수)
  - 프레임워크 또는 라이브러리 형태로 제공 

- ##### First-class Citizen

  - 다음의 조건을 만족하는 요소
    - 1)  변수나 구조체, 클래스와 같은 사용자 정의 자료형에 저장가능
    - 2) 파라미터로 전달 가능
    - 3) 리턴값으로 사용 가능

  



### Part 3 언어 기초

- **Class and modifier(ch03)**

- **Optional(ch04)**

- **Memory & pointer (ch08)**

  **value & reference(ch09)**

  **Closure & block (ch14)**

  **Collection(ch16)**

  **Enumeration(ch17)**

  **Struct & class (ch18)**

  **Attribute(ch19)**

  **Subscript(ch21)**

  **Optional Chaining(ch22)**

  **Inheritence(ch23)**

  **Constructor and Desctructor (ch24)**

  **Polymorphism(ch25)**

- Optional(ch04)
- Memory & pointer (ch08)
- value & reference(ch09)
- Closure & block (ch14)
- Collection(ch16)
- Enumeration(ch17)
- Struct & class (ch18)
- Attribute(ch19)
- Subscript(ch21)
- Optional Chaining(ch22)
- Inheritence(ch23)
- Constructor and Desctructor (ch24)
- Polymorphism(ch25)



### Part 4 메모리 관리

- **ch01 memory mgnt**
- ch02 MMR
- ch03 Autorelease Pool
- **ch04 ARC (Automatic Reference Counting)**





-------



### Part 5 Auto Layout

- Overview
- **Constraint**
- **Interface Builder**
- **Auto Layout with Code**





### Part 6 Concurrency Programming

- Overview

- **Thread**
- NSThread
- **Operation**
- **GCD**