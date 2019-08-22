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
    
    var cacheImage: NSCache<NSString, UIImage> = NSCache() /// NSCache의 Key는 class 여야 한다.
    var cachedImage: [String: UIImage] = [:]    /// 메모리에 그냥 저장하는 경우
   
    
    @objc func loadImageFromCache(_ sender: UIButton){
        /// 캐시를 사용하는 경우
        let urlString = "https://upload.wikimedia.org/wikipedia/commons/3/3d/LARGE_elevation.jpg"
        guard let dataURL = URL.init(string: urlString) else { return }
        let filePath = dataURL.pathComponents.last!
        if let memCachedImage = cacheImage.object(forKey: filePath as! NSString){
            DispatchQueue.main.async {
                print("메모리 캐시에서 이미지 가져옴")
                self.imageView.image = memCachedImage
            }
            return
        }
        ///파일 캐시
        DispatchQueue.global(qos: .default).async {
            let documentURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).forEach { print($0) }
            
            let fileURL = documentURL.appendingPathComponent(filePath)
            do {
                let data = try Data.init(contentsOf: fileURL)
                DispatchQueue.main.async {
                    print("디스크 캐시 디렉토리에서 가져옴")
                    let diskCahedImage = UIImage(data: data)!
                    self.imageView.image = diskCahedImage
                    self.cacheImage.setObject(diskCahedImage, forKey: filePath as NSString)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        ///네트워크
        let request = URLRequest(url: dataURL)
        URLSession.shared.dataTask(with: request){ (data, response, error) in
            if let error = error {
                print( error.localizedDescription)
                return
            }
            guard let data = data else {
                print("image load failed")
                return
            }
            
            OperationQueue.main.addOperation {
                guard let image = UIImage(data: data) else { return }
                print("네트워크에서 가져옴")
                self.imageView.image = image
                
                OperationQueue().addOperation { ///main thread가 아닌 스레드에서 캐싱작업을 담당하도록 한다.
                    guard let fileName = dataURL.pathComponents.last else { return }
                    ///caching
                    print("메모리 캐시에 이미지 저장")
                    self.cacheImage.setObject(image, forKey: fileName as NSString)
                    ///file cache
                    do {
                        print("디스크 캐시에 이미지 저장")
                        let cacheDirectory = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                        let filePath = cacheDirectory.appendingPathComponent(fileName)
                        try data.write(to: filePath)
                    }catch{
                        print(error.localizedDescription)
                    }
                }
                
            }
        }
    }
    @objc func loadImage(_ sender: UIButton){
        /// 캐시를 사용하는 경우
        let urlString = "https://upload.wikimedia.org/wikipedia/commons/3/3d/LARGE_elevation.jpg"
        guard let dataURL = URL.init(string: urlString) else { return }
        let filePath = dataURL.pathComponents.last!
        
        
        /// 캐시를 사용하는 경우
        //        if let image = cacheImage.object(forKey: urlString as! NSString){
        //            self.imageView.image = image
        //            return
        //        }
        //        let caches = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0])
        //        let fullPath =  String(format:"%@/\(filePath)",caches)
        //        if let imageData = FileManager.default.contents(atPath: fullPath) {
        //            self.imageView.image = UIImage(data: imageData)
        //            return
        //        }

        let request = URLRequest(url: dataURL)
        URLSession.shared.dataTask(with: request){ (data, response, error) in
            if let error = error {
                print( error.localizedDescription)
                return
            }
            guard let data = data else {
                print("image load failed")
                return
            }
            
            OperationQueue.main.addOperation {
                guard let image = UIImage(data: data) else { return }
                print("네트워크에서 가져옴")
                self.imageView.image = image

                OperationQueue().addOperation { ///main thread가 아닌 스레드에서 캐싱작업을 담당하도록 한다.
                    guard let fileName = dataURL.pathComponents.last else { return }
                    ///caching
                    print("메모리 캐시에 이미지 저장")
                    self.cacheImage.setObject(image, forKey: fileName as NSString)
                    ///file cache
                    do {
                        print("디스크 캐시에 이미지 저장")
                        let cacheDirectory = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                        let filePath = cacheDirectory.appendingPathComponent(fileName)
                        try data.write(to: filePath)
                    }catch{
                        print(error.localizedDescription)
                    }
                }

            }
        }
        /// 메모리 차원에서 관리하는 경우... ex. 딕셔너리
//        let urlString = "https://upload.wikimedia.org/wikipedia/commons/3/3d/LARGE_elevation.jpg"
//        if let image = cachedImage[urlString] {
//            self.imageView.image = image
//            return
//        }
//        guard let dataURL = URL(string: urlString)  else{
//            return
//        }
//        let request = URLRequest(url: dataURL)  /// dataset, cache policy 정책등 설정 가능하다.
//        ///URLSession을 통한 request 요청은 background 스레드에서 기본적으로 동작한다.
//        let session = URLSession.shared.dataTask(with: request){ (data, response, error) in
//            if let error = error { print(error.localizedDescription); return}
//            guard let data = data else {
//                print("image load failed")
//                return
//            }
//            ///UI update는 DispatchQueue.main에서 async로 작업해줘야 한다.
//            let uiImage = UIImage(data: data)!
//            DispatchQueue.main.async {
//                self.imageView.image = uiImage
//                OperationQueue().addOperation {
//                    self.cachedImage[urlString] = uiImage
//                }
//            }
//            ///DQ 말고 OperationQueue도 가능
//            OperationQueue.main.addOperation {  ///addOperation은 기본적으로 비동기로 동작
//                self.imageView.image = uiImage
//                OperationQueue().addOperation {
//                    self.cachedImage.updateValue(uiImage, forKey: urlString)
//                }
//            }
//        }
//        session.resume()
//
//        /// Disk cache ex
//        let cacheURL = try? FileManager.default.url(for: .cachesDirectory,
//                                                in: .userDomainMask,
//                                                appropriateFor: nil,
//                                                create: true)
        /*
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
         */
    }
    
    @objc func loadImage2(_ sender: UIButton){
        let urlString = "https://upload.wikimedia.org/wikipedia/commons/3/3d/LARGE_elevation.jpg"
        guard let dataURL = URL.init(string: urlString) else { return }
         ///Ex2
        let request = URLRequest(url: dataURL)  /// dataset, cache policy 정책등 설정 가능하다.
        ///URLSession을 통한 request 요청은 background 스레드에서 기본적으로 동작한다.
        let session = URLSession.shared.dataTask(with: request){ (data, response, error) in
            if let error = error { print(error.localizedDescription); return}
            guard let data = data else {
                print("image load failed")
                return
            }
            ///UI update는 DispatchQueue.main에서 async로 작업해줘야 한다.
//            DispatchQueue.main.async {
//                self.imageView.image = UIImage(data: data)
//            }
            ///DQ 말고 OperationQueue도 가능
            let image = UIImage(data: data)!
            OperationQueue.main.addOperation {  ///addOperation은 기본적으로 비동기로 동작
                self.imageView.image = image
                OperationQueue().addOperation {
                    ///caching
//                    self.cacheImage.setObject(image, forKey: urlString as NSString)
                    ///file cache
                    do {
                        guard let fileName = dataURL.pathComponents.last else { return }
                        print(fileName)

                        let cacheDirectory = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                        let filePath = cacheDirectory.appendingPathComponent(fileName)
                        try data.write(to: filePath)
                    }catch{
                        print(error.localizedDescription)
                    }
                }
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

