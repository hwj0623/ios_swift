## iOS

### iOS앱이 시작되는 과정

iOS앱은 사실 `UIApplication`이라는 클래스의 객체이다. 프로젝트의 `main` 함수는 기본적으로 `UIApplication` 클래스의 인스턴스를 만들어서 GUI를 사용하기 위한 **Run Loop** 를 돌려주는 작업을 수행한다. 그리고 그 이후에 앱 내에서 일어나는 모든 처리는 `UIApplication` 객체가 관리하게 된다.

1. `main` 함수가 실행된다.
2. `main` 함수는 다시 `UIApplicationMain` 함수를 호출한다.
3. 이 함수는 앱의 본체에 해당하는 객체인 `UIApplication` 객체를 생성한다.
4. 또 `Info.plist` 파일을 읽어들여 파일에 기록된 정보를 참고하여 그외에 필요한 데이터를 로드한다.
5. 메인 nib 파일을 사용하는 경우 4.의 과정에서 로드된다.
6. 메인 nib 파일이 없거나, 그 속에 앱 델리게이트가 없는 경우, 앱 델리게이트[^델리게이트] 객체를 만들고 앱 객체와 연결한다.
7. 런루프를 만드는 등 실행에 필요한 준비를 마무리해 간다.
8. 실행 완료를 앞두고 앱 객체가 앱 델리게이트에게 `application:didFinishLaunchingWithOptions:` 메시지를 보낸다.

https://soooprmx.com/archives/4454



#### 0. View Controller LifeCycle 설명

