# Memory cache

캐시 : 메모리에서 CPU에 빈번히 로드될 데이터를 담는 임시 저장 장치. CPU 내부에 존재하는 메모리. 

- 폰 노이만 구조에서 CPU - memory 는 일방향  으로, CPU에서 메모리로 연산결과를 보내는 동안에 메모리로부터 CPU로 데이터를 보낼 수 없다. 이 때, RAM의 데이터를 CPU 레지스터가 아닌, 캐시 메모리에 데이터를 적재하는 방식으로 속도를 높일 수 있다.
  - (일반적인 RAM에서 CPU로 데이터를 로드하는 것이 CPU에서 RAM으로 연산결과를 보내는 것과 동시에 진행될 수는 없다.)



## Practice Example

- 기존의 iOS_Network에서 작업한 내용을 기반으로 코드를 추가한다. 

#### 1) 메모리 차원에서 관리하는 경우…ex) 딕셔너리를 사용

```swift
var cachedImage: [String: UIImage] = [:]  /// 딕셔너리 사용
@objc func loadImage1(_ sender: UIButton){
		let urlString = "https://upload.wikimedia.org/wikipedia/commons/3/3d/LARGE_elevation.jpg"
        if let image = cachedImage[urlString] {	/// 딕셔너리에 지정한 캐시가 존재하면 그것을 사용
            self.imageView.image = image
            return
        }
        guard let dataURL = URL(string: urlString)  else{ return }
        let request = URLRequest(url: dataURL)  
        let session = URLSession.shared.dataTask(with: request){ (data, response, error) in
            if let error = error { print(error.localizedDescription); return}
            guard let data = data else {
                print("image load failed")
                return
            }
            
            let uiImage = UIImage(data: data)!
            DispatchQueue.main.async {
                self.imageView.image = uiImage
                OperationQueue().addOperation {/// 딕셔너리에 저장
                 		self.cachedImage.updateValue(uiImage, forKey: urlString) 
                }
            }
        }
        session.resume()
}
```

- 단점 : 딕셔너리에는 저장할 수 있는 데이터의 한계가 존재한다. 



#### 2) 메모리 캐시

- NSCache를 사용한다.

  ```swift
  var cacheImage: NSCache<NSString, UIImage> = NSCache()
   @objc func loadImage2(_ sender: UIButton){
          /// 캐시를 사용하는 경우
          let urlString = "https://upload.wikimedia.org/wikipedia/commons/3/3d/LARGE_elevation.jpg"
     			/// 메모리 캐시에 저장되어있는지 확인
          if let image = cacheImage.object(forKey: urlString as! NSString) as? UIImage{
              self.imageView.image = image
              return
          }
  			  /// 네트워크 통신
          guard let dataURL = URL.init(string: urlString) else { return }
          let request = URLRequest(url: dataURL)
          URLSession.shared.dataTask(with: request){ (data, response, error) in
              if let error = error { print( error.localizedDescription); return }
              guard let data = data else { print("image load failed"); return }
                                                    
              OperationQueue.main.addOperation {
                  guard let image = UIImage(data: data) else { return }
                  self.imageView.image = image
                  OperationQueue().addOperation { 
                   	  ///main thread가 아닌 스레드에서 캐싱작업을 담당하도록 한다.
                      ///memory caching
                      self.cacheImage.setObject(image, forKey: urlString as NSString)
                  }
              }
          }
   }
  ```

- 주의사항 : key 값으로 class 만 들어올 수 있다. String은 NSString으로 변환시켜야 한다.

- 단점 : 앱이 종료되면 캐시정보가 사라진다.

- 장점 : 매우 빠르게 이미지 정보를 가져올 수 있다.

  

#### 3) 디스크 캐시 

- iOS는 앱의 내부 디렉토리 구조에서 캐시한 파일을 위한 별도의 폴더가 존재한다. 여기에 파일로 저장한 디스크 캐시 내용이 저장된다.

```swift
/// Disk cache ex
guard let cacheURL = try FileManager.default.url(for: .cachesDirectory,
                                           in: .userDomainMask,
                                           appropriateFor: nil,
                                           create: true) else { return }
```

```swift
@objc func loadImageFromMemAndDiskCache(_ sender: UIButton){
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
      
  /// 파일디렉토리 (캐시 디렉토리)에서 가져오는 경우
  DispatchQueue.global(qos: .default).async {
      /// 캐시 디렉토리 URL 주소 찾기
      let documentURL = FileManager.default.urls(for: .cachesDirectory,
                                                 in: .userDomainMask)[0]
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
  /// 네트워크에서 HTTP 통신으로 가져옴
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
            	let cacheDirectory = try FileManager.default.url(for: .cachesDirectory, 
                                                             in: .userDomainMask, 
                                                             appropriateFor: nil, 
                                                             create: true)
            	let filePath = cacheDirectory.appendingPathComponent(fileName)
            	try data.write(to: filePath)
          }catch{
           	 print(error.localizedDescription)
          }
      }
    }
}
```

```결과
file:///Users/hw/Library/Developer/CoreSimulator/Devices/6F4557DC-4F75-4BBE-9F04-DCFC297EDAA1/data/Containers/Data/Application/077B23F8-F554-46D9-8DFC-89B6444DA0B8/Library/Caches/
디스크 캐시에서 디렉토리에서 가져옴
메모리 캐시에서 이미지 가져옴
```

- 파일 매니저를 통해서 디스크에 캐시정보를 저장할 수 있다.
- 장점 : 앱이 종료가 되어도 캐시정보를 복원할 수 있다.
- 단점 : 메모리 캐시에서 가져오는 것보다는 로딩 속도가 느리다. (file I/O 작업을 거치므로)

