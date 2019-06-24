//
//  AmphibiousBus.swift
//  POP_EX
//
//  Created by hw on 14/05/2019.
//  Copyright © 2019 hwj. All rights reserved.
//

import Foundation


struct AmphibiousBus : Carable, Waterproofable {
    func go(to destination: String) {
        print("\(destination) 으로 달려갑니다.")
    }
    
    var numberOfPassengers: Int = 20
    var ipGrade: String = "IP68"
    
}
