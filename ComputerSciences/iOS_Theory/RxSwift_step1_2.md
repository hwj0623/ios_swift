# RxSwift 



https://www.youtube.com/watch?v=w5Qmie-GbiA



### Observable



### Stream

- 줄을 세워서 순서대로 (중간 중간 operator를 거쳐나가는) 내려가는 형태를 의미

- 기본적으로 <u>subscribe를 제외한</u> 다른 `operator의 return type`은 **stream** 형태이다. 
  - 따라서, chaining으로 함수를 이어나갈 수 있음



## 주요 연산자

#### just

- 어떠한 객체를 생성 가능
- 해당 내용을 스트림의 아래로 전달 가능.

#### from

- 배열을 파라미터로 전달받음
- 배열 요소를 순차적으로 stream을 통해 처리

#### map

- 앞선 스트림의 내용을 전달받아서 각각의 데이터에 대해 처리 가능

#### filter

- 조건에 따라 `true` 면 다음 스트림으로 진행, `false` 면 현재 상태에서 종료



#### disposed(by: disposeBag)



### subscribe

- 다양한 Observable operator 이후에 처리된 데이터를 다루고자 하는 메서드
- 리턴 타입이 disposable이다. 
  
- disposed 로 체이닝 가능.
  
- subscribe() // 결과에 대해서는 신경쓰지 않음. 리턴값 없음

- subscribe(on : (Event`<String>`) -> Void )

  - event 타입은 3가지 존재 (성공시 `.next`, 실패시 `.error`, 완료/종료에 ` .completed` )

  - ```swift
    Observable.just("Hello World")
    	.subscribe { event in 
        	switch event {
            case .next(let str):
            	break
            case .error(let err):
            	break
            case .completed:
            	break
          }             
      }
      .disposed(by: disoposeBag)
    ```

  - 예제

    ```swift
    Observable.from([ "RxSwift", "In", 4, "Hours"])
    	.subscribe { event in 
        	switch event {
            case .next(let str):
            	print("next: \(str)")
            	break
            case .error(let err):
           	  print(" error: \(err.localizedDescription)")
            	break
            case .completed:
              print("completed")
            	break
          }             
      }
    	.disposed(by: disoposeBag)
    
    /* 결과
    next: RxSwift
    next: In
    next: 4
    next: Hours
    complted
    */
    ```

  - sinlge 적용 예

    ``` swift
    Observable.from([ "RxSwift", "In", 4, "Hours"])
      .single()
    	.subscribe { event in 
       //.. 동일 code
    //결과
    // next: RxSwift
    // 에러 발생 (error: The operation couldn't be completed)
    ```

  - subscribe(onNext: ( (Any) -> Void )?, onError ((Error) -> Void )?, onCompleted: (()->Void?), onDisposed: (()-> Void?)  사용 예

    ```swift
    Observable.from([ "RxSwift", "In", 4, "Hours"])
      .single() 
    	.subscribe { onNext: {s in 
    		print(s)
    	}, onError: { err in 
        print(err.localizedDescription)
      }, onCompleted: {
        print("completed")
      }, onDisposed: {
        print("disposed")
      })
      .disposed(by: disposeBag)
    }
    //결과 
    RxSwift
    (error: The operation couldn't be completed)
    disposed
     
    //sinlge() 제거시
    RxSwift
    In
    4
    Hours
    completed
    disposed
    ```

  - onNext에 들어갈 클로저는 별도  func로 정의할 수 있음

    ```swift
    func output(_ s: Any) -> Void {print(s)}
    //Observable에서
    .subscribe(onNext: output)
    ```

    



thread  분리가 안된 예

- 메인 스레드에서 스트림이 전부 실행 처리되는 상황

  ```swift
   @IBAction func exMap3() {
     Observable.just("800x600")
     .map { $0.replacingOccurrences(of: "x", with: "/") }
     .map { "https://picsum.photos/\($0)/?random" }
     .map { URL(string: $0) }
     .filter { $0 != nil }
     .map { $0! }
     .map { try Data(contentsOf: $0) }
     .map { UIImage(data: $0) }
     .subscribe(onNext: { image in
                         self.imageView.image = image
                        })
     .disposed(by: disposeBag)
   }
  ```

- observeOn(scheduler: 스케줄러 인스턴스) 메서드를 활용

  ```swift
  @IBAction func exMap3() {
     Observable.just("800x600")
     .observeOn(ConcurrentDispatchQueueScheduler(qos: .default)) //동기화 지원되는 스케쥴러에 아래의 스트림 작업들을 넣는다. 
     .map { $0.replacingOccurrences(of: "x", with: "/") }
     .map { "https://picsum.photos/\($0)/?random" }
     .map { URL(string: $0) }
     .filter { $0 != nil }
     .map { $0! }
     //Data 가져오는 부분이 latency가 존재하므로 여기에 DispatchQueue가 있어도 된다.
     .map { try Data(contentsOf: $0) }
     .map { UIImage(data: $0) }
     .observeOn(MainScheduler.instance)	//UI 담당하는 메인스레드에 아래의 스트림 작업을 추가한다. 
     .subscribe(onNext: { image in
                         self.imageView.image = image
                        })
     .disposed(by: disposeBag)
   }
  ```



- subscribeOn(scheduler: _ ) 사용 예

  - 만약  스트림의 맨 처음부터 영향을 미치게 하고 싶다면 observeOn  대신 subscribeOn을 사용한다.
  - 위치에 상관없이 subscribe 전의 모든 스트림에 대해 subscribeOn 의 스케줄러로 작동시킨다.

  ```swift
  @IBAction func exMap3() {
          Observable.just("800x600")
  //            .observeOn(ConcurrentDispatchQueueScheduler(qos: .default))
              .map { $0.replacingOccurrences(of: "x", with: "/") }
              .map { "https://picsum.photos/\($0)/?random" }
              .map { URL(string: $0) }
              .filter { $0 != nil }
              .map { $0! }
              .map { try Data(contentsOf: $0) }
              .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default)) // 위치가 여기든
              .map { UIImage(data: $0) }
              .observeOn(MainScheduler.instance)
    					.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default)) // 위치가 여기든 상관없이 .subscribe 나오는 순 맨 위에서부터 ConcurrentDispatchQueueScheduler를 사용한다.
              .subscribe(onNext: { image in
                  self.imageView.image = image
              })
              .disposed(by: disposeBag)
      }
  ```

  

- #### Side Effect (취약점)

  - 스트림 중 외부에 영향을 주는 부분에서 side effect 발생 우려가 있다.
  - `subscribe` 또는 `do` 연산자



### RxCocoa

- Podfile에 pod 'RxCocoa' 로 설치

- view 등을 다룰 때 좋은 extension이 있으니 각자 알아볼 것