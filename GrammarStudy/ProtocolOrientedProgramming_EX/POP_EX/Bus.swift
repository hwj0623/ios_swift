//
//  ㅠㅕㄴ.swift
//  POP_EX
//
//  Created by hw on 14/05/2019.
//  Copyright © 2019 hwj. All rights reserved.
//

import Foundation

//class Buss: Car{
//    var fare: Int = 1200
//    
//}


class Bus : Carable, NeedFare {
    
    func go(to destination: String) {
        print("요금은 \(fare)입니다.")
        print("\(destination) 으로 달려갑니다.")
    }
    
    var numberOfPassengers: Int = 28
    
    var fare: Int = 1200

}
