//
//  ViewController.swift
//  NetworkAsyncEx
//
//  Created by hw on 19/08/2019.
//  Copyright © 2019 hwj. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUIImageView()
        setButtons()
    }
    
    private func setUIImageView(){
        let frame = CGRect(x: 50, y: 50, width: 200, height: 200)
        let imageView = UIImageView.init(frame: frame)
        view.addSubview(imageView)
        self.imageView = imageView
    }
    
    private func setButtons(){
        let resetButton = UIButton(type: .system)
        resetButton.frame = CGRect.init(x: 250, y: 250, width: 40, height: 44)
        resetButton.setTitle("Clear", for: .normal)
        resetButton.addTarget(self, action: #selector(clearImage(_:))
            , for: .touchUpInside)
        let loadButton = UIButton(type: .system)
        loadButton.frame = CGRect.init(x: 30, y: 250, width: 40, height: 44)
        loadButton.setTitle("Load", for: .normal)
        loadButton.addTarget(self, action: #selector(loadImage(_:))
            , for: .touchUpInside)
        view.addSubview(loadButton)
        view.addSubview(resetButton)
    }
    
    private func receiveImageData(){
        guard let dataURL = URL(string: "https://upload.wikimedia.org/wikipedia/commons/3/3d/LARGE_elevation.jpg")  else{
            return
        }
        let request = URLRequest(url: dataURL)  /// dataset, cache policy 정책등 설정 가능하다.
        ///URLSession을 통한 request 요청은 background 스레드에서 기본적으로 동작한다.
        let session = URLSession.shared.dataTask(with: request){ (data, response, error) in
            if let error = error { print(error.localizedDescription); return}
            guard let data = data else {
                print("image load failed")
                return
            }
            
            ///UI update는 DispatchQueue.main에서 async로 작업해줘야 한다.
            DispatchQueue.main.sync {
                self.imageView.image = UIImage(data: data)
            }
            ///DQ 말고 OperationQueue도 가능
            //            OperationQueue.main.addOperation {  ///addOperation은 기본적으로 비동기로 동작
            //                self.imageView.image = UIImage(data: data)
            //            }
            
            }
        session.resume()
    }
    
    @objc func clearImage(_ sender: UIButton){
        self.imageView.image = nil
    }
    
    @objc func loadImage(_ sender: UIButton){
        guard let requestUrl = URL(string: "https://randomuser.me/api/?inc=gender,name,nat&results=5") else {
            return
        }
        ///Ex3 - Json Request
        let task = URLSession.shared.dataTask(with: requestUrl){ (data, response, error) in
            guard let data = data else{
                print("load data failed")
                return
            }
            let decoder: JSONDecoder = JSONDecoder()
            do{
                let userResponse = try decoder.decode(RandomUserResponse.self, from: data)
                let users = userResponse.results
                print("\(users.count) 명의 user 로드됨")
                print("\(userResponse.info)")
            }catch{
                print(error.localizedDescription)
            }
            }
        task.resume()
    }
    
    @objc func loadImage2(_ sender: UIButton){
         ///Ex2
        guard let dataURL = URL(string: "https://upload.wikimedia.org/wikipedia/commons/3/3d/LARGE_elevation.jpg")  else{
            return
        }
        let request = URLRequest(url: dataURL)  /// dataset, cache policy 정책등 설정 가능하다.
        ///URLSession을 통한 request 요청은 background 스레드에서 기본적으로 동작한다.
        let session = URLSession.shared.dataTask(with: request){ (data, response, error) in
            if let error = error { print(error.localizedDescription); return}
            guard let data = data else {
                print("image load failed")
                return
            }
            ///UI update는 DispatchQueue.main에서 async로 작업해줘야 한다.
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: data)
            }
            ///DQ 말고 OperationQueue도 가능
            OperationQueue.main.addOperation {  ///addOperation은 기본적으로 비동기로 동작
                self.imageView.image = UIImage(data: data)
            }
        }
        session.resume()
    }
    
    @objc func loadImage3(_ sendeR: UIButton){
        
        /// Ex1
        DispatchQueue.global(qos: .userInitiated).async {
            guard let dataURL = URL(string: "https://upload.wikimedia.org/wikipedia/commons/3/3d/LARGE_elevation.jpg")  else{
                return
            }
            // DispatchQueue.global(qos: .default).async {
            do {
                let data = try Data(contentsOf: dataURL)
                let image = UIImage(data: data)
                //self.imageView.image = image
                    // Main Thread Checker: UI API called on a background thread: -[UIImageView setImage:]
                DispatchQueue.main.sync {  /// why main.sync not use?
                    self.imageView.image = image
                }
            }catch{
                print(error.localizedDescription)
            }
            //}
        }
        
    }
    
    
}

