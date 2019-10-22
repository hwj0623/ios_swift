# RxSwift (step3)

- 다음의 기능을 RxSwift 를 활용하여 구현해보자.

  ```swift
      // MARK: - Bind UI
      // 사용자 입력 x - 빨간 불 x
      // 사용자 입력 시작
      // 이메일 -> 빨간 불 on // 형식이 맞으면 빨간 불 off
      // 비번 -> ""
      // 둘다 valid면 login 활성화
      // 둘 중 하나라도 invalid라면 login 비활성화
  ```



#### STEP 1

- 먼저 bindUI 메소드의 첫 기능으로 email ID 텍스트 필드에 대해 rx 적용.

  - idField.rx : idField 가 취급하는 데이터를 비동기로 받겠다는 의미이다. 

  ```swift
  private func bindUI() {
    // id input +--> check valid --> bullet
    //          |
    //          +--> button enable
    //          |
    // pw input +--> check valid --> bullet
    //RxCocoa - idField.rx : idField 가 취급하는 데이터를 비동기로 받음
    idField.rx.text
    .subscribe(onNext : {s in
                         print(s)
                        })
    .disposed(by: disposeBag)
  }
  ```

- 코드 입력 후 run 하면 다음과 같이 터미널에 출력

  ```swift
  Optional("a")
  Optional("as")
  Optional("asd")
  Optional("asdd")
  Optional("asddf")
  Optional("asddfg")
  ```



#### STEP 2 : text 옵셔널 언래핑 후, email 유효성 검사

- RxCocoa 사용시 UIComponenet를 Reactive 타입으로 전환하는 `.rx` 를 사용가능하다.
  
- RxCocoa는 RxSwift를 이용하여 UI 컴포넌트 조작을 위한 확장 모듈이라고 보면 된다.
  
- ```swift
  private func bindUI() {
    // id input +--> check valid --> bullet
    //          |
    //          +--> button enable
    //          |
    // pw input +--> check valid --> bullet
    //RxCocoa - idField.rx : idField 가 취급하는 데이터를 비동기로 받음
    idField.rx.text
    .filter { $0 != nil } //옵셔널 텍스트를 강제 언래핑하기 위함
    .map { $0! }				  //옵셔널 텍스트를 강제 언래핑하기 위함
    .map (checkEmailValid)
    .subscribe(onNext : {s in
                         print(s)
                        })
    .disposed(by: disposeBag)
  }
  // MARK: - Logic
  private func checkEmailValid(_ email: String) -> Bool {
    return email.contains("@") && email.contains(".")
  }
  private func checkPasswordValid(_ password: String) -> Bool {
    return password.count > 5
  }
  ```

- ```swift
  false
  false
  false
  false
  false
  false
  false
  false
  true
  true
  true
  ```

- optional unwrapping 과정 대신에 text`.orEmpty` 를 통해 언래핑 없이 확정값으로 스트림에 전달할 수 있다.

- ```swift
  private func bindUI() {
    // id input +--> check valid --> bullet
    //          |
    //          +--> button enable
    //          |
    // pw input +--> check valid --> bullet
    //RxCocoa - idField.rx : idField 가 취급하는 데이터를 비동기로 받음
    idField.rx.text.orEmpty
    .map (checkEmailValid)
    .subscribe(onNext : {s in
                         print(s)
                        })
    .disposed(by: disposeBag)
  }
  ```



#### STEP 3

- 유효성 통과시 valid 체크하는 붉은 박스 지우기

  ```swift
  private func bindUI() {
    // id input +--> check valid --> bullet
    //          |
    //          +--> button enable
    //          |
    // pw input +--> check valid --> bullet
  
    //RxCocoa - idField.rx : idField 가 취급하는 데이터를 비동기로 받음
    idField.rx.text
    .filter { $0 != nil }
    .map { $0! }
    .map(checkEmailValid)
    .subscribe(onNext : {b in
                         self.idValidView.isHidden = b
                        })
    .disposed(by: disposeBag)
  }
  ```



#### STEP 4 

- pw 필드 동일하게 적용



#### STEP 5

