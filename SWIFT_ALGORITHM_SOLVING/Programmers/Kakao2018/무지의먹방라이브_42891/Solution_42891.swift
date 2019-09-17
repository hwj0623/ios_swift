//
//  Solution_42891.swift
//  SWIFT_ALGORITHM_SOLVING
//
//  Created by hw on 21/08/2019.
//  Copyright © 2019 hwj. All rights reserved.
//

import Foundation


/// 문제 출처 : https://programmers.co.kr/learn/courses/30/lessons/42891
/*
 그냥 먹방을 하면 다른 방송과 차별성이 없기 때문에 무지는 아래와 같이 독특한 방식을 생각해냈다.
 
 회전판에 먹어야 할 N 개의 음식이 있다.
 각 음식에는 1부터 N 까지 번호가 붙어있으며, 각 음식을 섭취하는데 일정 시간이 소요된다.
 무지는 다음과 같은 방법으로 음식을 섭취한다.
 
 무지는 1번 음식부터 먹기 시작하며, 회전판은 번호가 증가하는 순서대로 음식을 무지 앞으로 가져다 놓는다.
 마지막 번호의 음식을 섭취한 후에는 회전판에 의해 다시 1번 음식이 무지 앞으로 온다.
 무지는 음식 하나를 1초 동안 섭취한 후 남은 음식은 그대로 두고, 다음 음식을 섭취한다.
 다음 음식이란, 아직 남은 음식 중 다음으로 섭취해야 할 가장 가까운 번호의 음식을 말한다.
 회전판이 다음 음식을 무지 앞으로 가져오는데 걸리는 시간은 없다고 가정한다.
 무지가 먹방을 시작한 지 K 초 후에 네트워크 장애로 인해 방송이 잠시 중단되었다.
 무지는 네트워크 정상화 후 다시 방송을 이어갈 때, 몇 번 음식부터 섭취해야 하는지를 알고자 한다.
 각 음식을 모두 먹는데 필요한 시간이 담겨있는 배열 food_times, 네트워크 장애가 발생한 시간 K 초가 매개변수로 주어질 때 몇 번 음식부터 다시 섭취하면 되는지 return 하도록 solution 함수를 완성하라.
 
 제한사항
    food_times 는 각 음식을 모두 먹는데 필요한 시간이 음식의 번호 순서대로 들어있는 배열이다.
    k 는 방송이 중단된 시간을 나타낸다.
    만약 더 섭취해야 할 음식이 없다면 -1을 반환하면 된다.
 정확성 테스트 제한 사항
    food_times 의 길이는 1 이상 2,000 이하이다.
    food_times 의 원소는 1 이상 1,000 이하의 자연수이다.
    k는 1 이상 2,000,000 이하의 자연수이다.
 효율성 테스트 제한 사항
    food_times 의 길이는 1 이상 200,000 이하이다.
    food_times 의 원소는 1 이상 100,000,000 이하의 자연수이다.
    k는 1 이상 2 x 10^13 이하의 자연수이다.
 
 입출력 예
     food_times    k    result
     [3, 1, 2]    5    1
 입출력 예 설명
 입출력 예 #1
     0~1초 동안에 1번 음식을 섭취한다. 남은 시간은 [2,1,2] 이다.
     1~2초 동안 2번 음식을 섭취한다. 남은 시간은 [2,0,2] 이다.
     2~3초 동안 3번 음식을 섭취한다. 남은 시간은 [2,0,1] 이다.
     3~4초 동안 1번 음식을 섭취한다. 남은 시간은 [1,0,1] 이다.
     4~5초 동안 (2번 음식은 다 먹었으므로) 3번 음식을 섭취한다. 남은 시간은 [1,0,0] 이다.
     5초에서 네트워크 장애가 발생했다. 1번 음식을 섭취해야 할 때 중단되었으므로, 장애 복구 후에 1번 음식부터 다시 먹기 시작하면 된다.
 */
class Solution_42891 {
    
