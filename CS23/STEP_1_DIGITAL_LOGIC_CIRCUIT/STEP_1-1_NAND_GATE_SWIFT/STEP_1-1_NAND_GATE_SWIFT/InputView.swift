//
//  InputView.swift
//  STEP_1-1_NAND_GATE_SWIFT
//
//  Created by hw on 03/05/2019.
//  Copyright © 2019 hwj. All rights reserved.
//

import Foundation

// 입력 에러 예외처리는 생략
struct InputView {
    
    static func readNumber(_ prompt: String) -> String{
        print(prompt)
        let input = readLine() ?? "0"
        return input
    }
    
    static func convertDecimalToBinaryNumber(_ input: String) -> UInt64{
        return UInt64(input) ?? 0b0
    }
    
    static func readDecimalNumber () -> UInt64 {
        let input = readNumber("정수 입력 > ")
        return convertDecimalToBinaryNumber(input)
    }
}
