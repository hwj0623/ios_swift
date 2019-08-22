import Cocoa

class Animal : Codable {
    var type : String {
        return "animal"
    }
    func a(){
        print("type : \(type)")
    }
}

class Dog : Animal {
    var dogType = "malamute"
    override var type : String {
        return  "dog"
    }
    override func a(){
        print("type :  \(type), dogType : \(dogType)")
    }
    private enum CodingKeys: String, CodingKey {
        case dogType
    }
}

class Cat : Animal {
    var catType = "norwayForest"
    override var type : String {
        return  "cat"
    }
    override func a(){
        print("type :  \(type), catType: \(catType)")
    }
    private enum CodingKeys: String, CodingKey {
        case catType
    }
    
}

class Animals: Codable {
    var array : [Animal]
    init(array: [Animal]){
        self.array = array
    }
}
var array : [Animal] = [Dog(), Cat(), Dog(), Cat()]
let testArrayClass = Animals.init(array: array)

testArrayClass.array.forEach{ print($0.type)
    $0.a()
}

print("====")
//var data = try PropertyListEncoder().encode(array)
//var restoreArray = try? PropertyListDecoder().decode(Array<Animal>.self, from: data)
let encoder = JSONEncoder()
encoder.outputFormatting = [.sortedKeys, .prettyPrinted]


//encode
let jsonData = try! encoder.encode(testArrayClass)
print(String(data: jsonData, encoding: .utf8)!)
//archive
UserDefaults.standard.set(jsonData, forKey: "testArray")

//unarchive
let archivedData = UserDefaults.standard.value(forKey: "testArray") as! Data
print(String(data: jsonData, encoding: .utf8))

let decoder = JSONDecoder()
let restoreArray = try? decoder.decode(Animals.self, from: jsonData)
restoreArray!.array.forEach{ print($0.type) ; $0.a()}


