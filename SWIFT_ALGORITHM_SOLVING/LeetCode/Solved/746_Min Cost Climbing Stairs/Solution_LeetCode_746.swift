//
//  Solution_LeetCode_746.swift
//  SWIFT_ALGORITHM_SOLVING
//
//  Created by hw on 26/08/2019.
//  Copyright © 2019 hwj. All rights reserved.
//

import Foundation


/*
 On a staircase, the i-th step has some non-negative cost cost[i] assigned (0 indexed).
 
 Once you pay the cost, you can either climb one or two steps.
 You need to find minimum cost to reach the top of the floor,
 and you can either start from the step with index 0, or the step with index 1.
 
 cost will have a length in the range [2, 1000].
 Every cost[i] will be an integer in the range [0, 999].

 */
class Solution_LeetCode_746{
    func minCostClimbingStairs(_ cost: [Int]) -> Int {
        var first = cost[0]
        var second = cost[1]
        var dp = [Int].init(repeating: 0, count: cost.endIndex)
        dp[0] = first
        dp[1] = second
        for i in 2..<cost.endIndex {
            dp[i] = min(dp[i-1]+cost[i], dp[i-2]+cost[i])
        }
        let result = min(dp[cost.endIndex-1], dp[cost.endIndex-2])
        return result
    }
    
    func start(){
        let cost1 = [10, 15, 20]
        print(minCostClimbingStairs(cost1)) // 15
        
        let cost2 = [1, 100, 1, 1, 1, 100, 1, 1, 100, 1]
        print(minCostClimbingStairs(cost2))    // 6
    }
}
