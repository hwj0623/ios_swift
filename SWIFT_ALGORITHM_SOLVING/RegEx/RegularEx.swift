//
//  RegularEx.swift
//  SWIFT_ALGORITHM_SOLVING
//
//  Created by hw on 07/09/2019.
//  Copyright © 2019 hwj. All rights reserved.
//

import Foundation

extension String {
    func pattern(for regex: String, in inputString: String) -> [String] {
        do {
            if let regex = try? NSRegularExpression(pattern: regex, options: .caseInsensitive){
                let test = regex.matches(in: inputString, options: [], range: NSRange(location:0, length: inputString.count))
                let result : [String] = test.map{ String(inputString[Range($0.range, in: inputString)!])}
                return result
            }
        }
        //if fails
        return []
    }
}


