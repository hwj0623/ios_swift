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

// 2-2 FUNCTION : convert centimeter To Meter
//  - 소숫점 처리를 위해 extension 활용. 첫째 자리에서 반올림
func convertCmToM (cmToM: String) -> String {
    let doubleValue : Double = NSString(string: cmToM as NSString).doubleValue
    let divisor: Double = 100
    let result = Double(doubleValue/divisor).rounded(toPlace: 4)
    print ("\(cmToM)cm -> \(result)m")
    return String(result)
}

// 2-2 FUNCTION : convert Meter To centimeter
//  - 소숫점 처리를 위해 extension 활용. 4자리에서 반올림
func convertMToCm (mToCm: String ) -> String {
    let doubleValue : Double = NSString(string: mToCm as NSString).doubleValue
    let times: Double = 100
    let result = Double(doubleValue*times).rounded(toPlace: 4)
    print ("\(mToCm)meter -> \(result)cm")
    return String(result)
}

func convertInchToCm (inchToCm: String) -> String {
    let doubleValue : Double = NSString(string: inchToCm as NSString).doubleValue
    let times: Double = 2.54
    let result = Double(doubleValue*times).rounded(toPlace: 4)
    print ("\(inchToCm)inch -> \(result)cm")
    return String(result)
}

func convertCmToInch (cmToInch: String) -> String {
    let doubleValue : Double = NSString(string: cmToInch as NSString).doubleValue
    let divisor: Double = 2.54
    let result = Double(doubleValue / divisor).rounded(toPlace: 4)
    print ("\(cmToInch)cm -> \(result)Inch")
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
    default:
        print("지원하지 않는 단위입니다.")
    }
}

// RUN
//2-3 STEP - 값 입력
while true {
    
    let str = readLine()
    
    if let test = str {
        let firstIdx = test.firstIndex(of: " ") ?? test.endIndex
        let tmpStr = String(test[..<firstIdx])
        let strArr =  tmpStr.unitSeperate()
//        print ("parse number and unit : > \(strArr) ")
//        print ("start : \(strArr.startIndex) , end : \(strArr.endIndex)")
        let unitIndex = strArr.endIndex-1
        let numberIndex = strArr.startIndex
        
        //규격에 안맞으면 처음부터 다시
        if strArr[unitIndex].lowercased() != "cm"
            && strArr[unitIndex].lowercased() != "m"
            && strArr[unitIndex].lowercased() != "inch" {
            continue
        }
        
         //2 input elements
        if(firstIdx != test.endIndex){
            let secondStr = test.split(separator: " ",  omittingEmptySubsequences: true)[1]
//            print ("to unit > \(secondStr)")
            unitConverter(number: strArr[numberIndex], from: strArr[unitIndex], to: String(secondStr))
            break
        }
         //1 input element
        else{
            unitConverter(number: strArr[numberIndex], input: strArr[unitIndex])
            break
        }
    }
}



