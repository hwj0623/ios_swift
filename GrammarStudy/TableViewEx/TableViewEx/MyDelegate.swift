//
//  MyDelegate.swift
//  TableViewEx
//
//  Created by hw on 01/08/2019.
//  Copyright © 2019 hwj. All rights reserved.
//

import UIKit

///Delegate를 구현하는 부분
class MyDelegate: NSObject, UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.section), \(indexPath.row)")
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