![img](https://t1.daumcdn.net/cfile/tistory/998D703359F037C907)

#### 1. init(coder:)

`storyboard` 를 통해 View Controller들을 만들 경우 View Controller의 객체가 생성될 때 초기화 작업을 하는 메소드가 바로 `init(coder:)`메소드 입니다. 객체를 Byte Stream으로 바꾸어 디스크에 저장하거나 네트워크를 통해 전송하는 직렬화 작업을 하지 않는 이상 매개변수로 넘어오는 `NSCoder` 는 무시하셔도 무방합니다.

**이 메소드에서 초기화 작업을 할 때 View Controller들은 그들의 lifetime동안 필요한 자원들을 할당받게 됩니다.**

**이 시점에서는 View Controller의 View가 생성된 것이 아니기 때문에 View의 요소들에 대한 접근을 시도한다면 에러를 발생시킬 것입니다.**



#### 2. init(nibName:bundle:)

`storyboard`가 아닌 분뢰된 `.nib`파일로 관리될 경우 `init(coder:)`대신 이 메소드를 초기화의 용도로 사용할 수 있습니다.



#### 3. loadView()

이 메소드는 본격적으로 화면에 띄어질 View를 만드는 메소드입니다. `storyboard` 나 `.nib`파일로 만들어지는 경우가 아닌 모두 직접적으로 코딩하여 만드는 경우를 제외하고서는 `override`하지 않는 것이 좋습니다.

 **`outlet`들과 `action`들이 이 메소드에서 생성되고 연결됩니다.**



#### 4. viewDidLoad()

이 메소드가 호출되는 시점에서는 이미 `outlet` 들이 모두 메모리에 위치하고 있습니다. 그러므로 사용자에게 화면이 보여지기 전 데이터를 뿌려주는 행위에 대한 코드를 작성할 수 있습니다. 또한 보통 화면이 로드되기 전 백그라운드에서 처리해주어야 하는 작업들이 위치하기 좋은데 그 예로는 네트워크 호출 등이 있습니다.

이 메소드는 View Controller의 생에 오로지 **한 번만 호출**이 됩니다. 그러므로 **<u>오로지 한 번만 일어날 행위들에 대해서는 이 메소드 안에서 정의</u>**를 해주어야 합니다. 주기적으로 데이터가 변경되거나 하는 행위는 다른 메소드에서 정의해주어야 합니다.



#### 5. viewWillAppear(_:)

이 메소드는 View Controller의 화면이 올라오고 난 이후에 호출되는 메소드입니다. 

처음 어플리케이션이 수행되고 첫 화면이 띄어질 때도 호출이 되는 것은 `viewDidLoad()`와 동일하지만 **화면 전환을 통해 다시 현재의 화면으로 돌아올 때도 `viewWillAppeare(_:)`는 호출**됩니다.

Frame이 배치되지 않았으므로 Frame과 관련된 조작을 하면 안된다.

#### 6. viewDidAppear(_:)

View Controller의 **뷰가 데이터와 함께 완전히 화면이 나타나고 호출되는 메소드**입니다.

이 메소드에서는 UI내의 애니메이션을 실행시키거나, 비디오나 소리를 재생하는 행위, 그리고 뿌려지는 데이터의 업데이트를 수행할 수 있습니다.

화면에 적용될 애니메이션을 그리거나 API로 부터 정보를 받아와 화면을 업데이트 할 때 이곳에 로직을 위치시키면 좋습니다. 왜냐하면 지나치게 빨리 애니메이션을 그리거나 API에서 정보를 받아와 뷰 컨트롤러를 업데이트 할 경우 화면에 반영되지 않습니다.

Frame 배치가 완료되었으므로 Frame 써도 무방

- **viewDidAppear**, **viewWillLayoutSubviews**, **viewDidLayoutSubviews**.



#### 8. viewWillDisappear(_:)

다음 View Controller로 화면이 전환되기 전, **Original View Controller가 화면에서 사라질 때 이 메소드가 호출**됩니다. 여러분은 이 시점에서 해야할 일반적인 작업들은 거의 없기 때문에 굳이 `override` 할 필요는 없지만 몇몇 필요한 경우가 있기도 하지만 이번 포스팅에서는 기본적인 요소에 대해서만 다루기 때문에 언급하지 않도록 하겠습니다.

------

#### 9. viewDidDisappear(_:)

View Controller들이 화면에서 사라지고 나서 이 메소드가 호출됩니다. 여러분은 화면에서 **View Controller가 사라진 이후에는 멈추어야할 작업들 이 메소드를 `override`하여 작성**할 수 있습니다. 예를 들어 notification을 듣는 행위를 멈추기, 다른 객체의 속성을 observing하는것을 멈추기, 디바이스의 센서를 점검하거나 네트워크를 호출하는 행위들은 화면이 사라지고 나서는 필요 없는 작업들입니다.

------

#### 10. deinit()

다른 모든 객체와 마찬가지로 **View Controller가 메모리에서 사라지기 전 이 메소드가 호출**됩니다. 대개 여러분은 이 메소드를 **<u>할당 받은 자원 중 ARC에 의해 해지가 불가능한 자원들을 해제하기 위해 `override` 할 수**</u> 있습니다. 또한 **<u>백그라운드에서 돌리기 위해 이전의 메소드에서 멈추지 못하였던 행위들을 이 메소드 내에서 멈출 수</u>** 있습니다.

<u>View Controller가 화면에서 사라지는 것이 **메모리에서 해지된다는 것을 의미하지 않는다**는 것을 명심</u>하셔야 합니다. 즉 화면에서 사라진다고 메모리에서 해지되는 것은 아닙니다. 많은 Container View Controller들이 그들의 View Controller들을 메모리에서 유지하고 있기 때문입니다.

![img](https://miro.medium.com/max/1665/1*etDLgjBamDJoiaM3_hie9A.png)





-----

## UIView vs UIViewController

- **`UIView`**는 `유저에게 data를 표시`하고, `user의 input을 입력받는 역할`을 하는 객체이다.

  - 1. **Drawing and animation**

    - Views draw content in their rectangular area using UIKit or Core Graphics.
    - Some view properties can be animated to new values.

  - 1. **Layout and subview management**

    - Views may contain zero or more subviews.
    - Views can adjust the size and position of their subviews.
    - Use Auto Layout to define the rules for resizing and repositioning your views in response to changes in the view hierarchy.

  - 1. **Event handling**

    - A view is a subclass of [`UIResponder`](https://developer.apple.com/documentation/uikit/uiresponder) and can respond to touches and other types of events.
    - Views can install gesture recognizers to handle common gestures.

    

- **`UIViewController`**는 `유저에게 표시할 data가 무엇인지 파악`하고, `유저의 input으로부터 무엇을 할지 결정`하는 객체이다.

  - **Update** views contents
  - **Responding** to user interactions with views.
  - **Resizing** views and managing the layout of the overall interface.
  - **Coordinating** with other objects—including other view controllers—in your app.

---



#### 1. Bounds 와 Frame 의 차이점을 설명하시오.

- 답변 : 

  - 자식 요소로 추가될 UIView 는 자신이 보여질 위치와 크기가 결정되어야 한다. **자식 UIView 요소들의 위치의 기준점은 부모요소의 기준점으로부터 계산**된다.
    - **UIView의 위치와 크기는 일반적으로  frame 속성을 통해 결정**되며, 이를 위해 UIView는 initWithFrame: 초기화 메소드를 제공

  ##### 예시

  - UIWindow 와 UIImageView(이미지를 컨텐츠로 갖는 UIView)로 구성된 화면이다. UIImageView 는 UIWindow 의 자식요소이다. UIImageView 의 frame 과 bounds 값은 다음과 같다. – ( x, y, width, height ) 로 표시
    - frame : (40, 40, 240, 380)
    - bounds : (0,0, 240, 380)
  - frame 과 bounds 의 너비, 높이 값은 (240,380)으로 동일하나 (x,y)좌표는 다르다.
  - **frame 의 좌표는 부모요소를 기준으로** 한다. 위 화면에서UIImageView는 UIWindow 기준점으로부터 x 축으로 40, y 축으로 40 만큼 떨어진 지점에 위치함으로 frame 의 (x,y) 좌표는 (40,40) 이 된다.
  - 반면에 **bounds 는 자신을 기준으로** 한다. 따라서 (x,y) 는 (0,0) 을 가진다. 일반적으로  bounds 값은 (0,0,width,height) 이다.

  

----



#### 2. 실제 디바이스가 없을 경우 개발 환경에서 할 수 있는 것과 없는 것을 설명하시오.

- 답변 : [iOS Simulator vs Physical iOS Devices for App Testing](https://www.browserstack.com/test-on-ios-simulator)

- UI 레이아웃 테스트와 기본적인 앱의 기능 테스트 만 시뮬레이터에서 지원한다.

- | iOS App Functionality                                        | iOS Simulator | Physical iOS Device |
  | ------------------------------------------------------------ | ------------- | ------------------- |
  | <u>Basic functionality testing of iOS apps</u>               | O             | O                   |
  | <u>UI Layout testing</u>                                     | O             | O                   |
  | UI performance (transitions and animations)                  | X             | O                   |
  | System testing (bringing your app to foreground and background) | X             | O                   |
  | **Real User-condition testing** (testing interrupts, battery consumption, CPU & memory utilisation) | X             | O                   |
  | **Push Notifications**                                       | X             | O                   |
  | **Natural gestures** (tap, scroll, zoom, pinch, pinch and zoom and more) | X             | O                   |
  | Display (resolutions, pixel per point, colors)               | X             | O                   |
  | **Hardware functionality (bluetooth, gps, motion support, barometer, proximity sensor, ambient light sensor and more)** | X             | O                   |
  | **Camera**                                                   | X             | O                   |
  | **App performance testing (processing, graphics, networking speed, etc.)** | X             | O                   |
  | OpenGL ES support                                            | X             | O                   |
  | **Framework Support** (ARKit, External accessory, HomeKit, IOSurface, Message UI, etc) | X             | O                   |
  | API Feature Support (Metal, Metalkit, UIBackgroundModesKey, Support for handoff, UIVideoEditorController in UIKit) | X             | O                   |
  | 100 % Testing accuracy                                       | X             | O                   |

https://stackoverflow.com/questions/13235702/testing-ios-testing-on-real-devices-vs-simulator



------



#### 3. 앱이 foreground에 있을 때와 background에 있을 때 어떤 제약사항이 있고, 상태 변화에 따라 다른 동작을 처리하기 위한 델리게이트 메서드들을 설명하시오.

[앱 생명주기(App Lifecycle) vs 뷰 컨트롤러 생명주기(ViewController Lifecycle) in iOS](https://medium.com/ios-development-with-swift/앱-생명주기-app-lifecycle-vs-뷰-생명주기-view-lifecycle-in-ios-336ae00d1855)

https://blog.yagom.net/480

http://geekluo.com/contents/2014/06/28/24-ios-being-a-responsible-background-app.html

#### background 에 있는 경우 제약사항

- 기본적으로 백그라운드에 있는 앱은 foreground에 있는 앱에게 자원의 우선순위가 밀린다. 즉, 언제든지 자원을 반납하는 것에 따른 준비가 되어있어야 한다. 

- 기본적으로 몇가지 가능한 모드를 선택해서 시스템에게 요청하는 경우를 제외하고는 다음의 사항들을 지켜야 한다. 
- 코드에서 시각화와 관련된 어떠한 호출도 있어서는 안된다. 
- 네트워크 기반 소켓들의 연결 실패를 다루기 위한 준비를 해야 한다. 
- 현재 작업 중인 서비스들이 앱이 중지가 되기 전에 취소시킨다.
- 백그라운드 가기 전에 앱 상태를 저장해야 한다. 
- 백그라운드 이동 전에 불필요한 객체의 강한 참조를 제거해야 한다.
- shared system resource 사용을 중지한다.
- 민감한 정보를 뷰에서 제거한다.
- 백그라운드에서 작업되는 일을 최소로 한다.

#### background에서 할 수 있는 작업

- 오디오, AirPlay
- Location updates (사용자 위치정보 제공 받기 )
- VoIP (인터넷 전화)
- 외부 액세서리 등과의 통신
- 데이터 다운로드 및 처리

#### 상태 변화에 따라 다른 동작을 처리하기 위한 Delegate 메서드

- **`application:willFinishLaunchingWithOptions`**: **앱 런칭이 끝나기 전 불리는 메소드**로, 앱 런칭 타임에서 코드를 실행할 수 있는 첫 번째 시점입니다.
- **`application:didFinishLaunchingWithOptions`** : **앱 런칭 시점에서 Application 단의 초기화 작업등을 수행**할 수 있습니다.
- **`applicationDidBecomeActive`** : <u>**Active 상태로** 전이 될 때</u> 호출됩니다. Background 상태의 앱이 다시 호출되어 Active 상태가 되도 호출됩니다.
- **`applicationWillResignActive`** : 앱이 <u>**Active 상태를 벗어나기 전에** 호출</u>됩니다. (ex. 홈 버튼을 누르면 호출됨) 단, 앱이 Background 상태로 전이된다는 보장은 없습니다. In-Active에 잠깐 머물다가 다시 바로 Active 상태로 바뀔 수도 있습니다.
- **`applicationDidEnterBackground`** : Background로 진입 후 호출됩니다. 언제든 System에 의해 Suspended 상태로 전이될 수 있으므로 나중에 재생성할 수 있는 모든 리소스들을 제거하고 사용자 데이터를 저장한는 등의 작업을 수행하는 용도로 사용할 수 있다. 이 메소드 호출 이전에 applicationWillResignActive가 호출됩니다.
- **`applicationWillEnterForeground`** : **Background를 벗어나 Foreground로 진입될 것**을 알려준다. (아직 Active 상태는 아님) <u>applicationDidEnterBackground 에서 해제한 리소드들을 재생성하는 용도로 사용</u>할 수 있습니다. **이 메소드 호출 뒤에 `applicationDidBecomeActive`가 호출**됩니다.
- `applicationWillTerminate` : 앱이 종료될 것임을 알려줍니다. 앱이 **Suspended 상태에서 종료되는 것이라면 호출되지 않는다.**



---

#### 4. scene delegate에 대해 설명하시오.

https://developer.apple.com/documentation/uikit/uiscenedelegate

app delegate에서는 key window 하나만 보이도록 지정 가능했으나, 하나의 앱에 여러 scene 을 구성하여 작동하도록 바뀜. 이에 따라 기존에 AppDelegate(UIApplicationDelegate) 에서 담당하던 역할 중 앱 런칭 이후의 상태 전이와 관련된 동작을 담당하게 되었다.



-----

### 5. 앱이 In-Active 상태가 되는 시나리오를 설명하시오.

- In-Active 상태는 앱이 Foreground에서 실행중이나, 이벤트를 받을 수 없는 상태를 말한다. 이 상태는 잠시 머물렀다가 다른 상태로 전이된다.

  #### 1) 사용자가 앱을 실행하는 경우

  - > Not Running » **In-Active** » Active

  1. ##### Not Running

  2. ##### In-Active

     - `application:willFinishLaunchingWithOptions`

     - `application:didFinishLaunchingWithOptions`

  3. ##### Active

     - `applicationDidBecomeActive`

  #### 2) 앱 실행 도중 홈 버튼 누를 경우 

  - > Active » **In-Active** » Background

  1. ##### Active

     - `applicationWillResignActive`

  2. ##### In-Active » Background

     - `applicationDidEnterBackground`

  #### 3) 백그라운드의 앱을 다시 키는 경우

  - > Background » **In-Active** » Active

  1. ##### Background

     - applicationWillEnterForeground

  2. ##### Active

     - applicationDidBecomeActive

  #### 4) 앱이 백그라운드에 있다가 Suspended 상태로 전이되는 경우

  - > Active » **In-Active** » Background » Suspended

  1. ##### Active

     - applicationWillResignActive

  2. ##### In-Active » Background

     - applicationDidEnterBackground

  3. ##### Suspended



#### 상태 변화에 따라 다른 동작을 처리하기 위한 Delegate 메서드

- **`application:willFinishLaunchingWithOptions`**: **앱 런칭이 끝나기 전 불리는 메소드**로, 앱 런칭 타임에서 코드를 실행할 수 있는 첫 번째 시점입니다.
- **`application:didFinishLaunchingWithOptions`** : **앱 런칭 시점에서 Application 단의 초기화 작업등을 수행**할 수 있습니다.
- **`applicationDidBecomeActive`** : <u>**Active 상태로** 전이 될 때</u> 호출됩니다. Background 상태의 앱이 다시 호출되어 Active 상태가 되도 호출됩니다.
- **`applicationWillResignActive`** : 앱이 <u>**Active 상태를 벗어나기 전에** 호출</u>됩니다. (ex. 홈 버튼을 누르면 호출됨) 단, 앱이 Background 상태로 전이된다는 보장은 없습니다. In-Active에 잠깐 머물다가 다시 바로 Active 상태로 바뀔 수도 있습니다.
- **`applicationDidEnterBackground`** : Background로 진입 후 호출됩니다. 언제든 System에 의해 Suspended 상태로 전이될 수 있으므로 나중에 재생성할 수 있는 모든 리소스들을 제거하고 사용자 데이터를 저장한는 등의 작업을 수행하는 용도로 사용할 수 있다. 이 메소드 호출 이전에 applicationWillResignActive가 호출됩니다.
- **`applicationWillEnterForeground`** : **Background를 벗어나 Foreground로 진입될 것**을 알려준다. (아직 Active 상태는 아님) <u>applicationDidEnterBackground 에서 해제한 리소드들을 재생성하는 용도로 사용</u>할 수 있습니다. **이 메소드 호출 뒤에 `applicationDidBecomeActive`가 호출**됩니다.
- `applicationWillTerminate` : 앱이 종료될 것임을 알려줍니다. 앱이 **Suspended 상태에서 종료되는 것이라면 호출되지 않는다.**



-----

#### 6.NSOperationQueue 와 GCD Queue 의 차이점을 설명하시오.

- 동작 방식은 유사.
- 인스턴스 생성 유무에 차이.
- 함수레벨 / 객체 레벨 
- OperationQueue와 달리 GCD는 원래 취소가 안되었으나, 현재는 된다. 취소 로직 구현 자체는 OQ가 더 쉽다.

#### NSOperationQueue

- Objective-C 객체
- 항상 Operation을 동시에 실행하지만, 종속성을 사용해 필요할 때 순차적 실행가능
- KVO(Key-value observing) 알림 생성, 작업 진행 상황을 모니터링하는 유용한 방법이 될 수 있음
- operation 우선 순위 지정을 지원한다. 실행 순서에 영향을 준다.
- 실행 중 조작을 정지 할 수 있는 canceling semantics 기능을 지원한다.



https://magi82.github.io/gcd-01/

## About Dispatch Queues

> GCD 는애플리케이션이 블록 오브젝트의 형태로 task들을 제출하는 FIFO 큐들을 제공한다.
>
> 디스패치 큐들에 제출된 작업들은 시스템에서 전적으로 관리되는 **스레드풀**에 의해 실행된다.
>
> 어떤 스레드가 어떤 작업을 수행할지에 대해 전적으로 보장되지는 않는다.

>  **Grand Central Dispatch는 멀티 코어 프로세서 및 기타 대칭 다중 처리 시스템이있는 시스템에 대한 응용 프로그램 지원을 최적화하기 위해 Apple Inc.에서 개발 한 기술.** 

> - **호출자(caller)와 관련하여 비동기/동기식으로 임의의 코드 블록을 수행**
> - dispatch queues를 사용하여 **별도의 쓰레드에서 수행하는 거의 모든 task를 수행**
> - dispatch queues를 사용하면, 쓰레드 생성 및 관리에 대해 걱정 할 필요 없이 실제로 수행하려는 작업에 집중 할 수 있다. **시스템이 모든 쓰레드 생성 및 관리를 처리**



### == Queue Type ==

#### 1) Serial Queue (private dispatch queues)

- 큐에 추가된 순서대로 한번에 하나의 task를 실행

- 현재 실행중인 task는 dispatch queues에서 관리하는 고유한 쓰레드(task마다 다를 수 있음)에서 실행

- Serial queues는 **종종 특정 자원에 대한 액세스를 동기화** 하는데 사용

- 필요한 만큼 Serial queues를 작성 할 수 있으며, 각 큐는 다른 모든 큐와 관련하여 동시에 작동함.

  ![grand central dispatch tutorial](https://koenig-media.raywenderlich.com/uploads/2014/09/Serial-Queue-Swift-480x272.png)



#### 2) Concurrent Queue ( 일종의 global dispatch queue)

- 동시에 하나 이상의 task를 실행하지만 task는 큐에 추가된 순서대로 계속 시작됨.
- 현재 실행중인 task는 dispatch queue에서 관리하는 고유한 쓰레드에서 실행
- 특정 시점에서 실행되는 정확한 task의 수는 가변적이며 시스템 조건에 따라 다름

- Global Dispatch Queue는 concurrent에 해당

![grand central dispatch tutorial](https://koenig-media.raywenderlich.com/uploads/2014/09/Concurrent-Queue-Swift-480x272.png)



### == Dispatch Queue Type ==

#### 1) The Main Queue

- 세가지 큐 중 가장 높은 스레드할당 우선순위를 지닌다.

- 모든 UI 작업은 메인 큐에서 수행된다.

- **Serial Queue**로 작동한다.

- 전역적으로 사용 가능하다.

- 종종 앱의 주요 동기화 지점으로 사용된다.

  ```swift
  // MainQueue
  DispatchQueue.main.async {
    // Do Any UI Update Here
  }
  ```

  

#### 2) The Global Queue

- 크게 다섯가지 타입으로 나뉜다. 타입에 따라 우선순위가 나뉜다.

- **Concurrent Queue** 방식이다.

- 타입은 `QoS (Quality of Service)` 에 따라 나뉜다.

- 우선순위가 높은 순서대로 나열하면 다음과 같다

  - ##### 1) userInteractive

    - 바로 수행되어야 하는 작업

  - ##### 2) userInitiated

    - 수 초 내에 이뤄져야 하는 작업

  - ##### 3) default

    - 잘 쓰지는 않음

  - ##### 4) utility

    - 수 초 ~ 수분 내에 이뤄져야 하는 작업 (30초 ~ 3분)
    - 나름 무거운 작업 수행에 필요

  - ##### 5) background

    - 수 분 ~ 수 시간 소요될 작업 
    - ex: 큰 계산, 큰 파일 다운로드 등

  ```swift
  /// Global Queue
  DispatchQueue.global(qos: .background).async{
    	/// Do Heavy Work Here
  }
  ```

  

#### 3) Custom Queue

- 위 두 개의 큐는 `시스템` 에서 관리하는 것

- GCD에서 사용할 dispatchQueue를 직접 설정하여 사용하는 것

- Custom Queue의 이름 (label)을 지정한다.

- `Quality of Service`를 지정해야 함

- 동기화가 보장되어야 하는 concurrent를 attribute로 설정할 수 있음. 설정하지 않는 기본은 SerialQueue가 된다.

  ```swift
  /// Custom Queue
  let concurrentQueue = DispatchQueue(label: "concurrent", qos: .background, attributes: .concurrent)
  let serialQueue = DispatchQueue(label: "serial", qos: .background)
  ```





-----

### 7. GCD API 동작 방식과 필요성에 대해 설명하시오.

##### 1) init (label:qos:attributes..) 

- 커스텀 dispatchQueue 생성을 위한 생성자.

##### 2) class func global(qos:)

-  qos 등급을 지닌 전역 시스템 큐를 리턴한다.



#### [ 비동기 작업 관련 메소드 ]

##### 1) func async(execution: DispatchWorkItem)

- 즉시실행하고, 즉시 리턴 받을 수 있는 비동기 처리를 위한 작업을 스케줄한다.

##### 2) func asyncAfter(deadline: DispatchTime, execute: DispatchWorkItem)

- 특정 시간에 실행할 블록을 스케줄하고, 즉시 리턴 받는다.

##### 3) func asyncAfter(deadline: DispatchTime, qos: DispatchQoS, flags: DispatchWorkItemFlags, execute: () -> Void)

- **특정 속성들을 사용**하여 실행할 블록을 스케줄한다.

##### 4) func asyncAfter(wallDeadline: DispatchWallTime, execute: DispatchWorkItem)

- **특정 시간 이후에 수행**하고, 즉시 리턴할 작업을 스케줄한다.

##### 5) func asyncAfter(wallDeadline: DispatchWallTime, qos: DispatchQoS, flags: DispatchWorkItemFlags, execute: () -> Void)

##### 7) func asyncAfter(wallDeadline: DispatchWallTime, qos: DispatchQoS, flags: DispatchWorkItemFlags, execute: () -> Void)

- 5)+6)



#### [ 동기 작업 관련 메소드 ]

##### 1) func sync(execute: DispatchWorkItem)

- 현재 큐에서 실행할 작업 아이템을 작성하고, **블록 실행이 끝난 후에 리턴**한다.

##### 2) func sync(execute: () -> Void)

- 실행을 위한 블록 객체를 작성하고, 블록 실행이 끝난 후에 리턴한다.

##### 3) func sync(execute: () -> T) -> T

- 실행을 위한 작업 아이템를 작성하고, 블록 실행이 끝난 후에 그 **결과를 리턴** 
- Submits a work item for execution and returns the results from that item after it finishes executing.

##### 4) func sync(flags: DispatchWorkItemFlags, execute: () -> T) -> T

- 특정 속성들을 사용하여 실행할 작업 아이템을 작성하고, 블록 실행이 끝난 후에 그 **결과를 리턴** 



#### [ 병렬 실행 관련 메소드 ]

##### 1) class func concurrentPerform(iterations: Int, execute: (Int) -> Void)

- 디스패치 큐에 단일 블록을 넘기고, 해당 블록이 지정된 횟수만큼 실행되도록 한다.

등등



----

- Dispatch Queue 외에도 다음의 GCD를 활용한 코드 관리 기술이 존재한다.
  - **Dispatch groups** : Dispatch groups은 <u>**완료(completion)을 위해 블록 객체 집합을 모니터링 하는 방법**</u>입니다. 그룹은 필요에 따라 동기적/비동기적으로 블록을 모니터링 할 수 있습니다. 그룹은 다른 task의 완료 여부에 따라 코드에 유용한 동기화 메커니즘을 제공합니다.

  

  - **Dispatch semaphores** : Dispatch semaphores는 전통적인 세마포어와 유사하지만, 일반적으로 더 효율적입니다. 세마포어를 사용 할 수 없기 때문에 호출 쓰레드(calling thread)를 차단해야하는 경우에만 세마포어가 커널로 호출됩니다. 세마포어를 사용 할 수 있으면, 커널 호출이 수행되지 않습니다. 

  

  - **Dispatch sources** : dispatch source는 특정 타입 시스템 이벤트에 대한 응답(response)으로 notifications을 생성합니다. Dispatch sources를 사용하여 프로세스 notifications, 신호(signal) 및 descriptor events와 같은 이벤트를 모니터링 할 수 있습니다. 이벤트가 발생하면 Dispatch sources는 처리를 위해 지정된 dispatch queue에 비동기적으로 task코드를 제출(submit)합니다. 

  https://zeddios.tistory.com/513



-----

#### 8. iOS 앱을 만들고, User Interface를 구성하는 데 필수적인 프레임워크 이름은 무엇인가?

- UIKit :  iOS나 tvOS 앱의 **그래픽요소**, **이벤트 드리븐 UI**를 **관리**하고 **구축**하는 용도로 쓰인다.



---

#### 9. Foundation Kit은 무엇이고 포함되어 있는 클래스들은 어떤 것이 있는지 설명하시오.

- 앱의 기본 기능을 위해 필수 데이터 타입들, 콜렉션들, 운영 체제 서비스 들을 정의해놓은 프레임워크이다.
- 숫자, 데이터, 불린 값 등 기본 값
- 문자열과 텍스트 
- 콜렉션
- 데이트와 시간
- 단위, 측정
- 노티피케이션 
- Extension
- 에러와 예외처리 등

----

#### 10. Delegate란 무언인가 설명하고, retain 되는지 안되는지 그 이유를 함께 설명하시오.

- 객체 지향 프로그래밍에서 **하나의 객체가 모든 일을 처리하는 것이 아니라 처리 해야 할 일 중 일부를 다른 객체에 넘기는 것을 뜻한다.**
- 통상 뷰컨트롤러에서 Delegate를 채택하는 경우, `viewDidLoad()`에서 **1) 위임자(대리자)가 누구인지 알려주는 과정**을 거치고 (ex, `테이블뷰, textField등의 delegate = self` (=view controller) 로 지정한다.) **2) 해당 Delegate를 통해 구현해야 할 메서드를 구현하는 과정** 을 거쳐 Delegate를 구현한다.
- **Delegate는 프로토콜로 구현**된다.
  - 프로토콜은 서로간에 지켜야 하는 규약으로, 해당 규약은 프로토콜을 채택한 클래스를 정의할 때, 프로토콜의 메소드를  구현하며 준수된다.
- delegate를 [ weak 선언 안하면 ] retain 된다.

----

#### 11.NotificationCenter 동작 방식과 활용 방안에 대해 설명하시오.

- delegate( 1:1 관계) 보다 좀 더 유연 (1:N 관계). sender와 Name 등으로 
- 느슨한 관계.



-----

#### 12.UIKit 클래스들을 다룰 때 꼭 처리해야하는 애플리케이션 쓰레드 이름은 무엇인가?

- app's **main thread** 또는 **main dispatch queue**



----

#### 13.TableView를 동작 방식과 화면에 Cell을 출력하기 위해 최소한 구현해야 하는 DataSource 메서드를 설명하시오.

- tableView(:numberOfRowsInSection:) -> Int 

  - ##### 섹션 하나에 들어갈 Row의 갯수를 설정하는 메서드 

- tableView(: cellForRowAt indexPath: IndexPath) -> UITableViewCell

  - ##### 테이블 뷰 내부의 재사용가능한 셀에 데이터를 바인딩하는 메서드

  

-----

#### 14. 하나의 View Controller 코드에서 여러 TableView Controller 역할을 해야 할 경우 어떻게 구분해서 구현해야 하는지 설명하시오.

- 

  

-----

#### 15.App Bundle의 구조와 역할에 대해 설명하시오.

https://developer.apple.com/library/archive/documentation/CoreFoundation/Conceptual/CFBundles/BundleTypes/BundleTypes.html#//apple_ref/doc/uid/10000123i-CH101-SW1

##### App bundle 구조 

- bundle Package 구조 
  - Info.plist file : 앱의 메타 데이터를 저장하고 있는 Property List 파일
  - Executable : 앱 실행 파일 
  - Resource files : 앱 아이콘, 시작이미지, UI 구성 이미지 등
  - Other support files : 배포용 아이콘 이미지 등 
- bundle package 폴더 내에 컴파일된 바이너리 파일과 로컬 리소스 파일을 묶어서 배포할 수 있는 구조.
- iOS 앱에서는 앱 번들 구조가 스토어에 올라가는 경우, 개발자의 시그니처(서명)이 같이 포함된다. 
- 앱스토어에서 사용자의 폰에 앱을 설치하는 경우, 앱이 설치되는 폴더 아래에 앱의 UUID가 발행되어 read-only 형태로 설치된다.



----

### 16.View 객체에 대해 설명하시오.

#### View

- 사각영역에 앱 데이터를 시각적으로 표시하는 역할을 담당하는 UIView 객체이다.
- 자신의 영역에서 발생하는 이벤트를 처리한다.
- 데이터 변경될 때 마다 내용을 다시 그린다. 
- 뷰는 하위에 다른 뷰를 포함할 수 있으며, 상위 뷰는 하위 뷰의 배치와 계층구조를 관리한다.



----

### 17.UIView 에서 Layer 객체는 무엇이고 어떤 역할을 담당하는지 설명하시오.

- Layer 객체는 시각적 내용을 나타내는 데이터 객체로서, **뷰가 내용을 렌더링하는 데 사용**한다. 또한 사용자 지정 layer 객체를 인터페이스에 추가하여 복잡한 **애니메이션** 및 기타 유형의 **정교한 시각 효과를 구현**할 수 있다.
- 뷰는 레이어 객체를 지니며, `layer` 속성을 통해 접근한다.
- 레이어는 뷰를 통해 그려지는 데이터를 내부 저장소에 **캐시** 로 저장한다. 
  - 뷰의 그리기 코드 실행시 캐시 데이터가 생성, 코드가 다시 실행되기 전까지 캐시를 사용하여 화면을 그림
  - 캐시의 재사용이 앱의 렌더링 성능을 향상시킨다.

### 18.UIWindow 객체의 역할은 무엇인가?

#### UIWindow 객체

- 화면에 뷰를 출력하는 역할을 담당.
- 대부분의 앱은 하나의 윈도우를 지니나, 외부 디스플레이 지원하는 경우, 그 이상의 윈도우 가질 수 있음.
- 윈도우는 생성 후 교체되거나 변경되지 않음
- 윈도우에 표시되는 뷰가 교체될 뿐
- 뷰의 계층 구조를 관리하여 뷰와 뷰 컨트롤러 사이에서 발생하는 이벤트를 대상 객체로 전달한다.

- 시각적 요소 없음 (<-> macOS)
- 다음의 기능 제공
  - 윈도우의 Z-Index 설정
  - 키보드 입력 대상으로 설정
  - 좌표 변환
  - 최상위 뷰 컨트롤러 설정 

#### 19.UINavigationController 의 역할이 무엇인지 설명하시오.

- 화면을 나타내주는 뷰 컨트롤러를 관리하는 역할이다.
- 뷰를 네비게이션 스택에 담아두기 때문에 컨테이너 뷰 컨트롤러이기도 하다.
- 뷰의 push 전환 시 스택에 남아있는 뷰 컨트롤러는 사라지지 않기 때문에 뒤로 가면 기존 뷰컨트롤러가 나타날 때 viewDidLoad 가 재호출되지 않는다.



#### 20. 모든 View Controller 객체의 상위 클래스는 무엇이고 그 역할은 무엇인가?

>  **UIViewController**
>
> 모든 뷰 컨트롤러의 **공통된 행동을 정의**한다.



---------

#### 21.앱이 시작할 때 main.c 에 있는 UIApplicationMain 함수에 의해서 생성되는 객체는 무엇인가? (=> UIApplication객체)

- 모든 iOS앱에는 UIApplication인스턴스가 "하나만" (exactly one instance)있습니다. (또는 매우 드물게 UIApplication의 하위클래스)

  - 앱이 시작되면, 시스템은 **`UIApplicationMain(_:_:_:_:)`** 함수를 호출합니다. 

  - 이 함수는 다른 task들 중에서 싱글톤 **`UIApplication객체`를** 만듭니다.

  - 그런 다음, shared클래스 메소드를 호출하여 객체에 접근함.

  - https://zeddios.tistory.com/539

  - 즉, **`UIApplicationMain(_:_:_:_:)`** 함수는 shared app instance를 만든다.

  - **`UIApplicationMain(_:_:_:_:)`** 는 **application** 객체와 **application delegate**를 만들고, 이벤트 사이클을 설정하는 역할을 지닌다.

    - 스토리보드에서 **앱의 UI를 로드**
    - **사용자 지정 코드를 호출**해 초기 설정
    - **앱의 RUN LOOP를 실행**해 이 프로세스를 처리

    

#### 22.UIApplication 객체의 컨트롤러 역할은 어디에 구현해야 하는가?

- ##### **`AppDelegate`** 객체 

- AppDelegate는 **UIApplication 객체와 서로 연결**되어 앱의 초기화, 상태변화, 기타 이벤트를 핸들링하는 역할

  출처: https://sibalja.tistory.com/3 [eternity]



#### 23.앱의 콘텐츠나 데이터 자체를 저장/보관하는 특별한 객체를 무엇이라고 하는가?

- raw file, APIs, Property List, Serialization, Core Data, Realme같은 라이브러리, NSCoding 등

- 가벼운 데이터는 NSCoding / Codable

  - 디스크에 데이터를 지속하기 위한 간단한 방법이 필요하다면 NSCoding 과 Codable은 좋은 선택입니다. 하지만, 둘다 복잡한 객체 그래프 생성과 쿼리하는것을 지원하지 않습니다. 

- NSCoding과  Codable 단점

  - NSCoding의 주된 단점은 Foundation에 의존해야 한다는 것
    - JSON 직렬화 불가
  - Codable은 어떤 프레임워크도 의존하지 않지만 Swift에 모델을 작성해야
  - Codable은 모델을 JSON으로 쉽게 직렬화 하기위해 사용

- 무거운 데이터는 Core Data나 Realm

  - 복잡한 객체 그래프 생성과 쿼리하는것을 지원

  

----

#### 24. 앱 화면의 콘텐츠를 표시하는 로직과 관리를 담당하는 객체를 무엇이라고 하는가?

- ViewController 이다. 





----

### 25. Swift의 클로저와 Objective-C의 블록은 어떤 차이가 있는가?

- 클로저 : 람다 계산식의 구현체. 익명 함수를 포함한다. 함수를 `func` 키워드로 선언하는 것이 아니라, 함수를 `변수에 선언하는 형태`

  - 함수처럼 바깥 스코프 접근할 변수나 객체가 있는 경우,  내부에서 **클로저 선언 시점**에 해당 변수/객체를 캡처링하여 사용한다. 캡처링의 경우, **캡처 리스트** 필요
  - 기본적으로 reference 방식으로 동작.

- Objective-C : c 레벨의 블록. 기본적으로 캡처리스트로 동작. 

  -  기본적으로는 원본과 공유되지 않는 값으로 클로저 선언시점의 변수값을 복사하거나, 외부 변수 값을 참조시에 해당 값을 변경할 수 없는 형태로 캡처링한다.
  - `__block` 키워드 선언시 스위프트와 유사하게 참조 형식으로 값을 캡처링하여 변경가능함.

  

- 상호 호환성 문제 : 기본적으로는 호환되나, Objective-C에서 소화할 수 없는 튜플 등의 자료형을 담는 경우, 호환되지 않는다.





----

### 26. App의 Not running, Inactive, Active, Background, Suspended에 대해 설명하시오. 

- 각각의 5개는 App State 종류를 의미한다. 

##### [ 초기 ]

- **Not running** : 앱이 실행되지 않았거나, 시스템에 의해 종료된 상태

##### [ Foreground 상태 ]

- App이 실행되어 사용자에게 보여지고 있는 상태입니다.
- <u>오직 하나의 App만 Foreground 상태를 가지며</u> inActive와 Active의 두가지 상태로 나뉘어집니다.

- **In-Active** : 앱이 foreground에서 실행되었으나, 이벤트는 수신하지 않은 상태. iOS 앱이 상태 변환을 할 때 머무는 단계 
- **Active** : 앱이 실행되고 있는 상태. 가장 일반적인 상태

##### [ Background 상태 ]

- **Background** : 앱 실행 중에 홈버튼, 앱 전환으로 Active에서 Suspended로 변하기 전에 머무는 단계
  - 사용자에 의한 이벤트는 받지 못하지만 소스코드는 수행이 가능하다. 추가적인 수행이 필요한 경우 시간을 늘릴 수 있다.
  - 멀티 태스킹을 위해 제어해야 하는 부분 
  - 1) 오디오, 비디오 플레이어(Sound only)는 백그라운드에서 동작 가능하다.
  - 2) Location : GPS 제어 

##### [ 종료 ]

- **Suspended** : 앱이 중단된 상태. 메모리는 있지만 코드는 수행되지 않은 상태.
  - App에 여전히 메모리에 존재하며 Suspend 상태가 될 당시의 상태를 저장하고 있지만, CPU나 배터리를 소모하지 않습니다
  - 메모리 부족 발생시 시스템은 이 상태의 앱을 죽일 수 있다.
  - ![state change](https://t1.daumcdn.net/cfile/tistory/1113BD4750FCEF6232)

#### **Monitoring App State Changes**

- **application:willFinishLaunchingWithOptions** : 어플리케이션의 초기화 작업
- [**applicationDidBecomeActive**:](http://developer.apple.com/library/ios/DOCUMENTATION/UIKit/Reference/UIApplicationDelegate_Protocol/Reference/Reference.html#//apple_ref/occ/intfm/UIApplicationDelegate/applicationDidBecomeActive:) Active 상태로 될 때 호출. 
- **applicationWillResignActive**: 앱이 Active 상태에서 변할 때 알려주는 함수.
- **applicationDidEnterBackground**: Background로 진입 시 호출되는 함수
- **applicationWillEnterForeground**: Background에서 Foreground로 진입 시 호출 되는 함수
- **applicationWillTerminate**: 앱이 종료될 때 호출되는 함수. Suspended 상태에서 시스템에 의해 메모리 해제되어 앱이 죽는 경우는 호출되지 않습니다.



https://winplz.tistory.com/entry/About-iOS-Multitasking

---

#### 27. App thinning에 대해서 설명하시오.

- 앱을 다운받을 때, 사용자의 디바이스 환경에 맞는 정보들을 최적화하여 필요한 양식의 데이터들만 받아서 운영하는 방식/기술을 의미한다. app slicing은 App thinning을 위한 기술이다.

- 앱스토어에서 앱이 다운로드되기전에 **디바이스에 맞게 앱을 최적화 하여 바이너리를 새로 만들어 제공**하는데, 이 때 앱의 데이터를 Bitcode 형식이라고 한다. 기계코드도아니고, 고차원 레벨 코드도 아닌 중간수준의 코드 형태이다.

- Bitcode는 다른 아키텍쳐에 대한 최적화를 "제거"하여 다운로드는 더 작게 만듬 / **관련 최적화만 다운로드하여 위에 언급한 App Thining 기술(App slicing)과 함께 사용**
- 위와 같이 앱을 최적화 하기 위해서는 앱스토어에 앱을 **"intermediate representation"으로 archive해야 한다.**

출처: https://zeddios.tistory.com/655 [ZeddiOS]

----

#### 28. Global DispatchQueue 의 Qos 에는 어떤 종류가 있는지, 각각 어떤 의미인지 설명하시오.

- ##### 총 여섯가지

  - ##### 1) userInteractive

    - 바로 수행되어야 하는 작업

    - 사용자 인터페이스(UI) 새로고침 또는 애니메이션 수행과 같이 사용자와 상호작용 하는 작업

      

  - ##### 2) userInitiated

    - 수 초 내에 이뤄져야 하는 작업
    - 사용자가 시작한 작업이며, 저장된 문서를 열거나, 사용자 인터페이스에서 무언가를 클릭할 때 작업을 수행하는 것과 같은 즉각적인 결과가 필요

  - ##### 3) default

    - 잘 쓰지는 않음

  - ##### 4) utility

    - 수 초 ~ 수분 내에 이뤄져야 하는 작업 (30초 ~ 3분)
    - 나름 무거운 작업 수행에 필요
    - 작업을 완료하는 데 약간의 시간이 걸릴 수 있으며, 데이터 다운로드 또는 import와 같은 **즉각적인 결과가 필요하지 않습니다**.
    - 반응성, 성능 및 에너지 효율성 간에 **균형을 유지하는 데 중점**
    - progress Bar 등

    

  - ##### 5) background

    - 수 분 ~ 수 시간 소요될 작업 
    - ex: 큰 계산, 큰 파일 다운로드 등
    - 백그라운드에서 작동하며, indexing, 동기화 및 백업과 같이 **사용자가 볼 수 없는 작업**. 에너지 효율성에 중점

  - ##### 6) unspecified

    - 우선순위 미정 











## Autolayout

- ##### 오토레이아웃 장점

  - 뷰의 프레임보다는 **뷰의 관계**에 대해서 접근하는 방식으로 패러다임 전환을 시도함.
  - 오토레이아웃은 **두 뷰의 관계를 통해서 레이아웃을 결정**하는 것이며, 따라서 일련의 제한요소(constraint)등을 정의하여 내적 / 외적인 레이아웃 변경 요인에 대해 전향적으로 대응할 수 있게 한다.
  - 화면 크기/디바이스 방향에 따라 유연하게 업데이트 되는 UI를 비교적 쉽게 구현
  - 향후 새로운 해상도 디바이스 출시되도 일관된 UI 유지 가능
  - 화면 좌표 직접 계산, 수 많은 분기코드 작성 필요 없음
  - 지역화 문자열 사용에 편리
  - Content Hugging과 Compression Resistance 우선순위 조절하여 동적 UI 세부적으로 제어
  - 뷰 애니메이션, 모션 이펙트와 함께 사용 가능
  - 동일 계층 구조에 존재하지 않는 뷰 사이의 관계를 설정 가능

- ##### 오토레이아웃 주의사항

  - 뷰의 기하학적 정의를 frame, bounds, center를 통해서 정의하지 말 것
  - 가능하다면 스택뷰를 사용할 것. 스택뷰는 콘텐츠의 레이아웃을 자동으로 관리하며 따라서 제한요소에 필요한 로직을 대거 줄여줄 수 있다.
  - 뷰의 제한 요소는 가장 가까운 뷰와 관련지어 생성할 것
  - 뷰에 고정폭, 고정높이를 적용하는 것을 피할 것



-----



### 오토레이아웃을 코드로 작성하는 방법은 무엇인가? (3가지)

https://soooprmx.com/archives/7232

#### 1) 앵커 사용하기 `NSLayoutAnchor`

- 제한요소를 만들기 위한 유틸리티 클래스로 사용하기 쉬운 인터페이스를 제공하여 다양한 제약 요소들을 생성

- 대부분의 시각 요소들은 이러한 앵커들을 이미 가지고 있으며, 이들로부터 제약요소를 생성

  ```swift
  //myView의 좌우를 기본 레이아웃 마진을 사용하여 부모 뷰에 딱 고정하고,
  //그리고 myView의 높이를 가로의 2배로 사용하는 코드 
  let margins = view.layoutMarginsGuide
  myView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).aotive = true
  myView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).active = true
  myView.heightAnchor.constraint(equalTo: myView.widthAnchor, multiplier: 2.0)
  ```



#### 2) `NSLayoutConstraint` 를 사용하기

- 앵커를 사용하는 1의 문법들은 모두 조금 더 쓰기 쉬운 인터페이스를 이용해서 제약 요소값들을 생성하는 데, 이를 직접 이용하는 방법이 있다. 
- 이 방법은 매우 무식하며 가독성도 떨어지고 그만큼 실수하기도 쉽다. 따라서 매우 추천하지는 않는다

- ```swift
  NSLayoutConstraint(item: myView, 
                     attribute: .leading,
                     relatedBy: .Equal, 
                     toItem: view, 
                     attribute: .leadingMargin, 
                     multiplier: 1.0, 
                     constant: 0.0).isActive = true
  ```



#### 3) 비주얼 포맷 (VFL) 사용하기

비주얼 포맷 언어는 마치 아스키 아트처럼 보이는 문자열을 이용해서 제약요소값들을 생성하는 방식이다.

- 오토레이아웃의 디버깅은 콘솔을 통해 비주얼 포맷을 사용하여 출력한다. 따라서 디버깅시에 사용되는 포맷과 생성에 사용하는 포맷이 일치한다.
- 비주얼 포맷을 사용하면 여러 제약 요소를 한 번에 만들 수 있다.
- 유효한 제약요소들만이 만들어진다. (단, 모든 필요한 제약요소가 다 만들어지는 것은 아니다.)
- 완전성보다는 좋은 시각화에 집중한 방식이다. 따라서 일부 제약요소는 이 방식으로 만들 수 없다.
- 단 포맷은 컴파일 타임에 체크할 수 없다. 실행하여 확인할 수만 있다.

```swift
let views = ["myView": myView]
let formatString = "|-[myView]-|"
let constraints = NSLayoutConstraint.constraintsWithVisualFormat(formatString, 
    options: .AlignAllTop, 
    metrics: nil, 
    views: views)

NSLayoutConstraint.activateConstraints(constraints)
```

- 비주얼 포맷은 뷰의 한쪽 끝에서 끝까지를 다 정의해야 하는 것은 아니다. 
- 연관있는 뷰들만 포함하는 일부분을 만들 수 있다. 
- 이렇게해서 만들어지는 결과는 `Array` 타입이므로 이들 결과를 합한 다음에 `NSLayoutContraint.activateContraints(_:)`를 이용해서 한꺼번에 활성화할 수 있다.

비주얼 포맷을 사용하여 위 세개 뷰의 위치를 정의한 코드는 다음과 같다.

```swift
let views = ["redView": redView,
             "blueView": blueView,
             "greenView": greenView]

let format1 = "V:|-[redView]-8-[greenView]-|"
let format2 = "H:|-[redView]-8-[blueView(==redView)]-|"
let format3 = "H:|-[greenView]-|"

var constraints = NSConstraint.constraints(withVisualFormat: format1,
                    options: alignAllLeft,
                    matrics: nil,
                    views: views)
constraints += NSConstraint.constraints(withVisualFormat: format2,
                    options: alignAllTop,
                    matrics: nil,
                    views: views)
constraints += NSConstraint.constraints(withVisualFormat: format3,
                    options: []
                    matrics: nil,
                    views: views)
NSConstraint.activateConstraints(constraints)
```









-----

### **Intrinsic Size**에 대해서 설명하시오.

- Intrinsic Content Size : 뷰의 핵심적인 내용을 모두 표시랗 수 있는 가장 작은 영역의 크기

  - ex) 버튼의 Intrinsic size :  타이틀의 클리핑 없이 모두 출력할 수 있는 크기.
  - ex) label의 Intrinsic size : text 값을 클리핑 없이 출력할 수 있는 크기.

- 레이아웃 시스템은 레이아웃 과정에서 뷰가 Intrinsic size 갖고 있는지, 크기는 얼마인지 확인한다.

  - 이 크기와 주변 뷰 제약을 토대로 뷰의 크기를 계산함. 
  - 버튼, 레이블 같은 표준 뷰는 대부분 Intrinsic size 를 갖고 있으며, 표시되는 내용이 변경될 때 이 값이 함께 변경됨. 
  - slider와 같은 일부 뷰는 높이에 대해서만 Intrinsic size를 지닌다. 
  - 컨테이너 역할의 일부 뷰들은  Intrinsic size가 없다. 

- <u>뷰의 내용에 따라 크기가 자동으로 변경되는 장점</u>이 있음.

- 그러나, **뷰에 고정된 너비/높이 제약 추가시 이러한 장점이 발휘되지 않음.**

- 따라서 오토레이아웃을 사용할 때는 **고정된 너비/높이 제약 지정**은 **피해야 하는 안티패턴** 중 하나. 

  

  

### `hugging`, `resistance`에 대해서 설명하시오.

Intrinsic Size를 지닌 뷰는 런타임에 각 방향별 두 개의 제약을 자동으로 추가한다. 만약 Intrinsic Size가 (100, 50) 이라면 다음의 제약이 추가된다.

##### [hugging]

- 너비 <= 100 // 너비가 100보다 커지는 것을 막는다.
- 높이 <= 50  // 높이가 50보다 커지는 것을 막는다.

##### [resistance]

- 너비 >= 100
- 높이 >= 50

#### 	hugging (Content Hugging)

- Intrinsic Size를 통해 최대 크기에 제한을 두는 것을 의미한다.
- 주어진 크기보다 커질 수 있는 경우 사용한다.

#### 	Resistance ( Compression Resistance)

- 최소 크기에 제한을 두는 것
- 주어진 크기보다 작아질 수 있는 경우 사용한다.



----

#### 스토리보드를 이용했을때의 장단점을 설명하시오.

- 장점
  - 결과물에 대해 예측하기 쉬움
  - 속성 확인 가능
  - 소스코드를 일일이 기억하지 않아도 됨
- 단점
  - 무겁다
  - 링크가 끊어졌을 때 알기 힘들다.
  - 개발 내용을 알기 힘들다.
  - 충돌이 발생할 수 있다.

----

#### Safe Area 에 대해서 설명하시오.

- **iOS 11**에서 스크린 영역을 가리지 않는 UIViewController 기존 프로퍼티 topLayoutGuide, bottomLayoutGuide를 금지 시키고 **safe area를 소개** 했다.

  ```swift
  @available(iOS 11.0, *)
  open var safeAreaInsets: UIEdgeInsets { get }
  
  @available(iOS 11.0, *)
  open var safeAreaLayoutGuide: UILayoutGuide { get }
  ```

- `safeAreaInsets` 프로퍼티는 화면의 상, 하단 뿐만 아니라 **모든 면에서 화면을 가릴 수 있음을 의미**한다. 

  https://devmjun.github.io/archive/SafeArea_1

- #### **Left Constraint 와 Leading Constraint 의 차이점**을 설명하시오.

  - leading은 일반적으로 left를 의미하지만, **오른쪽에서 왼쪽으로 쓰는 언어로 설정되어 있는 경우**에는 **leading이 right를 의미**한다.

  



Screen (UIScreen)

- 디바이스에 설치되어 있거나 연결되어 있는 화면. `UIScreen.mainScreen` 메소드를 통해 참조를 얻을 수 있음 

-----

-----



## Swift

- #### Optional 이란 무엇인지 설명하시오.

  - 값이 있는 경우(Associated value가 구현)와 없는 경우를 나타내기 위한 Enum 구현체이다.

- **Fast Enumration** 이란 무엇인지 설명하시오.

- #### Struct 가 무엇이고 어떻게 사용하는지 설명하시오.

  - 여러 변수를 담을 수 있는 컨테이너 타입을 정의하는 것
  - 멤버 변수(프로퍼티), 함수(메서드) 정의가 가능.
  - 이니셜라이저를 정의하지 않으면, 기본적으로 모든 파라미터를 초기화 가능한 이니셜라이저를 제공한다.

- #### **instance 메서드와 `class 메서드`의 차이점**을 설명하시오.

  - `클래스 메서드`는 **`인스턴스를 생성하지 않고도 호출가능`**하다.
  - **인스턴스 메서드는 멤버 변수 접근 가능**하나 `클래스 메서드는 멤버 변수에 접근이 불가능`하다.
  - `객체가 어디에 있는지 몰라도 동작할 수 있는 일`을 클래스 메서드로 정의
  - `클래스 프로퍼티만 사용하는 경우` 클래스 메서드로 만듬
  - **객체가 어디에 있는지 알아야만 동작할 수 있는 일은 인스턴스 메서드로** 정의

- #### Delegate 패턴을 활용하는 경우를 예를 들어 설명하시오.

  - 어떤 객체가 해야 하는 일을 부분적으로 확장해서 대신 처리한다.
  - **대신 처리 해줄 객체(Delegate 실행 객체 - ViewController)** 와 **처리하라고 시키는 객체(위임 객체 - tableView)** 로 나뉜다.

- #### Singleton 패턴을 활용하는 경우를 예를 들어 설명하시오.

  - UIApplication 객체
  - FileManager
  - NotificationCenter
  - UserDefaults 객체
  - URLSession 객체 등
  - 

- KVO(Key-Value-Observing) 동작 방식에 대해 설명하시오.

  - http://seorenn.blogspot.com/2017/07/kvo-key-value-observing.html

- #### **Delegates와 Notification 방식의 차이점**에 대해 설명하시오.

  - 1:1의 소통 방식과 1:N의 소통 방식. 
  - Notification은 전역적으로 소통이 가능한 객체.
  - Notification 종류에 따라 Name을 설정하고, Notification에 따른 selector 구현 메소드를 커스텀하여 사용한다.

- #### 멀티 쓰레드로 동작하는 앱을 작성하고 싶을 때 고려할 수 있는 방식들을 설명하시오.

  - NSThread
    별도의 메소드를 스레드 함수로 등록하는 형태로 만들어 동작시키는 방법

  - ##### NSOperationQueue

    큐에 작업을 쌓아두고 이 작업들을 병렬로 처리하기 위한 클래스
    개별 작업을 개별 스레드에서 가능한 만큼 병렬로 한번에 실행시키려고 하는 성격

  - ##### GCD ( Grand Central Dispatch )

    멀티쓰레딩을 위해 애플이 만든 API
    동기 비동기 처리가 가능하며,  적절한 Dispatch Queue 와 Qos를 사용해야 한다

- MVC 구조에 대해 블록 그림을 그리고, 각 역할과 흐름을 설명하시오.
- ![img](https://github.com/fimuxd/RxSwift/raw/master/Lectures/23_MVVM%20with%20RxSwift/1.MVC.png?raw=true)
  - Model : 앱의 데이터를 관리한다.
  - View : UI 표현 및 관리. 유저와 상호작용
  - Controller : 중간에서 Model의 변화를 View에 알리거나, View로부터 받은 유저 상호작용을 Model에 전달한다. 
  - Delegate : View -> Controller 상호작용을 담당
  - NotificationCenter  : Model -> Controller 의 상호작용을 담당
- MVVM 구조
  - ![img](https://github.com/fimuxd/RxSwift/raw/master/Lectures/23_MVVM%20with%20RxSwift/2.MVVM.png?raw=true)
  - ViewModel은 아키텍처에서 센터역할을 한다. 이 녀석은 business 로직을 관리하고 model과 view 사이에서 통신
  - MVVM은 다음과 같은 규칙을 따른다.
    - **Model**은 다른 클래스들이 데이터 변경에 대한 notification을 내보내더라도 이들과 직접 통신하지 않는다.
    - **View Model**은 **Model**과 통신하며 여기서의 데이터들을 **ViewController**로 내보낸다.
    - View Controller는 View 생명주기를 처리하고 데이터를 UI 구성요소에 바인딩 할 때만 **View Model** 및 **View**와 통신한다.
    - (MVC 패턴에서처럼) **View**는 이벤트에 대해서만 view controller를 인식한다.
  - 여기서 의문이 생긴다. 그렇다면 View Model은 MVC에서의 View Controller가 하는 역할을 하는 놈인지? 그렇기도 하고 아니기도 하다.
  - 문제는 View Controller에 자꾸 View를 자체를 컨트롤하지 않는 코드를 채우는 것이다. MVVM은 이 문제를 해결하기 위해서 View Controller와 View를 한데 묶었다. 그리고 단독으로 View를 컨트롤할 책임을 할당한다.
  - MVVM 아키텍처의 또 다른 장점은 코드 테스트가 용이하다는 점이다. business 로직으로부터 view의 생명주기를 분리하기 때문에, view controller와 view 모두에 대해 명확하게 테스트 하는 것이 가능하다.
  - view model은 표현부에서 완전히 분리되어있고, 필요시에 platfrom들 사이에서 재사용이 가능하다. 즉, 단순히 view와 view controller 쌍을 대체하는 것만으로도 iOs, macOs, tvOS에까지도 마이그레이션이 가능하다.



- #### `프로토콜`이란 무엇인지 설명하시오.

  - 특정 인스턴스 메소드 및 타입 메소드가 타입을 준수하여 구현되도록 **요구**
  - 메소드 본문은 작성하지 않고, 정의만 담당
  - 저장 프로퍼티는 정의할 수 없다. (연산 프로퍼티, 타입 프로퍼티 만 가능)
  - 타입프로퍼티를 정의하는 경우, 타입메소드 요구사항에 `static` 키워드를 붙여야 한다.

  

- #### `Hashable`이 무엇이고, `Equatable`을 왜 상속해야 하는지 설명하시오.

  - Hashable : 정수의 **Hash값을 제공하는 타입.** 유일하게 표현이 가능한 방법을 제공할 수 있는 타입이라는 뜻.

  - Equatable : **값의 동일성을 비교 할 수 있는 타입**. 등호 연산자 및 같지 않음 연산자를 통해 동등성을 비교 할 수 있게 된다.

  - Hashable은 생성된 해시값의 비교가 필요하기 때문에 Equatable을 만족해야한다.

    

- #### `mutating` 키워드에 대해 설명하시오.

  - **값 타입의 인스턴스(구조체 등)**는 **메서드 안에서 값의 변경이 불가능**하다. 하지만 값 타입 인스턴스의 메서드가 <u>내부에서 데이터를 수정을 해야하는 경우</u>가 있다.
    이 때, <u>mutating키워드를 메서드에 선언</u>해주면 메서드 안에서 프로퍼티의 값 변경이 가능하다.

  

- #### **`탈출 클로저(@escaping)`** 에 대하여 설명하시오.

  - https://hcn1519.github.io/articles/2017-09/swift_escaping_closure

  - 클로저가 함수로부터 `Escape`한다는 것은 해당 함수의 인자로 클로저가 전달되지만, **함수가 반환된 후 실행** 되는 것을 의미.

  -  함수의 인자가 함수의 영역을 탈출하여 함수 밖에서 사용할 수 있는 개념은 기존에 우리가 알고 있던 변수의 `scope` 개념을 무시합니다. 왜냐하면 함수에서 선언된 로컬 변수가 로컬 변수의 영역을 뛰어넘어 **함수 밖** 에서도 유효하기 때문

  - 클로저의 `Escaping`은 `A 함수가 마무리된 상태에서만 B 함수가 실행되도록` 함수를 작성할 수 있다는 점에서 유용

  - > Escaping Closure를 활용하면 통해서 함수 사이에 실행 순서를 정할 수 있습니다.

  - 함수가 끝난 다음에 클로저가 호출되어 실행되는 경우에 사용된다. 

  

- #### **`Extension`**에 대해 설명하시오.

  - 구조체, 클래스, 열거형, 프로토콜타입에 새로운 기능을 추가할 수 있는 기능.
    기존 소스코드에서 접근하지 못하는 타입들을 확장하는 능력.

  - ##### 주요 기능 세가지 

    - 1) Default Implementation 을 가능하게 한다.
    - 2) 코드의 분리: 확장 영역과 그렇지 않은 부분을 나눈다.
    - 3) 프로토콜을 준수할 수 있도록 함.

    

