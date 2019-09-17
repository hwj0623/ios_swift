//
//  CombinationEx1.swift
//  SWIFT_ALGORITHM_SOLVING
//
//  Created by hw on 03/09/2019.
//  Copyright © 2019 hwj. All rights reserved.
//

import Foundation

class RepeatPermuationEx2 {
    /*
     n 은 전체 개수
     r 은 중복을 포함하여 뽑을 개수
     arr은 현재 조합중인 배열
     subject는 원본 배열
     check는 자기자신을 포함하지 않는 중복순열
     */
    func combination(n: Int, r: Int, arr: [Int], subject: [Int], check: [Bool]){
        var curArr = arr
        var curCheck = check
        if arr.count == r {
            print(arr)
            return
        }
        for i in 0..<n {
            if !curCheck[i] {
                curCheck[i] = true
                curArr.append(subject[i])
                combination(n: n, r: r, arr: curArr, subject: subject, check: curCheck)
                curCheck[i] = false
                curArr.removeLast()
            }
        }
    }
    func start(){
        let test1 = [1,2,3,4]
        combination(n: 4, r: 2, arr: [Int](), subject: test1, check: [Bool].init(repeating: false, count: test1.count))
    }
}
