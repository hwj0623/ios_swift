# Part 01 Intro Overview

## Objective-C

##### Obj-C -> Swift 언어 호환성을 위한 노력

- Nullability Annotation

- Lightweight Generics



## Swift 

##### 지원되는 것들..

- @UIApplicationMain(iOS)

- AnyObject

- as! = Failable cast 
- `let` 선언 상수의 사용 규칙 수정 : "`let` 선언된 상수는 선언 시점이 아니라 사용되기 전에 반드시 초기화 되어야 한다."

- 옵셔널 바인딩 개선 
  - 다수의 옵셔널 값을 동시에 추출하는 문법 : `if let`, `guard`
- 안정성 높이는 문법 : `defer`, `guard`
- `#available` : 지정된 버전에서만 동작하는 코드를 구현하는 블록처리
- `@available` : 지정된 버전에서만 동작하는 코드를 구현하는 속성(메서드 등에 사용)
- `@nonobj` : 속성
- `do…while` 문법을 `repeat..while` 로 변경
- Protocol extension 
- String Interpolation 문자열 리터럴 허용 (2015~)
- 파라미터 레이블(inout, var, let 제외) 사용 가능
- `#selector`: 컴파일 시점에 셀렉터의 유효성을 검증함 
- 튜플 비교 지원

##### 삭제 및 변경

- `++`, `—` 연산자 삭제, C 스타일 for Loop 삭제
- `__FILE__`, `__LINE__` 등과 같은 디버그 식별자가 `#file`, `#line`, `#column`, `#function` 으로 대체
- Objective-C API 임포트 방식 변경 e.g.@objc (2016.09~)



## Objective-C vs Swift(ch03)



#### 1) Objective-C 같은 C계열 언어는 **프로그램 실행시 가장 먼저 호출되는 진입점 함수(main 함수)**를 갖는다.

```objective-c
int main(int argc, char* argv[])
{
  @autoreleasepool {
    return UIApplicationMain(argc, argv, nil, NSStringFromClass([PAAppDelegate class]));
  }
}
```

- Objective-C의 mian 함수는 `UIApplicationMain`  함수 호출하여 Run-loop를 실행하고, 앱에 필요한 필수요소를 구성하는 UIApplication 객체의 딜리게이트를 지정한다.



####  2) Swift는 main 함수가 존재하지 않는다.

- 컴파일러가 전역범위의 코드를 자동으로 인식하고 실행한다. 

- AppDelegate 클래스 구현 앞에 `@UIApplicationMain`  속성을 추가하여 Objc-c의  `UIApplicationMain`  함수 호출과 동일 작업 수행되도록 지정한다.

  ```swift
  @UIApplicationMain
  class AppDelegate: UIResponder, UIApplicationDelegate {
    //...
  }
  ```

  - plus,  `@UIApplicationMain`  속성은 만약 AppDelegate의 UnitTest 등을 수행하는 과정에서 커스텀하여 사용할 수 있다. 

  - #### @UIApplicationMain의 역할

    - main 클래스 역할
    - AppDelegate와 UIApplication을 연결
      - AppDelegate 테스트시에 아래의 항등코드를 수동으로 작성가능하다.
    - UIApplication도 UIResponder를 상속받는 대표적인 객체이나, UIApplication는 이벤트 처리를 위해 UIViewController, UIView 등으로 이벤트를 전달한다.
      - 기타 이벤트 처리 기능은 **event handling을 담당하는** **`UIResponder`** 프로토콜을 상속받은 다른 객체 인스턴스들이 수행한다.

    ```swift
    UIApplicationMain{
      	CommandLine.argc,
      	CommandLine.unsafeArgv,
      	NSStringFromClass(UIApplication.self),
      	NSStringFromClass(AppDelegate.self)
    }
    ```



#### 3) 문장의 끝에 semicolon 여부

- obj-c : ` ;` 있어야 구분
- swift는 컴파일러가 자동으로 문장의 끝을 인식



#### 4)변수와 상수 선언

##### Objective-C

