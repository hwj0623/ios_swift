//
//  Solution_LeetCode_884.swift
//  SWIFT_ALGORITHM_SOLVING
//
//  Created by hw on 01/09/2019.
//  Copyright © 2019 hwj. All rights reserved.
//
//https://leetcode.com/problems/uncommon-words-from-two-sentences/
/*
 
 We are given two sentences A and B.
 (A sentence is a string of space separated words. Each word consists only of lowercase letters.)
 
 A word is uncommon if it appears exactly once in one of the sentences, and does not appear in the other sentence.
 Return a list of all uncommon words.
 You may return the list in any order.
 */
import Foundation

class Solution_LeetCode_884 {
    
    func uncommonFromSentences(_ A: String, _ B: String) -> [String] {
        var dict = [String: Int]()
        let listA = A.components(separatedBy: " ")
        let listB = B.components(separatedBy: " ")
        for str in listA {
            if let existenceA = dict[str] {
                dict.updateValue(existenceA+1, forKey: str)
            }else {
                dict.updateValue(1, forKey: str)
            }
        }
        for str in listB{
            if let existenceB = dict[str] {
                dict.updateValue(existenceB+1, forKey: str)
            }else {
                dict.updateValue(1, forKey: str)
            }
        }
        let result = dict.filter { $0.value == 1}.map { $0.key}
        return result
    }
    
    func start(){
        let testA = "this apple is sweet"
        let testB = "this apple is sour"
        print(uncommonFromSentences(testA, testB))  //["sweet", "sour"]
        let testA1 = "apple apple"
        let testB1 = "banana"
        print(uncommonFromSentences(testA1, testB1))  //["sweet", "sour"]

    }
}