- 두 개의 필드의 스트림 값을 받아, AND 연산의 결과로 하위 스트림에서 Login 버튼을 활성화 하고자 할 때

  - 즉, 한 쪽의 값이나 두 값이 모두 변경되는 경우, 기존의 상태값과 변경된 값의 상태값을 바탕으로 다른 작업을 수행하려고 할 때.

- combineLatest, merge, zip 등의 Observable 함수로 이와 같은 작업을 수행시킬 수 있다. 각각의 기능은 차이가 존재

  - http://reactivex.io/documentation/operators.html 참고
  - `combineLatest` : **두 개 이상의 Observable 객체의 상태 중 하나라도 변경 시**, 각 **Observable 객체의 최신 상태들을 바탕으로 계산한 결과**를 하위 스트림으로 내려보낸다.
  - `merge` : combine multiple Observables into one by merging their emissions
    - 결과들을 하나로 압축한 계산결과를 내려보내는 것이 아니라 두 개의 Observable의 데이터들을 하나의 Observable 내에 놓겠다는 의미.
  - `zip` : 리스트의 모든 observable 대상이 바뀌어야 resultSelector의 결과를 하위 스트림으로 내려보낸다.

- ```swift
  				//+--> button enable : 두 개의 상태 결과를 합쳐야 함
          //다른 Observable을 결합시켜서 새로운 Observable을 생성한다.
          //CombineLatest : 여러개의 Observable 중 하나라도 값을 배출할 경우, 마지막으로 배출한 값들을 결합시켜서 배출
          Observable.combineLatest(
              idField.rx.text.orEmpty.map(checkEmailValid),
              pwField.rx.text.orEmpty.map(checkPasswordValid),
              resultSelector: {s1, s2 in s1 && s2}
          ).subscribe(onNext: { b in
              self.loginButton.isEnabled = b
          })
          .disposed(by: disposeBag)
  ```



완성 코드

- ```swift
  private func bindUI(){
    //RxCocoa - idField.rx : idField 가 취급하는 데이터를 비동기로 받음
    // id input +--> check valid --> bullet
    idField.rx.text.orEmpty
    //            .filter { $0 != nil }
    //            .map { $0! }
    .map(checkEmailValid)
    .subscribe(onNext : {b in
                         self.idValidView.isHidden = b
                        })
    .disposed(by: disposeBag)
    // pw input +--> check valid --> bullet
    pwField.rx.text.orEmpty
    .map(checkPasswordValid)
    .subscribe(onNext: { pw in
                        self.pwValidView.isHidden = pw
                       })
    .disposed(by: disposeBag)
  
    //+--> button enable : 두 개의 상태 결과를 합쳐야 함
    //다른 Observable을 결합시켜서 새로운 Observable을 생성한다.
    //CombineLatest : 여러개의 Observable 중 하나라도 값을 배출할 경우, 마지막으로 배출한 값들을 결합시켜서 배출
    Observable.combineLatest(
      idField.rx.text.orEmpty.map(checkEmailValid),
      pwField.rx.text.orEmpty.map(checkPasswordValid),
      resultSelector: {s1, s2 in s1 && s2}
    ).subscribe(onNext: { b in
                         self.loginButton.isEnabled = b
                        })
    .disposed(by: disposeBag)
      
  }
  ```



#### STEP 6

- 위 코드를 리팩토링하여 아래와 같이 나타내도록 하자.

  ```swift
  private func bindUI() {
    // input
    // idInputObserverable: Observable<String>객체를 사용하는
    // idValidOb: Observable<Bool>는 idInputObserverable의 변경에 영향을 받는다.
    let idInputObserverable: Observable<String> = idField.rx.text.orEmpty.asObservable()
    let idValidOb = idInputObserverable.map(checkEmailValid)
  
    // pwInputObserverable: Observable<String>객체를 사용하는 
    // pwValidOb: Observable<Bool>는 pwInputObserverable의 변경에 영향을 받는다.
    let pwInputObserverable: Observable<String> = pwField.rx.text.orEmpty.asObservable()
    let pwValidOb = pwInputObserverable.map(checkPasswordValid)
  
    //output
    idValidOb.subscribe(onNext: { b in self.idValidView.isHidden = b}).disposed(by: disposeBag)
    pwValidOb.subscribe(onNext: { b in self.pwValidView.isHidden = b}).disposed(by: disposeBag)
  
    Observable.combineLatest(idValidOb, pwValidOb, resultSelector: { $0 && $1})
    .subscribe(onNext: {b in self.loginButton.isEnabled = b})
    .disposed(by: disposeBag )
  }
  ```

  



