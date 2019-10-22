# Part 03 LanguageBasics  (2)





## Attribute(ch19)

- Swift는 인스턴스 변수/속성을 별도로 구분하지 않음



### Swift 프로퍼티

- 저장 프로퍼티 Stored Property
- 연산 프로퍼티 Computed Property
- 형식 프로퍼티 Type Property



#### 1) Stored Property

- 가장 일반적 프로퍼티
- 변수/상수 선언 방식과 동일
  - 기본 값을 지정하거나 생성자를 구현하여 모든 속성을 초기화 해야 함

- 별도의 내부 저장소 존재하지 않음
  - **속성 선언** == **값이 저장되는 저장소를 선언**하는 것
  - 내부 저장소 접근을 위한 접근자 메소드를 합성하는 과정도 필요 없음

- **옵셔널 선언한 저장 프로퍼티**는 기본 값이 없으면 **nil 로 초기화** 된다.



#### 1.1) Lazy Stored Property

- 지연 로딩 패턴을 활용하여 인스턴스 생성시에 초기화 하지 않고, 접근시에 초기화 하는 방식
- 메모리 효율성을 높임
- lazy 키워드를 통해 선언
  - **반드시** **선언 부분에서 기본값 지정**해야 함
  - 기본값은 **리터럴** 혹은 **생성자** 호출 표현식
  - 타입 추론 가능

```swift
lazy var propertyName: DataType = 초기화 표현식
```



```swift
import UIKit
struct Contact {
    var email: String?
    var mobile: String?
    var fax: String?
    
    init() {
        print("new Contact instance")
    }
}
class Person {
    var name = ""
    var age = 0
    
    lazy var contacts = Contact()
    
    init() {
        print("new Person instance")
    }
}
let james = Person()
// new Person instance
print(james.name)
print(james.age)

james.contacts.email = "james@example.com"
// new Contact instance
```

- Person의 contacts는 초기화 과정에서 초기화 되지 않음.
- james.contacts.email 같이 **프로퍼티에 처음 접근하는 시점에 초기화** 
  - **큰 값을 저장**하거나,
  - 속성의 **값이 초기화 이후에 결정되는 값에 의존적인 경우 활용**한다.
- 여러 스레드에서 동시 접근하는 경우, 두 번 이상 초기화 될 가능성이 있으므로 주의



#### 2) 연산 프로퍼티

- 값을 직접 저장하지 않음
- **저장 프로퍼티의 값을 기반으로 계산된 새로운 값을 리턴**하거나
- **전달된 값을 토대로 다른 속성의 값을 갱신**
- 항상 `var` 로 선언

- [ 클래스/구조체/열거형 ]에 사용 가능

  - get / set block으로 구성

  ```swift
  var computedProperty: dataType {
    get {	//필수
      return computedProperty
    }
    set {	//생략 가능. 생략시 read only 
      computedProperty = newValue
    }
  }
  ```

- ```swift
  class Person {
      var name: String = ""
      var birthDate: Date?
      var age: Int {
          get {
              if let date = birthDate {
                  let calendar = NSCalendar.current
                  let components = calendar.dateComponents([Calendar.Component.year], from: date, to: Date())
                  return components.year ?? -1
              }
              
              return -1
          }
          set {
              let calendar = NSCalendar.current
              birthDate = calendar.date(byAdding: .year, value: newValue * -1, to: Date())
          }
      }
  }
  
  let calendar = NSCalendar.current
  var componets = DateComponents()
  
  componets.year = 1983
  componets.month = 3
  componets.day = 17
  
  let james = Person()
  james.birthDate = calendar.date(from: componets)
  print(james.age)
  // 36
  james.age = 10
  print(james.birthDate)
  // Optional(2009-10-10 08:49:23 +0000)
  ```

- 새로 대입 연산되는 값은 `newValue` 로 상수 이다.
- 만약 새로운 파라미터를 직접 입력시 `newValue` 는 사용 불가.
  - ex) set(year) { // }

- set 블록 생략시 get 키워드도 생략 가능 .  { }는 자동으로 get으로 인식함



#### 3) Type Property

- 타입 자체와 연관된 속성

- 동일 타입으로 생성된 모든 인스턴스는 **타입 프로퍼티에 저장된 값을 공유**함.

- `static` 키워드로 선언

  ```swift
  static var propertyName: dataType = 초기화표현식
  static class classPropertyName: dataType = 초기화표현식
  ```

  

- [ 클래스/구조체/열거형 ]에 모두 추가 가능

- 타입 프로퍼티는 **Stored 타입 프로퍼티**와 **Computed 타입 프로퍼티**로 구분 

  - 1) **Stored 타입 프로퍼티** : var 또는 let으로 선언
    - (lazy stored property 처럼) 최초 접근 시점에 초기화됨
    - lazy 명시적 추가 필요 없음
    - 다중 스레드 환경에서 동시 접근에도 항상 한번만 수행됨
  - 2) **Computed 타입 프로퍼티** : var 로만 선언

