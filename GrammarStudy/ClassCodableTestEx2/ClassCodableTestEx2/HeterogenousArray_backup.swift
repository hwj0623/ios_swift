////
////  HeterogenousArray_backup.swift
////  ClassCodableTestEx2
////
////  Created by hw on 20/08/2019.
////  Copyright © 2019 hwj. All rights reserved.
////
//
//import Foundation
//
//var drinks = """
//    {
//    "drinks": [
//        {
//            "type": "water",
//            "description": "All natural"
//        },
//        {
//            "type": "orange_juice",
//            "description": "Best drank with breakfast"
//        },
//        {
//            "type": "beer",
//            "description": "An alcoholic beverage, best drunk on fridays after work",
//            "alcohol_content": "5%"
//        }
//    ]
//}
//"""
//
//class Drink: Codable {
//    var type: String
//    var description: String
//
//    enum CodingKeys: String, CodingKey {
//        case type
//        case description
//    }
//
//    init(type: String, description: String){
//        self.type = type
//        self.description = description
//    }
//    //    func encode(to encoder: Encoder) throws {
//    //        var container = encoder.container(keyedBy: CodingKeys.self)
//    //        try container.encode(type, forKey: .type)
//    //        try container.encode(description, forKey: .description)
//    //    }
//}
//
//class Beer: Drink {
//    var alcohol_content: String
//
//    private enum BeerCodingKeys: String, CodingKey {
//        case alcohol_content
//    }
//
//    init(type:String, description: String, alcohol: String){
//        alcohol_content = alcohol
//        super.init(type: type, description: description)
//    }
//
//    override func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: BeerCodingKeys.self)
//        try container.encode(alcohol_content, forKey: .alcohol_content)
//        try super.encode(to: encoder)
//    }
//
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: BeerCodingKeys.self)
//        self.alcohol_content = try container.decode(String.self, forKey: .alcohol_content)
//        try super.init(from: decoder)
//    }
//}
//
//struct Drinks: Codable {
//    var drinks: [Drink]
//
//    init(){ drinks = [Drink]()}
//    enum DrinksKey: CodingKey {
//        case drinks
//    }
//
//    enum DrinkTypeKey: CodingKey {
//        case type
//    }
//
//    enum DrinkTypes: String, Decodable {
//        case water = "water"
//        case orangeJuice = "orange_juice"
//        case beer = "beer"
//    }
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: DrinksKey.self)
//        var drinksArrayForType = try container.nestedUnkeyedContainer(forKey: DrinksKey.drinks)
//        var drinks = [Drink]()
//
//        var drinksArray = drinksArrayForType
//        while(!drinksArrayForType.isAtEnd) {
//            let drink = try drinksArrayForType.nestedContainer(keyedBy: DrinkTypeKey.self)
//            let type = try drink.decode(DrinkTypes.self, forKey: DrinkTypeKey.type)
//            switch type {
//            case .water, .orangeJuice:
//                print("found drink")
//                drinks.append(try drinksArray.decode(Drink.self))
//            case .beer:
//                print("found beer")
//                drinks.append(try drinksArray.decode(Beer.self))
//            }
//        }
//        self.drinks = drinks
//    }
//}
//
//let jsonDecoder = JSONDecoder()
//func testmain(){
//    do {
//        let results = try jsonDecoder.decode(Drinks.self, from:drinks.data(using: .utf8)!)
//        for result in results.drinks {
//            print(result.description)
//            if let beer = result as? Beer {
//                print(beer.alcohol_content)
//            }
//        }
//    } catch {
//        print("caught: \(error)")
//    }
//}
//
//
//
//let beerTest = Beer.init(type: "beer", description: "맛좋은 봉구비어", alcohol: "5%")
//let water = Drink.init(type: "water", description: "에비앙 생수")
//let orangeJuice = Drink.init(type: "orange_juice", description: "어륀지 주스")
//var drinkList = Drinks() //[Drink]()//
//drinkList.drinks.append(beerTest)
//drinkList.drinks.append(water)
//drinkList.drinks.append(orangeJuice)
//
////drinkList.append(beerTest)
////drinkList.append(water)s
//
//let jsonEncoder = JSONEncoder()
//jsonEncoder.outputFormatting = [.prettyPrinted, .sortedKeys]
//let jsonString = try jsonEncoder.encode(drinkList)
//print(String(data: jsonString, encoding: .utf8)!)
//
//func testmain2(){
//    do {
//        let results = try jsonDecoder.decode(Drinks.self, from: jsonString)
//        for result in results.drinks {
//            print(type(of: result))
//            if let beer = result as? Beer {
//                print(beer.alcohol_content)
//            }
//        }
//    } catch {
//        print("caught: \(error)")
//    }
//}
//testmain2()
