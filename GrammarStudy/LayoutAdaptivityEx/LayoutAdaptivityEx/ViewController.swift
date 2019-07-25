//
//  ViewController.swift
//  LayoutAdaptivityEx
//
//  Created by hw on 25/07/2019.
//  Copyright © 2019 hwj. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 화면 가운데 정렬, 가로세로 비율이 1:1, 가로 길이가 Safe Area의 30%인 뷰
        
        // 방법1 NSLayoutConstraint 객체 생성
        let square = UIView.init()
        self.view.addSubview(square)
        /// 제약조건대로 Mask하여 사이즈를 변환하는 것. Auto layout을 쓸 것이므로 해제한다.
        square.translatesAutoresizingMaskIntoConstraints = false
        square.backgroundColor = .red
        
        let safeArea = self.view.safeAreaLayoutGuide
        var centerXConstraint: NSLayoutConstraint
        centerXConstraint = NSLayoutConstraint(item: safeArea, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: square, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        
        var centerYConstraint: NSLayoutConstraint
        centerYConstraint = NSLayoutConstraint(     item: safeArea,
                                                    attribute: NSLayoutConstraint.Attribute.centerY,
                                                    relatedBy: NSLayoutConstraint.Relation.equal,
                                                    toItem: square,
                                                    attribute: NSLayoutConstraint.Attribute.centerY,
                                                    multiplier: 1,
                                                    constant: 0)
        
        var ratioConstraint: NSLayoutConstraint
        ratioConstraint = NSLayoutConstraint(       item: square,
                                                    attribute: NSLayoutConstraint.Attribute.width,
                                                    relatedBy: NSLayoutConstraint.Relation.equal,
                                                    toItem: square,
                                                    attribute: NSLayoutConstraint.Attribute.height,
                                                    multiplier: 1,
                                                    constant: 0)
        
        var widthConstraint: NSLayoutConstraint
        widthConstraint = NSLayoutConstraint(       item: square,
                                                    attribute: NSLayoutConstraint.Attribute.width,
                                                    relatedBy: NSLayoutConstraint.Relation.equal,
                                                    toItem: safeArea,
                                                    attribute: NSLayoutConstraint.Attribute.width,
                                                    multiplier: 0.3,
                                                    constant: 0)
        NSLayoutConstraint.activate([centerXConstraint,
                                    centerYConstraint,
                                    ratioConstraint,
                                    widthConstraint])
        
        NSLayoutConstraint.deactivate([centerXConstraint,
                                       centerYConstraint,
                                       ratioConstraint,
                                       widthConstraint])
        square.removeConstraints([centerXConstraint,
                                  centerYConstraint,
                                  ratioConstraint,
                                  widthConstraint])
        /// 방법2 Anchor를 사용하여 NSLayoutConstraint 객체 생성
        /// 방법2는 용이하나, 제한적인 기능
        centerXConstraint = square.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor)
        centerYConstraint = square.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor)
        ratioConstraint = square.heightAnchor.constraint(equalTo: square.widthAnchor)
        widthConstraint = square.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.3)
    }
    
    
}

