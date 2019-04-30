//
//  NANDGate.swift
//  STEP_1-1_NAND_GATE_SWIFT
//
//  Created by hw on 30/04/2019.
//  Copyright © 2019 hwj. All rights reserved.
//


/**
  릴레이가 동작하지 않을 때 전압이 출력되고 전구에 불이 들어오는 특징이 있다.
 이 논리 게이트는 AND 게이트의 동작과 완전히 반대로 동작한다.
 회로에서 나오는 출력이 연결되어 있어서 OR 게이트처럼 비슷하게 보인다.
 이 회로는 두 스위치가 모두 닫혀있을 때만 전구에 불이 꺼집니다. 그 외에 나머지 경우에는 불이 켜진다.
 그래서 이 논리 게이트의 이름을 NOT AND (줄여서 NAND) 게이트라고 한다.
 NAND    false    true
 false    true    true
 true    true    false
 */
import Foundation

struct NANDGate {
    static func nand( paramA: Bool, paramB: Bool) -> Bool {
        var answer = true
        if ANDGate.and(paramA: paramA, paramB: paramB) {
            answer = false
        }
        return answer
    }
}
