//
//  Solution_kakao1.swift
//  SWIFT_ALGORITHM_SOLVING
//
//  Created by hw on 07/09/2019.
//  Copyright © 2019 hwj. All rights reserved.
//

import Foundation
/*
 데이터 처리 전문가가 되고 싶은 어피치는 문자열을 압축하는 방법에 대해 공부를 하고 있습니다. 최근에 대량의 데이터 처리를 위한 간단한 비손실 압축 방법에 대해 공부를 하고 있는데, 문자열에서 같은 값이 연속해서 나타나는 것을 그 문자의 개수와 반복되는 값으로 표현하여 더 짧은 문자열로 줄여서 표현하는 알고리즘을 공부하고 있습니다.
 간단한 예로 aabbaccc의 경우 2a2ba3c(문자가 반복되지 않아 한번만 나타난 경우 1은 생략함)와 같이 표현할 수 있는데, 이러한 방식은 반복되는 문자가 적은 경우 압축률이 낮다는 단점이 있습니다. 예를 들면, abcabcdede와 같은 문자열은 전혀 압축되지 않습니다. 어피치는 이러한 단점을 해결하기 위해 문자열을 1개 이상의 단위로 잘라서 압축하여 더 짧은 문자열로 표현할 수 있는지 방법을 찾아보려고 합니다.
 
 예를 들어, ababcdcdababcdcd의 경우 문자를 1개 단위로 자르면 전혀 압축되지 않지만, 2개 단위로 잘라서 압축한다면 2ab2cd2ab2cd로 표현할 수 있습니다. 다른 방법으로 8개 단위로 잘라서 압축한다면 2ababcdcd로 표현할 수 있으며, 이때가 가장 짧게 압축하여 표현할 수 있는 방법입니다.
 
 다른 예로, abcabcdede와 같은 경우, 문자를 2개 단위로 잘라서 압축하면 abcabc2de가 되지만, 3개 단위로 자른다면 2abcdede가 되어 3개 단위가 가장 짧은 압축 방법이 됩니다. 이때 3개 단위로 자르고 마지막에 남는 문자열은 그대로 붙여주면 됩니다.
 
 압축할 문자열 s가 매개변수로 주어질 때, 위에 설명한 방법으로 1개 이상 단위로 문자열을 잘라 압축하여 표현한 문자열 중 가장 짧은 것의 길이를 return 하도록 solution 함수를 완성해주세요.
 
 제한사항
 s의 길이는 1 이상 1,000 이하입니다.
 s는 알파벳 소문자로만 이루어져 있습니다.
 
 s              result
 "aabbaccc"    7
 "ababcdcdababcdcd"    9
 "abcabcdede"    8
 "abcabcabcabcdededededede"    14
 "xababcdcdababcdcd"    17
 */
class Solution_kakao1 {
    func solution(_ s:String) -> Int {
        let maxUnitSize = s.count/2

        var minValue = s.count
        var answer = s.count
        if (s.count == 0 ){
            return 0
        }
        
        for i in 1..<maxUnitSize+1 {
            answer = s.count
            var unitSize = i
            var curStr = s[0..<i]
            print(curStr)
            var k = 1
            var j = 0
            var next = ""
            while j<s.count {
                var nextIndex = s.index(s.startIndex, offsetBy: j+(i*(k+1)))
                var nidx = j+(i*(k+1))
                var curIndex = s.index(s.startIndex, offsetBy: j+(i*k))
                if (nidx > s.count){
                    break
                }
                
//                next = s[j+(i*k)..<j+(i*(k+1))]
                
                
                j += unitSize
            }
        }
        
        return minValue
    }
    
    func start(){
        
    }
}

extension String {
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    subscript (bounds: CountableRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[start ..< end]
    }
    subscript (bounds: CountableClosedRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[start ... end]
    }
    subscript (bounds: CountablePartialRangeFrom<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(endIndex, offsetBy: -1)
        return self[start ... end]
    }
    subscript (bounds: PartialRangeThrough<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[startIndex ... end]
    }
    subscript (bounds: PartialRangeUpTo<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[startIndex ..< end]
    }
}
