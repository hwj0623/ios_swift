//
//  DetailViewController.swift
//  BountyListApp
//
//  Created by hw on 17/07/2019.
//  Copyright © 2019 hwj. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bountyLabel: UILabel!
    
    var bountyInfo: BountyInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUIInfo()
    }
    
    private func updateUIInfo(){
        guard let bountyInfo = self.bountyInfo else { return }
        imgView.image = bountyInfo.image
        nameLabel.text = bountyInfo.name
        bountyLabel.text = "\(bountyInfo.bounty)"
    }
    
    @IBAction func close(_ sender: UIButton){
        dismiss(animated: true, completion: nil)
    }
}
