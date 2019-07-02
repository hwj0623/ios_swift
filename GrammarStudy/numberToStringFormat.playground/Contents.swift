import UIKit
import Foundation

var str = "Hello, playground"

var a = 3
/// String.init(format: )을 사용하면 빈 자릿수를 채워주는 string format을 구현할 수 있다.
var stringNumber  = String.init(format: "%.2d", a)
print(stringNumber)
