//
//  CameraViewController.swift
//  SimpleFullScreenCameraApp
//
//  Created by hw on 08/08/2019.
//  Copyright © 2019 hwj. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController {
    // TODO: 초기설정 1
    // - captureSession
    // - AVCaptureDeviceInput
    // - AVCapturePhotoOutput
    
    @IBOutlet weak var photoLibraryButton: UIButton!
    @IBOutlet weak var previewView: PreviewView!
    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var blurBGView: UIVisualEffectView!
    @IBOutlet weak var switchButton: UIButton!
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func setupUI(){
        
    }
    
    @IBAction func switchCamera(sender: Any){
        //TODO: camera 는 1개 이상
        
        //TODO: 반대 카메라 찾아서 재설정
    }

}
