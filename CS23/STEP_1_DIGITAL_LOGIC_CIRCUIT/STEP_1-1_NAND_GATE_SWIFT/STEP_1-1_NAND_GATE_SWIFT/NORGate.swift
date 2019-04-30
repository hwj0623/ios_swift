//
//  NORGate.swift
//  STEP_1-1_NAND_GATE_SWIFT
//
//  Created by hw on 30/04/2019.
//  Copyright © 2019 hwj. All rights reserved.
//

import Foundation

struct NORGate {
    static func nor( paramA: Bool, paramB: Bool) -> Bool {
        let answer = INVERTORGate.invert(ORGate.or(paramA: paramA, paramB: paramB))
        return answer
    }
}
