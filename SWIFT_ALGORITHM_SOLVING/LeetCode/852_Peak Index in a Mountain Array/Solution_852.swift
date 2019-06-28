//
//  Solution_852.swift
//  SWIFT_ALGORITHM_SOLVING
//
//  Created by hw on 28/06/2019.
//  Copyright © 2019 hwj. All rights reserved.
//
/*
 Let's call an array A a mountain if the following properties hold:
 
 A.length >= 3
 There exists some 0 < i < A.length - 1 such that A[0] < A[1] < ... A[i-1] < A[i] > A[i+1] > ... > A[A.length - 1]
 Given an array that is definitely a mountain, return any i such that A[0] < A[1] < ... A[i-1] < A[i] > A[i+1] > ... > A[A.length - 1].
 
 */
import Foundation

class Solution_LeetCode_852{
    func peakIndexInMountainArray(_ A: [Int]) -> Int {
        var currentMax = A[0]
        var currentIdx = 0
        for i in 1..<A.endIndex {
            if A[i] > currentMax {
                currentMax = A[i]
                currentIdx = i
            }
        }
        return currentIdx
    }
    func start(){
        let test = [0,1,0] // 1
        let test2 = [0,2,1,0] // 1
        
        var result = peakIndexInMountainArray(test)
        print(result)
        result = peakIndexInMountainArray(test2)
        print(result)
        
    }
}
