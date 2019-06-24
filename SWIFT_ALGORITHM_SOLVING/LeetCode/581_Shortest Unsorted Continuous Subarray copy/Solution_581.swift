//
//  Solution_581.swift
//  SWIFT_ALGORITHM_SOLVING
//
//  Created by hw on 18/06/2019.
//  Copyright © 2019 hwj. All rights reserved.
//

import Foundation

class Solution_LeetCode_581 {
    let test = [2, 6, 4, 8, 10, 9, 15]  //5
    let test2 = [1,2,3,4]               //0
    let test3 = [2,1,0]                 //3
    let test4 = [1,3,2,2,2]             //4
    let test5 = [1,2,3,3,3]             //0
    let test6 = [2,3,3,2,4]             //3
    
    func findUnsortedSubarray(_ nums: [Int]) -> Int {
        var sorted = nums.sorted(by: <)
        var min = 0
        var max = 0
        for index in 0..<sorted.count-1 {
            if nums[index] != sorted[index] {
                min = index
                break
            }
        }
        for index in stride(from: sorted.endIndex-1, to: sorted.startIndex, by: -1){
            if nums[index] != sorted[index] {
                max = index
                break
            }
        }
        if max == 0 {
            return 0
        }
        return max - min + 1
    }

    func start(){
        var result = findUnsortedSubarray(test)
        print(result)
        result = findUnsortedSubarray(test2)
        print(result)
        result = findUnsortedSubarray(test3)
        print(result)
        result = findUnsortedSubarray(test4)
        print(result)
        result = findUnsortedSubarray(test5)
        print(result)
        result = findUnsortedSubarray(test6)
        print(result)
        
    }
}