- **접근 제어자의 종류엔 어떤게 있는지 설명**하시오.

  - public / open 

    - **모든 소스 파일 내에서 사용 가능**하며, 정의한 모듈을 가져오는 다른 모듈의 소스파일에서도 사용 가능. 일반적으로 Framework에 **공용 인터페이스를 지정할 때 사용**

  - internal 

    -  **엔티티가 정의 모듈의 모든 소스 파일 내에서 사용**되지만, **<u>해당 모듈 외부의 소스파일에서는 사용이 안된다.</u>** App 혹은 Framework의 내부 구조를 정의 할 때 사용

  - fileprivate

    - **자체 정의 소스 파일에 대한 엔티티 사용을 제한.** 
    - 세부 정보가 전체 파일 내에서 사용 될 때 특정 기능의 세부 정보를 숨길 수 있음

  - private 

    - **엔티티의 사용을 enclosing 선언과 동일한 파일에 있는 해당 선언의 extension으로 제한**. 
    - 단일 정의 내에서만 사용되는 특정 기능 조각의 구현의 상세 내역을 숨길 수 있음.

    

- #### **`defer`란 무엇인지 설명**하시오.

- 1. 함수 종료 직전에 실행되는 코드블럭을 의미한다. 네트워크 등의 연결에서 메모리 자원을 해제하기 위해 사용한다.

  2. defer 블록이 읽히기 전에 종료 되면 실행 되지 않는다.

  3. 가장 마지막에 호출된 defer 블록 부터 역순으로 호출 된다.

  4. defer블록을 중첩으로 사용할 때, 바깥쪽 블록 부터 호출 된다.
  5. 

  

  

  https://gogorchg.tistory.com/entry/iOS-Swift-defer-블록

