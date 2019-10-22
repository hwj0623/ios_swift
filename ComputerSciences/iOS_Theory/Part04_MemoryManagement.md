# Part 04 - 메모리 관리 

## 1) 메모리 관리 규칙

### MMR 

- **<u>객체 소유권 기반으로 메모리 관리.</u>**
- 모든 객체는 하나 이상의 소유자가 있는 경우에 메모리에 유지됨.
- 소유자에 의해 포기되어 소유가자 없는 메모리는 해제됨.
- **객체 소유권을 파악**하기 위해 **참조 카운트 사용**
  - 객체 소유시 +1
  - 소유권 포기시 -1
- retain, release, autorelease 메소드를 사용하여 객체 소유권과 관련된 코드 직접 구현해야 함.



### ARC

- 참조 카운트 모델
- 컴파일러에 의해 메모리 관리 코드 자동 추가. 



## 소유정책

모든 객체는 생성시 참조 카운트 = 1 로 생성

retain 메시지 보내면 참조 카운트 += 1. 메시지를 보낸 호출자는 객체를 소유

release 메시지 보내면 참조 카운트 -= 1. 소유권 포기

autorelease 메시지 : 현재 사용중인 autoreleasepool 블록의 실행 종료 시점에 참조 카운트 1 감소

참조 카운트 0 : 객체 메모리 해제





## ARC 

- 컴파일러가 객체 생명주기에 적합한 메모리 관리 코드를 추가하는 방식
- 런타임에 주기적으로 메모리 정리하는 GC와 달리, 컴파일 시점에 코드가 자동으로 추가되는 방식.
  - 런타임에 메모리 관리 위한 오버헤드 없음
  - ARC는 객체 생성시 객체에 대한 정보를 저장하는 별도의 메모리 공간 생성
  - 이 공간에는 객체에 대한 형식정보와 속성 값이 저장됨.
- MRR의 메모리 관리 규칙/소유 정책이 동일하게 적용 **+ 추가적인 규칙**
- Transitioning to ARC Release Notes 에 따른 추가규칙  (Objective-C에 해당)
  - dealloc 메소드 직접 호출 불가. 하위 dealloc 메소드 구현에서 상위 클래스의 구현을 호출 할 수 없음
  - retain, release, autorelease, retainCount 메소드 구현하거나 직접 호출 불가
  - C 구조체에서 객체 포인터 사용 불가
  - NSAllocatedObject, NSDeallocatedObject 클래스 사용 불가
  - NSAutoreleasePool 객체 사용 불가
    - @autoreleasepool 블록으로 대체
  - 프로퍼티 접두어로 `new` 사용 불가.



### 강한 참조(Strong Reference) 문제 

- 해제된 객체에 접근하는 코드는 런타임 오류

- 마찬가지로 활성화된 참조가 하나라도 존재하면 메모리 해제되지 않음

- **기본적으로 새로 생성된 객체**는 자신이 **할당된 프로퍼티 또는 변수와 강한 참조를 유지**

  ```swift
  var person1: Person?
  var person2: Person?
  person1 = Person() //Person 객체와 강한 참조 유지
  person2 = person1  // ""
  person3 = person1  // ""
  ```

  - Person 객체의 참조 카운트 == 3

  ``` swift
  person1 = nil //참조 카운트-=1 >>> == 2
  person2 = nil //참조 카운트-=1 >>> == 1
  person3 = nil //참조 카운트 == 0. 메모리 해제
  ```

  

- 만약, Person이 Car? 클래스를 프로퍼티로 소유하고, Car 클래스는 Person? 데이터타입의 lessee 프로퍼티 소유한다고 가정

  ```swift
  class Person {
    var name = "John Doe"
    var car: Car?
    deinit{
      print("\(name) is being deinitialized")
    }class PersonA {
    var name = "John Doe"
    var car: CarA?
    deinit{
      print("\(name) is being deinitialized")
    }
  }
  class CarA {
      var model: String
      var lessee: PersonA?
      init(model: String){
          self.model = model
      }
      deinit{
        print("\(model) is being deinitialized")
      }
  }
  var person: PersonA? = PersonA()
  var rentedCar: CarA? = CarA.init(model: "Porsche 911")
  //강한 참조 형성. 각각의 reference count == 2 가 된다.
  person!.car = rentedCar
  rentedCar!.lessee = person
  //각각의 참조를 해제해도, 상호참조가 남아서 소멸자 호출되지 않음
  person = nil
  rentedCar = nil
  ```



### Weak Reference

- 참조 사이클 문제 해결을 위해 도입

  - objective-c, swift 둘다 가능

- 자신이 참조하는 객체에 대해 강한 참조 유지하지 않음

