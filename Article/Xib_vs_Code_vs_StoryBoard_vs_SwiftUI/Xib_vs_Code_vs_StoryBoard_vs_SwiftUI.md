Xib(NIB) vs Storyboard vs Code vs SwiftUI



# STEP17. 뷰와 렌더링 (이론)

뷰View 와 관련된 내용을 자기만의 방식으로 학습하고, 정리해보자.

- 뷰 객체의 역할은 무엇인가?
- 나만의 **커스텀 뷰 객체**를 만드는 방법은 무엇이 있는가?
- 뷰 객체를 만들때 **주의해야 하는 것**은 무엇인가
- ViewController를 기준으로 뷰 객체가 그려지는 **렌더링 방식에 대해 학습**한다.
- 계층화된 뷰 구조에서 상위뷰(SuperView)와 하위뷰(subview) 레이아웃의 상관 관계를 정리한다.
- 뷰를 생성하기 위한 다양한 방법에 대해 **공통점**과 **차이점**을 학습한다.
- 뷰에서 이벤트 처리하는 여러 방식에 대해 학습한다.
- 뷰 애니메이션을 위한 여러 방식을 구분해서 정리한다.



## XIB 

Next Interface Builder

### XML Interface Builder

- 화면 UI를 기록하는 XML파일로, 기존의 바이너리로 저장하던 GUI 파일을 XML로 전환한 것이다.
- 안드로이드 layout XML과 흡사하다.
- VCS(version control system, 형상관리) 사용을 위해 nib 대신 xib를 사용한다.

- view는 여러개 추가가능하나, 화면(viewController)는 하나만 존재.

- 스토리보드에서 뷰는 scene과 매칭이 되지만, xib는 view와 매칭이 된다. 

- 각각의 view는 **file's Owner**의 인스턴스로 생성된다.



- 

### IPA 앱 Bundle 구조와 관련성

> IPA : iPhone, iPad application 확장자, android의 .apk와 유사
>
> **Archive**

- 아카이브화되는 대상은 빌드시 (ex: UIView) 리소스 디렉토리에 컴파일된 결과가 File로 저장된다. - 예) CustomCell.**xibc** or **BlueView.nib**
- 아카이브화된 리소스는 .ipa 앱의 실행시점에  **`Unarchived`** 되서  **`File's Owner `** 에 연결된다. 
- 이 때, 인스턴스 변수(ex: view)에 IBOutlet을 연결한다.

- file's Owner가 여러 view를 지닌 경우, UIView를 채택한 custom class를 연동할 수 있다.
  - 기존의 .xib 파일의 view에서 file's Owner의 custom class로  blueView를 연동할 수 있다.
  - file's Owner는 여러 뷰를 지닐 수 있으므로, file's owner의 custom class로 custom view class인 (ex: blueView)를 지정한다.
    - 이 경우, file's Owner가 BlueView에 대응하고, 기존의 view는 blueView 대신 IBOutlet 프로퍼티로 선언하여 (mainView)가 file's owner의 property로 존재하게 만들 수 있다.

>  **cf. 뷰 객체가 아카이브화 되어있다? != serialize를 의미하는 것은 아님**

- iOS에서 serialize되는 대상은 다른 언어와 다르다.
  - String, Int, Double, Float, Bool, Object은 **serialized** 된다.
  - 클래스, 구조체들은 serialize하지 않고, **Archived** 된다. 
    - (아카이브되는 객체는 객체의 포함관계에 따라 하위 프로퍼티들을 Deep copy 한다.)



### 아카이브된  View-Object 관련 UIView method

**awakeFromNib**

- 뷰 객체를 모두 언아카이브(unarchive) 처리한 직후 호출하는 함수
- 객체가 다 언아카이브 되었음을 알려준다.

```swift
override func awakeFromNib() {
    print("Resources from Nib files are completely unarchived")
    super.awakeFromNib()
}
```



> 뷰 객체를 직접 생성할 때만 호출
>
> 지정 초기화 (designated initializer) 메소드

```swift
override init(frame: CGRect) {
    print("initWithFrame")
    super.init(frame: frame)
}
```

> 인터페이스 빌더(.storyboard) 에서 만든 뷰 객체를 언아카이브할 때만 호출하는 생성자함수

```swift
required init?(coder aDecoder: NSCoder) {
    print("initWithCoder")
    super.init(coder: aDecoder)
}
```



----



```swift
var aViewController = UIViewController.init(nibName: "BlueView", bundle: nil)
self.view.addSubview(aViewController.view)s
```

- ViewController의 view에 다른 ViewController의 view를 연결하거나, Xib로 만든  View를 만드는 것을 권장하지는 않는다.





## StoryBoard

- Objective-c의 화면 구성 방식인 Interface Builder를 대체하기 위해 나온 인터페이스 생성화면
- MVC 패턴 도입으로 ViewController를 도입하면서 ViewController를 기반으로 생성
- **UIViewController 단위로 매칭되는 화면구성**은 **스토리보드로** 사용한다.

- **화면 단위로 구분**하는 **`Scene`** 과 **다른 화면 사이에 전환 효과**를 의미하는 **`Segue`** 를 조합해서 만든다.

- 여러 뷰 컨트롤러, 뷰가 존재가능하나 용도에 따라 별도의 스토리보드로 관리하는 것을 권장
- 모든 뷰 객체는 코드로 만드는 것이 가능 

- 특정 SuperView의 하위에 속하지 않는 View를 만들 수는 없다. <-> Xib의 Hidden View 
  - HiddenView는 숨겨진 뷰를 만들어서 IBOutlet으로 연결할 수 있다.





## XIB vs StoryBoard

XIB 특징

- 독립적인 뷰 디자인
- 뷰 단위 재사용성이 높다.
- 화면사이즈/로컬라이즈 리소스 미리 보기가 가능하다.
- 동적으로 로딩이 가능하다. (Lazy loading)

XIB 단점

- 콘텐츠 구성, Layout이 동적으로 바뀌는 경우에 적용하기 힘들다.
- IB(interface builder)에서 바꿀 수 없는 속성이 있다.
- 뷰 컨트롤러 사이의 연결(transition, segue)이 불가능



## SwiftUI

- `import SwiftUI`

- Swift 코드로 view와 action을 작성
- 빌드시 컴파일러가 컴파일 후 리소스 파일을 만들지 않는다.
- Products 내 .app 패키지에서  .storyboardc 라든가,  xibc 같은 컴파일코드가 리소스파일로 존재하지 않는다.
- 뷰 생성하는 행위 == 코드를 만드는 행위 가 된다.