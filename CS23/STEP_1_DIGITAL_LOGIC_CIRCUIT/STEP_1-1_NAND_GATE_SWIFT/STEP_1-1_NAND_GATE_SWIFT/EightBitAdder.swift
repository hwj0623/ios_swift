//
//  EightBitAdder.swift
//  STEP_1-1_NAND_GATE_SWIFT
//
//  Created by hw on 30/04/2019.
//  Copyright © 2019 hwj. All rights reserved.
//
/* 바이트 덧셈(byteadder) : 8비트를 BOOL타입 배열로 2개를 입력 받는다.
 자리올림(carry) + 전체 합(sum)을 순서대로 배열로 담아서 리턴하는 함수를 구현한다.
 입력으로 들어오는 byteA, byteB 배열의 길이는 같다고 가정한다.
 입력으로 들어오는 byteA 비트 순서는 낮은 자리(LSB)가 배열의 앞쪽에 오도록 표현한다. 배열의 순서대로 보면 이진수가 뒤집혀 있는 것처럼 보인다고 가정한다.
*/
import Foundation

struct EightBitAdder {
    var adderResult: [Bool]

    var eightBitAdderResult: [Int]{
        return adderResult.map{ (value) in return value == true ? 1 : 0 }
    }
    
    static func sum (byteA: [Bool], byteB: [Bool]) -> [Int] {
        var carry : Bool = false
        var sumResult = [Bool]()
        for index in 0..<byteA.count {
            let EachFullAdderResult = BinaryAdder.fullAdder(byteA: byteA[index], byteB: byteB[index], carryBit: carry)
            sumResult.append(EachFullAdderResult.sum)
            carry = EachFullAdderResult.carry
        }
        if carry {
            sumResult.append(carry)
        }
        return sumResult.map { (value) in return value == true ? 1 : 0}
    }
    
    /// 0b01011011 == 91 => [ 1, 1, 0, 1, 1, 0, 1, 0 ]
    static func convertBinaryNumberToBooleanArray (binaryInteger: UInt8) -> [Bool]{
        var number = binaryInteger
        var result : [Int] = [Int]()
        var unit = UInt8(128)
        while number >= 0 && unit >= 1 {
            if number < unit {
                result.append(0)
            }else{
                number = number - unit
                result.append(1)
            }
            unit /= 2
        }
        let reversedResult = result.reversed().map {(value) in return value == 1 ? true: false}
        return reversedResult
    }
}
