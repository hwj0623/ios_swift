//
//  PermutationEx0.swift
//  SWIFT_ALGORITHM_SOLVING
//
//  Created by hw on 03/09/2019.
//  Copyright © 2019 hwj. All rights reserved.
//

import Foundation

import Foundation

class PermutationEx0{
    /**
     출처: https://gorakgarak.tistory.com/522 [먹거리 만드는 열정맨 고락가락]
     arr - 교환되는 배열
     depth - 현재 트리구조에서 어떤 깊이에서 교환작업을 하고있는지에 대한 변수
         맨처음 깊이라면 0의 위치에서 작업하고 있을것이며 이는
         첫번째와 첫번째 인자를 교환하거나(1,2,3,4)
         첫번째와 두번째 인자를 교환(2,1,3,4)하거나,
         첫번째와 세번째(3,2,1,4) 인자를 교환하거나
         첫번째와 네번째(4,2,3,1) 인자를 교환하는 중이다.
     
     n - 총 배열안에 들어있는 숫자를 뜻하며 고정값
     k - 몇개를 뽑아내서 순열을 만들것인지를 뜻하며 고정값.  nPk의 k
     */
    func permutate(arr: [Int], depth: Int, n: Int, k: Int)-> [[Int]]{
        var result = [[Int]]()
        var curArr = arr
        if depth == k {
            print(curArr)
            return [curArr]
        }
        for i in depth..<n {
            curArr.swapAt(i, depth)
            let nextResult = permutate(arr: curArr, depth: depth+1, n: n, k: k)
            curArr.swapAt(i, depth)
            result += nextResult
        }
        return result
    }
    
    func start(){
        let test1 = [1,2,3,4]
        let result = permutate(arr: test1, depth: 0, n: test1.count, k: 4)
        print(result)
     
    }
}
