//
//  MyDataSource.swift
//  TableViewEx
//
//  Created by hw on 01/08/2019.
//  Copyright © 2019 hwj. All rights reserved.
//

import UIKit

/// 데이터소스에 관하여
class MyDataSource: NSObject, UITableViewDataSource{
    
    let contacts = ["홍길동":"01011112222",
                    "성춘향":"01012121314",
                    "민디":"01032423522",
                    "부엉이":"01039432891",
                    "빈":"01032434892",
                    "흰":"01037438273",
                    "도란":"01038473982",
                    "도미닉":"01038492736",
                    "오기":"01087622095"]
    let contacts2 = ["홍길동":"01011112222",
                    "성춘향":"01012121314",
                    "민디":"01032423522",
                    "부엉이":"01039432891",
                    "빈":"01032434892",
                    "오기":"01087622095"]
    /// 테이블 뷰의 각 센션에서 보여줄 셀(Row)은 몇개인가?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.contacts.count
        }else {
            return self.contacts2.count
        }
        return self.contacts.count
    }
    
    /// 섹션(정보 묶음 단위)을 몇개를 만들 것인가? default = 1
    /// row : 섹션 내의 인덱스로 구분되는 셀
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    /// 각각의 테이블 뷰에서 보여줄 셀이 내용은 무엇인가?
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = contacts.map{$0.key}[indexPath.row]
        
        if indexPath.row == 0 {
            cell.backgroundColor = .red
        }else{
            cell.backgroundColor = .white
        }
        return cell
    }
    
    
    

}