- 형식 자체에 연관된 특성상 생성자를 통해 초기화 불가. 

- 선언과 동시에 기본값을 할당해야 함.

- `static 선언된 타입 프로퍼티`는 기본적으로 **하위 클래스에서 재정의 불가.**

  -  **final 속성**임

  ```swift
  class A {
    static var sharedValue: Int {
      return 10
    }
  }
  class B: A {
    override static var sharedValue: Int {	//compile Error
      return 20
    }
  }
  ```

- 하위 클래스에서 재정의 하려면 **class 키워드로 선언해야 함**

  ```swift
  class A {
    class var sharedValue: Int {
      return 10
    }
  }
  class B: A {
    override class var sharedValue: Int {
      return 20
    }
  }
  ```

  - 재정의 하더라도 **속성 이름**과 **데이터 타입**은 **동일**해야 한다.

  

##### 열거형 타입 프로퍼티 예제

```swift
enum Days: Int {
    static var targetLocale = "en"	//저장 타입 프로퍼티
    static var localizedWeekdayNames: [String] {	//연산 타입 프로퍼티
        switch Days.targetLocale {
        case "kr":
            return ["일요일", "월요일", "화요일"]
        default :
            return ["Sunday", "Monday", "Tuesday"]
        }
    }
    case sunday, monday, tuesday
}

let today = Days.tuesday // 인스턴스로 타입프로퍼티 접근시 에러
// 에러 발생 Static member 'targetLocale' cannot be used on instance of type 'Days'
// today.targetLocale = "us" 
let tomorrow = Days.sunday
Days.targetLocale = "kr" // 항상 타입 이름으로 접근
print(Days.localizedWeekdayNames[today.rawValue])	//화요일
print(Days.localizedWeekdayNames[tomorrow.rawValue])	//일요일
```

- 인스턴스를 통해서 접근이 불가. 
- 타입 프로퍼티는 항상 타입 이름으로 접근해야 한다.





---

### 프로퍼티 옵저버

- 프로퍼티 값의 갱신 전/후에 특정 코드 실행가능
  - 옵저버 패턴, 노티피케이션 패턴, Delegate 패턴과 유사한 기능
- 옵저버, Delegate 등록, 리스너 메소드 구현 필요 없음
- 프로퍼티 선언과 같은 위치에서 구현
- Lazy Stored Property를 제외한 Stored Property에 구현 가능
- 하위 클래스에서 속성 재정의시 Stored Property와 Computed Property 모두에 구현 가능

- `willSet`, `didSet` 코드 블록으로 구현
  - willSet : 속성 값 설정 전에 호출. 새로운 값을 상수 파라미터 `newValue` 로 접근
  - didSet : 새로운 값으로 설정 후에 호출. 기존 값을 상수 파라미터 `oldValue` 로 접근
  - **<u>속성이 처음 초기화되는 시점에는 호출되지 않음!!</u>**

```swift
class Person {
    var name = "John doe" {
        willSet {
            print("Current name is \(name). New name is \(newValue).")
        }
        didSet {
            print("Current name is \(name). Old name is \(oldValue).")
        }
    }
}

let p = Person()
p.name = "James"
// Current name is John doe. New name is James.
// Current name is James. Old name is John doe.
```





## Method (ch 20)

##### 1) 인스턴스 메소드

```objective-c
//Objective-C 
- (리턴형) 메소드 이름: (파라미터 자료형) 파라미터 이름 {
  //실행 코드
}

//swift
func 메소드 이름(파라미터이름 : 데이터타입) -> 리턴타입{
  //실행코드
}
```

예제 - SuperHero

SuperHero.h

```objective-c
#import <Foundation/Foundation.h>
@interface SuperHero : NSObject

@property (strong, nonnull) NSString* name;
@property (strong, nonnull) NSString* secretary;
- (instancetype)initWithHeroName:(NSString *)heroName secretaryName:(NSString*)secretaryName;
- (void)callSecretary;  // 파라미터 없는 메소드
- (BOOL)attackWithWeapon:(NSString*)weaponName target:(NSString*)enemyName; //파라미터 존재

@end
```

SuperHero.m