    func solution(_ food_times:[Int], _ k:Int64) -> Int {
        var totalDishTimes: Int64 = 0
        var tempDict = [Int : Int]()
        for i in 0..<food_times.endIndex{
            tempDict.updateValue(food_times[i], forKey: i+1)
            totalDishTimes += Int64(food_times[i])
        }
        var sorted = tempDict.sorted{ (lhs: (key: Int, value: Int), rhs: (key: Int, value: Int)) -> Bool in
            return lhs.value < rhs.value
        }
        var totalK = k          /// 총 시간
        var minTimes = 0        /// 현재 뺄 최소 시간
        var size = 0            /// 한번에 뺄 접시 개수
        var index = 0           /// 시간순으로 정렬된 접시 인덱스
        var cumulatedMinus = 0  /// 현재까지 뺀 값
        /// 최소 시간 * 단위 접시 수 보다 k가 클 때
        
        if totalDishTimes <= k { /// 중단되는 시간보다 접시 소요시간이 작다면 -1
            return -1
        }
        var result = 0
        while totalK >= 0 {
            minTimes = sorted[index].value - cumulatedMinus // 현재 뺄 최소시간 계산
            cumulatedMinus += minTimes               /// 뺀 최소 단위 누적 시간 업데이트
            size = sorted.endIndex - index           /// 접시 계산
            
            if totalK == 0 {
                let sortedByKeys = sorted[index..<sorted.endIndex].sorted{ (lhs: (key: Int, value: Int), rhs: (key: Int, value: Int)) -> Bool in
                    lhs.key < rhs.key
                }
                result = sortedByKeys[Int(totalK)].key
                break
            }else if totalK < (minTimes * size) {
                let sortedByKeys = sorted[index..<sorted.endIndex].sorted{ (lhs: (key: Int, value: Int), rhs: (key: Int, value: Int)) -> Bool in
                    lhs.key < rhs.key
                }
                totalK = totalK % Int64(sortedByKeys.endIndex)
                result = sortedByKeys[Int(totalK)].key
                break
            }
            
            totalK -= Int64(minTimes) * Int64(size) ///시간 제거
            /// 다음 시작 접시 인덱스를 찾는다.
            for i in index..<sorted.endIndex{
                if sorted[i].value > cumulatedMinus {
                    index = i
                    break
                }
            }
        }
        return result
    }
    
//    func solution3(_ food_times:[Int], _ k:Int64) -> Int {
//        ///단위 접시 크기
//        var dishSize = 0
//        var deleteAmount = 0
//        var totalTime = k
//        var startIndex = 0
//        var backup_food_times = [(key: Int, dishes: Int)]()
//        var sorted_food_times = [(key: Int, dishes: Int)]()
//        for i in 0..<food_times.endIndex {
//            backup_food_times.append((key: i+1, dishes: food_times[i]))
//            sorted_food_times.append((key: i+1, dishes: food_times[i]))
//        }
//        sorted_food_times.sort { (lhs: (key: Int, dishes: Int), rhs: (key: Int, dishes: Int)) -> Bool in
//            if lhs.dishes < rhs.dishes {
//                return true
//            }else if lhs.dishes == rhs.dishes {
//                return lhs.key < rhs.key
//            }else{
//                return false
//            }
//        }
//
//        while totalTime > 0 {
//            let size = ( sorted_food_times.endIndex - startIndex ) /// n - i , 0 아닌 그릇의 크기
//            let amount = sorted_food_times[startIndex].dishes      /// 정렬된 유효 그릇의 최소 양
//            let deleted = Int64(size) * Int64(amount)
//
//            if totalTime >= deleted {
//                totalTime -= deleted
//                if totalTime == 0 { ///total Time 전부 제거시, 0이 아닌 startIndex 찾아서 key를 구한다.
//                    for i in startIndex..<sorted_food_times.endIndex {
//                        sorted_food_times[i].dishes -= amount
////                        if sorted_food_times[i].dishes > 0 {
////                            startIndex = i
////                            let result = sorted_food_times[startIndex].key - 1
////                            return backup_food_times[result].key
////                        }
//                    }
//                     return -1
//                }
//            }else { /// if totalTime < deleted ; 삭제할 단위크기묶음보다 totalTime이 작다면,
//                    /// loop(startIndex..<backup.endIndex)로 다음 key를 찾아야 한다.
//                    /// ex: deleted = 15이고, totalTime은 12, 유효배열의 크기는 전체 10개중 오른쪽 5개 라고 하면
//                let validSize = (sorted_food_times.endIndex - startIndex)
//                if totalTime >= validSize {
//                    let sortedArrayIndex = startIndex + Int((totalTime % Int64(sorted_food_times.endIndex)))
//                    let resultIndex = sorted_food_times[sortedArrayIndex].key
//                    return backup_food_times[resultIndex-1].key
//                }else {
//                    let sortedArrayIndex = startIndex + Int(totalTime)
//                    return backup_food_times[sortedArrayIndex].key
//                }
//            }
//            /// sorted array의 나머지 값들을 갱신한다. startIndex도 갱신
//            for i in startIndex..<sorted_food_times.endIndex {
//                sorted_food_times[i].dishes -= amount
//                if sorted_food_times[i].dishes < 0 {
//                    startIndex = i
//                }
//            }
//            startIndex += 1
//        }
//        return -1
//    }
//
//    func solution2(_ food_times:[Int], _ k:Int64) -> Int {
//        var tempTimes = [ (key: Int, count: Int)]()
//        var backup_food_times = [ (key: Int, count: Int)]()
//        var totalTime = k
//        for index in 0..<food_times.endIndex {
//            tempTimes.append((key: index+1, count: food_times[index]))
//            backup_food_times.append((key: index+1, count: food_times[index]))
//        }
//        var sortedTimes = tempTimes.sorted { (lhs: (key: Int, count: Int), rhs: (key: Int, count: Int)) -> Bool in
//            if lhs.count < rhs.count {
//                return true
//            }else if lhs.count == rhs.count {
//                return lhs.key < rhs.key
//            }
//            return false
//        }
//        var minimumDishCount: Int64 = 0        /// 현재 소비할 시간 크기
//        var curDishSize: Int64 = 0             /// 현재 소비할 접시의 개수
//
//        while totalTime > 0 {
//            minimumDishCount = 0
//            curDishSize = 0
//            if sortedTimes.endIndex > 0 {
//                minimumDishCount = Int64(sortedTimes[0].count)
//                curDishSize = Int64(sortedTimes.endIndex)
//            }else {
//                return -1
//            }
//
//            let deleted = minimumDishCount * curDishSize    ///전체 시간에서 지울 시간
//            if totalTime >= deleted {
//                totalTime -= deleted
//            }else {
//                if totalTime >= sortedTimes.endIndex {
//                    let resultIndex = Int(totalTime) % (sortedTimes.endIndex)
//                    let result = backup_food_times[resultIndex].key
//                    return result
//                }else {
//                    let result = backup_food_times[Int(totalTime)].key
//                    return result
//                }
//            }
//            ///현재 접시들 중에서 최소 시간 단위만큼을 빼준다.
//            for index in 0..<sortedTimes.endIndex {
//                sortedTimes[index].count -= Int(minimumDishCount)
//                backup_food_times[index].count -= Int(minimumDishCount)
//            }
//            /// 접시 카운트 0 짜리 필터링
//            sortedTimes = sortedTimes.filter { (element: (key: Int, count: Int)) -> Bool in
//                return element.count > 0
//            }
//            backup_food_times = backup_food_times.filter { (element: (key: Int, count: Int)) -> Bool in
//                return element.count > 0
//            }
//            if totalTime == 0 {
//                if backup_food_times.count > 0 {
//                    let result = backup_food_times[0].key
//                    return result
//                }else {
//                    return -1
//                }
//            }
//        }
//        return -1
//    }
    func start(){
        let testArray = [3, 1, 2]
        let testArray2 = [1000]

        let k: Int64 = 1
        print(solution(testArray, 1))
        print(solution(testArray, 2))
        print(solution(testArray, 3))
        print(solution(testArray, 4))
        print(solution(testArray, 5))
        print(solution(testArray, 6))
        print(solution(testArray2, 50))

        
    }
}
