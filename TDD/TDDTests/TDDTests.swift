//
//  TDDTests.swift
//  TDDTests
//
//  Created by hw on 15/04/2019.
//  Copyright © 2019 hwj. All rights reserved.
//

import XCTest
@testable import TDD    //TDD 프로젝트에 있는 클래스들을 인식하기 위함..

class TDDTests: XCTestCase {

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
}
