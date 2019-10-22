## RxSwift_step4 - MVC 모델을 MVVM 으로 변환시키기

#### MVVM

- View와 ViewModel을 N:1로 설정 (1:1 관계의 MVP보다 개선)
  - 하나의 뷰 모델이 여러 뷰에 의해 공통으로 참조된다.

- Controller나 Presenter와 달리, **ViewModel은 Model에만 관심**이 있다. 
  - 화면 그릴 것을 강요하지 않음. View가 ViewModel을 지켜보고 있다가(구독), ViewModel의 변경에 대해 구독중인 뷰의 현재 상태를 변경하는 것



## STEP 1

기존 뷰 컨트롤러를 분할하여, ViewModel을 만든다.

기존 뷰 컨트롤러에는 ViewModel 클래스를 프로퍼티로 injection 시킨다.

viewController는 무언가 "판단" 하면 안된다.

#### viewController.swift

```swift
import RxCocoa
import RxSwift
import UIKit

class ViewController: UIViewController {
    let viewModel = ViewModel()
    var disposeBag = DisposeBag()
    
    var idInputText: BehaviorSubject<String> = BehaviorSubject(value: "")
    var idValid: BehaviorSubject<Bool> = BehaviorSubject.init(value: false)
    var pwInputText: BehaviorSubject<String> = BehaviorSubject(value: "")
    var pwValid: BehaviorSubject<Bool> = BehaviorSubject.init(value: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()
    }

    // MARK: - IBOutler

    @IBOutlet var idField: UITextField!
    @IBOutlet var pwField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var idValidView: UIView!
    @IBOutlet var pwValidView: UIView!

    // MARK: - Bind UI
    // 사용자 입력 x - 빨간 불 x
    // 사용자 입력 시작
    // 이메일 -> 빨간 불 on // 형식이 맞으면 빨간 불 off
    // 비번 -> ""
    // 둘다 valid면 login 활성화
    // 둘 중 하나라도 invalid라면 login 비활성화
    // id input +--> check valid --> bullet
    //          |
    //          +--> button enable
    //          |
    // pw input +--> check valid --> bullet

    // MARK: - MVVM
    private func bindUI(){
        //input 2: 이메일, 비번 입력
        idField.rx.text.orEmpty
            .subscribe(onNext: { email in
                self.viewModel.setEmailText(email)
        }).disposed(by: disposeBag)
        pwField.rx.text.orEmpty
            .subscribe(onNext: { pw in
                self.viewModel.setPasswordText(pw)
        }).disposed(by: disposeBag)
        
        //output 2: ㅣ메일, 비번 체크 결과
        viewModel.isEmailValid
            .bind(to: idValidView.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.isPasswordValid
            .bind(to: pwValidView.rx.isHidden)
            .disposed(by: disposeBag)
        
        //output 1 : 버튼은 enable 상태
        //UI 관련 내용이라 ViewModel에 넣을지 View에 놔둘지는 각자가 판단. 여기서는 View 에서 다룸.
        Observable.combineLatest(viewModel.isEmailValid, viewModel.isPasswordValid){ $0 && $1 }
            .bind(to: loginButton.rx.isEnabled)
        .disposed(by: disposeBag)
    }
}
```



#### ViewModel.swift

```swift
import Foundation
import RxSwift
// MARK: - MVVM
class ViewModel {
    let isEmailValid: Observable<Bool> = Observable.just(false)
    let isPasswordValid: Observable<Bool> = Observable.just(false)

    func setEmailText(_ email: String){
    }
    func setPasswordText(_ pw: String){
        
    }
    
    // MARK: - Logic

    private func checkEmailValid(_ email: String) -> Bool {
        return email.contains("@") && email.contains(".")
    }

    private func checkPasswordValid(_ password: String) -> Bool {
        return password.count > 5
    }
    
}

```





## STEP 2

https://www.youtube.com/watch?v=lOts3BGuOtY&list=PL03rJBlpwTaBBtiJ0BtgASCsS4ye-4gC7&index=2



#### ViewModel.swift