```objective-c
#import "SuperHero.h"
@implementation SuperHero
- (instancetype)initWithHeroName:(NSString*)heroName secretaryName:(NSString*)secretaryName {
    self = [super init];
    if (self) {
        _name = heroName;
        _secretary = secretaryName;
    }
    return self;
}
- (void)callSecretary { // 파라미터 없는 메소드
    if (self.secretary != nil) {
        NSLog(@"Hey, %@!", self.secretary);
    } else {
        NSLog(@"%@ is working along.", self.name);
    }
}
- (BOOL)attackWithWeapon:(NSString*)weaponName target:(NSString*)enemyName { //파라미터 존재
    if (enemyName != nil) {
        [self callSecretary];
        NSLog(@"Attack %@ with %@!!!", enemyName, weaponName);
        return YES;
    }
    return NO;
}
@end
```

#### 함수 호출  (메시지 표현식)

- 메시지 표현식을 통해 메소드 호출. 
  - 메시지 표현식 : `[ ]` 사이에 **리시버(인스턴스 변수명 혹은 클래스 타입)** 와 **메시지(호출할 메소드)**로 구성

- [`리시버` `메소드 이름`]; 
- [`리시버` `메소드이름`: `파라미터1` `메소드이름`: `파라미터N` ];
- 메소드가 리턴값 갖고, 리턴값이 리시버가 될 수 있으면 다음과 같은 형식으로 메소드 표현식 중첩 가능
  - [ [ 리시버 호출메소드 ] 호출메소드]

```objective-c
#import <Foundation/Foundation.h>
#import "SuperHero.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        SuperHero* ironMan = [[SuperHero alloc] initWithHeroName:@"Iron Man" secretaryName:@"Jarvis"];
        [ironMan callSecretary];
        [ironMan attackWithWeapon:@"Repulsor Beam" target:@"Mandarin"];
        // Hey, Jarvis!
        // Hey, Jarvis!
        // Attack Mandarin with Repulsor Beam!!!
        
        SuperHero* thor = [[SuperHero alloc] initWithHeroName:@"Thor" secretaryName:nil];
        [thor callSecretary];
        [thor attackWithWeapon:@"Mjölnir" target:@"Laufey"];
        // Thor is working along.
        // Thor is working along.
        // Attack Laufey with Mjölnir!!!
        
        thor = nil;	//인스턴스 해제
        [thor callSecretary];	//리시버가 nil이므로 메소드 호출이 취소됨.
        [thor attackWithWeapon:@"Mjölnir" target:@"Laufey"]; //리시버 nil이므로 메소드호출이 취소됨.
    }
    return 0;
}
```





#### Swift Value Type 인스턴스의 메소드

- 구조체 / 열거형 메소드는 클래스의 메소드와 동작이 다름
- 구조체/열거형(값 타입) 메소드는 **내부 프로퍼티 변경하는 메소드**를 **mutating** 선언해야 함.
  - 클래스 메소드는 프로퍼티 값 변형에 제한이 없음

- `let` 으로 선언한 경우, **<u>mutating 선언되어도 내부 프로퍼티를 변경하는 메소드는 호출 불가.</u>**

  ```swift
  struct Weapon{
      var name: String
      var durability: Int
      
      mutating func use(){
          if durability > 0 {
              durability -= 1
          }
      }
  }
  
  let repulsorBeam = Weapon(name: "Repulsor Beam", durability: 10)
  repulsorBeam.use()//error
  //Cannot use mutating member on immutable value: 'repulsorBeam' is a 'let' constant
  //Change 'let' to 'var' to make it mutable
  print(repulsorBeam.durability)
  ```



### #selector (objective-c)

- 메소드 식별 위해 사용하는 객체. 함수포인터와 유사.

- Swift에서는 #selector 통해 셀렉터를 생성

  ```swift
  let attackSelector = #selector(SuperHero.attack(weapon:target:))
  ```

- selector의 대상이 되는 메소드는 **@objc** 키워드로 선언

  ```swift
  @objc func attack(weapon: String, target: String?) -> Bool {
    //...
  }
  ```

-----

---





## Subscript(ch21)

#### Subscript 문법 2가지

- 정수 인덱스 사용하는 배열방식
- key 를 사용하는 딕셔너리 방식



### Swift Subscript

- `subscript` 키워드로 구현
- 클래스, 구조체, 열거형 모두 사용 가능
- 일종의 접근자 메소드
- 파라미터목록/리턴형 선언하는 문법은 메소드와 동일
  - 반드시 리턴형을 지정해야 함
- get / set 블록 포함 가능.
  - set 생략시 읽기 전용 서브스크립트가 된다.

