# Let us Go - 2019 summer



## StringInterpolation과 SwiftUI - minsone(안정민 님)

StringInterpolation - swift5 에서 String Extension

- minsone.github.io

- StringInterpolation 소개
- RichString 만들기
- SwiftUI를 이용한 RichString 만들기
- FunctionBuilder를 이용한 RichString 만들기



### **StringInterpolation**

하나 이상의 placeholders(" \ (variable)")를 포함하는 문자열 리터럴을 실행하여 placeholders를 해당 값으로 대체한 결과를 산출하는 방식

```swift
let txt1 = "Hello"
let txt2 = "World"
"\(txt1), \(txt2)"

///swift에서 인식 방식
1: ""
2: \(txt1) -> "Hello"
3: ", "
4: \(txt2) -> "World"
5: ""
result : "Hello, World"
```

Apple/Swift의 StringInterpolation.swift 참고





### Extend StringInterpolation (swift5)

기존 StringInterpolation에 확장을 부여



```swift
let amount = 10000
print("(amount, style: .원)")


enum Style { case .원}
extension String.StringInterpolation {
	mutating func appendInterpolation(_ amount: Int, style: Style){
		switch style{
			case .원: appendLiteral("\(amount)원")
		}
	}
}

/// 기존 방식 - 자동완성이 원활하다. primitive type으로 도출. 
"\(amount.toCurrency(.원화))"	

/// StringInterpolation - 직접 currency까지 쳐줘야 함..
"\(amount, currency: .원화)"
```



///아래 코드예시는 나중에 영상보고 백업

```swift
struct CustomInterpolation: StringInterpolationProtocol {
	var str: String
  /// 초기화
  /// - Parameter
  ///	 	literalCapacity : 문자열길이
  /// 	interpolationCount : 문자열 placeholder 개수
  init(literalCapacity to: Int, interpolationCount: Int){
    self.str = ""
  }
  
  mutating func appendLiteral(_ literal: String){
    
  }
}
```





```swift
ExpressibleByStringInterpolation : ExpressibleBy
```





### StringInterpolation 사용하여 Rich String 만들기

NSAttributedString Library

- SwiftRichString, BonMot, Atributika와 같은 라이브러리를 통해 좀 더쉽게 NSAttributedString을 만들어줌



```swift
let style1 = Style{
  $0.font = UIFont.systemFont(ofSize: 25)
  $0.color = UIColor.blue
  $0.alinmnet = .center
}

let style2 = Style{
  $0.font = UIFont.systemFont(ofSize: 25)
  $0.color = UIColor.green
  $0.alinmnet = .center
}

let attr = NSMutableAttributedString(String: "")
attr.append("Hello".set(style:style1))
attr.append("World".set(style:style2))



struct RichStringInterpolation: 
```



### **SwiftUI에서 RichString 만들기**

```swift




```





### **FunctionBuilder를 이용한 RichString 만들기**

FunctionBuilder(beta)

빌더 패턴을 좀 더 보기 쉽게 해주는 Annotation

```swift
struct ContentView: View{	

	var body: someView

}
```





### **reference** 

SE-0228 - Fix ExpressibleByStringInterpolation

MSDN - Interpolation

HackingWithSwift - What's new in Swift 5.0









## 인디 앱 수입으로 월세 내기 - 미정님

- 프알못의 keras 앱 만들기 2017



App Biz Model

- AdMob (광고모델)
- Subscriptions (구독모델)
- Paid Apps/IAP (유료앱) - v



**출시한 앱**

Blink 2017.05

- 빠른 메모 블링크
- **유료앱의 featured 는 update에 따라 달라진다.**
- $ 27,000

BFT 2018.01 (Bear Focus Timer)

- 화이트 노이즈 (폰 뒤집으면 설정한 타이머 시작)
- 주어진 시간동안 폰을 건드리지 않으면 칭찬카드 보여주는 방식
- 1년 반 수익 = Blink의 2배

BBL 2018.05 (Bear Bucket List )

- 버킷리스트앱
- BFT 엔트리 포인트로 하기 위한 앱

총 $80,000 (세전, 환불 미포함)

- Apple/디자이너/개발자 



**좋은 기획 + 좋은 디자인** 

- John Jung (디자이너)
  - DAYGRAM / FeelcaD / FeelcaT / OLDV

**안정적인 기능구현 + 지속적인 업데이트 ** 

- 개발자의 몫



**For AppStore Featured…** 

개발자의 몫

- Error Free
- iOS Native
- update frequently
- Apple 기술 사용 - siri, ARKit, CoreML 등

비개발자의 몫

- AppStore 설명
  - 카테고리 (생산성/유틸리티/라이프스타일 등)
- 리뷰 확인
- 홍보 및 노출 - 개발블로그/디자인블로그/SNS/리딤코드
- Tell Us Your Story (Promote 요청)





