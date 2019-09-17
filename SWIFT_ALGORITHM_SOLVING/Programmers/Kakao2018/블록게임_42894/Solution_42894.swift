//
//  Solution_42894.swift
//  SWIFT_ALGORITHM_SOLVING
//
//  Created by hw on 31/08/2019.
//  Copyright © 2019 hwj. All rights reserved.
//

//https://programmers.co.kr/learn/courses/30/lessons/42894
/*
 블록게임
 프렌즈 블록이라는 신규 게임이 출시되었고, 어마어마한 상금이 걸린 이벤트 대회가 개최 되었다.
 
 이 대회는 사람을 대신해서 플레이할 프로그램으로 참가해도 된다는 규정이 있어서, 게임 실력이 형편없는 프로도는 프로그램을 만들어서 참가하기로 결심하고 개발을 시작하였다.
 
 프로도가 우승할 수 있도록 도와서 빠르고 정확한 프로그램을 작성해 보자.
 
 게임규칙
 아래 그림과 같이 1×1 크기의 블록을 이어 붙여 만든 3 종류의 블록을 회전해서 총 12가지 모양의 블록을 만들 수 있다.
 
 - board는 블록의 상태가 들어있는 N x N 크기 2차원 배열이다.
 - N은 4 이상 50 이하다.
 - board의 각 행의 원소는 0 이상 200 이하의 자연수이다.
 - 0 은 빈 칸을 나타낸다.
 - board에 놓여있는 각 블록은 숫자를 이용해 표현한다.
 - 잘못된 블록 모양이 주어지는 경우는 없다.
 - 모양에 관계 없이 서로 다른 블록은 서로 다른 숫자로 표현된다.
 - 예를 들어 문제에 주어진 예시의 경우 다음과 같이 주어진다.
 */

import Foundation

class Solution_42894{
    func solution(_ board:[[Int]]) -> Int {
        let fallenBlackBlock = -3
        var resultValue = 0
        var mutableBoard = board
        for i in 0..<board.count {
            for j in 0..<board[0].count{
                let isBlocking = isLading(x: i, y: j, board: mutableBoard)
                if isBlocking {
                    mutableBoard[i][j] = fallenBlackBlock
                }
                if mutableBoard[i][j] != 0 && mutableBoard[i][j] != fallenBlackBlock{
                    let result = checkIfCollide(x: i, y: j, board: mutableBoard, data: mutableBoard[i][j])
                    mutableBoard = result.map
                    resultValue += result.elimiatedCount
                }
            }
        }
        return resultValue
    }
    var dx = [[0,0,0,-1,-1,-1], [0,0,-1,-1,-2,-2]]
    var dy = [[0,-1,-2,0,-1,-2],[0,-1,0,-1,0,-1]]
    
    func checkIfCollide(x: Int, y: Int, board: [[Int]], data: Int) -> (map: [[Int]], elimiatedCount: Int){
        var mutableBoard = board
        let fallenBlackBlock = -3
        ///check case 1-3 : |__
        ///check case 1-4 : _|
        ///check case 2-2 : |_
        ///check case 2-3 : __|
        ///check case 3-1 : ㅗ
        var blackCount = 0
        var result = 0
        var arrX = [Int]()
        var arrY = [Int]()
        for j in 0..<dx.endIndex {  ///5가지 케이스에 대해서 2x3 or 3x2 비교하여 같은 색의 컬러블록이 4개 있는지만 판단하면 된다.
            arrX = [Int]()
            arrY = [Int]()
            for i in 0..<dx[0].endIndex{
                let nx = x + dx[0][i]
                let ny = y + dy[0][i]
                if nx < 0 || ny < 0 || nx >= board.endIndex || ny >= board[0].endIndex {
                    break
                }
                if (data == board[nx][ny]){
                    arrX.append(nx)
                    arrY.append(ny)
                }
                if (board[nx][ny] == fallenBlackBlock) {
                    blackCount += 1
                }
                if(arrX.count == 4 && blackCount == 2){
                    for row in 0..<arrX.count {
                        mutableBoard[arrX[row]][arrY[row]] = fallenBlackBlock   ///지운 블록은 검은 블록으로 채운다.
                    }
                    result += 1
                    return (mutableBoard, result)
                }
            }
        }
        return (mutableBoard, result)
    }
    
    func isLading(x: Int, y: Int, board: [[Int]]) -> Bool {
        let block = -3
        for i in 0...x {
            if board[i][y] != 0 && board[i][y] != block  { // 위에 다른 뭔가 있음
                return false
            }
        }
        return true
    }
    
    func start(){
        let blocks = [[0,0,0,0,0,0,0,0,0,0],
                      [0,0,0,0,0,0,0,0,0,0],
                      [0,0,0,0,0,0,0,0,0,0],
                      [0,0,0,0,0,0,0,0,0,0],
                      [0,0,0,0,0,0,4,0,0,0],
                      [0,0,0,0,0,4,4,0,0,0],
                      [0,0,0,0,3,0,4,0,0,0],
                      [0,0,0,2,3,0,0,0,5,5],
                      [1,2,2,2,3,3,0,0,0,5],
                      [1,1,1,0,0,0,0,0,0,5]]
        print(solution(blocks))
    }
}
