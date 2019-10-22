import Cocoa
//func getInitiality(familyName: String) -> String {
//    let str:NSString = NSString(string: familyName)
//    let oneChar:UniChar = str.character(at: 0)
//    var initiality:NSString = ""
//    if (oneChar >= 0xAC00 && oneChar <= 0xD7A3){
//        var firstCodeValue = ((oneChar - 0xAC00)/28)/21
//        firstCodeValue += 0x1100;
//        initiality = initiality.appending( NSString(format:"%C", firstCodeValue) as String ) as NSString
//    }
//    return String(initiality)
//}

//https://developer.apple.com/documentation/swift/string/unicodescalarview
let word = "ㅈ"
let familyName = "준호"
let myUInt32Array: [UInt32] = familyName.utf16.map({UInt32($0)})

print(myUInt32Array)
var myString: String = ""

//if let scalar = UnicodeScalar(oneChar) {
//    myString.append(Character(scalar))
//}
//print(myString)

//let myUInt32Array: [UInt32] = [72, 101, 108, 108, 111, 128049, 127465, 127466]
//let data = Data(bytes: myUInt32Array, count: myUInt32Array.count * MemoryLayout<UInt32>.stride)
//var myString = String(data: data, encoding: .utf32LittleEndian)!
//print(myString) // Hello🐱🇩🇪
//
//let myUInt32Array: [UInt32] = [72, 101, 108, 108, 111, 128049]
//
//
//for value in myUInt32Array {
//    if let scalar = UnicodeScalar(value) {
//        myString.append(Character(scalar))
//    }
//}
//
//print(myString) // Hello🐱
//
//extension String {
//    init(utf32chars:[UInt32]) {
//        let data = Data(bytes: utf32chars, count: utf32chars.count * MemoryLayout<UInt32>.stride)
//        self = String(data: data, encoding: .utf32LittleEndian)!
//    }
//}
