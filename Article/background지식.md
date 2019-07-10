이전 버전에서는 Controller에 UIApplication이 존재하였다.

- 해당 클래스 객체는 Event Loop를 처리하는 메인 스레드를 보유하며, 모든 ios의 이벤트를 수행하고, 화면처리도 동시에 수행하는 객체이다.
- 따라서 Event Loop는 무한루프로 실행되며
- UIApplication은 UI 처리와 관련된 일을 `Application Delegate`에게 위임한다.
-  `Application Delegate`은 `UIWindow`를 보유한다.
- Application Delegate는 적어도 하나의 view controller를 지닌 채로 생성되는데, 이 viewcontroller가 rootVC가 되어 window에 나타날 흰 바탕화면을 출력하는 역할을 한다.
- 