##### 자, 이제 클래스 내에 state를 저장하는 properties (subjects)를 두고 Observable의 변화에 따라 이를 변경시키는 방법에 대해 알아보자. 





## Subject

- 서브젝트는 **프록시** 또는 **브릿지**의 한 종류로, **Observer 이면서 Observable** 로써 작동하는 ReactiveX의 몇몇 구현체 형태로 사용된다. 

  > Subject is a sort of bridge or proxy that is available in some implementations of ReactiveX that acts both as an observer and as an Observable.
  >
  > - Subject는 **`옵저버`** 이기 때문에, 하나 이상의 Observable에 대해  **subscribe 할 수 있다.** 
  - 또한, Subject는 **`옵저버블`** 이기 때문에 관찰 중인 아이템을 **하위 스트림으로 전달(pass)**시키거나, **재방출(reemit)** 하거나, <u>**새로운 아이템을 방출(emit)**</u> 할 수 있다.
    - <u>**새로운 아이템을 방출(emit)**</u> : **`옵저버블`** 이므로 Subject는 **데이터가 추후에 발생 시(just, from 등), Data를 넣어 줄 수도 있다**. 

  

- Subject가 하나의 Observable을 구독하기때문에, Observable이 아이템을 방출을 시작하도록 트리거 작동을 할 수 있다. 

  - Observable이 `cold` 인 경우라면, 즉, 항목을 보내기 전에 구독을 기다리는 타입이라면 트리거 가능하다.
  - 그 결과로, subject는 원래 `cold Observable` 의 변형인 `hot Observable` 가 된다.



## Subject의 여러 종류 

- subject는 유즈케이스에 따라 여러 종류로 설계되었다.
- 다음의 4가지 유형이 모든 구현체에서 구현가능한 것은 아니다.
- 몇몇 구현체는 서로다른 네이밍 컨벤션을 따르므로 주의하자. 
  
- 가령, RxScala의 PublishSubject는 여기서는 단순히 Subject라 한다.
  
- ### AsyncSubject

  <img src="http://reactivex.io/documentation/operators/images/S.AsyncSubject.png" width="500px">

  - AsyncSubject는 **subject 종료시의 마지막 value 값만 방출(emit)** 한다. 
  - `Source Observable` 에서 emit 되며, source Observable이 완료된 후에 방출된다. 
  - `Source Observable` 에서 방출하는 값이 없다면, AsyncSubject 역시 배출하는 값 없이 완료된다.
  - 후속 observer들에게 동일한 final value 를 방출한다.

  <img src="http://reactivex.io/documentation/operators/images/S.AsyncSubject.e.png" width="500px">

  

  - 만약 에러 발생시, AsyncSubject 역시 방출 없이 Source Observable로부터 전달받은 에러를 전달한다. 

  

- ### BehaviorSubject

  <img src="http://reactivex.io/documentation/operators/images/S.BehaviorSubject.png" width="500px">

  

  - 옵저버가 `BehaviorSubject` 를 구독중일 때, **`Source Observable`에서 가장 최근에 항목을 방출**할 때 BehaviorSubject가 시작합니다. 
    - 두 번째 observer가  `BehaviorSubject` 에 **subscribe() 할 때,**  **`BehaviorSubject` 는 가장 최근에 emit한 value를 방출해서 observer에게 준다.**
    - BehaviorSubject에게 subscribe 할 수 있다는 것은 BehaviorSubject도 Observable임을 의미한다.
  - 아직 `Source Observable` 에서 방출되지 않은 경우에는 기본값 (seed 값) 을 방출합니다.
  - `Source Observable` 에서 어떤 item들이 방출되면 계속해서 이 변경된 value가 스트림에 전달됩니다.
  - 만약 **Source Observable이 에러로 종료**된다면, **BehaviorSubject는** 어떠한 item도 후속 observer들에게 방출하지 않으며, **Source Observable로부터 받은 에러값을 그대로 전달**합니다.
  - **스트림에서 값을 추출하는 기능도 지원** 한다.




