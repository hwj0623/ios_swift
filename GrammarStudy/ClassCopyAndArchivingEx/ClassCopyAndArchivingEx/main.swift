//
//  main.swift
//  ClassCopyAndArchivingEx
//
//  Created by hw on 25/07/2019.
//  Copyright © 2019 hwj. All rights reserved.
//
//
import Foundation

/*****************************
 *    Shallow / Deep Copy    *
 *****************************/
/// case 0 - 구조체 할당
/// 구조체는 기본적으로 call by value의 형태로 값을 복사한다. 즉, 대입연산시 구조체 인스턴스가 별개로 존재한다.
var testArray: Array = ["one", "two", "three", "four"]
var testCopiedArray = testArray
print("=============")
testArray.append("five")
print("구조체의 깊은 복사 - call by value 사례")
print(testArray)
print(testCopiedArray)

/// case 1 - 얕은 복사
/// 새 변수에 기존의 클래스 인스턴스를 직접 할당하게되면, 같은 메모리주소공간을 참조하게 된다.
var numberArray : NSMutableArray = ["one", "two", "three", "four"]
var shallowCopiedNumberArray = numberArray     //shallow copy. 메모리 참고 주소가 서로 같다.
shallowCopiedNumberArray.removeObject(at: 0)
print("클래스의 얕은 복사 사례")
print(numberArray)
print(shallowCopiedNumberArray)

/// case 2 - 깊은 복사
/// NSMutableArray에 대해 mutableCopy를 사용하면 클래스에 대해 깊은 복사를 이용하여 새로운 인스턴스를 만든다.
var numberArray2 : NSMutableArray = ["one", "two", "three", "four"]
var mutableCopiedArray = numberArray2.mutableCopy() as! NSMutableArray    //deep copy
mutableCopiedArray.removeObject(at: 0)
print("=============")
print("클래스의 깊은 복사 사례")
print(numberArray2)
print(mutableCopiedArray)

/// case 3 - custom class에 대한 deep copy
/// class는 기본적으로 깊은복사를 지원하는 프로토콜인 NSCopying을 채택할 수 있다.
/// 커스텀 클래스의 깊은 복사를 위해서는 NSCopying을 채택하고, copy 메서드를 구현하면된다.
class Drink {
    var brand: String = ""
    init(){}
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
print(cola.brand)
print(fanta.brand)

/// case 4 - class in class 의 사례
/// 내부 요소가 class인 경우에는 외부 클래스에 대해서는 깊은 복사가 일어난다.
/// 그러나, 내부요소에 대해 깊은복사(서로다른 메모리주소의 인스턴스)가 아니라, 얕은복사가 일어나게 된다.
var dataArray : NSMutableArray = [
                                      NSMutableString(string: "one"),
                                      NSMutableString(string:"two"),
                                      NSMutableString(string:"three"),
                                      NSMutableString(string:"four")
                                 ]
var dataArray2 = dataArray.mutableCopy() as! NSMutableArray
for (index, data) in dataArray2.enumerated() {
    dataArray[index] = (data as! NSMutableString).mutableCopy() as! NSMutableString
}
var stringItem = dataArray[0] as! NSMutableString
stringItem.append("ONE")
print(dataArray)
print(dataArray2)


/*****************************
 *      아 카 이 빙 연 습        *
 *****************************/
/// case 1 https://baked-corn.tistory.com/60
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

/// case 2
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


var buzz = Robot(name: "Buzz", model: 122)
print(buzz)

/// NSKeyedArchiver.archivedData(withRootObject:) 는 deprecated 되었다.
/// NSKeyedArchiver.archivedData(withRootObject: classInstance, requiringSecureCoding: Bool)을 쓰자.
/// encoding된 데이터에 대해 출력해보면 bytes 크기로 표현된다.
let data = try! NSKeyedArchiver.archivedData(withRootObject: buzz, requiringSecureCoding: false)
/// USerDefaults.standard 에 key/value 형태로 Data를 저장한다.
UserDefaults.standard.setValue(data, forKey: "robot")
/// 저장된 encodedData를 불러온다.
let userDefaultSavedData = UserDefaults.standard.data(forKey: "robot")
/// 언아카이빙을 실시한다. 방법은 2가지.
/// 1. unarchiveTopLevelObjectWithData로 archivedData(withRootObject)에 저장된 루트 오브젝트를 언아카이브 하는 방식
var robot = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Robot
if let robot = robot{
    print("robot - \(robot)")   //robot - name: Buzz, modelNumber: 122
} else{
    print("unarchiving error")
}





/// unarchivedObject(ofClass: from:)으로 ofClass로 전달된 클래스 형식으로 from에 전달된 데이터를 언아카이브 하는 방식
/// cf. This decoder will only decode classes that adopt NSSecureCoding.
/// Class 'ClassCopyAndArchivingEx.Robot' does not adopt it."
/// unarchivedObject 호출시 위 에러가 뜬다면 아카이빙할 클래스가 NSSecureCoding을 따르도록 만든다.
/// https://developer.apple.com/documentation/foundation/nssecurecoding
/// https://www.youtube.com/watch?v=V9OmySqbBK4
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

var terminator = NSSecureRobot(name: "Swaltzenegger", model: 1000)
print(terminator)
let secureCoded = try! NSKeyedArchiver.archivedData(withRootObject: terminator, requiringSecureCoding: true)
print(secureCoded)

if let unArchivedRobot = try! NSKeyedUnarchiver.unarchivedObject(ofClass: NSSecureRobot.self, from: secureCoded) {
    print("unArchivedRobot - \(unArchivedRobot)")
}else{
    print("unarchiving error")
}



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
/// 주의 : 단, Optional 값에 해당 하는 것을 디코딩할 떄, 값이 없을 수 있는데, 그것을 고려하지 않는 경우 에러가 발생할 수 있다.
/// https://medium.com/commencis/swift-4s-codable-one-last-battle-for-serialization-30ceb3ccb051
/// 아래와 같이 Mappable을 이용하여 이에 대비할 수 있다.

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


/// iOS 프로그래밍중일때는 JSON 형식으로 인코딩/디코딩하지 않고, .plist인 PropertyList에 저장하는 방법도 있다.

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
