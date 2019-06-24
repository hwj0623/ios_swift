//
//  Protocols.swift
//  POP_EX
//
//  Created by hw on 14/05/2019.
//  Copyright © 2019 hwj. All rights reserved.
//

import Foundation

/// 움직일 수 있는
protocol Movable {
    func go(to destination: String)
}

extension Movable {
    func go(to destination: String) {
        print("\(destination) 으로 달려갑니다.")
    }
}

/// Movable을 채택한 녀석이 NeedFare를 채택한 경우에
extension Movable where Self : NeedFare {
    func go(to destination: String) {
        print("요금은 \(fare)입니다.")
        print("\(destination) 으로 달려갑니다.")
    }
}

/// 승객을 탑승할 수 있는
protocol OnBoardable {
    var numberOfPassengers: Int { get }
}

/// 연산 프로퍼티는 extension으로 설정 가능
extension OnBoardable {
    var numberOfPassengers: Int {
        return 4
    }
}

//protocol Carable: Movable, OnBoardable { }
typealias Carable = Movable & OnBoardable
/// 요금이 필요한
protocol NeedFare {
    var fare: Int { get }
}

///물 위에 떠다니는
protocol Waterproofable {
    var ipGrade: String { get }
}
