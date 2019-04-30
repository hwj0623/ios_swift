//
//  ANDGate.swift
//  STEP_1-1_NAND_GATE_SWIFT
//
//  Created by hw on 30/04/2019.
//  Copyright © 2019 hwj. All rights reserved.
//

import Foundation

struct ANDGate{
    
    static func and ( paramA: Bool, paramB: Bool) -> Bool {
        var answer = false
        if paramA && paramB {
            answer = true
        }
        return answer
    }
}
