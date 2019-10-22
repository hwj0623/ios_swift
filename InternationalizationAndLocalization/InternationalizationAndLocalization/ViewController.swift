//
//  ViewController.swift
//  InternationalizationAndLocalization
//
//  Created by hw on 23/09/2019.
//  Copyright © 2019 hwj. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var greetingLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        greetingLabel.text = "greeting".localized
        //선호 언어 설정 가능
        print(Locale.preferredLanguages)
        print(Bundle.main.preferredLocalizations)
    }

    @IBAction func touchUpSettingButton(_ sender: Any){
        //세팅 열기
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }

}

extension String {
    var localized: String?{
        return NSLocalizedString(self,
                                 tableName: "Localization",
                                 bundle: .main,
                                 comment: "")
    }
}