- #### defer가 `호출되는 순서`는 어떻게 되고, defer가 `호출되지 않는 경우`를 설명하시오.

  - 가장 마지막에 호출된 defer부터 역순으로 호출되어 실행 되며, 중첩 사용시에는, 바깥쪽 블록부터 호출된다.

  - 특정 defer블록이 읽히기 전에 함수가 종료되면 실행되지 않는다.

  

- 이니셜라이저에 대해 설명
  - 기본 이니셜라이저 : 구조체/클래스에서 초기화 되지 않은 변수를 초기화하기 위해 사용.
  - convinience 이니셜라이저 : 선택. 기본 이니셜라이저를 반드시 호출.
  - required 이니셜라이저 : 반드시 구현해야 하는 이니셜라이저. 클래스 같은 경우, 특정 기본 이니셜라이저를 구현해야 하는 경우 required 이니셜라이저로 쓰낟.





## ARC

- #### ARC란 무엇인지 설명하시오.

  - Reference counting을 자동으로 하는 시스템. 컴파일러에 의해 retain 사이클을 파악한다. 

- #### Retain Count 방식에 대해 설명하시오.

  - Strong 형태로 참조가 되어있는 경우 retain count +1
  - weak, unowned 형태로 참조되어있는 경우 retain count 별도로 하지 않는다.

