//
//  Solution_42862.swift
//  SWIFT_ALGORITHM_SOLVING
//
//  Created by hw on 16/07/2019.
//  Copyright © 2019 hwj. All rights reserved.
//
//점심시간에 도둑이 들어, 일부 학생이 체육복을 도난당했습니다. 다행히 여벌 체육복이 있는 학생이 이들에게 체육복을 빌려주려 합니다.
//학생들의 번호는 체격 순으로 매겨져 있어, 바로 앞번호의 학생이나 바로 뒷번호의 학생에게만 체육복을 빌려줄 수 있습니다.
//예를 들어, 4번 학생은 3번 학생이나 5번 학생에게만 체육복을 빌려줄 수 있습니다.
// 체육복이 없으면 수업을 들을 수 없기 때문에 체육복을 적절히 빌려 최대한 많은 학생이 체육수업을 들어야 합니다.

//전체 학생의 수 n,
//체육복을 도난당한 학생들의 번호가 담긴 배열 lost,
//여벌의 체육복을 가져온 학생들의 번호가 담긴 배열 reserve가 매개변수로 주어질 때,
// 체육수업을 들을 수 있는 학생의 최댓값을 return 하도록 solution 함수를 작성해주세요.

//제한사항
//전체 학생의 수는 2명 이상 30명 이하입니다.
//체육복을 도난당한 학생의 수는 1명 이상 n명 이하이고 중복되는 번호는 없습니다.
//여벌의 체육복을 가져온 학생의 수는 1명 이상 n명 이하이고 중복되는 번호는 없습니다.
//여벌 체육복이 있는 학생만 다른 학생에게 체육복을 빌려줄 수 있습니다.
//여벌 체육복을 가져온 학생이 체육복을 도난당했을 수 있습니다. 이때 이 학생은 체육복을 하나만 도난당했다고 가정하며, 남은 체육복이 하나이기에 다른 학생에게는 체육복을 빌려줄 수 없습니다.
//입출력 예

//n    lost    reserve       return
//5    [2, 4]    [1, 3, 5]    5
//5    [2, 4]    [3]          4
//3    [3]       [1]          2

import Foundation

class Solution_42862{
    func solution(_ n:Int, _ lost:[Int], _ reserve:[Int]) -> Int {
        var current = [Int].init(repeating: 1, count: n)
        for i in lost{
            current[i-1] = 0
        }
        for j in reserve{
            current[j-1] += 1
        }
        var currentMax = 0
        for i in current{
            if i >= 1 {
                currentMax += 1
            }
        }
        if lost.isEmpty {
            return n
        }
        let tempMax = solve(lostIdx: 0, end: lost.endIndex-1, lost, current, currentMax)
        currentMax = tempMax > currentMax ? tempMax : currentMax
        return currentMax
    }
    
    func solve(lostIdx: Int, end: Int, _ lost: [Int], _ current: [Int], _ currentMax: Int) -> Int{
        var curStat: [Int] = current.map({$0}) //copy
        var curValue = currentMax
        
        var left = curValue
        var right = curValue
        var nothing = curValue
        
        /// basis
        if lostIdx > end {
            return currentMax
        }
        /// 현재 잃어버린 사람이 reserve인 경우, 다음 분실자 인덱스에 대해 실행하도록 리턴
        if current[lost[lostIdx]-1] == 1{
            return solve(lostIdx: lostIdx+1, end: end, lost, curStat, currentMax)
        }

        /// 잃어버린 사람이 reserve가 아닌 경우, 받아야 한다.
        if current[lost[lostIdx]-1] == 0 {
            let lostNum = lost[lostIdx]-1
            ///1st 가능하면 왼쪽 사람에게 빌린다.
            if lostNum-1 >= 0 && current[lostNum-1] == 2 {
                ///update
                curStat[lostNum-1] -= 1
                curStat[lostNum] = 1
                left = solve(lostIdx: lostIdx+1, end: end, lost, curStat, currentMax+1)
                ///restore
                curStat[lostNum-1] += 1
                curStat[lostNum] = 0
            }
            ///2nd 오른쪽 사람에게 빌린다.
            if lostNum+1 <= current.endIndex-1 && current[lostNum+1] == 2{
                curStat[lostNum+1] -= 1
                curStat[lostNum] = 1
                right = solve(lostIdx: lostIdx+1, end: end, lost, curStat, currentMax+1)
                ///restore
                curStat[lostNum+1] += 1
                curStat[lostNum] = 0
            }
            nothing = solve(lostIdx: lostIdx+1, end: end, lost, curStat, currentMax)
        }
        curValue = curValue < left ? left: curValue
        curValue = curValue < right ? right: curValue
        curValue = curValue < nothing ? nothing : curValue
        return curValue
    }
    func start(){
        var size = 5
        var lost = [2, 4]
        var reserve = [1, 3, 5]
        //5
        var result = solution(size, lost, reserve)
        print("result1 > : \(result)")
        size = 5
        lost = [2,4]
        reserve = [3]
        //4
        result = solution(size, lost, reserve)
        print("result2 > : \(result)")

        size = 3
        lost = [3]
        reserve = [1]
        //2
        result = solution(size, lost, reserve)
        print("result3 > : \(result)")
        
        size = 6
        lost = [1,2,5]
        reserve = [1,5,6]
        result = solution(size, lost, reserve)
        print("result4 > : \(result)")
        
        size = 7
        lost = [1,2,6,7]
        reserve = [4]
        result = solution(size, lost, reserve)
        print("result5 > : \(result)")


    }
}

