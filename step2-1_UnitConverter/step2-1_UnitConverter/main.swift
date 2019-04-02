//
//  main.swift
//  UnitConverter
//
//  Created by Doran & Dominic on 02/04/2019.
//  Copyright © 2019 hw. All rights reserved.
//

import Foundation

//2-3 STEP - 값 입력
let str = readLine()

//소숫점 n자리에서 반올림 extension
//https://stackoverflow.com/questions/27338573/rounding-a-double-value-to-x-number-of-decimal-places-in-swift
extension Double {
    func rounded(toPlace places: Int)-> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded()/divisor
    }
}

// 2-2 FUNCTION : convert centimeter To Meter
//  - 소숫점 처리를 위해 extension 활용. 첫째 자리에서 반올림
func convertCmToM (str: String) -> Void {
    let doubleValue : Double = NSString(string: str as NSString).doubleValue
    let divisor: Double = 100
    let result = Double(doubleValue/divisor).rounded(toPlace: 0)
    
    print ("\(result)m")
    
}

// 2-2 FUNCTION : convert Meter To centimeter
//  - 소숫점 처리를 위해 extension 활용. 4자리에서 반올림
func convertMToCm (str: String ) -> Void {
    let doubleValue : Double = NSString(string: str as NSString).doubleValue
    let times: Double = 100
    let result = Double(doubleValue*times).rounded(toPlace: 4)
    print ("\(result)cm")
    
}

// 2-2 FUNCTION : unitConverter
func unitConverter (input: String) -> Void {
    let strArr = input.split(separator: " ")
    if strArr.count == 0{
        return
    }else{
        for str in strArr {
            // Grab the last two or one characters
            if str.suffix(2) == "cm"  {
                convertCmToM(str: String(str))
            }
            else {
                convertMToCm(str: String(str))
            }
        }
    }
}

// RUN
if let test = str {
    unitConverter(input: test)
}