## ARKit 3 톺아보기 - 김형중 님

- 영상 참고









## iOS 프리랜서로 산다는 것 - Clint Jang

https://github.com/ClintJang

SW Freelancer

- 프리랜서란 
  - 인적용역 사업자(부가가치세법 시행령 42조)
- 경력기술양식
  - 경력 기술서, 개인이력카드, 포트폴리오
- 개발자 등급
  - 제도화된 공식 등급으로 인해 공식적인 등급은 폐지됨 (2012.11.24)
  - 공공기관과 대기업은 과거의 기준(초급/중급/고급/특급)으로 구분

- 계약서
  -  [참고](github.com/ClintJang/awesome-freelance-korea-information)
  - 계약서 사본 (계약기간/급여/급여일자/독소조항/특기사항/특약사항 /별도붙임문서/계약일자 등 살펴볼 것)
- 계약급여
  - 초급 : ? ~ 350~450 / 중급 450~550/590 ~ ?  / 고급 550 ~ 600 ~ 700 ~ 750 ~ ?/ 특급 (고급+PL+특수기술)
  - 지방/해외 
    - 체재비용으로 추가비용
  - SI / SM 
- 세금 / 실수령액
  - 3.3% 공제
  - 월 400, 520, 650 기준 => 386.8 / 502.84 / 628.55
  - 정규직과 비교 => 5400 / 7300 / 9400 연봉과 비슷
  - 퇴직금x 국민연금x 의료보험x 고용보험x 산재보험x 

- 구직과정
  - 이력서 오픈 > 

- 느낀 점(장단점)
- 간단한 통계





## **Combine vs RxSwift** - 상어

#### RxSwift - An API for async programming with observable streams

- iOS 8.0 +
- iOS, macOS, tvOS, watchOS, Linux 지원
- Reactive Extensions (ReactiveX)
- Third-party
- Open source / community
- RxCocoa

#### WWDC 2019 - Combine

- iOS 13부터 지원
- iOS, macOS, tvOS, watchOS, UIKit for Mac
- Reactive Streams(+adjustments)
- Fisrt-party (built-in)
- Apple maintained
- SwiftUI



#### map, filter, reduce 

map ( x => 10 * x )

reduce((x,y) => x+y)  /// error가 나오면 결과가 나오지 않음



### Rx - Observable , Combine - Publisher

Obserbable<Element> 

- 클래스 타입



AnyPublisher<Output, Failure> 

- Publisher protocol을 채택

- Struct Type



Subject 

- radio와 같은 개념



Rx PublishSubject<값> vs Combine PassthroughSubject<값, 에러>



Rx BehaviorSubject<값>(value: 초기값)  || CurrentValueSubject<Int, Never>(초기값)



**rx     combine**

subscribe() ===  sink()

bind(to: ) === subscribe()



**Rx의 Disposable , DisposeBag(Disposable이 담긴 가방에 해당)**

- 뷰컨트롤러 해제시 DisposeBag 이 해제 > Disposable 인스턴스도 해제 —> DisposeBag이 뷰컨의 라이프사이클과 같이움직임
- combine에서는 이에 대응하는 CancelBag같은것은 존재 x

let disposeBag = 





**Thread**

Rx | Combine

ObserveOn( ) | receive(on:)

subscribeOn(최상위 스트림) | subscribeOn() 동일

ObserveOn() | receive(on:)



코드 사진(Thread 관련)

**예상결과**

true / false / false / false

**현실**

t/f/f/f or f/f/f/f/

충분히 테스트해보고 쓸 것











## 그래요 저 비전공 개발자에요..** - Yo 

> 개발자는 디자인을 배워야하나?

디자인의 **종류**

- UI (User Interaction Design ; 시각적으로 상호작용하는 부분에 대해 디자인) / UX (User Experience ; 직간접적으로 경험하는 것을 신경써서 디자인)



> 디자인이 개발자에게 **어떤 도움**을 줄까?

- 속도 향상
  - 아이디어 > Layout과 서비스기획은 기획자/디자이너가. 뒷단 서비스로직개발에 대한 것을 개발자가
  - But, Layout에 대해 미리 설계하고 프로토타입 개발이 가능
- 협업 기술 (with 디자이너)

- 수익 창출(개인앱)

  - flat design trend > 개인앱 개발에 수월..

  

> 어떻게 디자인 감각을 키울까?

- 디자이너에게 질문하기 
  - padding / font / etc
- AppStore 살펴보기



https://dribbble.com

- demo app design

https://mobbin.design

- 실제 서비스하는 앱의 ui 모아놓은 것 (ex Airbnb)

https://pttrns.com

https://www.designnotes.co

- ui 정보얻기

https://icons8.com

- 무료로 사용가능한 아이콘 얻을 수 있음



> **8 point Grid System**

- 크기 / 높이 / 간격을 8의 배수로 설계하는 것