- ### PublishSubject

  <img src="http://reactivex.io/documentation/operators/images/S.PublishSubject.png" width="500px">

  - Source Observable(s)로부터 방출된 item들을 observer에게 그대로 방출합니다. 그러나, observer의 구독 이후에 발생한 방출 item에 대해서만 방출합니다.
  - `PublishSubject` 는 **생성 즉시 아이템을 생성하기 시작할 수 있으므로** (이를 방지하기위한 조치를 취하지 않은 경우) **Subject 가 생성 된 시점과 관찰자가 구독하는 시점 사이에 하나 이상의 항목이 손실 될 위험**이 있습니다. 

  - `Source Observable` 에서 **모든 항목의 전달을 보장해야하는 경우**, `cold` Observable 동작을 수동으로 재 도입 할 수 있도록 **1) Create로 Observable을 구성해야합니다**. (항목 관찰을 시작하기 전에 모든 관찰자가 구독했는지 확인). ) 또는 **2) ReplaySubject를 사용** 할 수 있습니다.

  - <img src="http://reactivex.io/documentation/operators/images/S.PublishSubject.e.png" width="500px">
  - 에러 발생시 PublishSubject 역시 다른 값 방출 없이 Source Observable로부터 전달받은 에러값을 옵저버들에게 전달합니다.

- ### ReplaySubject
  <img src="http://reactivex.io/documentation/operators/images/S.ReplaySubject.png" width="500px">

  - 어느 옵저버든  **source observable로부터 방출된 모든 아이템을 전달**합니다.
    - **옵저버의 구독시점에 상관없이 모든 방출된 아이템을 전달**합니다.
  - replay 버퍼가 특정 크기 이상으로 커질 위협이 있거나 특정 항목 방출 후에 지정 시간 경과시 오래된 item을 버퍼에서 버리는 ReplaySubject 도 가능합니다.
  - ReplaySubject를 옵저버로 사용하는 경우, **<u>*여러 thread 에서 onNext 메소드를 호출하지 않도록 주의*</u>** 하자. 
    - 잘못하면 비 순차적인 호출이 일어날 수 있기 때문에





## BehaviorSubject를 사용한 예시

```swift
class ViewController: UIViewController {
    var disposeBag = DisposeBag()
    var idValid: BehaviorSubject<Bool> = BehaviorSubject.init(value: false)
    var pwValid: BehaviorSubject<Bool> = BehaviorSubject.init(value: false)
  //...
  private func bindUI(){
    let idInputOb = idField.rx.text.orEmpty.asObservable()
    let idValidOb = idInputOb.map(checkEmailValid)
    
    idValidOb.subscribe(onNext: { b in 
				self.idValid.onNext(b)
		})
    //위 클로저 코드는 아래의 bind 함수로 대체 가능
    idValidOb.bind(to: idValid) //idValidOb로 전달되는 값을 idValid로 전달
    idValidOb.disposed(by: disposeBag)
  }
}
```

- 아래와 같이 간결하게 빌드 패턴으로 변경 

```swift
private func bindUI(){
    let idInputOb = idField.rx.text.orEmpty.asObservable()
  	idInputOb.map(checkEmailValid).bind(to: idValid).bind(to: idValid).disposed(by: disposeBag)
    
  	let pwInputOb = pwField.rx.text.orEmpty.asObservable()
  	pwInputOb.map(checkEmailValid).bind(to: pwValid).disposed(by: disposeBag)
}
```



