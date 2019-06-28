//
//  Solution_162.swift
//  SWIFT_ALGORITHM_SOLVING
//
//  Created by hw on 28/06/2019.
//  Copyright © 2019 hwj. All rights reserved.
//

import Foundation

class Solution_LeetCode_162{
    func findPeakElement(_ nums: [Int]) -> Int {
        var idx = 0
        if nums.endIndex >= 2 && nums[nums.endIndex-2] < nums[nums.endIndex-1] {
            return nums.endIndex-1
        }
        if nums.endIndex >= 2 && nums[0] > nums[1] {
            return idx
        }
        if nums.endIndex == 1 {
            return idx
        }
        for i in 1..<nums.endIndex-1 {
            if nums[i] > nums[i+1] && nums[i-1] < nums[i] {
                idx =  i
                break
            }
        }
        return idx
    }
    func start(){
        let test1 = [1,2,1,3,5,6,4]
        let test2 = [1,2,3,1]
        let test3 = [1,2]
        let test4 = [1]
        var result = findPeakElement(test1)
        print(result)
        result = findPeakElement(test4)
        print(result)
    }
}