```swift
subscript(파라미터 목록) -> 리턴형 {
  get{
    //값 리턴 코드
  }
  set{
    //값 설정 코드
  }
}
```

- 파라미터 목록 : 서브스크립트 문법 접근시 [ ] 사이에 전달하는 **서브스크립트의 수**와 **자료형**을 지정
  - 파라미터에 기본 값 지정 불가. 
  - 입출력 파라미터 사용 불가



### 서브스크립트 구현

#### case 1 배열 

```swift
class Headquarters {
  private var squad: [SuperHero]
  init(heroes: [SuperHero]){
    squard = heroes
  }
  subscript(index: Int) -> SuperHero? {
    get {
      if index < squad.count {
        return squad[index]
      }
      return nil
    }
    set{
      if let hero = newValue {
        if index < squad.count {
          squad[index] = hero
        }else {
          squad.append(hero)
        }
      }else {
        if index < squad.count { 
          squad.remove(at: index)
        }
      }
    }
  }
}
```

- index 내에 값만 해당 인덱스의 요소를 리턴



#### case 2 딕셔너리 - 문자열을 키로 사용하는 서브스크립트 구현

- 키로 값을 읽을 때
  - **배열 순회**하면서 name 속성을 비교. (name 프로퍼티가 키값)
- 키로 값을 쓰는 경우
  - 먼저, 대상 인덱스 검색 후
    - 인덱스 유효하면 할당된 값에 따라 값을 교체/삭제
    - 인덱스 존재하지 않으면 배열 마지막에 추가.

```swift
class Headquarters {
    private var squad: [SuperHero]
    
    init(heroes: [SuperHero]) {
        squad = heroes
    }
    
    subscript(index: Int) -> SuperHero? {
        get {
            if index < squad.count {
                return squad[index]
            }
            return nil
        }
        set {
            if let hero = newValue {
                if index < squad.count {
                    squad[index] = hero
                } else {
                    squad.append(hero)
                }
            } else {
                if index < squad.count {
                    squad.remove(at: index)
                }
            }
        }
    }
    
    subscript(key: String) -> SuperHero? {
        get {
            for hero in squad { //배열을 순회
                if hero.name == key {
                    return hero
                }
            }
            return nil
        }
        set {
            if let index = squad.index(where: { $0.name == key }) {
                if let hero = newValue {
                    squad[index] = hero
                } else {
                    squad.remove(at: index)
                }
            } else {
                if let hero = newValue {
                    squad.append(hero)
                }
            }
        }
    }
    func printSquad() {
        var list = [String]()
        for hero in squad {
            list.append(hero.name)
        }
        print(list.joined(separator: ", "))
    }
}

let ironMan = SuperHero(heroName: "Iron Man", secretaryName: "Jarvis")
let thor = SuperHero(heroName: "Thor")
let captainAmerica = SuperHero(heroName: "Captain America")

let shield = Headquarters(heroes: [ironMan, thor])
shield.printSquad()
// Iron Man, Thor
var firstHero = shield[0]
print(firstHero?.name)
// Iron Man
shield[0] = captainAmerica
firstHero = shield[0]
print(firstHero?.name)
// Captain America
var hero = shield["Iron Man"]
print(hero?.name)
// nil
shield["Iron Man"] = ironMan
hero = shield["Iron Man"]
print(hero?.name)
// Iron Man
shield.printSquad()
// Captain America, Thor, Iron Man
shield[0] = nil
shield.printSquad()
// Thor, Iron Man
shield["Thor"] = nil
shield.printSquad()
// Iron Man
```











## Optional Chaining(ch22)

- 강제 추출 옵션 대신 체이닝 연산자 `?` 를 사용하여 안전하게 접근하는 방법

  - if let 중첩을 보완

  - 옵셔널 형식에 저장된 값을 확인하고 추출함. 

    - 만약 유효한 값 - 다음 속성에 접근하거나 메소드 호출
    - nil - 실패로 판단. 나머지 요소 무시하고 nil 리턴

  - 옵셔널 바인딩 패턴과 결합하여 사용 가능

    ```swift
    if let email = p.contact?.email {
      //..
    }
    ```

- **옵셔널 체이닝 사용시** 결과로 **리턴되는 값의 자료형**은 (원래가 무엇이든간에) **<u>항상 옵셔널 형식</u>**

  ```swift
  class Person {
    var contact: Contact?
  }
  class Contact {
    var address: String?
    var tel: String?
    var email: String = "whoami@gmail.com"
  }
  let p = Person()
  p.contact = Contact()
  let email = (p.contact?.email)!
  print(email)	//whoami@gmail.com
  let optEmail = p.contact?.email
  print(optEmail) //Optional("whoami@gmail.com")
  ```

  

