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
    
    /// [ 합, 자리올림 ] 출력
    static func halfAdder(_ bitA: Bool, _ bitB: Bool) -> [Bool]{
        var answer : [Bool] = [Bool]()
        answer.append (sum(bitA, bitB))
        answer.append (carry(bitA, bitB))
        return answer
    }
}
