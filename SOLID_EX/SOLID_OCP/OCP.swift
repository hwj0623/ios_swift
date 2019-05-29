////
////  OCP.swift
////  SOLID_EX
////
////  Created by hw on 20/05/2019.
////  Copyright © 2019 hwj. All rights reserved.
////
//
//import Foundation
//
//protocol StringInstrument {
//    ///추상화 기능 명세
//}
//
//protocol StringInstrumentSpec {
//    /// 추상화 기능 명세.
//    var price : Int {get}
//    var maker : Maker {get}
//    var type : Type {get}
//    var model : String {get}
//    var stringNumber : Int {get}
//    var wood : Wood {get}
//}
//class Violin : StringInstrument {
//    private let serialNumber : String
//    private var violinSpec: ViolinSpec
//    init( serialNumber: String, violinSpec : ViolinSpec){
//        self.serialNumber = serialNumber
//        self.violinSpec = violinSpec
//    }
//}
//
//class Cello : StringInstrument{
//    private let serialNumber : String
//    private var celloSpec: CelloSpec
//    init(serialNumber : String, celloSpec : CelloSpec){
//        self.serialNumber = serialNumber
//        self.celloSpec = celloSpec
//    }
//}
//
//class ViolinSpec : StringInstrumentSpec{
//    var price: Int
//    var maker: Maker
//    var type: Type
//    var model: String
//    var stringNumber: Int
//    var wood: Wood
//
//    init(price: Int, maker: Maker, type: Type, model: String, stringNumber: Int, wood: Wood){
//        self.price = price
//        self.maker = maker
//        self.type = type
//        self.model = model
//        self.stringNumber = stringNumber
//        self.wood = wood
//    }
//    //extra properties or methods...
//
//}
//
//class CelloSpec : StringInstrumentSpec{
//    var price: Int
//    var maker: Maker
//    var type: Type
//    var model: String
//    var stringNumber: Int
//    var wood: Wood
//    init(price: Int, maker: Maker, type: Type, model: String, stringNumber: Int, wood: Wood){
//        self.price = price
//        self.maker = maker
//        self.type = type
//        self.model = model
//        self.stringNumber = stringNumber
//        self.wood = wood
//    }
//    //extra properties or methods...
//
//}
//
//
//class Wood {
//    var woodType: String
//    init(_ wood : String){
//        self.woodType = wood
//    }
//}
//
//class Maker {
//    var makerName: String
//    init(_ maker: String){
//        self.makerName = maker
//    }
//}
//
//class Type {
//    var typeName: String
//    init(_ type: String){
//        self.typeName = type
//    }
//}
