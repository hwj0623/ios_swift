



```swift
import Foundation

class Robot: NSCoding, Codable{	///NSCoding을 쓰는 경우, JSONEncoder는 되지 않는다.
    var name : String
    var model : Int
    
    ///NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(model, forKey: "model")
    }
    
    enum RCodingKey: String, CodingKey{
        case name
        case model
    }
    
    init(name: String, model: Int) {
        self.name = name
        self.model = model
    }
    
    ///NSCoding
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as! String
        model = aDecoder.decodeInteger(forKey: "model")
    }
}

class Terminator: Robot {
    var modelVersion: String
    
    enum TCodingKeys: String, CodingKey{
        case modelVersion
    }
    ///NSCoding
    override func encode(with aCoder: NSCoder) {
        aCoder.encode(modelVersion, forKey: "modelVersion")
        super.encode(with: aCoder)
    }
    ///Codable
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: TCodingKeys.self)
        try container.encode(modelVersion, forKey: .modelVersion)
        try super.encode(to: encoder)
    }
    init(name: String, model: Int, modelVersion: String="T-1000" ) {
        self.modelVersion = modelVersion
        super.init(name: name, model: model)
    }
    ///NSCoding
    required init?(coder aDecoder: NSCoder) {
        modelVersion = aDecoder.decodeObject(forKey: "modelVersion") as! String
        super.init(coder: aDecoder)
    }
    ///Codable
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TCodingKeys.self)
        modelVersion = try container.decode(String.self, forKey: .modelVersion)
        try super.init(from: decoder)
    }
}

let robo = Robot.init(name: "totti", model: 10)
let terminator = Terminator.init(name: "존 코너", model: 30, modelVersion: "T-50")
let terminator2 = Terminator.init(name: "사라 코너", model: 20)

var robotList = [Robot]()
robotList.append(robo)
robotList.append(terminator)
robotList.append(terminator2)
robotList.forEach { print(type(of: $0))}
/*
 Robot
 Terminator
 Terminator
 */

///Encoder
let jsonEncoder = JSONEncoder()
jsonEncoder.outputFormatting = [.prettyPrinted, .sortedKeys]
let jsonString = try jsonEncoder.encode(robotList)
print(String(data: jsonString, encoding: .utf8)!)
/*
 [
     {
        "model" : 10,
        "name" : "totti"
     },
    {
        "model" : 30,
        "modelVersion" : "T-50",
        "name" : "존 코너"
    },
    {
        "model" : 20,
        "modelVersion" : "T-1000",
        "name" : "사라 코너"
    }
]
 */
///Decoder
let jsonDecoder = JSONDecoder()
let decodedList = try jsonDecoder.decode([Robot].self, from: jsonString)
decodedList.forEach {
    if let terminator = $0 as? Terminator {
        print(terminator.modelVersion)  ///never called
    }
}

print("==========================================")

struct RobotList: Codable {
    var list: [Robot]
    enum LCodingKey: CodingKey{
        case list
    }
    enum RobotTypeKey: CodingKey {
        case model
    }
    enum Types: Int, Decodable{
        case terminator = 20
        case robot = 10
    }
    
    init(){ list = [Robot]()}
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: LCodingKey.self)
        var arrayForRobotType = try container.nestedUnkeyedContainer(forKey: LCodingKey.list)
        var robotList = [Robot]()
        
        var auxArray = arrayForRobotType
        while(!arrayForRobotType.isAtEnd){
            let robot = try arrayForRobotType.nestedContainer(keyedBy: RobotTypeKey.self)
            let model = try robot.decode(Int.self, forKey: RobotTypeKey.model)
            /// model 프로퍼티 값으로 서브클래스 분류가 가능한 경우...
//            if model == 10 {
//                robotList.append(try auxArray.decode(Robot.self))
//            }else if model == 20 {
//                robotList.append(try auxArray.decode(Terminator.self))
//            }
            /// 그냥 서브 클래스에 대해 한번씩 캐스팅을 시도하는 경우...
            if let terminator = try? auxArray.decode(Terminator.self) {
                robotList.append(terminator)
                continue
            }
            robotList.append(try auxArray.decode(Robot.self))
        }
        self.list = robotList
    }
}

var robotList2 = RobotList()
robotList2.list.append(robo)
robotList2.list.append(terminator)
robotList2.list.append(terminator2)

let jsonString2 = try jsonEncoder.encode(robotList2)
print(String(data: jsonString2, encoding: .utf8)!)
/*
 {
     "list" : [
         {
            "model" : 10,
            "name" : "totti"
         },
         {
            "model" : 30,
            "modelVersion" : "T-50",
            "name" : "존 코너"
         },
         {
            "model" : 20,
            "modelVersion" : "T-1000",
            "name" : "사라 코너"
         }
     ]
 }
 */
let decodedList2 = try jsonDecoder.decode(RobotList.self, from: jsonString2)
decodedList2.list.forEach {
    print(type(of: $0 ))
    if let terminator = $0 as? Terminator {
        print(terminator.modelVersion)  ///never called
    }
}
/*
 Robot
 Terminator
 T-50
 Terminator
 T-1000
 */

print("==========================================")
/// 구조체
struct StructRobot: Codable{
    var name : String
    var model : Int
    var modelVersion: String?

    init(name: String, model: Int, modelVersion: String? = nil) {
        self.name = name
        self.model = model
        self.modelVersion = modelVersion
    }
}

var structRobotList = [StructRobot]()
let stRobo1 = StructRobot.init(name: "카일 워커", model: 10, modelVersion: "T-80")
let stRobo2 = StructRobot.init(name: "앨런 워커", model: 15, modelVersion: "T-80")
let stRobo3 = StructRobot.init(name: "하드 워커", model: 17)
structRobotList.append(stRobo1)
structRobotList.append(stRobo2)
structRobotList.append(stRobo3)

let jsonStringStructList = try jsonEncoder.encode(structRobotList)
print(String(data: jsonStringStructList, encoding: .utf8)!)
/*
[
    {
        "model" : 10,
        "modelVersion" : "T-80",
        "name" : "카일 워커"
    },
    {
        "model" : 15,
        "modelVersion" : "T-80",
        "name" : "앨런 워커"
    },
    {
        "model" : 17,
        "name" : "하드 워커"
    }
]
*/
```

