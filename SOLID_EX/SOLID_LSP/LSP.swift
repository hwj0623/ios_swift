//
//  LSP.swift
//  SOLID_EX
//
//  Created by hw on 20/05/2019.
//  Copyright © 2019 hwj. All rights reserved.
//

import Foundation

class DoWork {
    func work() throws {
        let rectangle: Rectangle = Square()
        rectangle.setWidth(5)
        rectangle.setHeight(4)
        if(!isCheck(rectangle)){
            throw ErrorCode.InvalidArea
        }
        print("\(rectangle.area)")
    }
    func isCheck(_ rectangle: Rectangle) ->  Bool {
        return Int(rectangle.area) == 20
    }
}



