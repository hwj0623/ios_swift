//
//  Square.swift
//  SOLID_EX
//
//  Created by hw on 20/05/2019.
//  Copyright © 2019 hwj. All rights reserved.
//

import Foundation

class Square : Rectangle {
    override init () {
        super.init()
    }
    init (_ width: Double, _ height: Double){
        super.init(width: width, height: width)
    }
    
    override func setWidth(_ width: Double) {
        self.width = width
        self.height = width
    }
    
    override func setHeight(_ height: Double) {
        self.width = height
        self.height = height
    }
    override var area: Double{
        get {
            return self.width * self.height
        }
    }
}
