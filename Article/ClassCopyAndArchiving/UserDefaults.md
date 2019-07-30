# UserDefaults 

-  CoreData
  - 애플리케이션 사용자가 애플리케이션을 사용하면서 저장한 설정/값들을 서버가 아닌 클라이언트에 저장하기 위한 방식
  - CoreData는 DB의 테이블 수가 적거나 테이블간 관계가 복잡하지 않다면 사용하지 않는 것이 성능면에서 좋다는 의견이 많음
- SQLite
  - CoreData에 대응하여 높은 선호도를 보이는 대체재



- UserDefaults 

  > **An interface to the user’s defaults database, where you store key-value pairs persistently across launches of your app.**

  - key - value 쌍으로 디바이스에 데이터를 저장하는 것을 돕는 인터페이스 
  - Foundation 라이브러리
  - RDB Data를 클라이언트에 저장하기 위한 것이 아니라, 사용자가 설정한 앱의 설정값과 기록한 값 등과 같이 간단한 데이터들을 저장하기 위해서 적절함.

### 장점

앱의 어느 곳에서나 데이터를 쉽게 읽고 저장할 수 있게된다.

### 저장할 데이터 양식

- **사용자 기본설정과 같은 단일 데이터 값에 적합**
- 대량의 유사 데이터(테이블 레코드들, 여러 사용자 데이터 들)의 저장에는 SQLite DB가 적합

### 데이터 Save/Load

save 

```swift
UserDefaults.standard.set(value, forKey: "id")
```

Load

```swift
UserDefaults.standard.value(forKey: "id")
```

- 옵셔널 타입 : 올바르지 않은 키값에 대한 결과값이 nil로 반환되므로 반환값이 Any? 이다.
- Any? 타입 : 저장한 값의 타입으로 캐스팅을 해야 한다.



### 참고 사이트

 [이동건님의 이유있는 코드 블로그](https://baked-corn.tistory.com/49?category=718235) 

 [Zedd님 iOS ) 왕초보를 위한 User Defaults사용해보기](https://zeddios.tistory.com/107)

[공식문서](https://developer.apple.com/documentation/foundation/UserDefaults)

