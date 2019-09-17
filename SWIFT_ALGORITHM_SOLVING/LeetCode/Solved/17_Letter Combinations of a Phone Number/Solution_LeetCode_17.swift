//
//  Solution_LeetCode_17.swift
//  SWIFT_ALGORITHM_SOLVING
//
//  Created by hw on 05/09/2019.
//  Copyright © 2019 hwj. All rights reserved.
//

import Foundation

class Solution_LeetCode_17 {
    
    
    func letterCombinations(_ digits: String) -> [String] {
        if digits.contains("0") || digits.contains("1") || digits.isEmpty {
            return []
        }
        
        let phoneDict: [String: [String]] = [  "2" : ["a","b","c"],
                                            "3" : ["d","e","f"],
                                            "4" : ["g","h","i"],
                                            "5" : ["j","k","l"],
                                            "6" : ["m","n","o"],
                                            "7" : ["p","q","r","s"],
                                            "8" : ["t","u","v"],
                                            "9" : ["w", "x", "y", "z"]
            ]
        var alphaLists = [[String]]()
        for i in 0..<digits.count {
            let charString = String(digits[digits.index(digits.startIndex, offsetBy: i)])
            guard let alphaList = phoneDict[charString] else {
                continue
            }
            alphaLists.append(alphaList)
        }
        var result = [String]()
        for i in 0..<alphaLists[0].endIndex {
            result += combine(alphabetLists: alphaLists, depth: 0, pos: i, curString: "")
        }
        return result
    }
    
    func combine(alphabetLists list: [[String]], depth: Int, pos: Int, curString: String) -> [String]{
        let nextString = curString + list[depth][pos]
        if depth+1 == list.endIndex {
            return [nextString]
        }
        var currentResult = [String]()
        for position in 0..<list[depth+1].endIndex {
            let cur = combine(alphabetLists: list, depth: depth+1, pos: position, curString: nextString)
            currentResult += cur
        }
        return currentResult
    }
    
    func start(){
        let input = ""
        print(letterCombinations(input)) //["ad", "ae", "af", "bd", "be", "bf", "cd", "ce", "cf"]
    }
}