#### 옵셔널 체이닝으로 값 쓰기

- 옵셔널 체이닝 실패시에는 값을 쓰지 않는다.
- 체이닝 성공시에만 값을 정상적으로 쓴다.

```swift
class Person {
  var contact: Contact?
}
class Contact{
  var address: String?
  var tel: String?
  var email: String?
}
let p = Person()
var email = p.contact!.email! //강제 추출 옵션 -> 런타임 오류 발생
var email = p.contact?.email //옵셔널 체이닝 방식. "?" 는 체이닝 연산자
//체이닝 실패시 값 쓰지 않음
p.contact?.email? = "whoami@gmail.com"
if let email = p.contact?.email {
  print(email)
}else{
  print("nil")
}//nil

//Contact 변경시
class Contact{
  var address: String?
  var tel: String?
  var email: String? = "N/A"
}
p = Person()
p.contact?.email? = "whoami@gmail.com" //정상적으로 값을 쓴다.
if let email = p.contact?.email {
  print(email)
}else{
  print("nil")
}//"whoami@gmail.com"
```





-----

-----









## Inheritence(ch23)

- Objective-C 클래스는 NSObject 클래스를 직/간접적으로 상속해야 함
- Ob/swift 모두 다중상속 지원하지 않음
- 서브클래싱 : 클래스 상속해서 새로운 클래스를 정의하는 것
- 하위 클래스는 **<u>상위 클래스의 private property, private method를 제외한 나머지 요소를 모두 상속</u>** 

- swift에서 `final` 선언시 다른 클래스가 상속 불가.



---

----



## Constructor and Desctructor (ch24)



### Swift 생성자 / Objective-C 생성자

- #### Objective-C

  - 기본 생성자 메소드가 NSObject로부터 상속된 메소드임

  - 하위 클래스에서 생성자 메소드 직접 구현한 경우에도 사용 가능

  - ```objective-c
    //Simple.h
    #import <Foundation/Foundation.h>
    
    @interface Simple : NSObject
    @property (strong, nonatomic) NSString* str;
    @property (nonatomic) NSInteger num;
    @end
    //Simple.m
    #import "Simple.h"
    @implementation Simple
    @end
      
    //main.m
    #import <Foundation/Foundation.h>
    #import "Simple.h"
    int main(int argc, const char * argv[]) {
        @autoreleasepool {
            Simple* s = [[Simple alloc] init];
            NSLog(@"%@", s.str);  // (null)
            NSLog(@"%ld", s.num); // 0
        }
        return 0;
    }
    ```

  

- #### Swift 기본생성자

  - **모든 속성이 기본값을 가지고 있어야 제공됨**

  - 클래스에서 생성자를 구현하지 않은 경우에 컴파일러가 자동으로 생성하는 생성자.

  - ```swift
    class Simple{
      var str = "asda"
      var num = 0
    }
    let s = Simple() //기본 생성자
    ```

  

#### Memberwise Initializer (Swift only)

- 구조체에서 기본생성자가 자동으로 생성되는 조건에서 특별한 생성자 하나 더 생성
- 구조체의 속성과 동일한 이름의 파라미터를 가지고 있어서, 모든 속성을 생성자 문법을 통해 초기화 가능

- 직접 생성자 구현하지 않으면 항상 생성됨.



### Swift 생성자

- 기본 생성자 (init)

- #### 지정 생성자

  - 기본 생성자가 지정 생성자임.
  - 클래스의 생성자 중 가장 높은 우선순위 갖는 생성자.
  - 모든 클래스는 <u>상위 클래스로부터</u> <u>지정 생성자 상속하는 경우를 제외</u>하고, **반드시 하나 이상의 지정 생성자를 구현해야** 함.
  - 인스턴스 생성과정에서 지정 생성자는 항상 호출된다.

  - **init**( params.. ) { // } 로 생성
  - 생성자의 실행이 완료되는 시점에 클래스의 모든 속성이 유효한 초기값을 가지는 경우, 인스턴스가 정상적으로 초기화되었다고 판단.

  

- #### 편의 생성자 (convenience init)

  - 동일한 클래스에 구현된 다른 지정생성자를 호출함. 

  - 다른 편의 생성자 호출도 가능하나, 최종적으로 지정 생성자 호출되도록 구현

    ```swift
    class SuperHero {
      //..
      convenience init(dict: [String: String]){
        let name = dict["name"]!
        let sName = dict["secretary"]!
        self.init(heroName: name, secretaryName: sName) //지정생성자 호출. 메모리 공간 할당
      }
    }
    let dict = ["name": "Iron Man", "secretary": "Jarvis"]
    let ironMan = SuperHero(dict: dict)
    ```



#### 생성자 Delegation

- 생성자가 다른 생성자를 호출하는 것
  - 동일 클래스 혹은 상위 클래스 생성자 호출
  - **초기화 코드의 중복을 줄이고**
  - **상속관계**의 **모든 지정 생성자가 올바르게 호출되도록 하는 것**이 목표
    - 상위 클래스로부터 상속받은 모든 프로퍼티의 초기화가 필수
- 델리게이션 규칙
  - 1) 상위 클래스로부터 지정 생성자를 상속한 경우를 제외하고는 하나 이상의 지정 생성자 구현해야 함
  - 2) 지정 생성자는 반드시 상위 클래스 지정 생성자 호출해야 함
  - 3) 지정 생성자 **이외 생성자는** **상위 클래스의 생성자를 호출하면 안됨!!** 
    - 반드시 동일 클래스의 지정 생성자를 호출해야 함.

