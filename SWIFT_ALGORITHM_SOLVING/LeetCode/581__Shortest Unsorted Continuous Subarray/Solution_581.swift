//
//  Solution_581.swift
//  SWIFT_ALGORITHM_SOLVING
//
//  Created by hw on 18/06/2019.
//  Copyright © 2019 hwj. All rights reserved.
//

import Foundation

class Solution_LeetCode__581 {
    
    
    func findUnsortedSubarray(_ nums: [Int]) -> Int {
        var minIndex = 0
        var min = nums[minIndex]
        var maxIndex = 0
        var max = nums[maxIndex]
        for index in 0..<nums.endIndex-1 {
            if nums[index] > nums[index+1]{
                minIndex = index
                break
            }
        }
        for index in stride(from: nums.endIndex-1, to: nums.startIndex , by: -1){
            if nums[index] < nums[index-1]{
                maxIndex = index
                break
            }
        }
        if maxIndex != minIndex {
            return maxIndex-minIndex+1
        }
        return 0
    }
    
    func start(){
        let test = [2, 6, 4, 8, 10, 9, 15]  //5
        let test2 = [1,2,3,4]   //0
        let test3 = [2,1,0] //3
        let test4 = [1,3,2,2,2] //4
        let test5 = [1,2,3,3,3] //0
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
        
    }
}