- c  style 문법으로 변수/상수 선언. 영문자/숫자/_ (undercase) 문자 조합

```objective-c
int num = 0;
const double _ratio2 = 123.45;
```



##### Swift

- `var` 키워드를 통해 변수 선언
- `let` 키워드를 통해 상수 선언
  - 상수 이름에 유니코드로 표현 가능한 대부분의 문자 사용 가능

```swift
var num = 0
let _ratio2 = 123.45
let 한글변수 = "유니코드"
```



#### 5) 자료형

##### Objective-C

-  C자료형 : int, double 등
- Foundation 자료형 : NSInteger, CGRect, NSString 등

##### Swift

- 기본자료형 : Int, String, Double 등
- Foundation 자료형 : NSInteger, CGRect, NSString 등
- 값 형식의 자료형 추가
  -  NSData, NSDate, NSIndexPath에 대응되는 `Data, Date, IndexPath`
  - `Measurement`, `DateInterval` 등 추가
- `extension` 으로 기본/Foundation 자료형의 기능 확장 가능
- `Tuple` 을 통해 복합 값을 직관적 처리 가능



#### 6) 타입추론

- swift는 적합한 자료형을 판단할 수 있으므로 자료형 생략가능
  - 단, var doubleNumber = 7 // 기본적으로는 Int 형으로 인식 



#### 7) 문자 / 문자열

##### Objective - C 

- c 스타일 문자열과 `@"String"` 표현방식의 Objective-C 문자열을 구분

```objective-c
char* cStr = "C String";
NSString* str = @"Objective-C string";
char ch = 'a';
NSLog(@"value of ch : %c", ch);
```



##### Swift

- 문자와 문자열을 기본적으로 큰 따옴표로 감싸서 표현 
- 별도 자료형 지정하지 않는 경우, <u>문자 수에 관계없이</u> `문자열`
- `문자` 로 지정하려면 `Character` 를 명시적으로 지정



#### 8) 메모리 관리

##### Objective - C

- MRC or ARC 중 하나의 메모리 관리 모델 선택

##### Swift 

- ARC 가 기본.
- 참조 사이클 문제를 해결하기 위해 `unowned` 참조, `clousure capture list` 같은 기능을 제공



9) 서브스크립트 문법

##### Objective - C

- 아래 메소드 구현하거나 숫자나 키를 통해 클래스 내부 데이터에 접근 가능

```objective-c
(id) objectAtIndexedSubscript : (*IndexType*) index;
(void) setObject:(id)obj atIndexedSubscript : (*IndexType*) idx;
(id) objectForKeyedSubscript: (*KeyType*) key;
(void) setObject:(id)obj forKeyedSubscript: (*KeyType*) key;
```



##### Swift 

- `subscript` 키워드를 통해 서브스크립트를 구현 
- `IndexedSubscript`와 `KeyedSubscript` 를 구분하지 않음
- 인덱스와 키의 자료형은 파라미터를 통해 지정

```swift
class MyClass {
  let data = ["iPhone", "iPad", "iPod", "Mac Pro"]
  subscript(index: Int) -> String {
    return data[index]
  }
}
var myclass = Myclass()
print(myclass[0]) //iPhone
```



#### 10) 열거형

##### Objective - C

- c 와 동일. 열거형의 **primitive 값**은 **정수**로 저장

##### Swift

- 열거형의 primitive 값을 `정수`, `문자열`, `실수` 로 저장 가능
- Objective-C에서는 클래스에만 가능했던 개념들을 추가
  - `생성자` 구현 가능
  - `메소드` 구현 가능
  - `extention`으로 새로운 기능 추가 가능

```swift
enum DateFormat{
  case Undefined
  case Long(Int, Int, Int, String)
  case Short(Int, Int)
  init(){
    self = .Undefined
  }
  init(_ month: Int, _ day: Int){
    self = .Short(month, day)
  }
  init(_ year: Int, _ month: Int, _ day: Int, _ dayName: String){
    self = .Long(year, month, day, dayName)
  }
  func toString() -> String {
    switch self {
      case .Undefined:
      	return "Undefined"
      case let .Long(year, month, day, dayName):
      	return "\(year)-\(month)-\(day) \(dayName)"
      case let .Short(month, day):
	      return "\(month)-\(day)"
    }
  }
}
```



