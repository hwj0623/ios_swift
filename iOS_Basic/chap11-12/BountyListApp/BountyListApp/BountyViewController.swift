//
//  BountyViewController.swift
//  BountyListApp
//
//  Created by hw on 13/07/2019.
//  Copyright © 2019 hwj. All rights reserved.
//

import UIKit

class BountyViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    
    
    @IBOutlet weak var bountyTableView: UITableView!
    var bountyInfoList = [
                            BountyInfo(name: "brook", bounty: 3300000),
                            BountyInfo(name: "chopper", bounty: 50),
                            BountyInfo(name: "franky", bounty: 44000000),
                            BountyInfo(name: "luffy", bounty: 300000000),
                            BountyInfo(name: "nami", bounty: 16000000),
                            BountyInfo(name: "robin", bounty: 80000000),
                            BountyInfo(name: "sanji", bounty: 77000000),
                            BountyInfo(name: "zoro", bounty: 120000000),

                         ]
    /*
     * collectionView
     */
    /// 몇 개를 보여줄 것인가?
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bountyInfoList.count
    }
    
    ///셀은 어떻게 표현할 것인가? - 한줄표기가 아니므로 몇 번째 아이템인지
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCell", for: indexPath) as? GridCell else{
            return UICollectionViewCell()
        }
        let info = bountyInfoList[indexPath.item]
        cell.updateUI(info)
        return cell
    }
    /// 셀 클릭시 어떻게 할 것인지
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /// indexPath의 item을 지정하여 sender로 데이터를 넘긴다.
        performSegue(withIdentifier: "showDetail", sender: indexPath.item)
    }
    
    /// cell size 를 기기에 맞게 - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (collectionView.bounds.width-10)/2
        let height: CGFloat = width * 10/7 + 65
        return CGSize.init(width: width, height: height)
    }
    
    /*
     * tableView
     */
//    /// 데이터 몇개를 보여줄 것인가?
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return bountyInfoList.count
//    }
//
//    /// 셀은 어떻게 표현할 것인가? - customizing한 UITableViewCell인 ListCell을 사용한다.
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        /// 재사용가능한 셀을 사용한다.
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ListCell else {
//            return UITableViewCell()
//        }
//        /// img, name, bounty
//        let bountyInfo = bountyInfoList[indexPath.row]
//        cell.updateUI(bountyInfo)
//        return cell
//    }
//    /// 셀 클릭시 어떻게 할 것인지
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        /// 세그웨이의 id를 지정하여 sender로 데이터를 넘긴다.
//        performSegue(withIdentifier: "showDetail", sender: indexPath.row)
//    }
    
    /// segueway 실행시 목적지 vc에 전송할 데이터를 처리한다.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let vc = segue.destination as? DetailViewController
            if let index = sender as? Int {
                vc?.bountyInfo = bountyInfoList[index]
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

class GridCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bountyLabel: UILabel!
    
    func updateUI(_ bountyInfo: BountyInfo){
        imgView.image = bountyInfo.image
        nameLabel.text = bountyInfo.name
        bountyLabel.text = "\(bountyInfo.bounty)"
    }
}

//class ListCell: UITableViewCell {
//    @IBOutlet weak var imgView: UIImageView!
//    @IBOutlet weak var nameLabel: UILabel!
//    @IBOutlet weak var bountyLabel: UILabel!
//
//    func updateUI(_ bountyInfo: BountyInfo){
//        imgView.image = bountyInfo.image
//        nameLabel.text = bountyInfo.name
//        bountyLabel.text = "\(bountyInfo.bounty)"
//    }
//}
