import UIKit
///enum으로 조건 나누기
enum Number{
    case underHundred(Int)
    case overHundred(Int)
    init(value: Int){
        if value <= 100{
            self = .underHundred(value)
        }else{
            self = .overHundred(value)
        }
    }
    func extractIntValue() -> Int{
        switch self{
        case .overHundred(let value):
            return value
        case .underHundred(let value):
            return value
        }
    }
}
let result = Number.init(value: 150)
print("enum 생성자 함수를 통한 값 초기화 : \(result)")
print("결과값 추출하기 : \(result.extractIntValue())")


class Test{
    var isAssignable = true
    var currentValue: Int = 0 {
        willSet(newValue) {
            if newValue > 100 {
                isAssignable = !isAssignable
            }
        }
        didSet {
            if !isAssignable{
                currentValue = oldValue
                isAssignable = !isAssignable
            }
        }
    }
}
var testClass = Test.init()
testClass.currentValue = 10
print ("100 이하의 값이 주어지는 경우 : \(testClass.currentValue)")
testClass.currentValue = 200
print ("100 이상의 값이 주어지는 경우 : \(testClass.currentValue)")
