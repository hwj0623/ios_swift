//
//  Solution_14.swift
//  SWIFT_ALGORITHM_SOLVING
//
//  Created by hw on 30/06/2019.
//  Copyright © 2019 hwj. All rights reserved.
//

import Foundation




class Solution_Leetcode_14{
    func longestCommonPrefix(_ strs: [String]) -> String {
        var minLen = strs[0].count
        for i in 0..<strs.endIndex {
            if minLen > strs[i].count {
                minLen = strs[i].count
            }
        }
        var allCount = strs.count
        var result = ""
        for j in 0..<minLen {
            let cur = strs[0][j]
            var count = 0
            for i in 0..<strs.endIndex {
                if strs[i][j] == cur {
                    count += 1
                }
            }
            if count == allCount {
                result = result + strs[0][j]
            }
        }
        return result
    }
    
    func start () {
        let test1 = ["flower","flow","flowwightgtt"]
        var result = longestCommonPrefix(test1) // fl
        print(result)
        let test2 = ["dog","racecar","car"]
        result = longestCommonPrefix(test2)
        print(result)
    }
}

extension String {
   
    
    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start ..< end])
    }
}
