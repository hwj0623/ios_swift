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
    
    var name: String?
    var bounty: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUIInfo()
    }
    private func updateUIInfo(){
        if let name = self.name, let bounty = self.bounty {
            let img = UIImage(named: "\(name).jpg")
            imgView.image = img
            nameLabel.text = name
            bountyLabel.text = "\(bounty)"
        }
    }
    @IBAction func close(_ sender: UIButton){
        dismiss(animated: true, completion: nil)
    }
}
