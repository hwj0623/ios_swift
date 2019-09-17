//
//  Solution_43165.swift
//  SWIFT_ALGORITHM_SOLVING
//
//  Created by hw on 29/08/2019.
//  Copyright © 2019 hwj. All rights reserved.
//

import Foundation

class Solution_43165{
    
    func solution(_ numbers:[Int], _ target:Int) -> Int {
        let limit = numbers.endIndex
        var cumulatedNumber = 0
        var count = 0
        let coverage = (1<<limit)
        for i in 0..<coverage {
            var currentCase = generateBitmask(k: i, limit: limit)
            for j in 0..<currentCase.endIndex {
                if currentCase[j] == 0 {
                    cumulatedNumber -= numbers[j]
                }else if currentCase[j] == 1 {
                    cumulatedNumber += numbers[j]
                }
            }
            if cumulatedNumber == target{
                count += 1
            }
            cumulatedNumber = 0
        }
        return count
    }
    
    func generateBitmask(k: Int, limit: Int) -> [Int]{
        var dir = [Int].init(repeating: 0, count: limit)
        var number = k
        for i in 0..<limit {
            dir[i] = number&1
            number = number>>1 // number>>1
        }
        return dir
    }
    
    func start(){
        let arr = [1, 1, 1, 1, 1]   // 1<= E <=50
        let target = 3 // 1<=T<=1000 //result  5
        print(solution(arr, target))
    }
}
