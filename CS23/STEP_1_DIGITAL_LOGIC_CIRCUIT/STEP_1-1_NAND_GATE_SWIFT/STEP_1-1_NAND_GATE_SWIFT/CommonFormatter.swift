//
//  CommonFormatter.swift
//  STEP_1-1_NAND_GATE_SWIFT
//
//  Created by hw on 07/05/2019.
//  Copyright © 2019 hwj. All rights reserved.
//

import Foundation

struct CommonFormatter {
    /// MSB부터 0으로 시작하는 비트 제거
    static func compactResultValue(_ result: [Int]) -> [Int] {
        var isFirstBinaryDigit = false
        var cuttingIndex = 0
        for (index, element) in result.reversed().enumerated(){
            isFirstBinaryDigit = element == 1 ? true : false
            if isFirstBinaryDigit {
                cuttingIndex = index
                break
            }
        }
        let compactResult = Array(result.reversed()[cuttingIndex...result.count-1].reversed())
        return compactResult
    }
    /// true, false의 Bool배열을 -> 1,0 Int 배열로 
    static func convertBoolToDigit(_ input: [Bool]) -> [Int]{
        return input.map {(value) in return (value == true) ? 1 : 0 }
    }
    
    static func convertDigitToBool(_ input: [Int]) -> [Bool]{
        return input.map{ ($0 == 1) ? true : false}
    }
}
