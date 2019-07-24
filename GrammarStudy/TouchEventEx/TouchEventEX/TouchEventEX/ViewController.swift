//
//  ViewController.swift
//  TouchEventEX
//
//  Created by hw on 16/07/2019.
//  Copyright © 2019 hwj. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var nameText: UITextView!
    @IBAction func unnamed(_ sender: AnyObject){
        print("vc pressed")
        
//        nameText.resignFirstResponder() ///텍스트 필드를 firstResponder에서 해제한다.
//        nameText.becomeFirstResponder() ///텍스트 필드를 firstResponder로 만든다.
        
        /// 다음 responder에게 전달하는 방법 중 하나
        /// 모든 객체들이 특정 메서드를 호출할 수 있도록 하는 메서드
        /// with의 sender를 unnamed의 단일 파라미터로 넘긴다.
        ///next?.perform(#selector(unnamed(_:)), with: sender)
        let otherViewController = UIStoryboard.init(name: "SecondScene", bundle: nil).instantiateViewController(withIdentifier: "SecondScene")
        self.present(otherViewController, animated: true, completion: nil)
//        var aViewController = UIViewController.init(nibName: "BlueView", bundle: nil)
//        self.view.addSubview(aViewController.view)
    }
    
    @IBAction func inputTextView(_ sender: Any?){
        nameText.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
  
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /// 자주 쓰는 터치 이벤트 패턴을 정리한 클래스가 존재한다.
        /// UIGestureRecognizer
        /// 제스처레코그나이저 생성시에는 제스처 인식할 대상(타겟)과 이벤트 발생시 실행할 메서드를 전달해야 한다.
        let rec = UILongPressGestureRecognizer.init(target: self, action: #selector(ViewController.longPressed(rec:)))
        rec.minimumPressDuration = 1         //초 단위
        self.view.addGestureRecognizer(rec)
        super.touchesBegan(touches, with: event)
    }

    @objc func longPressed(rec: UILongPressGestureRecognizer ){
        /// 레코그나이저는 기본적으로 상태(began/moved/ended)를 다 갖고 있다.
        /// 대신 갖고와서 처리해준다.
        let state = rec.state
        if state == .ended{
            self.view.backgroundColor = UIColor.gray
        }else{
            self.view.backgroundColor = UIColor.white
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
    }
}

