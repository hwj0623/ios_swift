//
//  main.swift
//  UnitConverter
//
//  Created by Doran & Dominic on 02/04/2019.
//  Copyright © 2019 hw. All rights reserved.
//

import Foundation



// 소숫점 n자리에서 반올림 extension
extension Double {
    func rounded(toPlace places: Int)-> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded()/divisor
    }
}

// 2-4
// 18cm 등 수치와 단위가 혼재된 단어에 대한 정규식
// "128cm" -> [ "128", "cm"]
extension String {
    func unitSeperate() -> [String] {
        var unit: [String] = []
        var number: [String] = []
        
        if let regex = try? NSRegularExpression(pattern: "[a-zA-Z]+$", options: .caseInsensitive)
        {
            let string = self as NSString
            unit = regex.matches(
                in: self,
                options: [],
                range: NSRange(location: 0, length: string.length)
                )
                .map {
                    string.substring(with: $0.range)
            }
        }
        if let regex = try? NSRegularExpression(pattern: "^[^a-zA-Z]*", options: .caseInsensitive)
        {
            let string = self as NSString
            number = regex.matches(
                in: self,
                options: [],
                range: NSRange(location: 0, length: string.length)
                )
                .map {
                    string.substring(with: $0.range)
            }
        }
        if unit.count != 0 && number.count != 0 {
            number.append(unit[0])
            return number
        }else{
            return []
        }
    }
}

////  - 소숫점 처리를 위해 extension 활용. 넷째 자리에서 반올림
// 2-2 FUNCTION : 1 cm -> 0.01 m
func convertCmToM (cmToM: String) -> String {
    let doubleValue : Double = NSString(string: cmToM as NSString).doubleValue
    let divisor: Double = 100
    let result = Double(doubleValue/divisor).rounded(toPlace: 4)
    print ("\(cmToM)cm -> \(result)m")
    return String(result)
}
// 2-2 FUNCTION : 1 cm -> 0.393701 inch
func convertCmToInch (cmToInch: String) -> String {
    let doubleValue : Double = NSString(string: cmToInch as NSString).doubleValue
    let divisor: Double = 2.54
    let result = Double(doubleValue / divisor).rounded(toPlace: 4)
    print ("\(cmToInch)cm -> \(result)Inch")
    return String(result)
}

// 2-2 FUNCTION : 1 m -> 100 cm
func convertMToCm (mToCm: String ) -> String {
    let doubleValue : Double = NSString(string: mToCm as NSString).doubleValue
    let times: Double = 100
    let result = Double(doubleValue * times).rounded(toPlace: 4)
    print ("\(mToCm)meter -> \(result)cm")
    return String(result)
}

// 2-2 FUNCTION : 1 inch -> 2.54 cm
func convertInchToCm (inchToCm: String) -> String {
    let doubleValue : Double = NSString(string: inchToCm as NSString).doubleValue
    let times: Double = 2.54
    let result = Double(doubleValue * times).rounded(toPlace: 4)
    print ("\(inchToCm)inch -> \(result)cm")
    return String(result)
}


// 2-5
// yard --> 다른 단위로 환산
// 1 yard -> 91.44 cm
func convertYardToCm(yardToCm: String ) -> String{
    let doubleValue : Double = NSString(string: yardToCm as NSString).doubleValue
    let times: Double = 91.44
    let result = Double(doubleValue * times).rounded(toPlace: 4)
    print ("\(yardToCm) yard -> \(result) cm")
    return String(result)
}
// 1 yard -> 36 inch
func convertYardToInch (yardToInch: String )-> String{
    let doubleValue : Double = NSString(string: yardToInch as NSString).doubleValue
    let times: Double = 36
    let result = Double(doubleValue * times).rounded(toPlace: 4)
    print ("\(yardToInch) yard -> \(result) inch ")
    return String(result)
}
// 다른 단위 -- > yard로 환산
// 1 cm -> 0.0109361 yard
func convertCmToYard(cmToYard: String ) -> String {
    let doubleValue : Double = NSString(string: cmToYard as NSString).doubleValue
    let divisor: Double = 91.44
    let result = Double(doubleValue / divisor).rounded(toPlace: 4)
    print ("\(cmToYard) cm -> \(result) yard")
    return String(result)
}
// 1 inch -> 0.0277778 yard
func convertInchToYard(inchToYard: String )-> String{
    let doubleValue : Double = NSString(string: inchToYard as NSString).doubleValue
    let times: Double = 36
    let result = Double(doubleValue * times).rounded(toPlace: 4)
    print ("\(inchToYard) inch -> \(result) yard ")
    return String(result)
}

