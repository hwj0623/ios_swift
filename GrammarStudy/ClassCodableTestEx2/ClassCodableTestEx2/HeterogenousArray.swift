//////
//////  HeterogenousArray.swift
//////  ClassCodableTestEx2
//////
//////  Created by hw on 20/08/2019.
//////  Copyright © 2019 hwj. All rights reserved.
//////
////
//import Foundation
//
//var drinks = """
//{
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
//class Drink: Decodable {
//    var type: String
//    var description: String
//
//    private enum CodingKeys: String, CodingKey {
//        case type
//        case description
//    }
//}
//
//class Beer: Drink {
//    var alcohol_content: String
//
//    private enum CodingKeys: String, CodingKey {
//        case alcohol_content
//    }
//
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.alcohol_content = try container.decode(String.self, forKey: .alcohol_content)
//        try super.init(from: decoder)
//    }
//}
//
//struct Drinks: Decodable {
//    let drinks: [Drink]
//
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
