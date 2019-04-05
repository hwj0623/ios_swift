//  main.swift
//  UnitConverter
//
//  Created by Doran on 02/04/2019.
//  Copyright © 2019 hw. All rights reserved.
//
import Foundation

/// 소숫점 n자리에서 반올림 extension
extension Double {
    func rounded(toPlace places: Int)-> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded()/divisor
    }
}

/// 2-4
/// 18cm 등 수치와 단위가 혼재된 단어에 대한 정규식
/// "128cm" -> [ "128", "cm"]
/// 추가학습 : 사용자가 입력한 값 하나로 여러 단위로 변환해서 출력하도록 개선하기 위한 파싱 기능 추가
extension String {
    /// 정규식을 입력하면 해당 필터를 통해 구분된 문자열 배열을 리턴
    func unitSeprateFromString(for regex:String, in text : String) -> [String] {
        do {
            if let regex = try? NSRegularExpression(pattern: regex, options: .caseInsensitive){
                let results = regex.matches(in: text, options: [],
                                            range: NSRange(text.startIndex...,  in: text))
                let test: [String] = results.map{
                    String(text[Range($0.range, in: text)!])
                }
                return test
            }
        }
        // 실패시 빈 문자열 리턴
        return []
    }
}
/********************
 * Unit Dictionary  *
 ****************** */
let dist = "dist"
let mass = "mass"
let volume = "volume"