- #### Strong 과 Weak 참조 방식에 대해 설명하시오.

  - Strong 참조방식 : 객체에 대한 참조 카운트를 늘리는 방식. 해당 프로퍼티에 대한 참조소유가 일어난다.
  - Weak : 객체에 대한 참조 카운트를 늘리지 않는 방식. retain cycle을 방지한다.

- #### Weak vs Unowned

  - Weak은 제로잉이 수행된다. (참조된 weak 변수를 nil로 할당.) 
  - Unowned는 제로잉이 수행되지 않는다. (따라서 dangling point가 생성가능)

  

- #### ARC 대신 Manual Reference Count 방식으로 구현할 때 꼭 사용해야 하는 메서드들을 쓰고 역할을 설명하시오.

  - retain / release  / autorelease

  - #### retain 

    - Increases the retain count of an object by 1. Takes ownership of an object.

  - #### release

    - Decreases the retain count of an object by 1. Relinquishes ownership of an object.

    

- #### retain 과 assign 의 차이점을 설명하시오.

  - retain: 

  - assign: assign을 사용하면 **객체의 주소를 retain하거나 다른 방법으로 다루지 않고** <u>객체의 주소에 대한 속성 포인터를 설정</u>합니다.

  - https://jidolstar.tistory.com/735

  - delegate는 기본적으로 retain 대신 assign을 한다.

    -  만약 ViewController가 어떤 객체의 delegate대상으로 설정될때 retain을 해버리면 어떤 객체가 delegate를 release해주지 않는 이상 ViewController는 dealloc이 호출되지 않는 문제가 발생한다. 그러면 자연스럽게 메모리 릭(memory leak)이 발생한다. 그렇기 때문에 delegate는 assign을 해주는 것이다.

    

