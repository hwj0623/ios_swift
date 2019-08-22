//
//  NetworkModel.swift
//  NetworkAsyncEx
//
//  Created by hw on 19/08/2019.
//  Copyright © 2019 hwj. All rights reserved.
//

import Foundation

struct Name: Codable {
    let title: String
    let first: String
    let last: String
}

struct PersonInfo: Codable{
    enum Gender: String, Codable{
        case male, female
    }
    var gender: String
    var nat: String
    var name: Name
}

struct RandomUserResponse: Codable{
    let results: [PersonInfo]
    let info: Info
}

struct Info: Codable {
    let seed: String
    let results: Int
    let page: Int
    let version: String
}
