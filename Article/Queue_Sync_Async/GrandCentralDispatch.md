#  GCD

- Apple document 참고

  > GCD 는애플리케이션이 블록 오브젝트의 형태로 task들을 제출하는 FIFO 큐들을 제공한다.
  >
  > 디스패치 큐들에 제출된 작업들은 시스템에서 전적으로 관리되는 스레드풀에 의해 실행된다.
  >
  > 어떤 스레드가 어떤 작업을 수행할지에 대해 전적으로 보장되지는 않는다.

  https://developer.apple.com/documentation/DISPATCH

- Wiki 

  - Grand Central Dispatch는 멀티 코어 프로세서 및 기타 대칭 다중 처리 시스템이있는 시스템에 대한 응용 프로그램 지원을 최적화하기 위해 Apple Inc.에서 개발 한 기술. 

- 스레드 풀 패턴을 기반으로하는 작업 병렬 처리의 구현



### 1. Queue

- GCD는 세가지 타입의 큐를 제공한다.

  #### 1) The Main Queue

  - 세가지 큐 중 가장 높은 스레드할당 우선순위를 지닌다.

  - 모든 UI 작업은 메인 큐에서 수행된다.

    ```swift
    // MainQueue
    DispatchQueue.main.async {
      // Do Any UI Update Here
    }
    ```

    

  #### 2) The Global Queue

  - 크게 다섯가지 타입으로 나뉜다. 타입에 따라 우선순위가 나뉜다.

  - 타입은 QoS (Quality of Service) 에 따라 나뉜다.

  - 우선순위가 높은 순서대로 나열하면 다음과 같다

    - 1) userInteractive
      - 바로 수행되어야 하는 작업
    - 2) userInitiated
      - 수 초 내에 이뤄져야 하는 작업
    - 3) default
      - 잘 쓰지는 않음
    - 4) utility
      - 수 초 ~ 수분 내에 이뤄져야 하는 작업 (30초 ~ 3분)
      - 나름 무거운 작업 수행에 필요
    - 5) background
      - 수 분 ~ 수 시간 소요될 작업 
      - ex: 큰 계산, 큰 파일 다운로드 등

    ```swift
    /// Global Queue
    DispatchQueue.global(qos: .background).async{
      	/// Do Heavy Work Here
    }
    ```

    

  #### 3) Custom Queue

  - 위 두개의 큐는 시스템에서 관리하는 것

  - GCD에서 사용할 dispatchQueue를 직접 설정하여 사용하는 것

  - Custom Queue의 이름 (label)을 지정한다.

  - Quality of Service를 지정해야 함

  - 동기화가 보장되어야 하는 concurrent를 attribute로 설정할 수 있음. 설정하지 않는 기본은 SerialQueue가 된다.

    ```swift
    /// Custom Queue
    let concurrentQueue = DispatchQueue(label: "concurrent", qos: .background, attributes: .concurrent)
    let serialQueue = DispatchQueue(label: "serial", qos: .background)
    ```

  

  ### 두 개의 Queue 복합적으로 사용하기

  ```swift
  DispatchQueue.global(qos: .background).async {
    	let image = downloadImageFromServer()	/// 이미지 다운로드는 global & background 큐에 할당
    	DispatchQueue.main.async{	
        	self.imageView.image = image			/// 다운받은 이미지를 화면에 보여주는 작업은 main 큐에 할당
      }
  }
  ```

  

### 2. Sync / Async



#### Async Example

```swift
DispatchQueue.global(qos: .background).async{
  	for i in 0...5{
      	print("devil \(i)")
    }
}

DispatchQueue.global(qos: .userInteractive).async{
  	for i in 0...5{
      	print("sad \(i)")
    }
}

//결과 : devil이 다 출력되기 전에 우선순위가 높은 sad가 중간에 다 처리된다.
```



#### Sync Example

```swift
DispatchQueue.global(qos: .background).sync{	/// sync로 변경
  	for i in 0...5{
      	print("devil \(i)")
    }
}

DispatchQueue.global(qos: .userInteractive).async{
  	for i in 0...5{
      	print("sad \(i)")
    }
}

//결과 : devil이 무조건 먼저 다 실행되고 나서 userInteracitve qos의 작업이 수행된다.
```