- #### 순환 참조에 대하여 설명하시오.

  - 외부의 참조 없이 두 개 이상의 객체가 사이클을 형성하여 서로 참조하는 경우.
  - ARC에 의해 메모리의 정상적인 해제가 일어나지 않는다.

  

- #### 강한 순환 참조 (Strong Reference Cycle) 는 어떤 경우에 발생하는지 설명하시오.

  - 한 객체의 프로퍼티로 할당된 객체가 다시 원본 객체를 참조하는 경우
  - 클래스 객체의 프로퍼티로 클로저가 할당되어 있고, 클로저 내부에 해당 클래스의 다른 프로퍼티를 강하게 참조하는 경우. retain cycle이 발생한다. 

  - ```swift
    class Thing { 
      var disposable: Disposable? 
      var total: Int = 0 
      deinit { disposable?.dispose() } 
      init(producer: SignalProducer<Int, NoError>) {  
        //disposable에 클로저 할당 => ref +1, 
        //클로저 내에서 Thing 인스턴스의 total 프로퍼티를 참조하여 ref +1
        disposable = producer.startWithNext { number in
            self.total += number 
            print(self.total) 
        } 
      } 
    }
    // 출처: https://greenchobo.tistory.com/3 [녹초보 이야기]
    ```

  - Self는 사용과 함께 **retain count**를 증가시키게 되는데 위의 코드 역시 closure가 self를 해제하여 retain count를 다시 낮춰준다면 문제가 없이 작동하게 되지만, **closure에 대한 참조가 disposable 프로퍼티에 의해 붙잡혀 있다면** 문제가 발생할 수 있다.

  - 이를 해결하기 위해 **[ weak self ]** 를 클로저 선언부에 명시하고, self 사용되는 부분에 self를 optional로 사용하여 strong reference cycle 상황을 피할 수 있다.