- ID/PW에 대해 `xxinputText: BehaviorSubject<String> = BehaviorSubject(value: "")` 프로퍼티를 클래스 내에 선언하고, bindUI()  메서드에서 Input에 해당하는 부분을 다음과 같이 변경하자.

  - ```swift
    class ViewController: UIViewController {
        var disposeBag = DisposeBag()
        var idInputText: BehaviorSubject<String> = BehaviorSubject(value: "")
        var idValid: BehaviorSubject<Bool> = BehaviorSubject.init(value: false)
        var pwInputText: BehaviorSubject<String> = BehaviorSubject(value: "")
        var pwValid: BehaviorSubject<Bool> = BehaviorSubject.init(value: false)
      
        // MARK: - IBOutler
        @IBOutlet var idField: UITextField!
        @IBOutlet var pwField: UITextField!
        @IBOutlet var loginButton: UIButton!
        @IBOutlet var idValidView: UIView!
        @IBOutlet var pwValidView: UIView!
    
    	private func bindUI() {
        
        //input : 아이디 입력, 비번 입력
        idField.rx.text.orEmpty
        .bind(to: idInputText)
        .disposed(by: disposeBag)
            
        idInputText       //idInputText에 text 최신 값이 저장되어있으므로
        .map(checkEmailValid)
        .bind(to: idValid)
        .disposed(by: disposeBag)
    
        pwField.rx.text.orEmpty
        .bind(to: pwInputText)
        .disposed(by: disposeBag)
    
        pwInputText     //pwInputText에 text 최신 값이 저장되어있으므로
        .map(checkPasswordValid(_:))
        .bind(to: pwValid)
        .disposed(by: disposeBag)
        //output
      }
    }
    ```

  - ##### output에 해당하는 것도 다음과 같이 변경 가능 

  - ```swift
    //output
    idValid.subscribe(onNext: { b in self.idValidView.isHidden = b})
    .disposed(by: disposeBag)
    pwValid.subscribe(onNext: { b in self.pwValidView.isHidden = b})
    .disposed(by: disposeBag)
    
    Observable.combineLatest(idValid,
                             pwValid, 
                             resultSelector: { $0 && $1})
    .subscribe(onNext: {b in self.loginButton.isEnabled = b})
    .disposed(by: disposeBag )
    ```

  - ##### 클래스 내부에 프로퍼티를 선언하였으므로 bindUI 메서드를 둘로 나누자.

    ```swift
    override func viewDidLoad() {
      super.viewDidLoad()
      bindInput()
      bindOutput()
    }
    private func bindInput(){
      idField.rx.text.orEmpty
      .bind(to: idInputText)
      .disposed(by: disposeBag)
    
      idInputText      //idInputText에 text 최신 값이 저장되어있으므로
      .map(checkEmailValid)
      .bind(to: idValid)
      .disposed(by: disposeBag)
    
      pwField.rx.text.orEmpty
      .bind(to: pwInputText)
      .disposed(by: disposeBag)
    
      pwInputText      //pwInputText에 text 최신 값이 저장되어있으므로
      .map(checkPasswordValid(_:))
      .bind(to: pwValid)
      .disposed(by: disposeBag)
    }
    private func bindOutput(){
      //output
      idValid.subscribe(onNext: { b in self.idValidView.isHidden = b})
      .disposed(by: disposeBag)
      
      pwValid.subscribe(onNext: { b in self.pwValidView.isHidden = b})
      .disposed(by: disposeBag)
      
      Observable.combineLatest(idValid,
                               pwValid, 
                               resultSelector: { $0 && $1})
      .subscribe(onNext: {b in self.loginButton.isEnabled = b})
      .disposed(by: disposeBag )
    }
    ```



### Driver 

UI 업데이트를 위한 API에서 메인 스케줄러 전환을 위해 사용한다.

`.observeOn(MainScheduler.instance)` 를 덧붙일 수 있겠으나, 대신해서 .asDriver().drive(onNext: UI컴포턴트 업데이트(속성 변경) 코드) 등으로 대치할 수 있다.



- ```swift
  private func bindOutput(){
    //driver 사용시 
    viewModel.idBulletVisible
    	.asDriver()
    	.drive(onNext: idValidView.isHidden = $0 )
    	.disposed(by: disposeBag)
    //기존 방식
    viewModel.pwBulletVisible
    	.observeOn(MainScheduler.instance)
    	.bind(to: pwValidView.rx.isHidden)
    	.disposed(by: disposeBag)
  }
  ```





