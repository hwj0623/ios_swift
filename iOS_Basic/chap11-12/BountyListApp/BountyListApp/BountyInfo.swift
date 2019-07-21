//
//  BountyInfo.swift
//  BountyListApp
//
//  Created by hw on 18/07/2019.
//  Copyright © 2019 hwj. All rights reserved.
//

import UIKit

class BountyInfo: NSObject {
    var name: String
    var bounty: Int
    var image: UIImage?{
        return UIImage(named: "\(name).jpg")
    }
    init(name: String, bounty: Int){
        self.name = name
        self.bounty = bounty
    }
}