/// 단위 딕셔너리 : 각 단위의 도량형 유형을 구분
/* Unit Type Dictionary */
let unitDictionary : [String : String] = [
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
/****************************
 * Sub Dictionary for units *
 ****************************/
let defaultUnit = "default"
/* Sub Dictionary */
let centimeter : [String : Double] = [
    "m": 0.01,
    "inch": 0.393701,
    "yard": 0.0109361,
    defaultUnit: 0.01       //meter
]
let meter : [String : Double] = [
    "cm": 100,
    "inch": 39.3701,
    "yard": 1.09361,
    defaultUnit: 100        //centimeter
]
let inch : [String: Double] = [
    "cm": 2.54,
    "yard": 0.0277778,
    "m": 0.0254,
    defaultUnit: 2.54       //centimeter
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
    defaultUnit: 0.001      //kilogram
]
let kilogram: [String: Double] = [
    "g": 1000,
    "oz": 0.035274,
    "lb": 0.002204625,
    defaultUnit: 1000       //gram
]
let ounce: [String: Double] = [
    "g": 28.3495,
    "kg" : 0.0283495,
    "lb" : 0.0625,
    defaultUnit: 0.0625     //pound
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

/* Main Dictionary */
let unitDictionaryCoefficient: [String: [String: Double]] = [
    "cm": centimeter,
    "m": meter,
    "inch": inch,
    "yard": yard,
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
typealias digitUnitTuple = (Double, [String])

///숫자와 파싱 분리
func parseDigitToUnit (input: String) -> (digitUnitTuple){
    
    let numberRegex = "[0-9]+"
    let specialCharacterRemovalRegex = "[^ ~!@#$%^&*()_+-=\\,./'<>?\"]+"
    
    // double value
    let digitNumber = NSString(string: input.unitSeprateFromString(for: numberRegex, in: input)[0]
        as NSString ).doubleValue
    // String Array
    var units:[String] = input.unitSeprateFromString(for: specialCharacterRemovalRegex, in: input)
   
    /// 전환할 unit단위가 생략된 경우 default 입력
    if units.count == 1 {
        units.append(String (defaultUnit))
    }

    return (digit: digitNumber, units: units)
}

/**********************
 *  convert function  *
 **********************/
func convertDigit(_ digit :Double, to : Double)->Double{
    return digit * to
}

/**********************
 *  utility function  *
 **********************/
/// 거리 by pass 함수 : from단위에서 1차적으로 얻은 dict1에 대해 cm으로 변환 후, centimeter 딕셔너리에서 다시 to 단위로 변환
func cmBypass (_ digit: Double, _ from : String, _ to : String, _ dict1: [String: Double]) -> Double{
    var result:Double = 0
    let cm = "cm"
    
    /// 1 inch -> 2.54 cm 처럼 centimeter 변환 후 meter 변환 처리하는 경우
    if let temp = dict1[cm], let temp2 = centimeter[to]{
        let bypass = convertDigit(digit, to: temp)  // ex; inch -> cm
        print("bypass 값(cm 중간변환 값) > : \(bypass)")
        result = convertDigit(digit, to: temp2)     // cm -> 0.01 m
    }else {
        print("\(from)의 cm 중간 변환이 불가능합니다.")
        result = -1
    }
    print("meter 변환 값 > : \(result)")
    return result
}
/// 질량 변환기 보조함수(1) from : from의 다른 Unit에 대한 가중치 딕셔너리 / to : from에 대한 가중치 값
func unitConverterMassUtil(_ digit: Double, _ units: [String]) -> Double{
    var result: Double = -1
    if let from = unitDictionaryCoefficient[units[0]] {
        if let to = from[units[1]]{
            result = convertDigit(digit, to: to)
            print("\(units[0])에서 \(units[1]) 변환 완료 : \(result)")
        }else{
            print("변환할(convert To) 질량(mass) 단위가 존재하지 않습니다 : \(units)")
        }
    }else{
        print("존재하지 않는 원본(convert From) 질량(mass) 단위 입니다.")
    }
    return result
}

/// 부피 변환기 보조함수(1)
func unitConverterVolumeUtil(_ digit: Double, _ units: [String]) -> Double{
    var result: Double = -1
    if let from = unitDictionaryCoefficient[units[0]] {
        if let to = from[units[1]]{
            result = convertDigit(digit, to: to)
            print("\(units[0])에서 \(units[1]) 변환 완료 : \(result)")
        }else{
            print("변환할(convert To) 부피(volume) 단위가 존재하지 않습니다")
        }
    }else{
        print("존재하지 않는 원본(convert From) 부피(volume) 단위 입니다.")
    }
    return result
}

/// 거리 변환기 Util함수(1) : from -> to 명확히 주어진 경우
func unitConverterDistUtil(_ digit: Double,  _ units: [String]) -> Double{
    var result: Double = -1
    if let from = unitDictionaryCoefficient[units[0]] {
        print("from > : \(from)")
        if let to = from[units[1]]{
            ///bypass 거치기 위한 조건문
            switch (units[0], units[1]){
                case ("inch", "m"):
                    result = cmBypass(digit, units[0], units[1], from)
                case ("yard", "m"):
                    result = cmBypass(digit, units[0], units[1], from)
                case ("m", "inch"):
                    result = cmBypass(digit, units[0], units[1], from)
                case ("m", "yard"):
                    result = cmBypass(digit, units[0], units[1], from)
                default :
                    result = convertDigit(digit, to: to)
            }
            print("\(units[0])에서 \(units[1]) 변환 완료 : \(result)")
        }else{
            print("변환할(convert To) 거리(distance) 단위가 존재하지 않습니다")
        }
    }else{
        print("존재하지 않는 원본(convert From) 거리(distance) 단위 입니다.")
    }
    return result
}

/* 2-4,5 거리 변환기 */
func unitConvertDist (_ digit: Double, _ units: [String]) -> [String:Double]{

    var result = [String : Double]()
    for i in 1..<units.count {
        let subunit: [ String ] = [units[0] , units[i]]
        result.updateValue( unitConverterDistUtil(digit,  subunit), forKey: units[i])
    }

    return result
}
/* 2-6 질량 변환기 */
func unitConvertMass(_ digit : Double, _ units: [String]) -> [String:Double]{
    var result = [String : Double]()
    for i in 1..<units.count {
        let subunit: [ String ] = [units[0] , units[i]]
        result.updateValue( unitConverterMassUtil(digit,  subunit), forKey: units[i])
    }
    return result
}
/* 2-7 부피 변환기 */
func unitConvertVolume( _ digit: Double, _ units: [String]) -> [String:Double] {
    var result = [String : Double]()
    for i in 1..<units.count {
        let subunit: [ String ] = [units[0] , units[i]]
        result.updateValue( unitConverterVolumeUtil(digit,  subunit), forKey: units[i])
    }
    return result
}

/// 변환기
func unitConverter ( digit: Double,  units: [String] )-> Void{
    /// 변환기 타입 구분
    switch unitDictionary[units[0]] {
        case dist:  /// 거리 변환기
            let _ = unitConvertDist(digit,  units)
        case mass:  /// 무게 변환기
            let _ = unitConvertMass(digit,  units)
        case volume : /// 부피 변환기
            let _ = unitConvertVolume(digit,  units)
        case .none:
            print("존재하지 않는 변환 단위 입니다")
        case .some(_):
            print("지원하지 않는 변환 단위 입니다")
    }
}

/// start - 값 입력 받는 함수
func start()-> Void{
    while true{
        let str = readLine()
        /// 2-5 종료조건인 경우 탈출
        if(str == "quit" || str == "q"){
            break
        }
        if let inputString = str {
            if inputString.count > 0 {  ///
                let digitAndUnitsTuple = parseDigitToUnit(input: inputString)
                print ("digitAndUnitsTuple : \(digitAndUnitsTuple)")
                unitConverter(digit: digitAndUnitsTuple.0, units: digitAndUnitsTuple.1)
            }else{
                print("값을 입력하세요")
            }
        }else{
            print("값을 입력하세요")
        }
    }
}

// RUN
start()
