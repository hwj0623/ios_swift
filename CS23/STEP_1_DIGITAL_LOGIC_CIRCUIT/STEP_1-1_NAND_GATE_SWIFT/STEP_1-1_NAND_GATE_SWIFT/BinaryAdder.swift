//
//  BinaryAdder.swift
//  STEP_1-1_NAND_GATE_SWIFT
//
//  Created by hw on 30/04/2019.
//  Copyright © 2019 hwj. All rights reserved.
//

import Foundation

struct BinaryAdder {
    /// 두 비트의 [합]은 NAND의 결과와 NOR의 결과가 같으면 0, 다르면 1이 되도록 한다.
    static private func sum (_ bitA: Bool, _ bitB: Bool) -> Bool {
        let lhs = NANDGate.nand(paramA: bitA, paramB: bitB)
        let rhs = NORGate.nor(paramA: bitA, paramB: bitB)
        return lhs == rhs ? false : true
    }
    
    /// [자리올림]은 두 비트의 AND 결과와 같다
    static private func carry (_ bitA: Bool, _ bitB: Bool) -> Bool {
        return ANDGate.and(paramA: bitA, paramB: bitB)
    }
    
    /// [ 자리올림, 합 ] 출력
    static func halfAdder(_ bitA: Bool, _ bitB: Bool) -> [Bool]{
        var answer : [Bool] = [Bool]()
        answer.append (carry(bitA, bitB))
        answer.append (sum(bitA, bitB))
        return answer
    }
    
    static func fullAdder (_ byteA: Bool, _ byteB: Bool) -> [Int]{
        let lhs = carry(byteA, byteB)
        let (rhs, firstHalfAdderCarryBit) = firstHalfAdderOfFullAdder(byteA, byteB)
        let (secondHalfAdderCarryBit, sumBitOfFullAdder) = secondHalfAdderOfFullAdder(lhs, rhs)
        let fullAdderCarryBit = ORGate.or(paramA: firstHalfAdderCarryBit, paramB: secondHalfAdderCarryBit)
        
        var answer = [Int]()
        answer.append(sumBitOfFullAdder ? 1 : 0)
        answer.append(fullAdderCarryBit ? 1 : 0)
        return answer
    }
    
    private static func firstHalfAdderOfFullAdder(_ byteA: Bool, _ byteB: Bool) -> (rhs: Bool, firstHalfAdderCarryBit: Bool){
        
        var firstHalfAdder = halfAdder(byteA, byteB)
        let firstHalfAdderCarryBit = firstHalfAdder[0]
        let rhs = firstHalfAdder[1]                          //sum of half adder
        
        return (rhs, firstHalfAdderCarryBit)
    }
    
    private static func secondHalfAdderOfFullAdder(_ lhs: Bool, _ rhs: Bool) -> ( secondHalfAdderCarryBit: Bool, sumBitOfFullAdder: Bool){
        
        let secondHalfAdder = halfAdder(lhs, rhs)
        let secondHalfAdderCarryBit = secondHalfAdder[0]
        let sumBitOfFullAdder = secondHalfAdder[1]
        
        return (secondHalfAdderCarryBit, sumBitOfFullAdder)
    }
}
