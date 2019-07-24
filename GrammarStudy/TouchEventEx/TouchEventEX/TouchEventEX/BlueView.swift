//
//  BlueView.swift
//  TouchEventEX
//
//  Created by hw on 22/07/2019.
//  Copyright © 2019 hwj. All rights reserved.
//

import UIKit

class BlueView: UIView {
    var timestamp: Date
    var myFont: UIFont
    
    
    @IBOutlet weak var mainView: UIView!
    ///view 객체 만들 때는 생성자가 2개 필요
    /// 코드레벨에서 생성하는 View는 override init을 구현해주어야 한다.
    override init(frame: CGRect){
        timestamp = Date()
        myFont = UIFont.systemFont(ofSize: 18)
        super.init(frame: frame)
    }
    
    /// storyboard에서 생성한 UIView의 경우..
    /// 아카이브되었다가, unarchived될 때 생성되는 생성자함수
    /// View 내 프로퍼티를 모두 초기화 한다.
    required init?(coder aDecoder: NSCoder) {
        timestamp = Date()
        myFont = UIFont.systemFont(ofSize: 18)
        super.init(coder: aDecoder)
    }
}
