//
//  Solution_128.swift
//  SWIFT_ALGORITHM_SOLVING
//
//  Created by hw on 21/06/2019.
//  Copyright © 2019 hwj. All rights reserved.
//

import Foundation

class Solution_LeetCode_128 {
    
    /// sorted에 O(nlogn)이 소요되는데, 왜 더 빠를까..
    func longestConsecutive_modified(_ nums: [Int]) -> Int {
        if nums.isEmpty {
            return 0
        }
        var maxLength = 1
        let sortedNums = nums.sorted()
        var cur = sortedNums[0]
        var curSize = 1
        for i in 1..<sortedNums.count{
            if sortedNums[i] == cur {
                continue
            }
            if sortedNums[i] == cur+1 {
                curSize += 1
                cur = sortedNums[i]
                maxLength = maxLength > curSize ? maxLength : curSize
            }else{
                curSize = 1
                cur = sortedNums[i]
            }
        }
        return maxLength
    }
    
    func longestConsecutive(_ nums: [Int]) -> Int {
        if nums.isEmpty {
            return 0
        }
        let numSet : Set<Int> = Set<Int>(nums)
        var maxLength = 1
        for index in numSet.indices {
            var currentNumber = numSet[index]
            var length = 1
            while numSet.contains (currentNumber-1){
                length += 1
                currentNumber -= 1
            }
            maxLength = maxLength < length ? length : maxLength
        }
        return maxLength
    }
    //[100, 4, 200, 1, 3, 2]
    //output 4
    //[1, 2, 3, 4]
    func start(){
        let test = [100, 4, 200, 1, 3, 2]
        let test2: [Int] = []
        let result = longestConsecutive_modified(test)
        print(result)
    }
}
