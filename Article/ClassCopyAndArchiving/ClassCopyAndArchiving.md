# Class object의 Copy와 Archiving

## 0. Intro

### NSZone, NSCopying

- [원본 출처](http://wjapps.com/xe/Objective_C/1299)

- Cocoa에서는 메모리의 Heap 영역보다 발전된 Zone 영역을 사용함. 

  - 일반적인 Heap 영역은 메모리 할당/해제가 반복되는 경우, 데이터 엑세스 영역이 늘어나서 효율성이 감소된다.
  - Zone 영역을 이용하면 **참조 지역성( 국소성, principle of locality)**을 살린 메모리 접근이 가능하다.
  - 메모리 상에 임의의 Heap 영역을 만들어서 Zone을 생성할 수 있다. 
  - Default Zone : 프로그램 실행 직후 존재하는 Zone. Default Zone을 별도 지정하지 않으면 프로그램의 인스턴스 객체는 이 Default Zone 내에 생성됨.

  ---

  [참조 지역성 관련 출처]( https://anyflow.net/311 )

  - **참조 국소성 :** 1개의 자원에 여러번 접근하는 처리에 관한 정보공학상의 개념으로, 3종류가 존재
    - 시간 지역성(temporal locality): 어느 시기에 참조된 자원은 가까운 미래에 다시 참조될 가능성이 높음(순환, 서브루틴, 스택 등)
    - 공간 지역성(spatial locality) : 어떤 자원이 참조되면, 그 근처의 자원이 참조될 가능성이 높음(배열 등)
    - 순차 지역성(sequential locality) : 메모리를 순차적으로 참조할 가능성이 높음(공간 지역성의 일종)
  - **참조 지역성의 대표적 발생 원인**
    1. 프로그램의 순차적 실행 경향. 프로그램에서 분기(branch)와 프로시저 호출(procedure call)은 상대적으로 타 명령어에 비해 참조 빈도가 적다.
    2. 짧은 시간 동안 몇 개의 프로시저들로 국한되어 명령어들이 참조되는 경향. 프로그램은 일반적으로 한정된 수의 프로시저들이 계속 호출하며 실행되는 상태를 유지한다.
    3. (LOOP등으로 대표되는) 대부분의 반복 구조의 경우 비교적 적은 수의 명령어들로 구성됨. 연속된 작은 부분에 국한되어 계산이 이루어짐.
    4. 대부분의 프로그램에 배열 또는 레코드와 같은 데이터 구조에 대한 처리가 많음. 이러한 데이터 구조에 대한 연속적인 참조는 가깝게 인접해 있는 데이터 항목에 대한 참조임.

  ---



## 1-1. copy, mutableCopy 메서드

- 기본적으로 클래스에 대한 대입연산은 reference Type 에 대한 참조형태로 이뤄진다. (call by reference)
- 따라서 아래의 코드에서 `numberArray` 와  `shallowCopiedNumberArray` 는 같은 메모리주소를 공유하는 서로 다른 이름의 변수이다.

```swift
import Foundation

var numberArray : NSMutableArray = ["one", "two", "three", "four"]
var shallowCopiedNumberArray = numberArray  
//shallow copy. 메모리 참고 주소가 서로 같다.
shallowCopiedNumberArray.removeObject(at: 0)
print(numberArray)
print(shallowCopiedNumberArray)
/* 결과 
numberArray
(
    two,
    three,
    four
)
shallowCopiedNumberArray
(
    two,
    three,
    four
)
 */


```



- Array에 대해 `깊은 복사` 를 하려면 아래와 같이 `NSMutableArray` 형태로 선언 후, `mutableCopy` 를 통해서 새로운 메모리주소에 값을 복사하여 전달한다. 
- `NSMutableArray` 는 기본적으로 클래스의 형태이다. 
  - **open** **class** NSMutableArray : NSArray 
  - 기본 Array는 구조체이므로 대입연산시 값에 의한 복사가 일어난다. 즉, Default가 deep copy이다.

```swift
///NSMutableArray에 대해 mutableCopy를 사용하면 깊은 복사를 이용하여 새로운 인스턴스를 만들 수 있다.
var numberArray2 : NSMutableArray = ["one", "two", "three", "four"]
var mutableCopiedArray = numberArray2.mutableCopy() as! NSMutableArray    //deep copy
mutableCopiedArray.removeObject(at: 0)
mutableCopiedArray.add("five")
print(numberArray2)
print(mutableCopiedArray)
/*
numberArray2
(
    one,
    two,
    three,
    four
)
mutableCopiedArray
(
    two,
    three,
    four,
    five
)
*/
```



cf. Value Type인 Struct Array예제

```swift
var testArray: Array = ["one", "two", "three", "four"]
var testCopiedArray = testArray
testArray.append("five")
print(testArray)				//["one", "two", "three", "four", "five"]
print(testCopiedArray)	//["one", "two", "three", "four"]
```



## 1-2. NSCopying 프로토콜 구현하기

- 커스텀 클래스의 깊은 복사는 어떠한 방식으로 실행되어야 하나? 위에 서술한 NSCopying 프로토콜을 확장 채택하여 `copy` 메서드를 준수하도록 설정하면 된다. 

- [ Objective-C의 경우 ] 
  - 실제 복사를 처리하는 것은 copy 메서드가 아니라 copyWithZone: 이라는 인스턴스 메소드이다. 
  - 인스턴스 객체에 copy 메시지를 보내면 매개변수를 NIL로 지정해서 자기 자신의 copyWithZone:을 호출
  - 이렇게 함으로써 디폴트 존에 새로운 인스턴스를 만든다.
  - zone 영역에 인스턴스가 복사되도록 하기 위해서는 copy 메서드가 아닌 copyWithZone: 메서드를 정의한다





```swift
public protocol NSCopying {
    func copy(with zone: NSZone? = nil) -> Any
}
public protocol NSMutableCopying {
    func mutableCopy(with zone: NSZone? = nil) -> Any
}
```

```swift
/// class는 기본적으로 깊은복사를 지원하는 프로토콜인 NSCopying을 채택할 수 있다.
/// 커스텀 클래스의 깊은 복사를 위해서는 NSCopying을 채택하고, copy 메서드를 구현하면된다.
class Drink {
    var brand: String = ""
    init(){
    }
}

extension Drink : NSCopying {
    public func copy(with zone: NSZone? = nil) -> Any {
        let newDrink = Drink()
        return newDrink
    }
}

var cola = Drink()
cola.brand = "pepsi"
var fanta = cola.copy() as! Drink
fanta.brand = "coca cola"
print(cola.brand) //pepsi
print(fanta.brand) //coca cola
```



## 1-3. Class내 요소의 얕은 복사

- **클래스 내부 프로퍼티가 클래스인 경우**, 클래스 자체에 대해서 mutableCopy를 해도 얕은 복사가 일어난다. 
- 아래 예제를 보자

```swift
/// 얕은복사의 경우...
/// 내부 요소가 class인 경우에는 내부요소에 대해 깊은복사(서로다른 메모리주소의 인스턴스)가 아니라, 얕은복사가 일어나게 된다.
var dataArray : NSMutableArray = [
                                      NSMutableString(string: "one"),
                                      NSMutableString(string:"two"),
                                      NSMutableString(string:"three"),
                                      NSMutableString(string:"four")
                                 ]
var dataArray2 = dataArray.mutableCopy() as! NSMutableArray
var stringItem = dataArray[0] as! NSMutableString
stringItem.append("ONE")
print(dataArray)
print(dataArray2)

/*
(
    oneONE,
    two,
    three,
    four
)
(
    oneONE,
    two,
    three,
    four
)
*/
```

- 얼핏보기엔 두 객체가 서로 같은 객체 상태로 위에서 다뤘던 아래의 case와 별반 다를거 없어보인다.

```swift
var numberArray : NSMutableArray = ["one", "two", "three", "four"]
var shallowCopiedNumberArray = numberArray  
shallowCopiedNumberArray.removeObject(at: 0)
///아래 결과 2개 반복
(
    two,
    three,
    four
)
```

- 그러나 아래 코드를 보면 dataArray와 dataArray2인 `NSMutableArray` 자체는 서로 다른 인스턴스임을 알 수 있다.

```swift
var dataArray : NSMutableArray = [
                                      NSMutableString(string: "one"),
                                      NSMutableString(string:"two"),
                                      NSMutableString(string:"three"),
                                      NSMutableString(string:"four")
                                 ]
var dataArray2 = dataArray.mutableCopy() as! NSMutableArray
var stringItem = dataArray[0] as! NSMutableString
dataArray2.removeObject(at: 0)
stringItem.append("ONE")
print(dataArray)
print(dataArray2)
/*
(
    oneONE,
    two,
    three,
    four
)
(
    two,	//dataArray2.removeObject(at: 0)의 결과로 첫 원소가 사라졌다.
    three,
    four
)
*/
```



### 얕은 복사의 원인

- NSMutableArray의 요소에 대해 인덱스 접근 후 값 변경시, 두 NSMutableArray의 요소가 동일하게 변경되는 것을 알 수 있다.
- 이는 **`NSMutableArray`** 자체에 대해서는 깊은 복사가 이뤄졌지만, **`NSMutableString`** 또한 클래스기 때문에 이에 대해서는 추가적으로 mutableCopy가 이뤄지지 않았기에 요소에 대해서 얕은 복사가 일어난 결과이다.



### 해결방안

따라서 아래와 같이 요소 각각에 대해서도 mutableCopy를 적용한다면, 깊은 복사의 형태로 해결할 수 있다.

```swift
var dataArray : NSMutableArray = [
                                      NSMutableString(string: "one"),
                                      NSMutableString(string:"two"),
                                      NSMutableString(string:"three"),
                                      NSMutableString(string:"four")
                                 ]
var dataArray2 = dataArray.mutableCopy() as! NSMutableArray
dataArray2.removeObject(at: 0)
/// 클래스 요소에 대한 mutableCopy()시행
for (index, data) in dataArray2.enumerated() {
    dataArray[index] = (data as! NSMutableString).mutableCopy() as! NSMutableString
}
var stringItem = dataArray[0] as! NSMutableString
stringItem.append("ONE")
print(dataArray)
print(dataArray2)
/*
(
    oneONE,
    two,
    three,
    four
)
(
    one,
    two,
    three,
    four
)
*/
```



### 참조 

http://wjapps.com/xe/Objective_C/1280

http://wjapps.com/xe/Objective_C/1299

|                   데이터 타입                    | 추천방식                    |
| :----------------------------------------------: | :-------------------------- |
|                   사용자 설정                    | NSUserDefaults              |
|             작은 파일, 크로스 플랫폼             | NSPropertyListSerialization |
| 객체 참조 그래프와<br/>(non-property list types) | NSKeyedArchiver             |
|        큰 데이터, 객체 참조 데이터베이스         | Core Data                   |
|                특정 형식의 데이터                | Custom Format               |





-----

----



# 2. Keyed Archiving

### Object Graph

- 가령 NSArray = [NSString, NSString, ….] 의 형태로 데이터가 저장이 되어있다면 이는 두 객체간의 그래프로 나타낼 수 있다.
- 마찬가지로 UIViewController 클래스 내에 프로퍼티로 NSString, NSArray(요소로 UIView, UIScrollView, UIButton 등을 지님) , … NSURL 등의 오브젝트가 존재하면 이를 오브젝트간의 그래프 형태로 나타낼 수 있다. (rootNode는 UIViewController로 )



### Keyed Archiving

- 객체의 아카이빙이란, 객체의 그래프를 따라 객체의 프로퍼티의 내용을 모두 기록하고, 파일 시스템에 이를 저장하는 방식을 의미한다. 
- Archive <-> UnArchivie 를 통해 객체의 상태를 불러오거나(UnArchive), 저장(Archive)할 수 있다.

- 객체 그래프를 그대로 저장할 때 사용한다.
- 하위/상위 호환성을 유지할 수 있다
- 인코딩/디코딩 과정에서 대체가능하다
- 객체가 Plist 지원하도록 강제할 필요가 없다.
- **단, NSCoding 프로토콜을 반드시 구현해야 한다.**
  - 다시 읽어들일 수 있는 형태로 연관된 참조나 객체들을 저장할 수 있게 해준다.
- 또한, **NSCoding 프로토콜을 구현하기 위해서 반드시 NSObject도 상속받아야** 한다.
  - [참고설명](https://www.youtube.com/watch?v=V9OmySqbBK4)

- NSCoding 프로토콜을 준수하면, NSKeyedArchiver 를 이용해서 객체 내 데이터를 쉽게 저장할 수 있다.

  > NSKeyedArchiver : A coder that stores an object's data to an archive referenced by keys.



### NSCoding

- 객체의 아카이빙시에 가변객체나 다중참조 관계를 원래대로 복원해야하는 경우 위 프로토콜을 사용한다. 

- NSCoding 프로토콜은 객체 인스턴스를 인코딩하거나 다시 객체로 디코딩하기위한 두 개의 메서드가 존재한다.

  - encode(with:) : 객체 인스턴스를 인코딩하는 메서드 

    ```swift
    func encode(with aCoder: NSCoder)
    ```

  - init?(coder:) => 파일시스템에서 인코딩된 내용을 객체로 디코딩하는 메서드

    ```swift
    required init?(coder aDecoder: NSCoder)
    ```

  - NSCoder 클래스 

    - 메모리상에 있는 객체 인스턴스 변수를 다른 형태로 변환하기 위한 추상클래스이다.
    - `NSKeyedArchiver`, `NSKeyedUnarchiver`, `NSPortCoder` 등의 하위 클래스를 사용한다.

### NSKeyedArchiver

- Object graph의 구성을 책임지는 오브젝트이다.
- 사용자가 저장할 가장 최상단의 오브젝트인 root Object를 취한다.
- object를 machine 독립적인 바이트 스트림으로 변환한다.
- Identity와 relationships은 objects와 오브젝트내 values 사이에 보존이 된다.
- 다만, Weak references는 유지되지 않는다.



###Coders

- Coder objects를 사용하여 Objects를 읽거나 쓰는 역할을 한다.
- NSCoding 프로토콜을 구현하면서 오브젝트를 아카이브화 할 수 있게 해준다.
  - encode 메서드(object -> bytes)나 이니셜라이저(bytes -> class object)를 통해 NSCoding 프로토콜을 구현할 때, 두 메서드는 모두 Coder 객체를 넘긴다.



### 아카이빙 예제 (1) 

- 실습을 하면서 직접 출력을 확인해보았다. 예시코드의 기본 틀은 밑의 블로그의 예시 코드를 참고했음을 밝힌다.

  [출처 - 이동건님의 이유있는 코드 블로그](https://baked-corn.tistory.com/60)

- convenience 이니셜라이저를 사용하였으나, 역시 해당 이니셜라이저는 encode 메서드와 함께 NSCoding 프로토콜을 준수한다.

- 저장하는 방식은 최근의 iOS 버전을 기준으로 모두 encode로 통일되었지만, decode는 데이터타입에 따라서 호출 메서드가 다르다.

  - String - decodeObject, Integer - decodeInteger 
  - 이를 지키지 않으면 nil 값을 반환하거나, 기본으로 지정한 default 값을 지닌 프로퍼티를 반환한다. (int 값에  decodeObject 호출로 테스트 해봄)

```swift
/// NSCoding 프로토콜을 준수하는 클래스 정의부
class ToDo: NSObject, NSCoding {
    var title: String
    var desc: String
    var number: Int
    
    init(title:String, description: String, number: Int) {
        self.title = title
        self.desc = description
        self.number = number
    }
    func encode(with aCoder: NSCoder) { // --- 1
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(self.desc, forKey: "desc")
        aCoder.encode(self.number, forKey: "num")
    }
    required convenience init?(coder aDecoder: NSCoder) { // --- 2
        guard   let title = aDecoder.decodeObject(forKey: "title") as? String,
            let desc = aDecoder.decodeObject(forKey: "desc") as? String,
            let number = aDecoder.decodeInteger(forKey: "num") as? Int
            else {
                return nil
        }
        self.init(title: title, description: desc, number: number)
    }
}
```

```swift
var todo:[ToDo] = [ToDo.init(title: "title test", description: "description", number: 1)]

func save(){
    let encodedData = NSKeyedArchiver.archivedData(withRootObject: todo) // --- 1
    UserDefaults.standard.setValue(encodedData, forKey: "todo") // --- 2
}

func load(){
    guard let encodedData = UserDefaults.standard.value(forKeyPath: "todo") as? Data else { return  } // --- 3
    todo = NSKeyedUnarchiver.unarchiveObject(with: encodedData) as! [ToDo] // --- 4
    print(todo[0].title, todo[0].desc, todo[0].number)
}
save()
load()
```

#### [ 단계 1] Save -  `NSKeyedArchiver`를 통해 아카이빙을 한다. 

```swift
let encodedData = NSKeyedArchiver.archivedData(withRootObject: todo)
//class func archivedData(withRootObject rootObject: Any) -> Data
```

-  `archiveRootObject(withRootObject:)` : 단순한 아카이빙 메서드. 현재는 deprecated 되어있는 상태이다.

-  `archiveRootObject(rootObject: toFile:)` : 특정 파일에 저장을 하는 아카이빙 메서드이다.  

- 그리고 이렇게 반환되는 압축된 데이터의 타입은 `Data` 타입입니다.



#### [단계 2] Save - 압축된 `Data` 타입의 `encoding된 Data`를 `UserDefaults`에 저장한다.

```swift
UserDefaults.standard.setValue(encodedData, forKey: "todo")
//func setValue(_ value: Any?, forKey key: String)
```

- 이 과정은 UserDefaults에 저장가능한 데이터 타입인 경우에 가능하다. 
- FileManager를 활용한 파일저장 방식으로 대체가 가능하다.



#### [단계 3] Load - UserDefault로 부터 Encoded Data 를 불러온다.

```swift
guard let encodedData = UserDefaults.standard.value(forKeyPath: "todo") as? Data else { return  }
```

- `UserDefaults` 의 프로퍼티인 standard 클래스 메서드 `value` 를 통해서 값을 불러오고 이를 저장했던 `Data` 타입으로 타입 캐스팅을 합니다. 
- 이때 불러온 Data는 위에서 단계 1에서 압축된(encoded) `Data` 타입입니다.



####[단계 4] Load - `NSKeyedUnarchiver`를 통해 `bytes -> Class Instance`로 변환 

```swift
todo = NSKeyedUnarchiver.unarchiveObject(with: encodedData) as! [ToDo] 
```

- UserDefaults에 전달한 Key를 통해 불러온 `Data` 타입의 `encoded Data`를 `NSKeyedUnarchiver`를 통해 압축했던 당시 데이터로 타입 캐스팅을 하여 반환합니다.
- 압축전에 지정했던 원래 클래스 배열의 형태로 다시 타입 캐스팅을 해줘야 합니다. (예제에 따라 다름)



### 정리 - 예제 1 방식의 특징

- 전통적인 예제, key/value 형태로 encode decode 과정이 이뤄진다.
- UserDefaults를 통해 Data를 저장함.
- 각각의 저장/로드 과정에서 타입 캐스팅 검사가 필요하다.
-  deprecated 된 메서드를 활용



### 아카이빙 예제 2 - deprecated 메서드 탈피

- 이번에는 deprecated  메서드인 `NSKeyedArchiver.archivedData(withRootObject:)` 가 아니라, 개편된 아카이브 메서드인 `NSKeyedArchiver.archivedData(withRootObject: classInstance, requiringSecureCoding: Bool)` 를 사용해봅니다.
- 단, 시큐어코딩 인자는 false를 전달합니다.
- 또한 언아카이브시에는 `unarchiveTopLevelObjectWithData` 메서드를 사용합니다.

```swift
class Robot: NSObject, NSCoding{
    var name: String
    var model: Int
    init(name: String, model: Int){
        self.name = name
        self.model = model
    }
    /// 인코딩은 하나의 메서드 encode로 value/key 형태로 입력한다.
    func encode(with aCoder: NSCoder){
        aCoder.encode(name, forKey:"name")
        aCoder.encode(model, forKey: "modelNumber")
    }
    
    /// 디코딩은 메서드가 나뉜다.
    /// decodeObject,decodeInteger등 종류에 따라 다르다. String은 decodeObject로 호출
    required init?(coder aDecoder: NSCoder){
        guard let name = aDecoder.decodeObject(forKey: "name") as? String else{
            print("fail decoding")
            return nil
        }
        let model = aDecoder.decodeInteger(forKey: "modelNumber")
        self.name = name
        self.model = model
    }
    override var description : String {
        return "name: \(name), modelNumber: \(model)"
    }
}
```

```swift
var buzz = Robot(name: "Buzz", model: 122)
print(buzz)
let data = try! NSKeyedArchiver.archivedData(withRootObject: buzz, requiringSecureCoding: false)
UserDefaults.standard.setValue(data, forKey: "robot")
let userDefaultSavedData = UserDefaults.standard.data(forKey: "robot")

/// 언아카이빙시에 unarchiveTopLevelObjectWithData 메서드를 통해
/// archivedData메서드에서 아카이버에 저장된 루트 오브젝트를 언아카이브한다.
var robot = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Robot
if let robot = robot{
    print("robot - \(robot)")   //robot - name: Buzz, modelNumber: 122
} else{
    print("unarchiving error")
}
```



#### 정리 - 예제2 특징

- deprecated된 메서드에서 탈피 
- 여전히 언아카이빙시에 인코딩된 데이터에 대해 타입캐스팅 과정이 필요하다.

```swift
var robot = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Robot
```



### 아카이빙 예제 3 시큐어코딩

- 앞서 예제2를 시행하는 과정에서 **`unarchivedObject( ofClass: from: )`** 메서드의 존재여부를 확인했으나, 호출시 에러 발생
  - 이유 : `NSSecureCoding` 프로토콜을 준수해야 사용가능한 메서드이다.
- [WWDC 2018](https://developer.apple.com/videos/play/wwdc2018/222/)
  - 앱에서 데이터 로딩시 invalid/malicious data로부터 코드와 앱 사용자를 보호하기 위한 방법으로 제시됨

- NSSecureCoding 프로토콜을 채택하여아 한다. 
- NSCoding이 아니라 swift 전용 Codable 프로토콜을 통해서도 구현가능한 부분인 것 같다.
- [관련 예시](https://nshipster.com/nssecurecoding/)

```swift
class NSSecureRobot: NSObject, NSCoding, NSSecureCoding{
    static private var secureCoding = true
    static var supportsSecureCoding: Bool { return secureCoding }
    
    var name: String
    var model: Int
    init(name: String, model: Int){
        self.name = name
        self.model = model
    }
    /// 인코딩은 하나의 메서드 encode로 value/key 형태로 입력한다.
    func encode(with aCoder: NSCoder){
        aCoder.encode(name, forKey:"name")
        aCoder.encode(model, forKey: "modelNumber")
    }
    
    /// 디코딩은 메서드가 나뉜다.
    /// decodeObject,decodeInteger등 종류에 따라 다르다. String은 decodeObject로 호출
    required init?(coder aDecoder: NSCoder){
        guard let name = aDecoder.decodeObject(forKey: "name") as? String else{
            print("fail decoding")
            return nil
        }
        let model = aDecoder.decodeInteger(forKey: "modelNumber")
        self.name = name
        self.model = model
    }
    override var description : String {
        return "name: \(name), modelNumber: \(model), isSecure: \(NSSecureRobot.supportsSecureCoding)"
    }
}
```

```swift
var terminator = NSSecureRobot(name: "Swaltzenegger", model: 1000)
print(terminator)
let secureCoded = try! NSKeyedArchiver.archivedData(withRootObject: terminator, requiringSecureCoding: true)
print(secureCoded)

if let unArchivedRobot = try! NSKeyedUnarchiver.unarchivedObject(ofClass: NSSecureRobot.self, from: secureCoded) {
    print("unArchivedRobot - \(unArchivedRobot)")
    ///name: Swaltzenegger, modelNumber: 1000, isSecure: true
}else{
    print("unarchiving error")
}
```



#### 정리 - 예제3

- deprecated 메서드 제거

- 언아카이빙시 클래스 타입을 지정할 수 있으므로 이후에 부가적인 타입캐스팅이 불필요하다.

  ```swift
  let unArchivedRobot = try! NSKeyedUnarchiver.unarchivedObject(ofClass: NSSecureRobot.self, from: secureCoded)
  ```

- 아카이빙시 시큐어코딩 true 값을 전달하려면 NSSecureCoding 프로토콜을 채택한 클래스 객체를 사용해야 한다.





### 참고 및 출처 

 [공식문서](https://developer.apple.com/documentation/foundation/nscoding)

 [JIN.iOS 블로그](https://jinios.github.io/ios/2018/03/30/archive/)

[공식문서 - nssecurecoding	](https://developer.apple.com/documentation/foundation/nssecurecoding)

[유튜브 - raywenderlich](https://www.youtube.com/watch?v=V9OmySqbBK4)

- iOS에 데이터를 저장하는 방식은 단순히 KeyedArchiver를 이용하는 것만 있지는 않다. 다음의 링크 영상을 참고
- https://www.raywenderlich.com/3761-saving-data-in-ios/lessons/1