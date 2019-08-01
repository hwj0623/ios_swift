//
//  ViewController.swift
//  TableViewEx
//
//  Created by hw on 01/08/2019.
//  Copyright © 2019 hwj. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private let dataSource = MyDataSource()
    private let delegate = MyDelegate()
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.tableView.dataSource = MyDataSource() //이대로 놔두면 weak 참조로 viewDidLoad 호출 끝나면 사라진다.
        self.tableView.dataSource = self.dataSource
        self.tableView.delegate = self.delegate
    }


}