- 메소드 내부를 채우자.
- 외부에서 isEmailValid, isPasswordValid 값을 변경시켜주어야 하므로 이 둘을 Subject로 변경하는 작업이 진행된다.

```swift
import Foundation
import RxSwift
// MARK: - MVVM
class ViewModel {
    let isEmailValid = PublishSubject<Bool>()
    let isPasswordValid = PublishSubject<Bool>()

    func setEmailText(_ email: String){
      	let isValid = checkEmailValid(email)
        isEmailValid.onNext(isValid)
    }
    func setPasswordText(_ pw: String){
        let isValid = checkPasswordValid(pw)
        isPasswordValid.onNext(isValid)
    }
    
    // MARK: - Logic

    private func checkEmailValid(_ email: String) -> Bool {
        return email.contains("@") && email.contains(".")
    }

    private func checkPasswordValid(_ password: String) -> Bool {
        return password.count > 5
    }
}
```



#### 문제 발생 : 초기값이 true인 상태로 고정되어있다.

- mainStoryboard에서 state 값을 enabled 체크시에 subject에서 초기값을 재초기화할 수 없다.



뷰 모델의 subject에 초깃값을 주기 위해서는 다음과 같이 조치한다.

```swift
import Foundation
import RxSwift
// MARK: - MVVM
class ViewModel {
    let isEmailValid = BehaviorSubject(value: false) //초기값을 지정 가능하다.
    let isPasswordValid = BehaviorSubject(value: false)

  	//..이하 동일
}
```

- 기존 코드를 아래와 같이 변경한다.

#### ViewModel.swift

```swift
import Foundation
import RxSwift
// MARK: - MVVM 변경 작업
class ViewModel {
    //초기값을 세팅할 수 있는 BehaviorSubject를 사용
    //Output
    let isEmailValid = BehaviorSubject(value: false)
    let isPasswordValid = BehaviorSubject(value: false)
    //Input
    let emailText = BehaviorSubject(value: "")
    let pwText = BehaviorSubject(value: "")
    init(){
      // distinctUntilChanged : 매번 valid 체크할 필요없이 변화시에만 체크
        _ = emailText.distinctUntilChanged() 
            .map(checkEmailValid(_:))
            .bind(to: isEmailValid)
        
        _ = pwText.distinctUntilChanged()
            .map(checkPasswordValid(_:))
            .bind(to: isPasswordValid)
    }
    //아래 둔 메서드를 위 생성자 코드로 대체 한다.
    func setEmailText(_ email: String){
          let isValid = checkEmailValid(email)
        isEmailValid.onNext(isValid)
    }
    func setPasswordText(_ pw: String){
        let isValid = checkPasswordValid(pw)
        isPasswordValid.onNext(isValid)
    }
    
    // MARK: - Logic
    private func checkEmailValid(_ email: String) -> Bool {
        return email.contains("@") && email.contains(".")
    }

    private func checkPasswordValid(_ password: String) -> Bool {
        return password.count > 5
    }
    
}
```

 

### ViewController.swift

```swift

class ViewController: UIViewController {
    let viewModel = ViewModel()
  //...
  
	private func bindUI(){
   	//input 2: 이메일, 비번 입력
  	 // 선언형 프로그래밍 : subscribe를 bind로 대체한다.
 	   idField.rx.text.orEmpty
    		.bind(to: viewModel.emailText)
   		 	.disposed(by: disposeBag)
		  pwField.rx.text.orEmpty
        .bind(to: viewModel.pwText)
        .disposed(by: disposeBag)
 	 	//output 2: ㅣ메일, 비번 체크 결과
 	   viewModel.isEmailValid
    		.bind(to: idValidView.rx.isHidden)
  		  .disposed(by: disposeBag)
   		     
  		viewModel.isPasswordValid
  			.bind(to: pwValidView.rx.isHidden)
  			.disposed(by: disposeBag)
        
  	//output 1 : 버튼으 enable 상태
 		 Observable.combineLatest(viewModel.isEmailValid, 
                            viewModel.isPasswordValid){ $0 && $1 }
  			.bind(to: loginButton.rx.isEnabled)
  			.disposed(by: disposeBag)
}
```

