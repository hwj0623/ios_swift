//
//  Solution_42889.swift
//  SWIFT_ALGORITHM_SOLVING
//
//  Created by hw on 21/08/2019.
//  Copyright © 2019 hwj. All rights reserved.
//

import Foundation
///
/*
 - 실패율 정의
 스테이지에 도달했으나 아직 클리어하지 못한 플레이어의 수 / 스테이지에 도달한 플레이어 수
 
 제한사항
 - 스테이지의 개수 N은 1 이상 500 이하의 자연수이다.
 - stages의 길이는 1 이상 200,000 이하이다.
 - stages에는 1 이상 N + 1 이하의 자연수가 담겨있다.
 각 자연수는 사용자가 현재 도전 중인 스테이지의 번호를 나타낸다.
 단, N + 1 은 마지막 스테이지(N 번째 스테이지) 까지 클리어 한 사용자를 나타낸다.
 - 만약 실패율이 같은 스테이지가 있다면 작은 번호의 스테이지가 먼저 오도록 하면 된다.
 - 스테이지에 도달한 유저가 없는 경우 해당 스테이지의 실패율은 0 으로 정의한다.
 
 전체 스테이지의 개수 N,
 게임을 이용하는 사용자가 현재 멈춰있는 스테이지의 번호가 담긴 배열 stages가 매개변수로 주어질 때,
 실패율이 높은 스테이지부터 내림차순으로 스테이지의 번호가 담겨있는 배열을 return 하도록 solution 함수를 완성
 
 N    stages                        result
 5    [2, 1, 2, 6, 2, 4, 3, 3]    [3,4,2,1,5]
 4    [4,4,4,4,4]                   [4,1,2,3]
 
 */


class Solution_42889{
    func solution(_ N:Int, _ stages:[Int]) -> [Int] {
        var dictionary = [Int: Double]()
        var stagePerParent = [Int: Int]()
        var stagePerChild = [Int: Int]()
        let sortStages = stages.sorted(by: {$0 > $1})
        
        for i in 1...N {
            dictionary.updateValue(0, forKey: i)
            stagePerParent.updateValue(0, forKey: i)
            stagePerChild.updateValue(0, forKey: i)
        }
        var parent = 0
        
        for element in sortStages {
            parent += 1
            guard let child = stagePerChild[element] else {
                continue
            }
            stagePerChild.updateValue(child+1, forKey: element)
            stagePerParent.updateValue(parent, forKey: element)
        }
        
        for i in 1...N {
            let currentChild = Double(stagePerChild[i]!)
            let currentParent = Double(stagePerParent[i]!)
            if currentParent != 0 {
                dictionary.updateValue(currentChild/currentParent, forKey: i)
            }
        }

        let sorted = dictionary.sorted
        { (lhs: (key: Int, value: Double), rhs: (key: Int, value: Double)) -> Bool in
            if lhs.value > rhs.value {
                return true
            }else if lhs.value == rhs.value {
                if lhs.key < rhs.key {
                    return true
                }
                return false
            }
            return false
            }.map { $0.key }
        return sorted
    }
    
    func start() {
        let test1 = [2, 1, 2, 6, 2, 4, 3, 3]
        let n1 = 5
        let test2 = [3,5]
        let n2 = 4
        print(solution(n1, test1))     // [3,4,2,1,5]
        print(solution(n2, test2)) // [4,1,2,3]
    }
}
