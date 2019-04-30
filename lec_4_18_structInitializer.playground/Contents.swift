import UIKit

var str = "Hello, playground"

struct Person {
    let name: String
    var age: UInt = 0
    var nickname: String? = nil
    init(name: String, age: UInt){
        self.name = name
        self.age = age
    }
    init(name: String, age: UInt, nickname: String? = nil){
        self.name = name
        self.age = age
        self.nickname = nickname
    }
    
    init(name: String){
        self.name = name
    }
}


var yagom: Person = Person(name: "son", age: 27)
//or
//var yagom: Perosn = Person.init(name: <#T##String#>, age: <#T##UInt#>, nickname: <#T##String?#>)
