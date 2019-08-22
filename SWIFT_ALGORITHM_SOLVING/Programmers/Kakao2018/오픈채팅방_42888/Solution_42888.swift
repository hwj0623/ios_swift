//
//  Solution_42888.swift
//  SWIFT_ALGORITHM_SOLVING
//
//  Created by hw on 21/08/2019.
//  Copyright © 2019 hwj. All rights reserved.
//

import Foundation

/// https://programmers.co.kr/learn/courses/30/lessons/42888
/// 제목 : 오픈채팅방
/// 유형 : 자료구조
/* input
 ["Enter uid1234 Muzi",
 "Enter uid4567 Prodo",
 "Leave uid1234",
 "Enter uid1234 Prodo",
 "Change uid4567 Ryan"]
 */
class Solution_42888 {
    let record: [String] = [
        "Enter uid1234 Muzi",
        "Enter uid4567 Prodo",
        "Leave uid1234",
        "Enter uid1234 Prodo",
        "Change uid4567 Ryan"
    ]
    
    func solution(_ record:[String]) -> [String] {
        var instructionList = [String]()
        var instructionIdList = [String]()
        var idNickDict = [String: String]() /// id : Nickname
        var expressionDictionary = ["Enter": "님이 들어왔습니다.", "Leave": "님이 나갔습니다."]
        var resultList = [String]()

        record.forEach { (element) in
            let compositionString = element.components(separatedBy: " ")
            let instruct = compositionString[0]
            let actorId = compositionString[1]
            if compositionString.count == 3 {
                let nickName = compositionString[2]
                if instruct == "Enter" {
                    instructionList.append(instruct)
                    instructionIdList.append(actorId)
                    idNickDict.updateValue(nickName, forKey: actorId)
                }else if instruct == "Change" {
                    idNickDict.updateValue(nickName, forKey: actorId)
                }
            }else {
                instructionList.append(instruct)
                instructionIdList.append(actorId)
            }
        }
        
        for index in 0..<instructionList.endIndex {
            let instruct = instructionList[index]
            let actorId = instructionIdList[index]
            guard let presentationalInstruction = expressionDictionary[instruct], let nickName = idNickDict[actorId] else {
                continue
            }
            let eachResult = "\(nickName)\(presentationalInstruction)"
            resultList.append(eachResult)
        }
        return resultList
    }
    
    func start() {
        let record: [String] = [
            "Enter uid1234 Muzi",
            "Enter uid4567 Prodo",
            "Leave uid1234",
            "Enter uid1234 Prodo",
            "Change uid4567 Ryan"
        ]
        solution(record)
    }
}
/// main.swift 에서 static func 만들어서 아래와 같이 출력하여 실행
/*
 class Main {
    static func pG_42888(){
        var pg_42888 = Solution_42888()
        pg_42888.start()
    }
 }
 Main.pG_42888()
 */
