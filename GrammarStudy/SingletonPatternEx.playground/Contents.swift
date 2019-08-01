import UIKit

class MyClassSingleton {
    static let sharedInstance = MyClassSingleton()
    private init(){}
    var state = 5
    func helloClass() { print("hello from class Singleton: \(state)") }
}

struct MyStructSingleton {
    static let sharedInstance = MyStructSingleton()
    private init() {}
    var state = 5
    func helloStruct() { print("hello from struct Singleton: \(state)") }
}

let csi = MyClassSingleton.sharedInstance
csi.state = 42
MyClassSingleton.sharedInstance.helloClass()    //42

var ssi = MyStructSingleton.sharedInstance
ssi.state = 42
MyStructSingleton.sharedInstance.helloStruct()  //5