// 2-2 FUNCTION : unitConverter
// 2-4 FUNCTION : unitConverter overloading
// 18cm inch : cm -> inch
// 25.4inch m : inch -> cm -> m
// 0.5m inch : m -> cm -> inch
// 183cm : cm -> m
// 3.14m : m -> cm
// 2.54inch : inch -> cm (default)
// 3feet : catch -> readLine()
func unitConverter (number: String, input: String) -> Void {
  
    // Grab the last two or one characters
    switch input {
    case  "cm" :
        _ = convertCmToM(cmToM: number)
    case  "m" :
        _ =  convertMToCm(mToCm: number)
    case "inch" :
        _ = convertInchToCm(inchToCm: number)
    case "yard" :
        let bypass = convertYardToCm(yardToCm: number)
        _ = convertCmToM(cmToM: bypass)
    default :
        print("지원하지 않는 단위입니다.")
    }
}
// FUNCTION : FROM -> TO 로 파라미터가 주어진 경우에 대한 오버로딩 함수
func unitConverter(number: String, from: String, to : String) -> Void {
    switch from {
        case "cm":
            fromCmToWhat(number: number, to: to)
        case "m":
            fromMToWhat(number: number, to: to)
        case "inch":
            fromInchToWhat(number: number, to: to)
        case "yard":
            fromYardToWhat(number: number, to: to)
        default :
            print("지원하지 않는 단위입니다.")
    }
}
// FUNCTION : cm 에서 변환할 수치와 단위를 나타내는 서브루틴 함수
func fromCmToWhat (number: String, to: String) -> Void{
    switch to {
    case "m":
            _ = convertCmToM(cmToM: number)
    case "inch":
            _ = convertCmToInch(cmToInch: number)
    case "yard":
            _ = convertCmToYard(cmToYard: number)
    default:
        print("지원하지 않는 단위입니다.")
    }
}
// FUNCTION : m 에서 변환할 수치와 단위를 나타내는 서브루틴 함수
func fromMToWhat (number: String, to: String )-> Void {
    switch to {
    case "cm":
        _ = convertMToCm(mToCm: number)
    case "inch":
        let bypass = convertMToCm(mToCm: number)
        _ = convertCmToInch(cmToInch: bypass)
    case "yard":
        let bypass = convertMToCm(mToCm: number)
        _ = convertCmToYard(cmToYard: bypass)
    default:
        print("지원하지 않는 단위입니다.")
    }
}
// FUNCTION : inch 에서 변환할 수치와 단위를 나타내는 서브루틴 함수
func fromInchToWhat (number: String, to: String) -> Void {
    switch to {
    case "cm":
        _ = convertInchToCm(inchToCm: number)
    case "m":
        let bypass = convertInchToCm(inchToCm: number)
        _ = convertCmToM(cmToM: bypass)
    case "yard":
        _ = convertInchToYard(inchToYard: number)
    default:
        print("지원하지 않는 단위입니다.")
    }
}

// 2-5
// FUNCTION : yard 에서 변환할 수치와 단위를 나타내는 서브루틴 함수
func fromYardToWhat(number: String, to: String) -> Void {
    switch to {
    case "cm":
        _ = convertYardToCm(yardToCm: number)
    case "m":
        let bypass = convertYardToCm(yardToCm: number)
        _ = convertCmToM(cmToM: bypass)
    case "inch":
        _ = convertYardToInch(yardToInch: number)
    default:
        print("지원하지 않는 단위입니다.")
    }
}

// RUN
//2-3 STEP - 값 입력
while true {
    
    let str = readLine()
    // 2-5 종료조건인 경우 탈출
    if(str == "quit" || str == "q"){
        break
    }
    
    // unit converter process 시작
    if let test = str {
        
        let firstIdx = test.firstIndex(of: " ") ?? test.endIndex
        let tmpStr = String(test[..<firstIdx])
        let strArr =  tmpStr.unitSeperate()

        let unitIndex = strArr.endIndex-1
        let numberIndex = strArr.startIndex
      
        //규격에 안맞으면 처음부터 다시
        if strArr[unitIndex].lowercased() != "cm"
            && strArr[unitIndex].lowercased() != "m"
            && strArr[unitIndex].lowercased() != "inch"
            && strArr[unitIndex].lowercased() != "yard"
        {
            print("지원하지 않는 단위입니다.")
            continue
        }
        
         //2 input elements
        if(firstIdx != test.endIndex){
            let secondStr = test.split(separator: " ",  omittingEmptySubsequences: true)[1]
//            print ("to unit > \(secondStr)")
            unitConverter(number: strArr[numberIndex], from: strArr[unitIndex], to: String(secondStr))
        }
         //1 input element
        else{
            unitConverter(number: strArr[numberIndex], input: strArr[unitIndex])
        }
    }
}



