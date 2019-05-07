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
    case dec2bin
    case bin2dec
    case dec2hex
    case hex2bin
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
        let numberBinaryResult = CommonFormatter.convertBoolToDigit(result)
        let compactResult = CommonFormatter.compactResultValue(numberBinaryResult)
        print (compactResult)
    }
    
    static func dec2binExampleTest() {
        let decimal1 = Convertor.dec2bin(10)
        let digitResult1 = CommonFormatter.convertBoolToDigit(decimal1)
        let result1 = CommonFormatter.compactResultValue(digitResult1)
        
        let decimal2 = Convertor.dec2bin(173)
        let digitResult2 = CommonFormatter.convertBoolToDigit(decimal2)
        let result2 = CommonFormatter.compactResultValue(digitResult2)
        print("10 : \(result1),\n173 : \(result2)")
    }
    
    static func bin2decExampleTest() {
        let input1 = InputView.readBinaryNumber()
        let input2 = InputView.readBinaryNumber()
        let result1 = Convertor.bin2dec(input1)
        let result2 = Convertor.bin2dec(input2)

        print(" [0, 1, 1, 1] : \(result1),\n [1,1,1,1,0,1,0,1] : \(result2)")
    }
    
    static func dec2hexExampleTest(){
        let input1 = InputView.readBinaryNumber()
        let result1 = Convertor.bin2hex(input1)
        print(result1)
    }
    
    static func hex2binExampleTest(){
        let input = InputView.readHexNumber()
        let booleanResult = Convertor.hex2bin(input)
        let digitResult = CommonFormatter.convertBoolToDigit(booleanResult)
        let result = CommonFormatter.compactResultValue(digitResult)
        print(result)
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
        case .dec2bin:
            main.dec2binExampleTest()
        case .bin2dec:
            main.bin2decExampleTest()
        case .dec2hex:
            main.dec2hexExampleTest()
        case .hex2bin:
            main.hex2binExampleTest()
        }
    }
}

//main.test(testType: TestType.fullAdder)
//main.test(testType: TestType.dec2bin)
//main.test(testType: TestType.bin2dec)
//main.test(testType: TestType.dec2hex)

main.test(testType: TestType.hex2bin)

