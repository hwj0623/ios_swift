# Codable

### 개념 정리

- 아래 예제를 통해서 알아봅니다.
- NSCoding의 단점은 크게 두가지 입니다.
  - 첫째는 required 이니셜라이저나 encode 메서드에서 모든 클래스 프로퍼티에 대해서 이뤄져야하므로 준수 대상인 두 메서드를 구현하기 위한 코드가 길어집니다.
  - 둘째로 아카이빙을 위한 인코딩 데이터의 대상이 클래스에 국한됩니다.
- Codable은 장기적으로 NSCoding과 NSSerialization, NSDeserialization을 대체하기 위한 프로토콜로 나온 듯 합니다. (자세한 연혁은 모르지만...)
  - **구조체**나 **클래스** 모두에 적용이 가능합니다.
  - 인코딩 방식
    - JSON String 데이터 형식으로, 즉 문자열로 변환하여 이 데이터를 아카이빙할 수 있습니다.(**JSONEncoder** 활용)
    - 또한 JSON String 데이터 형식으로 변환없이 PropertyList(.plist) 에 직접 아카이빙 할 수 있습니다. (**PropertyListEncoder** 활용)
  - 기본 데이터타입 구조체는 모두 Codable을 따른다. 커스텀 클래스의 경우 해당 프로토콜을 준수함을 명시하면 됩니다.
  - 인코드/디코드 시의 유연함을 위해 CodingKey 프로토콜을 지원하며, 이를 구현하면 클래스의 변수명과 json 데이터의 키값이 엄격하게 같지 않아도 됩니다.
    - [참고 사이트](https://zeddios.tistory.com/394)
    - [예제코드 출처](https://medium.com/swift-india/use-of-codable-with-jsonencoder-and-jsondecoder-in-swift-4-71c3637a6c65)

```swift
/// case 4 - Codable
/// https://medium.com/swift-india/use-of-codable-with-jsonencoder-and-jsondecoder-in-swift-4-71c3637a6c65
class Movie: Codable{
    enum MovieGenere: String, Codable {
        case horror, skifi, comedy, adventure, animation
    }
    var name : String
    var moviesGenere : [MovieGenere]
    var rating : Int
    
    init(name: String, moviesGenere: [MovieGenere], rating: Int){
        self.name = name
        self.moviesGenere = moviesGenere
        self.rating = rating
    }
}

/// Codable 프로토콜 채택한 영화 인스턴스 생성
let disneyMovie = Movie.init(name: "Avengers", moviesGenere: [.adventure, .comedy], rating: 9)

/// Encode data - by JSONEncoder
let jsonEncoder = JSONEncoder()
var jsonData: Data!
do {
    jsonData = try jsonEncoder.encode(disneyMovie)
    let jsonString = String(data: jsonData, encoding: .utf8)
    print("Json String : \n"+jsonString!)
    /*
     {
        "name":"Avengers",
        "moviesGenere": [
            "adventure",
            "comedy"
        ],
        "rating":9
     }
    */
} catch{
}

/// JSONEncoder로부터 JSON data를 얻는데, 이는 JSON 문자열을 추출하기 위해 사용된다.
/// Decode data - JSONDecoder
do {
    // Decode data to object
    let jsonDecoder = JSONDecoder()
    let disneyMovie = try jsonDecoder.decode(Movie.self, from: jsonData)
    print("Name : \(disneyMovie.name)")
    print("Rating : \(disneyMovie.rating)")
}
catch {
}

/// 주의 
/// JSONDecoder를 사용하여 JSON String을 클래스로 변환할 때는 주의할 점이 있다. 
/// Optional 값에 해당 하는 것을 디코딩할 때, 값이 없을 수 있는데, 그것을 고려하지 않는 경우 에러가 발생할 수 있다. 
/// Codable은 디코딩시에 이를 고려하기때문에 별도의 트릭이 필요하지 않다.
/// https://medium.com/commencis/swift-4s-codable-one-last-battle-for-serialization-30ceb3ccb051

class Person: Codable, CustomStringConvertible{
    let name: String
    let age: Int
    let friends: [Person]?
    
    init(name: String, age: Int, friends: [Person]? = nil){
        self.name = name
        self.age = age
        self.friends = friends
    }
    var description: String {
        return "name: \(name), age: \(age), friends: \(friends)"
    }
}
let person = Person(name: "Brad", age: 53, friends: nil)
let encoder = JSONEncoder()
jsonData = try encoder.encode(person)
print(String(data: jsonData, encoding: .utf8)!)// {"name":"Brad","age":53}

/// deserialize
let decoder = JSONDecoder()
let decoded = try decoder.decode(Person.self, from: jsonData)
print("\(type(of: decoded))") // Person
print("\(decoded)")

/// Codable의 장점 2가지
/// 1. Mapping
/// 2. Archiving and Unarchiving

/// 원래대로라면 JSON 디코더는 실패에 대비하여 아래의 트릭이 필요하다.
protocol Mappable: Decodable {
    init?(jsonString: String)
}
extension Mappable {
    init?(jsonString: String) {
        guard let data = jsonString.data(using: .utf8) else {
            return nil
        }
        do{
            self = try JSONDecoder().decode(Self.self, from: data)
        }catch{
            return nil
        }
    }
}

```



- iOS 프로그래밍중일때는 JSON 형식으로 인코딩/디코딩하지 않고, .plist인 PropertyList에 저장하는 방법도 있습니다.
  - 이동건님 블로그의 코드를 차용하였음을 밝힙니다.

```swift
class ToDo2: Codable, CustomStringConvertible{
    var title: String
    var desc: String
    
    init(title:String, description: String){
        self.title = title
        self.desc = description
    }
    var description: String {
        return "Todo2 title: \(title), desc: \(desc)"
    }
}
var todo2: [ToDo2] = [ToDo2]()
todo2.append(ToDo2.init(title: "Codable todo", description: "Codable todo desc"))
todo2.append(ToDo2.init(title: "Codable todo2", description: "Codable todo2 desc"))


func save2(){
    UserDefaults.standard.set(try? PropertyListEncoder().encode(todo2), forKey: "todos2") // --- 1
}

func load2(){
    if let data = UserDefaults.standard.object(forKey: "todos2") as? Data {
        todo2 = try! PropertyListDecoder().decode([ToDo2].self, from: data) // --- 2
        for element in todo2 {
            print("todo2 : \(element)")
        }
    }
}

save2()
load2()
```



-----

----



## 실제 애플리케이션에서 적용하면서 추가적으로 고려할 이슈

### 1. Enum class

- 클래스의 프로퍼티로 Enum 데이터 타입을 지닌 경우, 클래스 자체에 대한 Codable만으로는 Encodable과 Decodable 프로토콜을 구현하지 못했다는 컴파일 에러메시지를 발견하게 된다.

- 기본 데이터타입(구조체)의 프로퍼티에 대해서는 Codable 프로토콜 적용시 인코딩/디코딩이 자동으로 설정되지만, 커스텀 데이터 타입이니만큼 해당 데이터타입에 대해 이를 명시해줘야한다.

- enum DataType에 rawValue를 지정해 주어야하는데, 이는 결국에 해당 enum case 에 대해 암묵적으로 CodingKey를 부여하기 위한 조치라고 판단합니다.

  - 위 문장은 stackoverflow를 찾아보며 hashValue는 왜 안되는가에 대한 질문에 대한 답변을 참고로 유추하였습니다.
  - https://stackoverflow.com/questions/43512146/how-can-i-encode-with-nscoding-an-enum-that-has-no-rawvalue/45908916#45908916

- Associated type을 적용한 예제는 아래의 레퍼런스를 참고하면 좋습니다.

  -  https://www.objc.io/blog/2018/01/23/codable-enums/
  - [스택오버플로 예제 링크](https://stackoverflow.com/questions/44580719/how-do-i-make-an-enum-decodable-in-swift-4)

- 가령, Fruit 라는 enum DataType에 대해 다음과 같이 지정할 수 있겠다.

  - Decodable 프로토콜에서 준수해야하는 Decoder 파라미터를 받는 이니셜라이저를 직접 구현함으로써 enum에 대한 Codable 프로토콜 준수를 이행한다.
  - rawValue로 String을 추가해줬던 것이 여기서 장점을 발휘한다. `switch 문으로 label의 값을 전부 분류할 필요 없이` , rawValue로 enum을 생성하여 어느 case에 해당하는지 지정할 수 있다. (물론 디폴트 값에 대한 처리가 있어줘야겠다.)
    - 수정 : 과제 코드를 구현하면서 enum에 대한 init을 수동으로 작성해야 한다고 생각했었는데, 이는 associated type에 국한된 것이고, swift4에서는 기본 enum 은 rawValue만 있으면 Codable 프로토콜 채택으로 자동으로 인코딩/디코딩을 지원해준다고 합니다. 

  ```swift
  enum Fruit: String, CustomStringConvertible, Codable{
      case strawberry
      case purpleGrape
      case orange
      case whiteGrape
      case mango
      
      init(from decoder: Decoder) throws {
          let label = try decoder.singleValueContainer().decode(String.self)
          self = Fruit(rawValue: label) ?? .strawberry
      }
  }
  ```



### 2. SubClass of Codable class

- codable로 선언한 클래스를 상속받는 하위 클래스의 경우 Encodable과 Decodable 프로토콜(typealias Codable = Encodable & Decodable 이니..)을 준수하지 못했다는 에러메시지가 뜹니다.

- 애먹은 부분이긴한데, fix 추천 메시지로 생성되는 아래와 같은 required init을 그대로 놔두기엔 찝찝하였습니다.

  ```swift
  required init (from decoder: Decoder) throws {
  		fatalError( "어쩌고 저쩌고, 디코딩 안되면 너님 클남")
  }
  ```

  관련 레퍼런스를 찾아보니, 서브클래스에서 추가된 프로퍼티에 대해서는 상위 클래스에서 따르는 Codable외에 추가적으로 프로퍼티에 대한 인코드/디코드 관련 로직이 필요하다고 합니다. 

  [ WWDC 2017에 나온 샘플 코드 ]

  ![이미지](https://i.stack.imgur.com/ptFvB.jpg)

  

- 우선 CodingKey를 따르는 private enum `CodingKeys` 에 서브클래스에서 새로 추가된 프로퍼티에 대해 기술합니다.

- 두번째로는 required init 내에 decode 시에 `CodingKeys` 를 키로하는 디코더 컨테이너에 접근하여 해당 프로퍼티의 데이터 타입에 맞는 디코드 작업이 이뤄져야합니다.

- 다음으로는 상위 클래스의 디코더를 불러와서 `super.init` 으로 상위 클래스의 이니셜라이저를 호출(역시 Decoder에 의한 디코딩 작업이 이뤄지는 부분) 을 수행합니다.

- `서브클래스의 프로퍼티가 다른 클래스나 구조체, enum인 경우`에는 역시 해당 객체가 **Codable**을 따르도록 설정해야 합니다. 

- 인코딩에 대해서도 필요하다면  `func encode(to encoder: Encoder) throws{}` 메서드를 오버라이드해서 같은 식으로 작업을 처리해주면 됩니다.

- 아래 스택오버플로에서는 순환참조식으로 super class에서 subclass를 프로퍼티로 지닌 경우에 데이터 손실이 발생하는 버그가 발생한다고 합니다. 아카이브의 경우에도 strong reference cycle이 발생하는 구조에서 데이터 복원이 원활하지 않을 수 있다는 설명을 들은 바 있는데, 유사한 주의가 필요해보입니다.

  - [링크](https://stackoverflow.com/questions/44553934/using-decodable-in-swift-4-with-inheritance)

  



### 3. PairValue

- typealias로 지정한 pairValue (ex :`(String, Int)`)에 대해서는 프로퍼티로 codable이 적용되지 않는듯 합니다.
  -  테스트 클래스에서 프로퍼티를 가지고 실험?을 하던 중 typealias 로 pair value를 지닌 프로퍼티를 추가해보니 Encodable, Decodable 프로토콜 미준수 에러가 떠서 알게 되었습니다.
- Codable 적용시 해당 pair값이 클래스/구조체 내에서 프로퍼티의 데이터 타입으로 꼭 필요한 경우, 구조체의 형태로 변환하여 쓰는 것을 추천합니다.



### 결론

- 이렇게 Codable로 설정하여 인코딩/디코딩 가능한 인스턴스 객체는 JSON 형태로 File/UserDefaults 등에 저장하거나, PropertyList에 저장할 수 있습니다.

----

---



### 출처

공식문서

https://developer.apple.com/videos/play/wwdc2017/212/

https://developer.apple.com/documentation/foundation/archives_and_serialization/encoding_and_decoding_custom_types

블로그

https://baked-corn.tistory.com/61

https://medium.com/commencis/swift-4s-codable-one-last-battle-for-serialization-30ceb3ccb051

https://useyourloaf.com/blog/using-swift-codable-with-property-lists/

https://zeddios.tistory.com/394

스택오버플로

https://stackoverflow.com/questions/44553934/using-decodable-in-swift-4-with-inheritance



-----

