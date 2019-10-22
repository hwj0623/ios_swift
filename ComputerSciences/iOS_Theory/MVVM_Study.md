# Model–view–viewmodel (10/14)



- [https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93viewmodel?source=post_page-----bb7576e23c65----------------------](https://en.wikipedia.org/wiki/Model–view–viewmodel?source=post_page-----bb7576e23c65----------------------)

- GUI 개발환경에 알맞는 소프트웨어 아키텍처 패턴 중 하나.
- MS사의 아키텍처 켄 쿠퍼에 의해 발명되고, 테드 피터스에 의해 UI 이벤트 기반 프로그래밍으로 구체화되었다.
  - 마틴파울러의 책 Presentation Model design pattern에서도 소개함.
- mark up 혹은 GUI code와 비즈니스로직/백엔드 로직(data model) 을 분리한다.



MVVM의 VM은 MVC에서의 컨트롤러 대신에 들어온 개념인데, 기존 iOS에서 컨트롤러가 뷰에 의존하여 엄격한 의미의 MVC가 지켜지지 않은데서 출발한 듯 하다. 컨트롤러 대신에 `뷰를 표현하는 형식으로 데이터를 변환하는 역할`을 담당하는 뷰 모델을 둔다.



### MVVM 패턴의 요소들

#### Model 

- 도메인 모델을 의미한다.  데이터(OOP에서의 ) 혹은 Data 접근 계층(데이터 중심 접근)의 실제 상태를 대표한다. 
- Domain Model, Data access Layer, Business Logic 등이 모델에 해당.

#### View

- MVC나 MVP에서와 마찬가지로 view는 스크린에 표현되는 구조체, 레이아웃, appearance를 의미한다. 모델의 대표성(representation)을 디스플레이하고, 유저의 인터랙션(클릭,터치, 키보드,제스처)을 수신한다.
- 더 나아가서 데이터 바인딩(프로퍼티, 이벤트 콜백 등)을 통해 이러한 인터랙션 처리를 뷰모델로 전달한다.

#### View Model

- 뷰 모델은 command, common properties를 노출하는 **뷰의 추상화**이다.

  - 뷰의 추상화는 재사용할 수 있고, 테스트하기 쉽다. (reusable & testable)
    - **testable** : 뷰 모델의 인터페이스를 통해 View Model과 의존적인 Model에 대해 쉽게 테스트 가능
  - **추상화된 View의 Model** 
  - **Presentation Logic** 이 뷰 모델에 해당

- View Model은 **스테이트 머신**과 **프레젠테이션 로직**을 처리한다.

  - View는 ViewModel만 알면 된다.
  - View Model  뒤에 있는 다른 레이어에 직/간접적인 의존성이 없게 된다.
  - **properties(text, items, …)**와 **commands(send, select, …)**를 통해 View에 조작이 가능한 인터페이스를 제공

- ##### MVC 패턴의 컨트롤러, MVP의 프레젠터와 달리 `binder` 를 갖는다.

  - Binder : 뷰와 (뷰모델 내) 뷰의 bound 프로퍼티들 간의 통신을 자동화 하는 역할을 수행한다. 
  - 뷰 모델은 모델 내 데이터의 상태로 묘사된다.

- ##### MVC 패턴에서 뷰 모델과 MVP 패턴의 Presenter의 주요 차이점

  - Presenter는 view에 대한 참조를 가지고 있으나, 뷰 모델은 view에 대한 참조를 가지지 않는다.
  - 대신, view는 뷰 모델의 프로퍼티들에 직접 바인딩되어 업데이트를 주고 받습니다.
  - 효율적으로 뷰 모델을 사용하기 위해, 뷰 모델은 [ 바인딩 기술||바인딩을 위한 보일러플레이트 코드 생성 ] 을 요구합니다.

#### Binder

- 바인더는 뷰 모델과 뷰를 동기화하기 위해 (업데이트를 위해) 개발자가 보일러플레이트 로직을 작성하지 않아도 됩니다.
- **iOS에서는 기존에 바인딩을 위해 제공되는 부분이 없으므로 주로 Rx를 이용**
  - iOS13 ~ combine 제공

----



### MVVM의 view model 과 Mediater pattern

- value converter : 모델이 제공하는 정보가 사용자에게 전달될 때, 혹은 그 반대의 경우 원본값이 그대로 사용되기도 하지만 그렇지 않은 경우도 있다. 모델이 표준시 기준 날짜 정보를 제공할 때 이것을 그대로 노출하는 것은 사용자에게 달갑지 않은 일이다. 지역 시간대 및 현지 언어가 적용되거나 ‘어제’와 같은 상대적 표현으로 변환된다면 사용자는 더 나은 경험을 하게된다. 이런 변환 작업을 위해 뷰모델은 값 변환기(ValueConverters)를 가진다.



- 뷰 모델은 **모델의 데이터 오브젝트를 쉽게 관리하고 표현하기 위한 방법으로 변환**시킬 책임을 지닌다.

- 뷰 라기보다는 모델에 가깝다. 

  - 뷰의 디스플레이 로직이 아닌 대부분의 경우를 담당한다.

- `뷰 모델`은 <u>뷰에 의해 지원되는 일련의 유즈케이스를 바탕으로</u>, 백엔드 로직에 대한 접근을 구성하는 **중재자 패턴**을 구현할 수 있습니다

  - **Mediator pattern** : 중재자 패턴은 오브젝트의 집합이 상호작용하는 방식을 캡슐화하는 객체를 정의한다. 이 패턴은 프로그램의 실행 동작을 변경할 수 있기 때문에, 행동패턴으로 불리기도 합니다.

  - 예시

    <img src="https://upload.wikimedia.org/wikipedia/commons/9/92/W3sDesign_Mediator_Design_Pattern_UML.jpg">

    - Colleague1과 Colleague2는 서로를 직접적으로 참조(혹은 업데이트)하지는 않으나, 상호작용(mediate() )을 제어하고 조정하기 위해 공통된 중재자 인터페이스를 참조합니다. 
    - 중재자 인터페이스를 통한 상호작용으로 **둘은 서로에게 독립적(상대방에게 직접적으로 관련하지 않음)으로 존재**합니다. 
    - 가령, colleague1이 colleague2과 인터랙션하기 원한다면(상태업데이트/동기화 등) colleague1이 mediator1 객체에서 `mediate(this)` 를 호출합니다.  mediator1 객체는 colleague1 로부터 데변경된 데이터를 얻고(`get`), colleague2에게 `action2()` 를 수행합니다.
    - 마찬가지로 colleague2는 상호작용이 필요하면 mediator1의 `mediate(this)`를 호출하고, mediator1은 `action1()` 메서드 호출로 colleague1에게 변화를 알립니다.









## 블로그 글 요약 등

[이규원님의 블로그 - MVVM 아키텍처 패턴](https://justhackem.wordpress.com/2017/03/05/mvvm-architectural-pattern/?source=post_page-----bb7576e23c65----------------------)



-  MVVM 패턴은 MVC(Model/View/Controller) 패턴의 변형으로 뷰의 추상화를 만드는 것이 핵심



#### MVVM 패턴의 요소들

- 1) **Model** 과 **View** 는 앞서 설명한 바와 같이 MVC 패턴의 요소와 동일

  - 모델 : 데이터, 비즈니스 로직, 서비스 클라이언트 등
  - 뷰 : 선언적으로 구성된 UI 요소

- 2) **ViewModel** : 뷰의 모형, 추상화된 뷰. 뷰를 플랫폼 독립적 공간에서 추상화한다. 뷰를 추상화하기 위해 추상화된 뷰 상태(ViewState)를 유지

  - ex) 뷰모델은 읽기와 쓰기 가능한 문자열 속성을 통해 텍스트 입력기 컨트롤을 추상화.
    - 데이터 목록 보여주는 컨트롤에 대해서는 각 요소의 뷰 상태가 들어있는 컬렉션을 사용 

