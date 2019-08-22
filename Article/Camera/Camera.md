# Camera









## AVFoundation

- 오디오/비디오 관련 도구 ( `audiovisual media`)를 다루는데 쓰는 프레임워크
- capturing / processing /synthesizing / controlling/ importing/ exporting / playback control
- 1) Playback and Editing (재생과 편집)

- 2) Media Capture 
  - 영상 / 오디오 관련 캡처링 (카메라 / 마이크)
- 3) Audio
  - sound engineering 가능
- 4) Speech
  - 음성 합성 기능 (Text To Speech 등)



[참고-Summary of AVFoundation Intro guide](https://medium.com/@cafielo/summary-of-avfoundation-intro-guide-ec7cd1aa74e8)



### Media Capture

- 사용자 UX를 고려한 카메라 UI 만들기
- UIImagePickerController 
  - 시스템에서 제공하는 `사진을 찍는 기능을 제공하는 컨트롤러`



### AVCaptureDeviceInput

- AVCaptureSession과 연결된 카메라, 마이크 등의 오디오를 제공해주는 소스
- Input을 담당

- AVCaptureDevice 를 이용함



### AVCaptureSession

- Media Capture의 핵심
- 카메라로부터 들어오는 데이터를 처리하는 클래스
- processing 역할



### AVCaptureOutput

- AVCaptureSession으로 만들어지는 미디어 캡처의 결과물을 다룸
- output 담당



AVCaptureDevice/**AVCaptureDeciveInput**	--> > **AVCaptureSession** 	-->> 	AVCaptureOutput









## Permission

- App이 Device 내 Hardware 접근 시 필요한 접근 권한
- Info.plist에서 Camera, mic usage description을 세팅한다.



### Ex) 사진 찍기 전 카메라 접근을 위한 Permission 요청 작업

- 

  ```swift
  switch AVCaptureDevice.authorizationStatus(for: .video){
    	case .authorize:	// user has previously granted access to the camera
    		self.setupCaptureSession()
    
    	case .notDetermined: // user has not yet been asked for camera access
    			AVCaptureDevice.requestAccess(for: .video) { granted in 
  						if granted{
         	     		self.setupCaptureSession()
            	}                                      
  				}
    
    	case .denied: // user has previously denied access
    			return
    	case .restricted:	//user can't grant access due to restrictions
    			return
  }
  ```



###  Ex) 사진저장 전 라이브러리 접근을 위한 Permission 요청 작업 

- 사진 저장 전에도 **Photo Library Permission 요청**되어야 한다. 

  ```swift
  PHPhotoLibrary.requestAuthorization { status in
  		guard status == .authorized else { return }
  		// Use PHPhotoLibrary.shared().performChanges(...) to add assets
  }
  ```



### Ex) 사진 저장하기

- 사진을 찍고, 사진 데이터를 **PHPhotoLibrary를 사용하여 사진을 저장**할 수 있다.

```swift
func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?){
  guard error == nil else { print("Error capturing photo: \(error)"); return }
  
  PHPhotoLibrary.requestAuthorization { status in
		guard status == .authorized else { return }
		
		PHPhotoLibrary.shared().performChanges({
      	//Add the captured photo's file data as the main resource for the Photo asset
      	let creationRequest = PHAssetCreationRequest.forAsset()
      	creationRequest.addResource(with: .photo, data: photo.fileDataRepresentation()!, options: nil)} , completionHandler: self.handlePhotoLibraryError)
	}
}
```