#### Swift Value Type 생성자 딜리게이션

- 상속 지원하지 않음

- 모든 속성 초기화하는 지정 생성자 구현 후, 나머지 생성자가 지정 생성자 호출하도록 구현

  ```swift
  struct Color {
    var red: Double
    var green: Double
    var blue: Double
    init(r: Double, g: Double, b: Double){ //지정 생성자
      red = r
      green = g
      blue = b
    }
    init() {
      self.init(r: 0, g: 0, b: 0) //지정생성자를 호출
    }
    init(white: Double){
      self.init(r: white, g: white, b: white)  ////지정생성자를 호출
    }
  }
  let redColr = Color(r: 1.0, g:0.0, b:0.0)
  let blackColor = Color()
  let grayColor = Color(white: 0.5)
  ```

  

#### Swift 클래스 생성자 딜리게이션

- Bottum up 방식
- **최상위 클래스의 초기화가 마지막에 수행** (<-> objective-c)
- 상위 클래스 지정생성자 **호출 전에** **모든 프로퍼티 초기화 해야 함**

- ##### 생성자 델리게이션 규칙

  - 1) 상위 클래스의 지정 생성자 호출 전에 모든 속성 초기화
  - 2) 상위 클래스로부터 **상속된 속성은 상위 클래스의 지정생성자 호출한 후에 접근 가능**
  - 3) **convenience 생성자는** <u>속성값 초기화 전에</u> **다른 생성자를 먼저 호출해야 함**

- SuperHero의 convenience init(dict: [String: String]) 호출시
  - 1) **SuperHero의** 지정생성자 `init(heroName: secretaryName: )` 호출
  - 2) **SuperHero** 클래스의 모든 프로퍼티 초기화 체크
  - 3) 상위 클래스 **Person** 의 지정 생성자 호출 
  - 4) 상위 클래스 Person이 프로퍼티 초기화 완료 
  - 5) SuperHero 클래스 지정생성자로 제어권 돌아옴
  - 6)  (SuperHero 클래스 지정생성자에서) super.init() 이후의 라인에서 부가적인 초기화 작업을 수행. 
    - `self` 를 통해 프로퍼티 접근하거나 인스턴스 메소드 호출 가능
  - 7) SuperHero 클래스의 Convenience 생성자로 제어권 돌아옴
    - 지정생성자 호출 완료 시점부터 `self` 통한 프로퍼티접근이나 메소드 호출 가능



#### 실패가능 생성자 (init?, init! )

- 초기화에 사용되는 데이터가 파일/네트워크 통해 전달되거나 잘못된 파라미터 전달되는 경우에 대응하기 위함
- 인스턴스 초기화 실패시 새로운 인스턴스를 리턴하지 않음
  - 따라서 상속관계상 상위 생성자의 불필요한 호출 방지
  - 실패시 nil 리턴하도록 구현

#### cf. 열거형의 실패가능 생성자

- 일치하는 케이스 : self = .case멤버
- 일치하지 않는 경우 : self = nil

