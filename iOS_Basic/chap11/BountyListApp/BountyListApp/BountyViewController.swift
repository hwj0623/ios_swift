//
//  BountyViewController.swift
//  BountyListApp
//
//  Created by hw on 13/07/2019.
//  Copyright © 2019 hwj. All rights reserved.
//

import UIKit

class BountyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    let nameList = ["brook", "chopper", "franky", "luffy", "nami", "robin", "sanji", "zoro"]
    let bountyList = [3300000, 50, 44000000, 300000000, 16000000, 80000000, 77000000, 120000000 ]
    @IBOutlet weak var bountyTableView: UITableView!
    
    /// 데이터 몇개를 보여줄 것인가?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.nameList.count
    }

    /// 셀은 어떻게 표현할 것인가? - customizing한 UITableViewCell인 ListCell을 사용한다.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /// 재사용가능한 셀을 사용한다.
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ListCell else {
            return UITableViewCell()
        }
        /// img, name, bounty
        let img = UIImage(named: "\(nameList[indexPath.row]).jpg")
        cell.imgView.image = img
        cell.nameLabel.text = nameList[indexPath.row]
        cell.bountyLabel.text = "\(bountyList[indexPath.row])"
        return cell
    }

    /// 셀 클릭시 어떻게 할 것인지
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /// 세그웨이의 id를 지정하여 sender로 데이터를 넘긴다.
        performSegue(withIdentifier: "showDetail", sender: indexPath.row)
    }
    
    /// segueway 실행시 목적지 vc에 전송할 데이터를 처리한다.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let vc = segue.destination as? DetailViewController
            if let index = sender as? Int {
                vc?.name = nameList[index]
                vc?.bounty = bountyList[index]
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

class ListCell: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bountyLabel: UILabel!
    
}
