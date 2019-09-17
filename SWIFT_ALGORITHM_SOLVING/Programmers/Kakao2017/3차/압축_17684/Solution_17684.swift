//
//  Solution_17684.swift
//  SWIFT_ALGORITHM_SOLVING
//
//  Created by hw on 06/09/2019.
//  Copyright © 2019 hwj. All rights reserved.
//
//https://programmers.co.kr/learn/courses/30/lessons/17684
import Foundation
/// LZW 알고리즘을 이용한 압축

class Solution_17684 {
    
    func solution(_ msg:String) -> [Int] {
        var charList =    ["A","B","C","D","E","F","G","H","I","J",
                           "K","L","M","N","O","P","Q","R","S","T",
                           "U","V","W","X","Y","Z"]
        var indexNumber = [1,  2,  3,  4,  5,  6,  7,  8,  9, 10,
                           11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
                           21, 22, 23, 24, 25, 26]
        
        var dict = [String:Int]()
        for i in 0..<charList.endIndex{
            dict.updateValue(indexNumber[i], forKey: charList[i])
        }
        var result = [Int]()
        var charIndex = -1
        while (charIndex < msg.count-1) {
            charIndex += 1
            if charIndex > msg.count-1 {
                break
            }
            var nextIndex = charIndex
            var stringIndex = msg.index(msg.startIndex, offsetBy: charIndex)
            var w = String(msg[stringIndex])
//            print("cur w: \(w), charIndex : \(charIndex) / \(msg.count)")
//            print("now appending...")
            var nextW = w
            var curW = w
            while(dict[curW] != nil && (nextIndex+1) <= msg.count){
                if dict[nextW] == nil && dict[curW] != nil {
                    print("curW : \(curW), next : \(nextW)")
                    dict.updateValue(indexNumber.endIndex+1, forKey: nextW)
                    charList.append(nextW)
                    indexNumber.append(indexNumber.endIndex+1)
                    result.append(dict[curW]!)
                    charIndex += curW.count - 1
                    break
                }else if dict[nextW] != nil && dict[curW] != nil && nextIndex+1 == msg.count{
                    result.append(dict[nextW]!)
                    charIndex += nextW.count - 1
                    break
                }
                curW = nextW
                nextIndex += 1
                stringIndex = msg.index(msg.startIndex, offsetBy: nextIndex)
                if stringIndex == msg.endIndex {
                    result.append(dict[curW]!)
                    break
                }
                nextW += String(msg[stringIndex])
            }
        }
        return result
    }
    
    func start(){
        var msg = "KAKAO"
//        msg = "TOBEORNOTTOBEORTOBEORNOT"
        msg = "ABABABABABABABAB"    //[1, 2, 27, 29, 28, 31, 30]
        print(solution(msg))    //[20, 15, 2, 5, 15, 18, 14, 15, 20, 27, 29, 31, 36, 30, 32, 34]
        
    }
    
}
