//
//  Solution_LeetCode_31.swift
//  SWIFT_ALGORITHM_SOLVING
//
//  Created by hw on 03/09/2019.
//  Copyright © 2019 hwj. All rights reserved.
//
// https://jins-dev.tistory.com/entry/%EB%8B%A4%EC%9D%8C-%EC%88%9C%EC%97%B4-%EC%B0%BE%EA%B8%B0-%EC%A0%84%EC%B2%B4-%EC%88%9C%EC%97%B4-%ED%83%90%EC%83%89-%EC%95%8C%EA%B3%A0%EB%A6%AC%EC%A6%98-Next-Permutation

import Foundation

class Solution_LeetCode_31{
    func nextPermutation(_ nums: inout [Int]) {
        var isDescending = true
        var from = 0    /// nums[i]<nums[i+1] 가운데 마지막 i
        for i in 0..<nums.endIndex-1 {
            if nums[i] < nums[i+1] {
                isDescending = false
                from = i              // nums[i] < nums[i+1] 인 마지막 i를 구한다.
            }
        }
        if isDescending { ///맨 마지막 녀석이라면 초기상태로
            nums = nums.reversed()
            return
        }
        var to = 0      /// 배열의 오른쪽에서부터 찾을 nums[from] 보다 큰 마지막 녀석
        for j in stride(from: nums.endIndex-1, to: from, by: -1){
            if nums[j] > nums[from] {
                to = j
                break
            }
        }
        nums.swapAt(from, to)
        if from+1 <= (nums.endIndex-1){
            var auxIndex = 0
            for k in 0..<(nums.endIndex-from-1)/2 {
                nums.swapAt(from+k+1, nums.endIndex-auxIndex-1)
                auxIndex += 1
            }
        }
    }
    
    func start(){
        var test = [1,2,3,4,5]
    
        var test2 = [3,2,1]
        var test3 = [1,1,5]
        print("start: \(test)")
        for i in 0..<20 {
            nextPermutation(&test)
        }
//        nextPermutation(&test)
//        nextPermutation(&test)

//        nextPermutation(test2)
//        nextPermutation(test3)
    }
}
