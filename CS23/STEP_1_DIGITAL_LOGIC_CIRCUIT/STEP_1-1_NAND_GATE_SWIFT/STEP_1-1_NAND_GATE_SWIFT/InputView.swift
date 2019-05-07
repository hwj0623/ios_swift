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
    
    static func readBinaryNumber () -> [Bool] {
        let input = readNumber("이진수 문자열로 입력 : ex 14 : [0, 1, 1, 1] ")
        let result = transformStringBinaryToBool(input)
        return result
    }
    
    static func transformStringBinaryToBool (_ input : String) -> [Bool]{
        let pattern = "[0-1]"
        let result = input.seperateDigitByDigit(for: pattern, in: input)
        
        let booleanResult = result.map { ($0 == "0") ? false : true}
        return booleanResult
    }
}

extension String {
    func seperateDigitByDigit(for regex: String, in inputString: String) -> [String] {
        do {
            if let regex = try? NSRegularExpression(pattern: regex, options: .caseInsensitive){
                let test = regex.matches(in: inputString, options: [], range: NSRange(location:0, length: inputString.count))
                let result : [String] = test.map{ String(inputString[Range($0.range, in: inputString)!])}
                return result
            }
        }
        return []
    }
}
