//
//  Solution_kakao6.swift
//  SWIFT_ALGORITHM_SOLVING
//
//  Created by hw on 07/09/2019.
//  Copyright © 2019 hwj. All rights reserved.
//

import Foundation


class Solution_kakao6 {
    
    func generateBitmaskArray(k: Int, limit: Int) -> [Int]{
        var dir = [Int].init(repeating: 0, count: limit)
        var number = k
        for i in 0..<limit {
            dir[i] = number&1
            number = number>>1 // number>>1
        }
        return dir
    }
    
    func solution(_ n:Int, _ weak:[Int], _ dist:[Int]) -> Int {
        let limit = dist.endIndex
        let testSize = 1<<limit
        var minValue = Int.max
        for i in 1..<testSize {
            let bitmask = generateBitmaskArray(k: i, limit: limit)
            let friends = bitmask.reduce(0, +)
            let visited = [Bool].init(repeating: false, count: n)
            var reviseDist = [Int].init()
            for i in 0..<bitmask.endIndex {
                if bitmask[i] == 1 {
                    reviseDist.append(dist[i])
                }
            }
            if friends == 0 {
                continue
            }
            let curValue = solve(depth: 0, visited: visited, friendList: reviseDist, friends: friends, weak: weak, n: n)
            if minValue > curValue {
                minValue = curValue
            }
        }
        if minValue == Int.max {
            minValue = -1
        }
        return minValue
    }
    
    func solve(depth: Int, visited: [Bool], friendList: [Int], friends: Int, weak: [Int], n : Int) -> Int {
        var curDist = friendList
        var checked = visited
        if depth == friends {
            var ret = true
            for v in weak {
                ret = ret && visited[v]
            }
            if !ret {
                return Int.max
            }
            return friends
        }
        var minValue = Int.max
        //friends i 번째 녀석을 투입
        for i in depth..<friendList.endIndex {
            for j in 0..<weak.endIndex {
                if checked[j]{
                    continue
                }
                checked[j] = true
                let backup = curDist
                let currentUse = curDist.remove(at: i)
                let clockWiseRet = clockWise(curPos: weak[j], step: currentUse, n: n, visited: checked)
                let next = solve(depth: depth+1, visited: clockWiseRet, friendList: curDist, friends: friends, weak: weak, n: n)
                
                let counterWiseRet = counterClockWise(curPos: weak[j], step: currentUse, n: n, visited: checked)
                let nextcc = solve(depth: depth+1, visited: counterWiseRet, friendList: curDist, friends: friends, weak: weak, n: n)
                
                curDist = backup
                
                ///백트래킹 원복
                if minValue > next {
                    minValue = next
                }
                if minValue > nextcc {
                    minValue = nextcc
                }
            }
        }
        return minValue
    }
    
    func clockWise(curPos: Int, step: Int, n: Int, visited: [Bool]) -> ([Bool]) {
        var checked = visited
        var startPoint = curPos
        for i in curPos..<curPos+step+1 {
            checked[startPoint] = true;
            if i >= n {
                startPoint = i - n
                checked[startPoint] = true;
            }else {
                startPoint = i
                checked[startPoint] = true;
            }
        }
        return  checked
    }
    
    func counterClockWise(curPos: Int, step: Int, n: Int, visited: [Bool]) -> [Bool]{
        var checked = visited
        var startPoint = curPos
        for i in stride(from: curPos, to: curPos-step-1, by: -1){
            if i < 0 {
                startPoint = n+i
                checked[startPoint] = true;
            }else{
                startPoint = i
                checked[startPoint] = true;
            }
        }
        return checked
    }
    
    func start(){
        let n = 12
        var weak = [1, 5, 6, 10]
        var dist = [1, 2, 3, 4]
        print(solution(n, weak, dist)) //2
        weak = [1, 3, 4, 9, 10]
        dist = [3,5,7]
        print(solution(n, weak, dist)) //1
    }
}