#### 11) Generics

##### Objective-C

- Generics 지원하지 않음

- Lightweight Generics 제공

  - 주로 컬렉션에 저장할 요소의 형식을 지정하는데 사용

    ```objective-c
    NSMutableArray<NSString* >* array = [NSMutableArray array];
    [array addObject: @"Objective-C LightWeight Generics"];
    
    [array addObject:@13];
    ```

    

##### Swift

- Generics 완벽 지원
- 자료형에 의존않는 범용 코드 쉽게 작성

```swift
func swapValue<T> (inout lhs: T, inout rhs: T){
  let tmp = lhs
  lhs = rhs
  rhs = tmp
}
```



#### 12) 구조체

##### Objective-C

- c 언어 구조체 그대로 상속
- 구조체 내부에 **메소드 구현 추가할 수 없음**
- 구조체 연관 기능은 전역함수를 통해 제공 (CGRectMake(), CGRectContainsPoint())

##### Swift 

- 메소드와 생성자 구현 가능
- Memberwise Initializer 통해 구조체 쉽게 초기화 가능



#### 13) 연산자

Objective-C

- c 기반 대부분의 연산자 제공

Swift

- 단항연산자 `++`,`—`  제거. 
- 필요에 따라 `사용자 정의 연산자` 구현 가능
- 연산자 함수를 통해 `연산자 오버로딩`을 구현
  - 연산자는 기본적으로 `연산자 함수`로 이뤄져있다.



#### 14) 중첩 형식(Nested Type)

Objective-C

- 클래스 내부에 중첩 클래스 선언 **불가**

Swift

- **[구조체, 열거형, 클래스]** 선언 내부에 **중첩된 [구조체, 열거형, 클래스] 선언 가능**



#### 15) nil

- 공통적으로 `값이 없음` 을 나타내기 위해 사용하는 키우더ㅡ

Objective-C

- 참조형식에 제한적으로 사용

Swift

- 옵셔널 개념 도입으로 다음을 엄격하게 구분
  - 반드시 값을 가져야 하는 형식
  - 값을 가지지 않을 수 있는 형식 
- 참조 형식과 값 형식 모두 nil 할당 가능
- 옵셔널 바인딩과 체이닝을 통해 안전하게 nil 처리



#### 16) 예외처리

##### Objective-C

- **try..catch** 형태의 예외처리 문법 제공

```objective-c
@try{
  //
}@catch(NSException *exception){
  //
}@finally {
  //
}
```

- 작업의 결과 리턴하는 경우에는 **BOOL, NSError**  조합을 활용



##### Swift 

- **do..catch** 문법과 **try** 키워드 조합

```swift
func trySomething(){
  do{
    try doSomething()
  }catch{
    print(error)
    return
  }
}
```



#### 17) 블록 / 클로저

Objective-C의 `블록`과 Swift의 `클로저` 는 특정 기능 수행하는 코드조각으로, 호환됨

Objective-C블록 - `__block`으로 선언되지 않은 변수를 내부에서 사용할 때 `값을 복사` 함.

Swift 클로저 - `값을 복사하지 않고` `__block`으로 선언한 것 처럼 **내부에서 값을 변경 가능**



#### 18) 네임스페이스

##### Objective-C

- 네임스페이스 부재. NS, UI 등의 접두어를 사용하여 보완
- 같은 프로젝트 내 코드 사용위해
  - 코드 상단에 #import "header.h" 같은 구문 반드시 추가해야 함

##### Swift 

- 모듈 단위의 네임스페이스 사용하여 이름 충돌 문제를 해결
- 모듈 
  - 앱의 Target과 동일한 의미로 이해
  - 서로 다른 모듈에서 동일한 이름 사용 가능
  - 동일 모듈에 구현된 모든 코드를 import 구문없이 사용

