//
//  ORGate.swift
//  STEP_1-1_NAND_GATE_SWIFT
//
//  Created by hw on 30/04/2019.
//  Copyright © 2019 hwj. All rights reserved.
//

import Foundation


struct ORGate {
    static func or (paramA: Bool, paramB: Bool) -> Bool{
        var answer = true
        if INVERTORGate.invert(paramA) && INVERTORGate.invert(paramB)  {
            answer = false
        }
        return answer
    }
}
