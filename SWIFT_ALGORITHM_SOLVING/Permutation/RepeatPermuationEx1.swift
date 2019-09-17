//
//  RepeatPermuationEx1.swift
//  SWIFT_ALGORITHM_SOLVING
//
//  Created by hw on 03/09/2019.
//  Copyright © 2019 hwj. All rights reserved.
//
// 중복순열
// https://limkydev.tistory.com/175 참고
import Foundation

class RepeatPermutationEx1 {
    /*
     n 은 전체 개수
     r 은 중복을 포함하여 뽑을 개수
     arr은 현재 조합중인 배열
     subject는 원본 배열
     */
    func rePermutate(n: Int, r: Int, arr: [Int], subject: [Int]){
        var curArr = arr
        if arr.count == r {
            print(arr)
            return
        }
        for i in 1...n {
            curArr.append(subject[i-1])
            rePermutate(n: n, r: r, arr: curArr, subject: subject)
            curArr.removeLast()
        }
    }
    func start(){
        let test1 = [1,2,3,4]
        rePermutate(n: 4, r: 2, arr: [Int](), subject: test1)
    }
}
