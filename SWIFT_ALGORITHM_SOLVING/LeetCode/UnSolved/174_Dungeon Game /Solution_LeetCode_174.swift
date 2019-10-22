//
//  Solution_LeetCode_746.swift
//  SWIFT_ALGORITHM_SOLVING
//
//  Created by hw on 26/08/2019.
//  Copyright © 2019 hwj. All rights reserved.
//

import Foundation
/**
 The demons had captured the princess (P) and imprisoned her in the bottom-right corner of a dungeon.
 The dungeon consists of M x N rooms laid out in a 2D grid.
 Our valiant knight (K) was initially positioned in the top-left room and must fight his way
 through the dungeon to rescue the princess.
 
 The knight has an initial health point represented by a positive integer.
 If at any point his health point drops to 0 or below, he dies immediately.
 
 Some of the rooms are guarded by demons,
 so the knight loses health (negative integers) upon entering these rooms;
 other rooms are either empty (0's) or contain magic orbs that increase the knight's health (positive integers).
 
 In order to reach the princess as quickly as possible, the knight decides to move only rightward or downward in each step.

 Write a function to determine the knight's minimum initial health so that he is able to rescue the princess.
 
 For example, given the dungeon below, the initial health of the knight must be at least 7 if he follows the optimal path RIGHT-> RIGHT -> DOWN -> DOWN.
 
 -2 (K)    -3    3
 -5    -10    1
 10    30    -5 (P)
 
 
 Note:
 
 The knight's health has no upper bound.
 Any room can contain threats or power-ups, even the first room the knight enters and the bottom-right room where the princess is imprisoned.

 */

class Solution_LeetCode_174 {
    var dx = [0,0,-1,1]  ///up down left right
    var dy = [-1,1,0,0]
    
    func calculateMinimumHP(_ dungeon: [[Int]]) -> Int {
        var result = 0
        let rowMax = dungeon.endIndex-1
        let colMax = dungeon[rowMax].endIndex-1
        let M = dungeon.endIndex+1
        let N = dungeon[0].endIndex+1
       
        return result
    }
    
//    fund solve (_ dungeon: [[Int]], )

    
    
    func start() {
//        let map = [[-2,-3,3],[-5,-10,1],[10,30,-5]]
//        for i in 0..<map.endIndex{
//            for j in 0..<map[i].endIndex{
//                print(map[i][j], terminator: " ")
//            }
//            print()
//        }
//        calculateMinimumHP(map)
        
        let map2 = [
                        [0,     -74,    -47,    -20,    -23,    -39,    -48],
                        [37,    -30,    37,     -65,    -82,    28,     -27],
                        [-76,   -33,    7,      42,     3,      49,     -93],
                        [37,    -41,    35,     -16,    -96,    -56,    38],
                        [-52,   19,     -37,    14,     -65,    -42,    9],
                        [5,     -26,    -30,    -65,    11,     5,      16],
                        [-60,   9,      36,     -36,    41,     -47,    -86],
                        [-22,   19,     -5,     -41,    -8,     -96,    -95]
                    ]
        let result = calculateMinimumHP(map2)
        print(result)
    }
}



//func search(curKnightHealth: Int, prevHistoryMinHP: Int, curX: Int, curY: Int, dungeon: [[Int]], visited: inout [[Bool]]) -> Int {
//    visited[curX][curY] = true
//    let curStateHP = curKnightHealth + dungeon[curX][curY]
//    var curHistoryMinHP = curStateHP > prevHistoryMinHP ? curStateHP : prevHistoryMinHP
//
//    let rowMax = dungeon.endIndex-1
//    let colMax = dungeon[rowMax].endIndex-1
//
//    /// 도착 지점에서 현재 누적 최솟값 갱신
//    if curX == rowMax && curY == colMax {
//        if result < curHistoryMinHP {
//            result = curHistoryMinHP
//            print("최저 결과 갱신 : \(result)")
//        }
//        return curHistoryMinHP
//    }else{
//        var count = 0
//        for i in 0..<dx.endIndex{
//            var nextX = curX+dx[i]
//            var nextY = curY+dy[i]
//            var nextResult = curHistoryMinHP
//            if (nextY < 0 || nextX < 0 || nextX > rowMax || nextY > colMax) {
//                count += 1
//                continue
//            }
//            if (!visited[nextX][nextY]){
//                //                print("다음 탐색 : curX: \(curX), curX: \(curY), nextX: \(nextX), nextY: \(nextY),curMinHP: \(curMinHP)")
//                if (curHistoryMinHP >= result){
//                    visited[nextX][nextY] = true
//                    nextResult = search(curKnightHealth: curStateHP, prevHistoryMinHP: curHistoryMinHP, curX: nextX, curY: nextY, dungeon: dungeon, visited: &visited)
//                    visited[nextX][nextY] = false
//                }
//            }else{
//                count += 1
//            }
//            if (curHistoryMinHP < nextResult){
//                curHistoryMinHP = nextResult
//            }
//        }
//        if count == 4{
//            return Int.min
//        }
//    }
//    return curHistoryMinHP
//}
