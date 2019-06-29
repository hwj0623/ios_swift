//
//  Solution_189.swift
//  SWIFT_ALGORITHM_SOLVING
//
//  Created by hw on 29/06/2019.
//  Copyright © 2019 hwj. All rights reserved.
//

import Foundation

class Solution_LeetCode_189 {
    
    func rotate(_ nums: inout [Int], _ k: Int) {
        var rotateNum = k
        if rotateNum >= nums.count {
            rotateNum = rotateNum % nums.count
        }
        var temp: [Int] = [Int].init(repeating: 0, count: nums.count)
        for i in 0..<rotateNum {
            temp[rotateNum-1-i] = nums[nums.endIndex-1-i]
        }
        for i in rotateNum..<nums.endIndex{
            temp[i] = nums[i-rotateNum]
        }
        for i in 0..<nums.endIndex{
            nums[i] = temp[i]
        }
    }
    //Could you do it in-place with O(1) extra space?
    
    func start () {
        var test1 = [1,2,3,4,5,6,7] // 3
        rotate(&test1, 3)
        print(test1) //[5,6,7,1,2,3,4]
        var test2 = [-1,-100,3,99]
        rotate(&test2, 3)
        print(test2)    //[3,99,-1,-100]
    }
}
