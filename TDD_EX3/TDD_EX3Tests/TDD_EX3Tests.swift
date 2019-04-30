//
//  TDD_EX3Tests.swift
//  TDD_EX3Tests
//
//  Created by hw on 15/04/2019.
//  Copyright © 2019 hwj. All rights reserved.
//

import XCTest

class TDD_EX3Tests: XCTestCase {
    /// 테스트 함수는 의무적으로 test로 시작해야 한다.
    func testAddSucceed() {
        let calculator = Calculator()
        let added = calculator.add(lhs: 3, rhs: 6)
        XCTAssertEqual(added, 9)
    }
    
    func testAddFails() {
        let calculator = Calculator()
        let added = calculator.add(lhs: 3, rhs: 6)
        XCTAssertEqual(added, 9)
    }
//    override func setUp() {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//
//    override func tearDown() {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
//
//    func testExample() {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }
//
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