- 뷰 : 자신이 가진 **상태를 사용자에게 표현(display)** + 사용자가 **응용프로그램에 명령을 내릴 수단(command)**을 제공 

- **뷰모델** : 위 명령 기능을 추상화 하기 위해 **명령(Commands)를 가짐**. 이를 통해 **유저는 모델의 행위를 실행시킴**

- 뷰 상태, 값 변환기, 명령을 통해 <u>뷰모델은 추상화된 뷰</u>가 된다.

  - 즉, 뷰모델은 개념적으로 사용자와 소통함.

  - 개념적 공간에서 사용자는 **뷰모델의 속성을 통해 정보를 입력**하고 **뷰모델의 명령을 실행**시키며 **뷰모델은 자신의 속성을 갱신**해 명령 실행 결과와 응용프로그램 상태 변화를 사용자에게 표현

    - 이메일과 암호를 이용한 로그인 화면을 떠올려보자. 이 화면을 추상화하는 뷰모델은 이메일 입력기와 암호 입력기에 대응하는 쓰기 가능한 문자열 속성 두 개와 로그인 버튼에 대응하는 명령을 가질 것이다. 만약 서비스(모델)가 로그인 실패 코드를 반환한다면 이 코드는 값 변환기에 의해 사용자 친화적인 메시지로 변환되어 읽기 전용 문자열 속성을 통해 출력된다.

    

