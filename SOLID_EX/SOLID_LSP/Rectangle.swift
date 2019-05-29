//
//  Rectangle.swift
//  SOLID_EX
//
//  Created by hw on 20/05/2019.
//  Copyright © 2019 hwj. All rights reserved.
//

import Foundation


class Rectangle {
    var width: Double
    var height: Double
    init () {
        self.width = 0
        self.height = 0
    }
    init (width: Double, height: Double){
        self.width = width
        self.height = height
    }
    
    func setWidth(_ width: Double){
        self.width = width
    }
    func setHeight(_ height: Double){
        self.height = height
    }
    var area: Double{
        get {
            return self.width * self.height
        }
    }
}