- 특정 객체를 autorelease 하기 위해 필요한 사항과 과정을 설명하시오.

  - 

- Autorelease Pool을 사용해야 하는 상황을 두 가지 이상 예로 들어 설명하시오.

  - 

- 다음 코드를 실행하면 어떤 일이 발생할까 추측해서 설명하시오. Ball *ball = [[[[Ball alloc] init] autorelease] autorelease];

  - 

## Functional Programming

- 함수형 프로그래밍이 무엇인지 설명하시오.
- 고차 함수가 무엇인지 설명하시오.
- Swift Standard Library의 map, filter, reduce, compactMap, flatMap에 대하여 설명하시오.





## iOS 앱 구성 객체

### UIApplication

- 앱 시작시 @UIApplicationMain 함수를 통해 생성된다.
- 모든 앱은 하나의 UIApplication 객체를 갖는다.
- 이벤트 루프를 관리하며 앱으로 전달되는 이벤트를 대상 객체로 전달한다.
- ![img](https://t1.daumcdn.net/cfile/tistory/261B584E573AFC0737)

### App Delegate (싱글톤)

@UIApplicationMain 함수를 통해 생성되는 싱글톤 객체이다.

중요한 시스템 이벤트 발생시 UIApplication 객체가 호출하는 메소드를 구현한 Delegate 객체이다.

- 앱의 초기화 코드를 구현한다. 

- 앱 상태 전환시 필요한 작업을 수행한다.
- 앱으로 전달되는 푸시 Notification, 다운로드 완료 Notification 등을 처리한다.

호출되는 메소드 목록은 UIApplicationDelegate 프로토콜에 선언됨.



### Window (UIWindow 객체)

- 화면에 뷰를 출력하는 역할을 담당.
- 대부분의 앱은 하나의 윈도우를 지니나, 외부 디스플레이 지원하는 경우, 그 이상의 윈도우 가질 수 있음.
- 윈도우는 생성 후 교체되거나 변경되지 않음
- 윈도우에 표시되는 뷰가 교체될 뿐
- 뷰의 계층 구조를 관리하여 뷰와 뷰 컨트롤러 사이에서 발생하는 이벤트를 대상 객체로 전달한다.



### ViewController

- 뷰 컨트롤러는 화면에 표시되는 뷰를 관리한다.
- 하나의 최상위 뷰를 가진다. 
- 화면에 표시되는 뷰는 최상위 뷰의 하위 뷰로 추가된다.
- 앱의 윈도우에 뷰를 추가하여 자신이 관리하는 뷰가 화면에 표시되도록 한다.
- 최상위 뷰에 포함되어 있는 모든 뷰의 배치를 담당한다. 
- 사용자의 상호작용이나 시스템 이벤트 발생시 연관된 앱 데이터와 뷰를 업데이트 한다.



### View

- 사각영역에 앱 데이터를 시각적으로 표시하는 역할을 담당하는 UIView 객체이다.
- 자신의 영역에서 발생하는 이벤트를 처리한다.
- 데이터 변경될 때 마다 내용을 다시 그린다. 
- 뷰는 하위에 다른 뷰를 포함할 수 있으며, 상위 뷰는 하위 뷰의 배치와 계층구조를 관리한다.





# Optional

아래부터는 추가로 공부를 하면 좋을 내용들입니다.

Objective-c나 rx는 회사, 팀마다 사용하는곳이 차이가있고 신입이나 주니어기준으로 필수라고 여겨지지않기에 옵셔널에 추가하였습니다.



## Advanced

- NSCoder 클래스는 어떤 상황에서 어떻게 써야 하는지 설명하시오.

- `Responder Chain 구조`에 대해 설명하고, `First Responder 역할`에 대해 설명하시오.

  - Responder Chain 구조는 Responder Chain 패턴을 구현하여 동작
  - 일반적으로는 포커스 되는 최상위 뷰가 First Responder가 된다. 
  - First Responder가 없는 경우 하위 뷰로 전파되어 top view > super view >.. > UIWindow > App Delegate로 전파된다.
  - text field 의 경우 first responder 되면 키보드 자판 올려야..
  - 여러 화면에서 동일 이벤트를 받는 경우 Window 레벨로 올려서 한번에 처리 가능 

  

- NSObject부터 UIButton 까지 상속 과정의 계층과 역할을 설명하시오.

- shallow copy와 deep copy의 차이점을 설명하시오.

- Push Notification 방식에 대해 설명하시오.

- Foundation 과 Core Foundation 프레임워크의 차이점을 설명하시오.

- NSURLConnection 에서 사용하는 Delegate 메서드들에 대해 설명하시오.

- Synchronous 방식과 Asynchronous 방식으로 URL Connection을 처리할 경우의 장단점을 비교하시오.

  - sync 방식은 deprecated 됨. 고민 no 

- Plist 파일 구조와 Plist 파일에 저장된 데이터를 다루기 적합한 클래스를 설명하시오.

- Core Data와 Sqlite 같은 데이터 베이스의 차이점을 설명하시오.

- JSON 데이터를 처리하는 방식과 파서, 객체 변환 방식에 대해 설명하시오.

- XML Parser를 사용하려면 어떻게 해야 하는지 설명하시오.

- 웹 서버와 HTTP 연결을 사용해서 데이터를 주거나 받으려면 사용해야 하는 클래스와 동작을 설명하시오.

- DOM 방식과 SAX 방식 XML Parser의 차이점을 설명하고 iOS XML Parser는 어떤 방식인지 설명하시오.

- In-App Purchase Product type 을 설명하시오.



## Architecture

- 의존성 주입에 대하여 설명하시오.

  

## Rx

- Reactive Programming이 무엇인지 설명하시오.

- Observable 설명

  - observable”, “observable sequence”, “sequence” 다 같은 말. 

  - 하나의 시퀀스로  이벤트를 발생시키고, 구독이 가능한 객체이다. 

  - 이벤트들은 숫자, 커스텀 인스턴스, 제스쳐(ex. tap) 와 같은 값을 포함

  - 라이프 타임에 걸쳐 값을 포함하는 next 이벤트를 발생

    

  - 

- Subject 설명

  - Observable과 Observer역할을 동시에 수행

  - 4가지 종류
    1) **PublishSubject**: 위에서 봤던 subject. Element없이 빈 상태로 생성되고, subscriber는 **subscribe한 시점 이후에 발생되는 이벤트만 전달받는다.**

    2) **BehaviorSubject**: PublishSubject와 유사하다. 차이점은 반드시 초기 값을 가지고 생성된다. 

  ​                **subscribe가 발생하면, 발생한 시점 이전에 발생한 이벤트 중 가장 최신의 이벤트를 전달받는다.**

  ​	   3) **ReplaySubject**: BufferSize와 함께 생성된다. **BehaviorSubject와 유사하지만, BufferSize만큼의 최신 이벤트를 전달받는다.**

  ​		4) **Variable**: BehaviorSubject의 Wrapper라고 보면 된다. BehaviorSubject처럼 작동하며, 더 쉽게 사용하기 위해 만들어졌다.

  

  https://rhammer.tistory.com/289?category=649741





