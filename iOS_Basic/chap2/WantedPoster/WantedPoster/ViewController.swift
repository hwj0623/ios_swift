//
//  ViewController.swift
//  WantedPoster
//
//  Created by hw on 07/07/2019.
//  Copyright © 2019 hwj. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var currentRansom: Int = 0
    @IBOutlet weak var ransomLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        refreshRansom()
    }
    
    @IBAction func showAlert(){
        refreshRansom()
        let message = "현재 현상금은 \(currentRansom)입니다."
        let alert = UIAlertController.init(title: "hello", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "확인", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    func refreshRansom() {
        let nextRansom = arc4random_uniform(1_000_000)
        currentRansom = Int(nextRansom)
        let formattedRansom = priceDisplay(currentRansom)
        ransomLabel.text = "\(formattedRansom)"
    }
    private func priceDisplay (_ input: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        let formattedPrice = formatter.string(from: NSNumber(value: input))
        return formattedPrice ?? "0"
    }

}

