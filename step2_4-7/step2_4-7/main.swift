//
//  main.swift
//  UnitConverter
//
//  Created by Doran on 02/04/2019.
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
/********************
 * Unit Dictionary  *
 ****************** */
let dist = "dist"
let mass = "mass"
let volume = "volume"

let UnitDictionary : [String : String] = [
    "cm": dist,
    "m": dist,
    "inch": dist,
    "yard": dist,
    "g": mass,
    "kg": mass,
    "lb": mass,
    "oz": mass,
    "L": volume,
    "pt": volume,
    "qt": volume,
    "gal": volume
]

/********************
 *  Dictionary for units  *
 ****************** */
let defaultUnit = "default"
let centimeter : [String : Double] = [
    "m": 0.01,
    "inch": 0.393701,
    "yard": 0.0109361,
    defaultUnit: 0.01
]
let meter : [String : Double] = [
    "cm": 100,
    "inch": 39.3701,
    "yard": 1.09361,
    defaultUnit: 100
]
let inch : [String: Double] = [
    "cm": 2.54,
    "yard": 0.0277778,
    "m": 0.0254,
    defaultUnit: 2.54
]
let yard : [String: Double] = [
    "cm": 91.44,
    "m": 0.9144,
    "inch": 36,
    defaultUnit: 0.9144
]
let gram : [String: Double] = [
    "kg": 0.001,
    "oz": 0.035274,
    "lb": 0.002204625,
    defaultUnit: 0.001  //kilogram
]
let kilogram: [String: Double] = [
    "g": 1000,
    "oz": 0.035274,
    "lb": 0.002204625,
    defaultUnit: 1000   //gram
]
let ounce: [String: Double] = [
    "g": 28.3495,
    "kg" : 0.0283495,
    "lb" : 0.0625,
    defaultUnit: 0.0625 //pound
]
let pound: [String: Double] = [
    "g": 453.592,
    "oz" : 16,
    "kg" : 0.453592,
    defaultUnit: 16         //ounce
]
let liter: [String: Double] = [
    "gal": 0.264172,
    "qt": 0.879877,
    "pt": 1.75975,
    defaultUnit: 0.264172   //gallon

]
let gallon: [String: Double] = [
    "liter": 4.54609,
    "qt": 4,
    "pt": 8,
    defaultUnit: 4.54609    //liter
]
let quart: [String: Double] = [
    "pt": 2,
    "gal": 0.25,
    "liter": 1.13652,
    defaultUnit: 1.13652    //liter
]
let pint: [String: Double] = [
    "qt": 0.5,
    "gal": 0.125,
    "liter": 0.568261,
    defaultUnit: 0.568261   //liter
]

let UnitDictionaryCoefficient: [String: [String: Double]] = [
    "cm": centimeter,
    "m": meter,
    "inch": inch,
    "g": gram,
    "kg": kilogram,
    "lb": pound,
    "oz": ounce,
    "L":liter,
    "pt":pint,
    "qt":quart,
    "gal":gallon
]

/**********************
 *  숫자와 첫단위 파싱 함수 *
 **********************/
typealias tupleVar = (Double, [String])

func parseDigitToUnit (input: String) -> (tupleVar){
    //18cm와 inch를 " "로 분리
    let firstIdx = input.firstIndex(of: " ") ?? input.endIndex
    let tmpStr = String(input[..<firstIdx])

    // digit과 from unit을 분리
    let strArr = tmpStr.unitSeperate()

    let numberIndex = strArr.startIndex
    let unitIndex = strArr.endIndex-1

    let digitNumber: Double = NSString(string: strArr[numberIndex] as NSString).doubleValue
    let from = strArr[unitIndex]
    let units: [String]

    //from, to element 개수 구분
    if(firstIdx != input.endIndex){
        let to = input.split(separator: " ",  omittingEmptySubsequences: true)[1]
        print ("\n > digitNumber : \(digitNumber) , from : \(from) , to : \(to)")
        units = [from, String (to)]
    }else{
        print ("\n > digitNumber : \(digitNumber) , from : \(from) ")
        units = [from]
    }

    return (digit: digitNumber, units: units)
}

/**********************
 *  convert function  *
 **********************/
func convertDigit(number:Double, to :Double)->Double{
    print(">> 변환 값 : \(number * to)")
    return number * to
}

/**********************
 *  utility function  *
 **********************/
//질량 변환기 보조함수(1)
func unitConverterExplicitMassUtil(number: Double, units: [String]) -> Double{
    var result: Double = -1
    if let from = UnitDictionaryCoefficient[units[0]] {
        if let to = from[units[1]]{
            result = convertDigit(number: number, to: to)
            print("\(units[0])에서 \(units[1])로 변환 완료 : \(result)")
        }else{
            print("변환할(convert To) 질량(mass) 단위가 존재하지 않습니다")
        }
    }else{
        print("존재하지 않는 원본(convert From) 질량(mass) 단위 입니다.")
    }
    return result
}
//질량 변환기 보조함수(2)
func unitConverterImplicitMassUtil(number: Double, units: [String]) -> Double{
    var result: Double = -1
    if let from = UnitDictionaryCoefficient[units[0]] {
        if let to = from[defaultUnit]{
            result = convertDigit(number: number, to: to)
            print("\(units[0])에 대한 기본 변환 완료 : \(result)")
        }else{
            print("변환할(convert To) 질량(mass) 단위가 존재하지 않습니다")
        }
    }else{
        print("존재하지 않는 원본(convert From) 질량(mass) 단위 입니다.")
    }
    return result
}