- 추상화된 뷰와 물리적 뷰를 연결해 줄 수단이 필요.

  - MVC 패턴에서 컨트롤러 : 뷰와 모델 사이의 작업 흐름을 제어
  - MVVM 패턴에서는 작업 흐름을 제어하기보다는 View와 ViewModel 상태를 동기화해줄 구성요소가 필요. 
    - **Data Binding을 하는 `Binder` 가**이 그 역할을 수행
    - 데이터 바인딩 : 뷰모델의 상태 변경 —> 뷰의 상태가 함께 변경 (역도 성립)
  - 뷰모델은 뷰에 대해 알지 못함.
    - 뷰모델은 플랫폼 독립적
    - TDD에 유리
    - 실제로 응용프로그램의 많은 부분이 뷰 독립적으로 설명되고 구현된다.



## MVVM APP을 위한 프로젝트 구조화

<img src="https://justhackem.files.wordpress.com/2017/03/structuring-projects-for-mvvm-application.png" width="600px">

( 그림 및 내용 출처 : 이규원님의 블로그 : https://justhackem.wordpress.com/2017/03/06/structuring-projects-for-mvvm-application/ )

- 모델/ 뷰모델/ 뷰를 물리적으로 구분된 프로젝트에 분산

- 프로젝트 **순환 참조 금지**

- `뷰모델` 프로젝트가 `모델` 프로젝트 참조하도록 한다.

- `뷰` 프로젝트가 `뷰모델` 프로젝트를 참조하게 함

- `뷰모델` 프로젝트가 `UI 프레임워크` 를 **<u>참조하지 않게 한다.</u>**

  - 뷰 모델에서 UI 컴포넌트 사용하면 안된다.

  - #### 잘못된 예

  - ```swift
    class ViewModel {
      let mainImage = PublishSubject<UIImage>()
    }
    ```
    - UIImage or UIView에 값을 수정하는 것을 뷰모델에서 수행하면 안된다.
    - View의 lifecycle에 의존적인 (viewDidLoad, viewDidAppear, …) 작업 수행 금지
    - View를 레퍼런스로 받아 뷰의 값을 직접 변경하는 일도 UI와 관련된것으로 간주되어 금지 

- DI원칙을 절제하여 사용. 인터페이스 분리 원칙을 함께 고려.

- #### 잘못된 예 2 - 모든 프로퍼티들을 Observable로 처리하는 경우

  - ```swift
    class ViewModel {
      // MARK: Input
      let password = PublishSubject<String>()
      let confirm = PublishSubject<Void>()
     
      // MARK: Output
      let isConfirm: Observable<Bool>
    }
    ```

  - input에 대한 output이 init에서 모두 구성하거나, 별도의 observer type을 생성 해야 한다는문제점 발생.

  - input이 Action인지 Property의 업데이트인지 명확하지 않은 문제 발생 

  - Output의 초기값이 있는지, 없는지 혹은 ObserverType으로 Output을 구성했을때 외부에서 값을 변경할 수 있는 문제 발생 

  - Rx의존도 매우 상

- 잘못된 예 3 - view에 대해 너무 많이 아는 ViewModel

  - MVVM 적용시 View에 코드를 최대한 없애려고하다보면 ViewModel 이 View에 대해 지나치게 많이 아는 문제 발생
  - ex) ViewModel의 Observable 프로퍼티를 View의 좌표에 바인딩 한다고 하면, ViewModel은 UI에 의존적인건 아니지만, UI에 대해 간접적인 지식을 알게 



