//
//  Solution_LeetCode_692.swift
//  SWIFT_ALGORITHM_SOLVING
//
//  Created by hw on 01/09/2019.
//  Copyright © 2019 hwj. All rights reserved.
//

import Foundation

/*
 Given a non-empty list of words, return the k most frequent elements.
 
 Your answer should be sorted by frequency from highest to lowest.
 If two words have the same frequency, then the word with the lower alphabetical order comes first.
 */
class Solution_LeetCode_692{
    func topKFrequent(_ words: [String], _ k: Int) -> [String] {
        var map = [String: Int]()
        words.forEach { (word: String) in
            if let existence = map[word] {
                map.updateValue(existence+1, forKey: word)
            }else {
                map.updateValue(1, forKey: word)
            }
        }
        let result = map.sorted {
            (lhs: (key: String, value: Int), rhs: (key: String, value: Int)) -> Bool in
            if lhs.value > rhs.value {
                return true
            }
            else if lhs.value == rhs.value {
                if lhs.key < rhs.key {
                    return true
                }
                return false
            }
            return false
            }.map({$0.key})
        return Array(result[0..<k])
    }
    func start(){
        let inputA = ["i", "love", "leetcode", "i", "love", "coding"]
        let kA = 2
        print(topKFrequent(inputA, kA))
        let inputB = ["the", "day", "is", "sunny", "the", "the", "the", "sunny", "is", "is"]
        let kB = 4
        print(topKFrequent(inputB, kB))
    }
}