### RxSwift에서 Hot Observable과 Cold Observable의 차이를 설명하시오.

#### 1. Hot Observable (Connectable Observable)

- **생성과 동시에 이벤트를 방출** // 이벤트를 외부에 생성하는 옵저버블을 Hot Observable이라 한다.
- 이후 **<u>subscribe 되는 시점과 관계없이</u> 옵저버들에게 이벤트를 중간부터 전송**함.
  - 즉, 일정 시간 이후에 subscribe하게 되면, 처음부터 아이템을 받아보지는 못하고, 중간부터 나온 아이템들부터 subscribe 할 수 있게 된다.
  - **multicasting** 방식으로 이뤄진다.
    - 즉, 많은 subscribers에 의해 데이터가 공유되는 방식이다.
- 관련 메서드
  - publish / multicast / connect
  - replay / replayAll
  - share / shareReplay
  - shareReplayLatestWhileConnected

#### 2. Cold Observable

- Observable 내부에 data(Event)를 생성한다. 
- lazy 한 Observable 이라고 볼 수 있다.

- **옵저버가 subscribe 되는 시점부터 이벤트를 생성하여 방출**하기 시작한다.
  - subscribe  이후에 이벤트를 방출하므로, Observable이 흘려보낸 아이템을 모두 받을 수 있다. 
    - 매 구독자에 대해 Observable은 새로운 execution을 시작한다. 
    - 즉, 데이터가 공유되지 않는다.
    - 만약 두 개의 옵저버블이 다양한 값을 생산하는 옵저버블을 구독한다면, 두 옵저버블이 수신한 동일한 순번의 값이 서로 다를 수 있다. 이를 **unicasting** 이라 부른다.



https://brunch.co.kr/@tilltue/15



-----

---



## Objective-C

- Mutable 객체과 Immutable 객체는 어떤것이 있는지 예를 들고, 차이점을 설명하시오.
- dynamic과 property 의미와 차이를 설명하시오.
- @property로 선언한 NSString* title 의 getter/setter 메서드를 구현해보시오.
- @property에서 atomic과 nonatomic 차이점을 설명하고, 어떤것이 안전한지, 어느것이 기본인지 설명하시오.
- @property로 선언한다는 것의 의미를 설명하고, .h에 넣을 경우와 .m에 넣을 경우 차이점을 설명하시오.
- -performSelector:withObject:afterDelay: 메시지를 보내면 인자값의 객체는 retain되는가? 그 이유를 함께 설명하시오.
- Objective-C 에서 캡슐화된 데이터를 접근하기 위한 방법들을 설명하시오.
- unnamed category 방식에 대해 설명하시오.
- Category 확장과 Subclass 확장의 차이점을 설명하시오.
- Category 방식에 대해 설명하시오.
- Objective-C 에서 Protocol 이란 무엇인지 설명하시오.
- Objective-C++ 방식이 무엇인지 설명하고, 어떤 경우 사용해야 하는지 설명하시오.
- method swizzling이 무엇이고, 어떨 때 사용하는지 설명하시오.

- 