참고 블로그 : [MVVM패턴에 대하여](https://blog.jisoo.net/2018/12/09/what-is-mvvm.html)





[Reactive MVVM 모바일 App 아키텍쳐](https://justhackem.wordpress.com/2015/03/19/rmvvm-architecture/)



[MVVM 디자인패턴과 RxSwift ](https://incoffee.tistory.com/10)

#### MVC 의 ViewController의 역할은 너무 많다.

- 모델과 뷰 사이에 존재.
- View 를 소유, View 계층구조 관리, 사용자 인터랙션 수집, View 라이프사이클 이벤트 담당.
- 인터랙션을 통한 Model 업데이트
- 프레젠테이션 로직 담당 : Model 데이터 표현

-  뷰 컨트롤러가 비대해짐. Massive View Controller

- SRP 원칙 위배
- 테스트 어려움



#### MVVM 디자인 패턴 

MVVM에서는 ViewController에서 애플리케이션 로직을 분리. View만 포함된 ViewController와 **애플리케이션 로직이 포함된 클래스(뷰 모델)**로 분리 (Composition pattern 을 이용)

- ViewModel은 ViewController와 **1:1 대응** 

#### ViewModel에서 View로 데이터 바인딩

- Swift의 Property Observer : 데이터를 바인딩하는데 사용되는 대표적인 매커니즘
- View가 ViewModel에 update closure를 제공 
  - 관찰된 프로퍼티의 변경사항을 뷰에 알리는데 사용
  - Rx 스위프트나 ReactiveCocoa가 이에 대응됨.



## RxSwift 

#### cf. 명령형 패러다임

- 단계별 실행되는 명시적 명령을 기반으로 함.

- 실행이 단계별로 수행. 나중에 값이 변한다고 변경사항이 전파되지는 않음.

  ```swift
  a = 1
  b = 2
  c = a+b //c = 3
  a = 5 // 5 명령형 패러다임
  ```



#### 기능 반응형 프로그래밍(Functional Reaction Programming, FRP) 패러다임

- ```swift
  a = 1
  b = 2
  c = a+b //c = 3
  a = 5 // c = 7 FRP 패러다임
  ```

- RxSwift 사용시 FRP 패러다임 적용하여 코드를 작성 가능
- 구성, 변환 및 관찰 가능한 Event || Data Stream 을 쉽게 작성하여 관측 값을 기반으로 일부 조치를 수행함.
- MVVM에서 View는 ViewModel에서 준비한 모델 데이터를 표시
  
  - Rx는 값을 관찰하고, View에 바인딩하는 간결한 매커니즘을 제공

#### Observable

- RxSwift의 주요 building block.
- 비동기적으로 요소를 수신할 수 있는 시퀀스
- 시퀀스는 0개 이상의 요소 보유
- 발생가능한 이벤트 유형은 Next(다음), Error(오류), Completed(완료)

```swift
enum Event  {
    case next(Element)      // 시퀸스의 다음 요소
    case error(Swift.Error) // sequence failed with error
    case completed          // sequence terminated successfully
}
```

- **subscribe 메서드를 사용**하여 **이벤트를 관찰**하고, 이벤트의 각 case를 처리.

- 관찰된 요소 값을 사용가능. (completed 시)
- Observable 시퀀스가 성공적 완료시 호출됨. 

- 관찰 가능한 시퀀스를 완료하지 못하면 오류 발생.

  - 완료되거나 오류 이벤트 관찰시 Observable 시퀀스는 다른 요소 생성 불가.

  ```swift
  observable.subscribe(
      onNext: { element in ... }, 
      onError: { error in ... },
      onCompleted: { ... }
  )
  ```

  