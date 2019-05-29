//
//  Solution.swift
//  SWIFT_ALGORITHM_SOLVING
//
//  Created by hw on 24/05/2019.
//  Copyright © 2019 hwj. All rights reserved.
//
/**
 * 0 또는 양의 정수가 주어졌을 때, 정수를 이어 붙여 만들 수 있는 가장 큰 수를 알아내 주세요.
 
 예를 들어, 주어진 정수가 [6, 10, 2]라면 [6102, 6210, 1062, 1026, 2610, 2106]를 만들 수 있고, 이중 가장 큰 수는 6210입니다.
 
 0 또는 양의 정수가 담긴 배열 numbers가 매개변수로 주어질 때,
 순서를 재배치하여 만들 수 있는 가장 큰 수를 문자열로 바꾸어 return 하도록 solution 함수를 작성해주세요.
 
 제한 사항
 numbers의 길이는 1 이상 100,000 이하입니다.
 numbers의 원소는 0 이상 1,000 이하입니다.
 정답이 너무 클 수 있으니 문자열로 바꾸어 return 합니다.
 
 numbers    return
 [6, 10, 2]    6210
 [3, 30, 34, 5, 9]    9534330
 
 */


import Foundation

extension String {
    subscript (i : Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
}

class Solution_42746 {
    
    init(){}
    
    func expo (base: Int = 10, power: Int ) -> Int {
        var result = 1
        for element in 0..<power {
            result *= base
        }
        return result
    }
    
    func solution(_ numbers:[Int]) -> String {
        var processedNumbers : [Int] = [Int].init(repeating: 0, count: numbers.count)
        
        for (index, value) in numbers.enumerated(){
            if value == 0 {
                continue
            }
            
            if value < 10 {
                processedNumbers[index] = value * 1001 + 3
                print("value : \(value), proce[idx] = \(processedNumbers[index])")
                continue
            }
            
            else if value < 100 {
                processedNumbers[index] = value * 101 + 2
                print("value : \(value), proce[idx] = \(processedNumbers[index])")
                continue
            }
            
            else if value < 1000 {
                processedNumbers[index] = value * 11 + 1
                print("value : \(value), proce[idx] = \(processedNumbers[index])")
                continue
            }
            else {
                processedNumbers[index] = value
            }
        }
        var orderedNumbers = processedNumbers.sorted(by: > )
        print (orderedNumbers)
        for (index, element) in orderedNumbers.enumerated() {
            if element > 1000 {
                let additional = element % 10
                print("element : \(element) , expo : \(expo(power: additional) + 1)")
                orderedNumbers[index] = (element - additional) / (expo(power: additional) + 1)
                print(orderedNumbers[index])
            }
        }
        print (orderedNumbers)

        var result = ""
        if orderedNumbers[0] == 0 {
            return "0"
        }
        for element in orderedNumbers {
            result += String(element)
        }
        return result
    }
    

  
    func getInput (_ caseInput: Int = 3, customCase: [Int] = []) -> [Int] {
        
        switch caseInput {
        case 1:
            return [ 6, 10, 2 ]
        case 2:
            return [ 3, 30, 34, 5, 9 ]
        case 3:
            return [ 0, 0, 0, 0]
        case 4:
            return [0, 1000, 0, 0]
        case 5:
            return [21, 212]
        default :
            return customCase
        }
    }
}