- why 8의 배수?
- 6도 10도 아니고 왜 8?
  - **많은 screen size들이 8의 배수의 해상도**를 지닌다.





## What's new in Xcode / iOS13  - 재르시

github.com/jaesunglee @Naver

iOS 13 - beta



### Darkmode

- 좀더 명확하게 컨텐츠에 집중가능
- 다른 많은 앱들이 이미 다크모드를 지원
- 배젤과 같은 색으로 더욱더 몰입감을 주도록 한다.

- Design Goal

  - 친숙함 유지
  - 일관된 플랫폼 사용성
  - 명확한 정보 계층 구조
  - 무엇보다 (개발자가 적용하기에) 쉬워야 함

- System Color

  - Light와 Dark 모드에 대비
  - 명암 대비 증가 및 투명도 감소와 같은 접근성 설정도 대비
  - 다양한 색상들이 각 모드별로 지원 

  - 설정 > 손쉬운사용 > 접근성 > 대비 사용에 대응하는 색감 
  - 투명도 줄이기에 용이하다.
  - 계층표현
    - 기존에는 그림자 통해서 레이어 계층을 구분
    - 배경볻 더 밝은 색을 통해서 계층을 표현한다.
    - 계층에 따라 다른 컬러

- 커스텀 컬러 사용시 다크모드 사용 방법에 대해..

  

### card style Modal presentations

- 기존의 모달은 아래에서 위로 올라오는 형태의 모달
  - 내가 어디 레이어/depth인지 알기어려움
-  백그라운드에 layer를 표시하도록 변경됨
- 위에서 끌어내리면 닫기 동작이 지원되도록 함
- 앨범과 같은 경우에는 모달로 띄워도 full screen 모달을 기본으로 함
- Navigation 영역이 줄어듬



### Contextual Menus

- iPad / Mac에 이미 지원하는 기능들
- developer.apple.com/design참고



### SF Symbols

- Face ID를 포함한 여러 symbols를 기본 아이콘으로 지원
- 다이나믹타입 / 텍스트 인라인 (아이콘도 bold) 



### 데모 영상







## **WWDC Cheatsheet** - 최완복

LINE BIZ PLUS



**SWIFT**

What's new in swift5

Binary Frameworks - ABI and Module Statiblity

- ABI - 기존에는여러 컴파일러에 대응하도록 여러개 넣었어야 했다 - statiblity 향상

Docker Swift 지원



**ADVANCES IN FOUNDATION** 강의

- DataProtocol instead of UInt8
- Format dates and lists with Formatter
- ...

- Operation Queue 
- Scanner
- FileHandle



**SWIFT UI** 강의

- reference counting (ARC)에 대한 부담이 줄어듦
- hierarchy 최적화 - overhead minimum
- Data Flow Primitives
- 만든 ui가 즉각적으로 보이게  Preview 기능 강화



**SWIFT UI Essentials** 강의

- view 선언 후 modifer를 사용
- custom view 생성을 위해 primitive view를 6개 제공함 
  - Building Custom Views in SWIFTUI 강의
    - Layout Basics
    - Layout Procedure
    - Avocado Toast
      - component의 뒤에 따라오는 메서드채이닝 내 메서드의 순서에 따라 Layout의 구성이 달라질 수 있음
    - Drawing Model
    - Gradient
- composing controls > V(iew)Stack 
- Accessibility 강화



**DATA**

- Advances in UI DATA SOURCES 강의
- Rx DataSource의 Apple ver



**DATA FLOW THROUGH SWIFT**

- A View has @state == source of truth 
- working with external data
  - multiple item을 async로 작동
  - combine과 관련된 얘기



**Introducing Combine**

- generic
- type safe
- request driven



- one / many / sync / async 2x2 matrix

  Int     |  Future 

  Array | Publisher

- CreateML



**What's new in Machine Learning**

- 9가지 범주의 ML boilerplate 제공
- CoreML
  - user data가 output으로 도출될 때, 이를 재학습!하는 App으로 만들 수 있음
- CREATE ML For Object Detection and Sound Classification



**DESIGNING GREAT ML EXPERIENCES**

- 편향된 real data를 잘 선택해서 학습시켜야
- 적당한 수준의 오류는 넘어가야..
- implicit feedback
  - 
- explicit feedback 
  - 부정적인 피드백 처리가 높아야..



**VISION - UNDERSTANDING IMAGES IN VISION FRAMEWORK**

- eye tracking
- 이미지 유사성



**Cryptography and your apps**

- TLS 대신 SecTrust 사용
- Apple CryptoKit



What's new in CLANG AND LLVM

- Bitcode (What is LLVM bitcode)



**GREAT DEVELOP HABITS**

Organize

- Group 잘 만들고
- zero warning 만들기

Track

Document

Test

Analyze

Evaluate

Decouple

Manage