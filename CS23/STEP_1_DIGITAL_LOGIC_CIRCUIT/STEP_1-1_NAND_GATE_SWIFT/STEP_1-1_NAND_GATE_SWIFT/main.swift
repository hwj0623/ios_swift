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

enum TestType {
    case nand
    case nor
    case halfAdder
    case fullAdder
    
}
struct main {
    
    static func nandGateExampleTest() {

        print (NANDGate.nand(paramA: true, paramB: true))
        print (NANDGate.nand(paramA: false, paramB: false))
        print (NANDGate.nand(paramA: true, paramB: false))
        print (NANDGate.nand(paramA: false, paramB: true))
    }
    static func norGateExampleTest(){
        print (NORGate.nor(paramA: true, paramB: true))
        print (NORGate.nor(paramA: false, paramB: false))
        print (NORGate.nor(paramA: true, paramB: false))
        print (NORGate.nor(paramA: false, paramB: true))
    }

    static func halfAdderExampleTest() {
        let byteA = true
        var byteB = true
        print("half Adder (1, 1) -> [ 1, 0 ] : \(BinaryAdder.halfAdder(byteA, byteB)))")
        byteB = false
        print("half Adder (1, 0) -> [ 0, 1 ] : \(BinaryAdder.halfAdder(byteA, byteB)))")
    }

    static func fullAdderExampleTest() {
        let eightBitA = InputView.readDecimalNumber()  // 0b11001101 [ 1, 1, 0, 1, 1, 0, 1, 0 ]
        let eightBitB = InputView.readDecimalNumber()  // 0b01011011  [ 1, 0, 1, 1, 0, 0, 1, 1 ]
        let lhs = EightBitAdder.convertBinaryNumberToBooleanArray(binaryInteger: eightBitA)
        let rhs = EightBitAdder.convertBinaryNumberToBooleanArray(binaryInteger: eightBitB)
        let result = EightBitAdder.sum(byteA: lhs, byteB: rhs)
        print (result)
    }
    
    static func test( testType: TestType ){
        switch testType {
        case .nand:
            main.nandGateExampleTest()
        case .nor:
            main.norGateExampleTest()
        case .halfAdder:
            main.halfAdderExampleTest()
        case.fullAdder:
            main.fullAdderExampleTest()
        }
    }
}
main.test(testType: TestType.fullAdder)
