//
//  ViewController.swift
//  TDD
//
//  Created by hw on 15/04/2019.
//  Copyright © 2019 hwj. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

class Calculator{
    func add(lhs: Int, rhs: Int) -> Int{
        return lhs + rhs
    }
}
