//
//  SRP.swift
//  SOLID_EX
//
//  Created by hw on 16/05/2019.
//  Copyright © 2019 hwj. All rights reserved.
//

import Foundation


class Violin  {
    private let serialNumber : String
    private var violinSpec: ViolinSpec
    init( serialNumber: String, violinSpec : ViolinSpec){
        self.serialNumber = serialNumber
        self.violinSpec = violinSpec
    }
}



class ViolinSpec {
    private var price: Int
    private var maker: Maker
    private var type: Type
    private var model: String
    private var stringNumber: Int
    private var wood: Wood
    
    init(price: Int, maker: Maker, type: Type, model: String, stringNumber: Int, wood: Wood){
        self.price = price
        self.maker = maker
        self.type = type
        self.model = model
        self.stringNumber = stringNumber
        self.wood = wood
    }
}



class Wood {
    var woodType: String
    init(_ wood : String){
        self.woodType = wood
    }
}

class Maker {
    var makerName: String
    init(_ maker: String){
        self.makerName = maker
    }
}

class Type {
    var typeName: String
    init(_ type: String){
        self.typeName = type
    }
}
