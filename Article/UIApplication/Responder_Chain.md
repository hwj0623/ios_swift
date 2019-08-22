7/18

# Responder Chain



## UIEvent의 종류

- multitouch events

  - 화면 스크린을 다루는 것. 
  - direct/indirect event/pencil 
  - UIEventTypeTouches

- Accelerometer events (가속도센서 이벤트)
  - 자이로스코프와 속도의 변화를 같이 고려
  - 자이로스코프를 사용하여 xyz-axis 정보를 판단
    - 회전, 폰의 방향, 모션, 자성(magnetic)
    - UIEventTypeMotion

- UIEventTypeRemoteControl

  - 리모컨을 통한 이벤트
  - bluetooth 등 표준 규격을 따름

- ETC

  - 화면 스크린샷 캡쳐에 대한 이벤트도 별도로 존재

  - ShakeEvent는 보통 현재 작업중인 내용을 취소하는 이벤트로 사용





## Hit-Test

https://developer.apple.com/documentation/uikit/uiview/1622469-hittest

> Returns the farthest descendant of the receiver in the view hierarchy (including itself) that contains a specified point.
>
> 일반적으로 가장 아래 view를 기준으로 특정 포인트를 포함하는 가장 최상위의 view를 반환한다.

view에 존재하는 [`point(inside:with:)`](https://developer.apple.com/documentation/uikit/uiview/1622533-point) 를 호출하여 `hitTest(_:with:)` 메서드가 순회한다.

만약 현재 view에서 point 메서드 반환값이 true면, 



### HitTest를 무시하는 경우

1) alpha값이 0.1(0.01)보다 작은 view 오브젝트

2) hidden 처리되어있는 경우, user interaction을 무시함

[`clipsToBounds`](https://developer.apple.com/documentation/uikit/uiview/1622415-clipstobounds) : parent view와 child view가 겹쳐서 존재하는 경우, 해당 속성을 활성화하면, 부모뷰 바깥의 자식뷰는 화면구성에서 제외된다. (해당 영역의 이벤트 터치도 무시된다.)



### HitTest 사용을 위한 기본 정보

Window : 하드웨어상에서 스크린에 나타낼 창

ViewA(parentView) : Window를 기준으로 일정부분 떨어져서 존재한다고 가정

Frame(width, height) : window를 기준으로 설정한 x,y 좌표 (절대좌표)

bounds(width, height) : 현재 view를 기준으로 0,0부터 설정한 x,y 좌표 (상대좌표)

- UIScrollViewController에서 현재의 view가 window보다 클 때, 화면에 표시할 영역을 나타내기에 유용하게 쓰임



## View Class Hierarchy

- UIView 외에 UIViewController 등 Responder를 처리할 수 있는 객체는 많다.
- UIImageView 자체는 이벤트를 인식하여 처리하지 않는다.
  - gestureRecognizer를 붙여서 사용하거나, 서브클래스를 두어 이벤트를 다룬다. 

- UIControl은  기본적으로 touch event를 다룬다. 즉, IBAction을 통해 원하는 기능을 구현할 수 있다.

- iOS13~ 
  - UIView 외에 UIScene이 추가되었다.
    - 앱 하나에 여러 화면을 다룰 때, 여러 scene을 두어 각각 터치이벤트를 처리할 수 있게 만들 수 있다.



## Responder Chain

https://developer.apple.com/documentation/uikit/uiresponder

처음으로 응답을 다루는 객체를 First Responder라 한다. Proxy Object라고도 부른다.

- First Responder (hit test의 최 앞단 view)에서 응답을 처리하려고 확인하고, 없으면 현재 view의 부모 view에 대해 —> 더 이상의 view가 없으면 viewController -> application에게 물어본다.
- text field의 키보드 입력 : First Responder가 되어야만 키보드 입력을 받을 수 있다.
  - 시뮬레이터 > hardware > 키보드 > toggle 설정 먼저 하고 확인
- 키보드 해제 : First Responder가 아니어야만 키보드를 내린다. 
  - 





View의 계층구조와 Model의 계층구조를 매핑시키는 것이 권장된다.

uiViewParent [ A, B] = class Parent { class A, class B }

View만 재사용할 것이 아니라, ViewController도 계층화하여 재사용하는 것이 권장된다.