//부피 변환기 보조함수(1)
func unitConverterExplicitVolumeUtil(number: Double, units: [String]) -> Double{
    var result: Double = -1
    if let from = UnitDictionaryCoefficient[units[0]] {
        if let to = from[units[1]]{
            result = convertDigit(number: number, to: to)
            print("\(units[0])에서 \(units[1])로 변환 완료 : \(result)")
        }else{
            print("변환할(convert To) 부피(volume) 단위가 존재하지 않습니다")
        }
    }else{
        print("존재하지 않는 원본(convert From) 부피(volume) 단위 입니다.")
    }
    return result
}
//부피 변환기 보조함수(2)
func unitConverterImplicitVolumeUtil(number: Double, units: [String]) -> Double{
    var result: Double = -1
    if let from = UnitDictionaryCoefficient[units[0]] {
        if let to = from[defaultUnit]{
            result = convertDigit(number: number, to: to)
            print("\(units[0])에 대한 기본 변환 완료 : \(result)")
        }else{
            print("변환할(convert To) 질량(mass) 단위가 존재하지 않습니다")
        }
    }else{
        print("존재하지 않는 원본(convert From) 질량(mass) 단위 입니다.")
    }
    return result
}

//거리 변환기 Util함수(1) : from -> to 명확히 주어진 경우
func unitConverterExplicitDistUtil(number: Double,  units: [String]) -> Double{
    var result: Double = -1
    if let from = UnitDictionaryCoefficient[units[0]] {
        if let to = from[units[1]]{
            result = convertDigit(number: number, to: to)
            print("\(units[0])에서 \(units[1])로 변환 완료 : \(result)")
        }else{
            print("변환할(convert To) 부피(volume) 단위가 존재하지 않습니다")
        }
    }else{
        print("존재하지 않는 원본(convert From) 부피(volume) 단위 입니다.")
    }
    return result
}
//거리 변환기 Util함수(2) : from만 주어진 경우
func unitConverterImplicitDistUtil(number: Double,  units: [String]) -> Double{
    var result: Double = -1
    if let from = UnitDictionaryCoefficient[units[0]] {
        if let to = from[defaultUnit]{
            result = convertDigit(number: number, to: to)
             print("\(units[0])에 대한 기본 변환 완료 : \(result)")
        }else{
            print("변환할(convert To) 질량(mass) 단위가 존재하지 않습니다")
        }
    }else{
        print("존재하지 않는 원본(convert From) 질량(mass) 단위 입니다.")
    }
    return result
}

/* 거리 변환기 */
func unitConvertDist (number: Double, units: [String]) -> Double{
    //units element가 2개면
    var result:Double = 0
    if units.count == 2 {
        result = unitConverterExplicitDistUtil(number: number, units: units)
    }else {//1개면
        result = unitConverterImplicitDistUtil(number: number, units: units)
    }
    return result
}
/* 질량 변환기 */
func unitConvertMass(number: Double, units: [String]) -> Double{
    var result: Double = 0

    if units.count == 2{
        result = unitConverterExplicitMassUtil(number: number, units: units)
    }else{
        result = unitConverterImplicitMassUtil(number: number, units: units)
    }
    return result
}
/* 부피 변환기 */
func unitConvertVolume(number: Double, units: [String]) -> Double{
    var result: Double = 0
    if units.count == 2{
        result = unitConverterExplicitVolumeUtil(number: number, units: units)
    }else{
        result = unitConverterImplicitVolumeUtil(number: number, units: units)
    }
    return result
}
// 변환기
func unitConverter (number: Double, units: [String] )-> Void{
    //변환기 타입 구분
    switch UnitDictionary[units[0]] {
        case dist:  //거리 변환기
            let _ = unitConvertDist(number: number, units: units)
        case mass:  //무게 변환기
            let _ = unitConvertMass(number: number, units: units)
        case volume : //부피 변환기
            let _ = unitConvertVolume(number: number, units: units)
        case .none:
            print("존재하지 않는 변환 단위 입니다")
        case .some(_):
            print("지원하지 않는 변환 단위 입니다")
    }
}

//2-3 STEP - 값 입력
func start()-> Void{
    while true{
        let str = readLine()
        // 2-5 종료조건인 경우 탈출
        if(str == "quit" || str == "q"){
            break
        }
        if let inputString = str {
            let ret = parseDigitToUnit(input: inputString)
            unitConverter(number: ret.0, units: ret.1)
        }else{
            print("값을 입력하세요")
        }
    }
}

// RUN
start()



