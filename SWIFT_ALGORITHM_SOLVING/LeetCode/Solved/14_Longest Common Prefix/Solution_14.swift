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
        let allCount = strs.count
        if strs.count == 0 {
            return ""
        }
        if strs.count == 1{
            return strs[0]
        }
        var minLen = strs[0].count
        for i in 0..<strs.endIndex {
            if minLen > strs[i].count {
                minLen = strs[i].count
            }
        }
        var result = ""
        var isEnd = false
        for j in 0..<minLen {
            let cur = strs[0][j]
            var count = 0
            for i in 0..<strs.endIndex {
                if strs[i][j] == cur {
                    count += 1
                }else{
                    isEnd = true
                    break
                }
            }
            if isEnd {
                break
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
        let test3 = [String]()
        result = longestCommonPrefix(test3)
        print(result)

        let test4 = ["aca","cba"]
        result = longestCommonPrefix(test4)
        
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