- 자신이 참조되고 있는 객체가 해제될 때 자신의 값도 nil로 초기화 한다.

  ```swift
  class PersonA {
    var name = "John Doe"
    var car: CarA?
    deinit{
      print("\(name) is being deinitialized")
    }
  }
  class CarA {
      var model: String
      weak var lessee: PersonA?
      init(model: String){
          self.model = model
      }
      deinit{
        print("\(model) is being deinitialized")
      }
  }
  var person: PersonA? = PersonA()
  var rentedCar: CarA? = CarA.init(model: "Porsche 911")
  //강한 참조 형성. 각각의 reference count == 2 가 된다.
  
  // 강한 참조. CarA의 RC ==2
  person!.car = rentedCar 
  //약한 참조. rentedCar는 person을 소유하지 않는다. Person객체의 reference count == 1 인 상태.
  rentedCar!.lessee = person 
  
  //참조 카운트 == 0 이므로 해제. John Doe is being deinitialized
  //person 객체 해제 과정에서 car 객체는 Person 객체에 대한 소유권을 자동으로 포기함.
  person = nil 
  //참조 카운트 == 0 이므로 해제. Porsche 911 is being deinitialized
  rentedCar = nil 
  ```

  

### Unowned Reference (Swift Only)

- 비소유 참조

- #### Weak Reference와의 차이 

  - **옵셔널로 선언되지 않고,** **nil 값을 가질 수 없음**
  - 참조 대상이 해제되는 경우 <u>자동으로 nil 변경이 되지 않아</u> 런타임 오류가 발생할 가능성 존재
  - 참조대상이 항상 존재한다고 확신할 수 있는 경우 (소유 객체의 LifeCycle이 더 큰게 명백한 경우)에만 제한적으로 사용

  ```swift
  class Person {
    var name = "John Doe"
    var fitnessMembership: Membership?
    deinit{
      print("\(name) is being deinitialized")
    }
  }
  class Membership{
    let membershipId: String
    unowned var owner: Person
    init(owner: Person){
      self.owner = owner
      self.membershipId = "20191010"
    }
    deinit{
      print("\(membershipId) membership is being deinitialized")
    }
  }
  
  var p: Person? = Person()
  p!.fitnessMembership = Membership(owner: p!)
  
  p = nil
  //John Doe is being deinitialized
  //20191010 membership is being deinitialized
  ```

  - 모든 사람이 피트니스 멤버십 보유한 것은 아님
  - 멤버십 갖는 경우도 언제든지 해지 가능하므로 옵셔널 선언
  - 모든 멤버십은 반드시 한 명의 회원과 연관되어 있으므로 Non-옵셔널 프로퍼티로 선언.
  - p = nil 에서 Person  객체 해제시 두 객체가 모두 해제됨
  - **멤버십 객체**는 자신과 **강한 참조 유지하는 fitnessMembership 속성 해제 시 함께 해제**됨



### 클로저와 블록의 강한 참조 사이클 문제

- 클로저/블록은 클래스처럼 reference type이다. 

```swift
class ClosureCar {
    var totalDrivingDistance: Double = 0.0
    var totalUsedGas : Double = 0.0
     // closure
    lazy var gasMileage: () -> Double = {
        return self.totalDrivingDistance / self.totalUsedGas
    }
    func drive(){
        self.totalDrivingDistance = 1200.0
        self.totalUsedGas = 73.0
    }
    deinit{
        print("Car is being deinit")
    }
}
var myCar: ClosureCar? = ClosureCar()
myCar!.drive()
myCar!.gasMileage()

myCar = nil // NOT released
```

- gasMileage 클로저 프로퍼티에서 강한 참조가 생긴다. 
  - 클로저를 `lazy` 로 선언하여 **객체 초기화 후에 self에 접근할 수 있도록** 한다.
  - lazy 선언 안하면 컴파일 오류.
- 클로저가 내부에서 `self` 참조하므로 강한 참조 유지된다. 
  - 이 클로저는 내부에서 `self` 의 대상이 되는 객체의 참조를 **캡처**한다. 
  - 횟수에 관계 없이 **클로저가 유지되는 동안에 self로 참조한 객체와 강한 참조를 유지**함.
- 결과적으로 객체와 클로저 간의 참조 사이클로 메모리 누수 발생

```swift
    lazy var gasMileage: () -> Double = {
  		  [unowned self] in 
        return self.totalDrivingDistance / self.totalUsedGas
    }
		//또는
		lazy var gasMileage: () -> Double = {
  		  [weak self] in 
        return self.totalDrivingDistance / self.totalUsedGas
    }

//..
myCar = nil // Car is being deinit
```