```swift
enum Weekday: Int {
    case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
    
    init?(value: Int) {
        switch value {
        case Weekday.sunday.rawValue:
            self = .sunday
        case Weekday.monday.rawValue:
            self = .monday
        case Weekday.tuesday.rawValue:
            self = .tuesday
        case Weekday.wednesday.rawValue:
            self = .wednesday
        case Weekday.thursday.rawValue:
            self = .thursday
        case Weekday.friday.rawValue:
            self = .friday
        case Weekday.saturday.rawValue:
            self = .saturday
        default:
            return nil
        }
    }
    
    init?(abbr: String) {
        switch abbr {
        case "SUN":
            self = .sunday
        case "MON":
            self = .monday
        case "TUE":
            self = .tuesday
        case "WED":
            self = .wednesday
        case "THU":
            self = .thursday
        case "FRI":
            self = .friday
        case "SAT":
            self = .saturday
        default:
            return nil
        }
    }
}

var validWeekday = Weekday(value: 1)
print(validWeekday)
// Weekday.sunday
validWeekday = Weekday(abbr: "SAT")
print(validWeekday)
// Weekday.saturday
var invalidWeekday = Weekday(value: 1000)
print(invalidWeekday)
// nil
invalidWeekday = Weekday(abbr: "ONE")
print(invalidWeekday)
// nil
```



#### 요구 생성자 (required init)

- 하위 클래스에서 **반드시 구현해야 하는 생성자를 필수 생성자로 선언**하는 것

- required 키워드를 통해 선언

- ```swift
  class A {
    required init(){
      //..
    }
  }
  class B: A{
    required init(){
      //..
    }
  }
  ```



#### 생성자 상속

- Objective-C는 상위 클래스의 모든 public 생성자 메소드를 상속함.

- Swift는 상위 클래스의 생성자를 상속하지 않음

- Swift는 아래 **두 조건이 만족되는 경우에 상위 클래스의 모든 지정 생성자를 상속**함.

  - 하위 클래스에서 **모든 속성 선언시, 기본 값을 지정한 경우**
  - 하위 클래스에서 **지정 생성자 구현하지 않은 경우**

  

- 상위 클래스의 convenience 생성자 상속하는 경우

  - 상위 클래스의 **지정 생성자 모두 상속**
  - 하위 클래스에서 **상위 클래스의 지정 생성자 모두 구현** (`override init`) 



#### 소멸자 

- 인스턴스 해제 직전에 호출되는 메소드. `deinit { }`
  - 직접 구현하지 않으면 자동 생성. 
  - 인스턴스는 소멸자 호출되어야 메모리에서 해제됨.
  - 소멸자 내부에서 속성에 접근하거나 메소드 호출 가능.
  - 직접 호출 불가

- ARC 사용하더라도 인스턴스가 파일, DB, 네트워크 등 **외부 리소스와 연결된 속성 존재하면** 소멸자에서 메모리를 직접 해제해야 함.



-----

---



## Polymorphism(ch25)

### 다형성

#### 1) 오버로딩

- 메소드 오버로딩 : 파라미터 수, 자료형, 인자 레이블, 리턴형을 기준으로 식별
  - static 키워드도 식별기준
- 생성자 오버로딩 : 파라미터의 수와 자료형, 인자 레이블 기준으로 식별
  - 이름은  init 고정.
  - 리턴값 없음
- subscript 오버로딩 : 메소드 오버로딩과 동일.
  - 이름은 subscript로 고정



#### 2) 오버라이딩

- Objective-C
  - 메소드만 오버라이딩 가능

- Swift 
  - 메소드/프로퍼티/subscript/생성자 오버라이딩 가능
  - `override` 키워드로 명시적 선언 



Swift 프로퍼티 오버라이딩

- 상속받은 속성 재정의
- `override` 에 get / set  구현하여 오버라이딩
- 상위 클래스는 프로퍼티에 직접 접근
- 하위 클래스는 get/set 통해서 프로퍼티 접근

#### 방법 1: override & get / set

```swift
class Super{
	var value = 0
}
class ErrorSub: Super{
  override var value = 0 //Error
}
class Sub: Super{
  override var value : Int {
    get{
      return super.value	// 반드시 super로 접근해야 함. self시 재귀호출 에러
    }
    set {
      super.value = newValue	// 반드시 super로 접근해야 함. self시 재귀호출 에러
    }
  }
}
let a = Super()
a.value = 123
print(a.value) //123

let b = Sub()
b.value = 456
//setter of value
print(b.value)
//getter of value
//456
```

- 반드시 super로 접근해야 함. self시 재귀호출로 인한 에러 발생

#### 방법 2 : 상속된 프로퍼티에 프로퍼티 옵저버 추가

```swift
class Sub: Super{
  override var value : Int {
    didSet{
      print("didSet value")
    }
  }
}
let a = Super()
a.value = 123
let b = Sub()
b.value = 456 //didSet value
```

- 단, let 선언 상수나 read-only 프로퍼티는 불가능





### 생성자 오버라이딩

- 생성자 딜리게이션 정상실행되도록 주의하면서 오버라이딩

