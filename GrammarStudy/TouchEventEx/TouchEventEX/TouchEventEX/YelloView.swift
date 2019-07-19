//
//  YelloView.swift
//  TouchEventEX
//
//  Created by hw on 16/07/2019.
//  Copyright © 2019 hwj. All rights reserved.
//

import UIKit

class YelloView: UIView {

        @IBAction func unnamed(_ sender: AnyObject){
            print("yellow pressed")
        }
//
    /// hitTest 검사를 통해서 터치를 인식할 UIView객체를 리턴한다.
    /// hitTest override 시에 뷰의 frontmost view들의 터치인식이 안 될 수 있다.
//    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        return self
//    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        backgroundColor = UIColor.red
        
        for touch in touches {
            touch.altitudeAngle // apple pencil의 입력 각도
            touch.force         // 터치의 강도 (z-axis 256단계 이상으로 분류)
            touch.location(in: self)    // view를 넘겨야 계산을 해준다. 전달받은 view를 기준으로 상대좌표를 계산해서 반환해준다.
            touch.previousLocation(in: self)
            touch.tapCount      // 짧은 순간의 여러번 터치에 대해 카운트
            touch.type          // 직접터치, 혹은 리모컨을 통한 간접 터치(애플티비) 등
            touch.preciseLocation(in: self) /// 손가락 터치의 정교한 입력을 반환. 힘의 중점
        }
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        backgroundColor = UIColor.blue
        super.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        backgroundColor = UIColor.yellow
        super.touchesEnded(touches, with: event)
    }

}
