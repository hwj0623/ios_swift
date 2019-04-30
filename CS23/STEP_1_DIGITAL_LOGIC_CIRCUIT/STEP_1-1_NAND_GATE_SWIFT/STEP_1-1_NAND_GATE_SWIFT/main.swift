//
//  main.swift
//  STEP_1-1_NAND_GATE_SWIFT
//
//  Created by hw on 11/04/2019.
//  Copyright © 2019 hwj. All rights reserved.
//
/**
 NAND    false    true
 false    true    true
 true     true    false
 */
import Foundation

let main = {
    print (NANDGate.nand(paramA: true, paramB: true))
    print (NANDGate.nand(paramA: false, paramB: false))
    print (NANDGate.nand(paramA: true, paramB: false))
    print (NANDGate.nand(paramA: false, paramB: true))

    print (NORGate.nor(paramA: true, paramB: true))
    print (NORGate.nor(paramA: false, paramB: false))
    print (NORGate.nor(paramA: true, paramB: false))
    print (NORGate.nor(paramA: false, paramB: true))

    
    var byteA = true
    var byteB = true
    print("half Adder (1, 1) -> [ 1, 0 ] : \(BinaryAdder.halfAdder(byteA, byteB)))")
    print(BinaryAdder.fullAdder(byteA, byteB))
    
    byteB = false
    print("half Adder (1, 0) -> [ 0, 1 ] : \(BinaryAdder.halfAdder(byteA, byteB)))")
    print(BinaryAdder.fullAdder(byteA, byteB))

}

main()