#### Swift

- 상위 클래스의 **지정 생성자 오버라이딩하면** 생성자 상속 규칙에 따라 **다른 지정 생성자가 상속되지 않음.**

  ```swift
  class Super{
    var value = 0
    init(){
      value = 0
    }
    init(value: Int){
      self.value = value
    }
  }
  ```

Super 상속하는 Sub에서 <u>생성자 오버라이딩 하지 않으면</u> **두 생성자 모두 상속**함.

- ```swift
  class Sub: Super{
    
  }
  let a = Sub()
  let b = Sub(value: 123)
  ```

**<u>Sub 클래스에서 Int 받는 생성자 오버라이딩 시, 파라미터 없는 기본 생성자는 더이상 상속되지 않음</u>**

- 모든 지정 생성자를 상속하거나, 오버라이딩한 생성자만 사용



#### final 선언

- 클래스에 final 키워드 추가시 서브 클래스가 해당 클래스 상속 불가
- 클래스 프로퍼티, 메소드, 서브스크립트 선언에 **개별적으로 final 추가 가능**
  -  프로퍼티, 메소드, 서브스크립트에  `final` 추가시, **상속 클래스에서 override 불가**



### 정적 타이핑(compile time) / 동적 타이핑(run time)

- 값의 형식을 지정하거나 확인하는 것

#### 정적 타이핑 

- 값의 형식을 명확히 지정. 
- 컴파일러에 의해 값의 손실, 자동형변환 오류를 쉽게 발견
- 컴파일 타임에 모든 타입이 결정됨
- 높은 성능
- 해당 타입이 제공하지 않는 속성/메소드 호출 시 컴파일 오류



#### 동적 타이핑

- 값의 형식을 명확히 지정하지 않음

- Any, AnyObject 

- 유연한 코드 작성

- 성능 낮음

- Swift는 Objective-C와의 호환성 위한 경우 제외하고는 거의 활용 않음

- 런타임 이전에는 오류가 발생하지 않다가, 런타임에 오류 발생

- 타입 동일성 체크(instropection)인 `is` 연산자 를 활용해 인스턴스의 실제 형식을 먼저 확인해야 함.

  **인스턴스 is DataType or Protocol**



### 업캐스팅 / 다운캐스팅

- 상속 계층에 있는 상위 클래스의 형식은 하위 클래스의 인스턴스를 저장 가능

- 업캐스팅 : 하위 클래스의 인스턴스가 상위 클래스의 형식으로 변환되는 것

- ```swift
  var drink: Drink = Coke()
  ```

  - 하위 클래스에 선언된 속성접근이나 메소드 호출 불가
  - **상위 클래스 타입의 콜렉션**에 **하위 클래스 요소 저장시 업캐스팅**이 일어남

- 다운 캐스팅 : 형식변환 연산자 `as?`, `as!` 로 다운캐스팅 가능
  - as? : 변환 성공시 변환된 인스턴스 리턴, 실패시 nil
  - as! : 변환 성공시 동일, 실패시 런타임 에러





### 정적 바인딩과 동적 바인딩

바인딩 : **메소드를 호출하는 코드**를 **메모리에 저장된 실제 코드와 연결**하는 것

- #### 정적 바인딩 

  -  호출할 메소드가 컴파일 타임에 결정

- #### 동적 바인딩

  - 런타임에 바인딩 수행
  - **1) 동적 타이핑으로 선언된 형식 (Any, AnyObject)** 이나 
  - **2) 업캐스팅**된 형식에서 **호출하는 메소드**는 
  - 컴파일 타임에 정확한 형식 판단 불가능하므로 **<u>바인딩을 런타임으로 보류한다.</u>**
  - **<u>실제 형식에 따라 오버라이딩된 메소드가 호출</u>**되는 장점
  - `is` 를 통한 인스턴스 타입 체크로 오류 예방





## 프로토콜

#### 프로토콜 composition

protocol1 **&** protocol2 **&** protocolN

ex :  typealias **Codable** = Encodable **&** Decodable

#### 프로토콜 적합성

- 프로토콜 채택여부를 나타냄 : is, as 연산자로 확인 가능

#### 프로토콜 

- 프로토콜 선언부 내부에는 저장 프로퍼티가 올 수 없다. (연산 프로퍼티는 가능)
  - (static) **var 속성이름 : 자료형 {  get(읽기) / set (쓰기) }**
- 메소드, 생성자 선언 가능
- 클래스, 구조체, 열거형이 공통적으로 구현할 메소드, 속성 목록 선언
- protocol 키워드





## 연산자 / 제네릭 추후에 ..