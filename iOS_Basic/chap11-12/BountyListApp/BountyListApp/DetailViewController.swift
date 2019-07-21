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
    
    @IBOutlet weak var nameLabelCenterX: NSLayoutConstraint!
    @IBOutlet weak var bountyLabelCenterX: NSLayoutConstraint!
    
    var bountyInfo: BountyInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUIInfo()
        //        initBeforeAnimated()
        initUsingCGAffineTransform()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //        animateNameLabel()
        //        animateBountLabel()
        animateNameLabelUsingCGAffineTransform()
        animateBountyLabelUsingCGAffineTransform()
        transitImage()
    }
    private func animateNameLabelUsingCGAffineTransform(){
        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 2,
                       options: .allowUserInteraction,
                       animations: {
                        self.nameLabel.transform = CGAffineTransform.identity   // 초기세팅값
                        self.nameLabel.alpha = 1
        },
                       completion: nil)
    }
    private func animateBountyLabelUsingCGAffineTransform(){
        UIView.animate(withDuration: 1,
                       delay: 0.2,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 2,
                       options: .allowUserInteraction,
                       animations: {
                        self.bountyLabel.transform = CGAffineTransform.identity   // 초기세팅값
                        self.bountyLabel.alpha = 1
        },
                       completion: nil)
    }
    private func initUsingCGAffineTransform(){
        nameLabel.transform = CGAffineTransform.init(translationX: view.bounds.width, y: 0).scaledBy(x: 3, y: 3).rotated(by: 180)
        bountyLabel.transform = CGAffineTransform.init(translationX: view.bounds.width, y: 0).scaledBy(x: 3, y: 3).rotated(by: 180)
        
        //opacity 0 -> 1
        nameLabel.alpha = 0
        bountyLabel.alpha = 0
    }
    private func initBeforeAnimated(){
        nameLabelCenterX.constant = view.bounds.width
        bountyLabelCenterX.constant = view.bounds.width
    }
    private func animateNameLabel(){
        nameLabelCenterX.constant = 0
        UIView.animate( withDuration: 0.5,
                        delay: 0,
                        usingSpringWithDamping: 0.6,
                        initialSpringVelocity: 2,
                        options: .allowUserInteraction,
                        animations: {
                            self.view.layoutIfNeeded()
        },
                        completion: nil)
    }
    private func animateBountLabel(){
        bountyLabelCenterX.constant = 0
        UIView.animate(
            withDuration: 0.5,
            delay: 0.2,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 2,
            options: .allowUserInteraction,
            animations: {
                self.view.layoutIfNeeded()
        },
            completion: nil
        )
    }
    private func transitImage(){
        UIView.transition(with: imgView, duration: 0.7, options: .transitionCurlUp, animations: nil, completion: nil)
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
