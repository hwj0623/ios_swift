//
//  ErrorCode.swift
//  SOLID_EX
//
//  Created by hw on 20/05/2019.
//  Copyright © 2019 hwj. All rights reserved.
//

import Foundation

enum ErrorCode : Error, CustomStringConvertible {
    case InvalidArea

    var description: String{
        switch self{
        case .InvalidArea:
            return "면적은 20이여야 합니다."
        }
    }
}
