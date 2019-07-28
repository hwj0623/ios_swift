# Codable



- 아래 예제를 통해서 알아본다.
- NSCoding의 단점은 크게 두가지 이다.
  - 첫째는 required 이니셜라이저나 encode 메서드에서 모든 클래스 프로퍼티에 대해서 이뤄져야하므로 준수 대상인 두 메서드를 구현하기 위한 코드가 길어진다.
  - 둘째로 아카이빙을 위한 인코딩 데이터의 대상이 클래스에 국한된다.
- Codable은 장기적으로 NSCoding과 NSSerialization, NSDeserialization을 대체하기 위한 프로토콜로 나온 듯 하다. (자세한 연혁은 모르지만...)
  - 구조체나 클래스 모두에 적용이 가능하다
  - JSON String 데이터 형식으로, 즉 문자열로 변환하여 이 데이터를 아카이빙할 수 있다.
  - 또한 JSON String 데이터 형식으로 변환없이 PropertyList(.plist) 에 직접 아카이빙 할 수 있다.
  - 기본 데이터타입 구조체는 모두 Codable을 따른다. 커스텀 클래스의 경우 해당 프로토콜을 준수함을 명시하면 된다.
  - 인코드/디코드 시의 유연함을 위해 CodingKey 프로토콜을 지원하며, 이를 구현하면 클래스의 변수명과 json 데이터의 키값이 엄격하게 같지 않아도 된다.
    - 참고 : https://zeddios.tistory.com/394

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



- iOS 프로그래밍중일때는 JSON 형식으로 인코딩/디코딩하지 않고, .plist인 PropertyList에 저장하는 방법도 있다.

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







### 출처

https://baked-corn.tistory.com/61

https://medium.com/commencis/swift-4s-codable-one-last-battle-for-serialization-30ceb3ccb051

https://useyourloaf.com/blog/using-swift-codable-with-property-lists/

https://zeddios.tistory.com/394