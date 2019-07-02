# Intro

만유인력의 법칙

- 모든 물리적 현상에 대해 수학적인 계산의 토대를 만듦
- 자연현상에 대해 현상의 분석(계산가능함, 예측가능함) 을 이끌어냄

Common Logarithms

- 일수로 이자를 계산하기 위한 로그 측정표
- 계산을 일일히 사람이 직접 했어야 하는 문제

### **Charles Babbage**

- 프로그이 가능한 컴퓨터 개념의 시초자
- 최초의 프로그래머 **Ada Lovelace** countless와 협업

### Two Paradigms

- **Alonzo Church**의 **람다식(선언적, Declarative)**
  - 함수형 프로그래밍으로 발전
  - Lisp, Prolog, Scheme, Erlang, Haskell, Clojure

- **Alan Turing**의 **튜링머신(절차적, Imperative)**
  - 절차적/OOP 프로그래밍으로 발전 
  - FORTRAN, ALGOL, Simula, Pascal, C, Smalltalk, Objective-C, C++, Java, Python, C#
- **2000`s ~ 두 패러다임의 혼재**
  - Ruby, JS, Scala, D, F#, Rust, Kotlin, Swift



## Lambda calculus (람다식)

[출처](https://en.wikipedia.org/wiki/Lambda_calculus#The_lambda_calculus)

The lambda calculus consists of a language of **lambda terms**, which is defined by a certain formal syntax, and a set of transformation rules, which allow manipulation of the lambda terms. These transformation rules can be viewed as an [equational theory](https://en.wikipedia.org/wiki/Equational_theory) or as an [operational definition](https://en.wikipedia.org/wiki/Operational_definition).

- 변수가 존재하고, 그 값이 변할 때 마다 어떻게 매핑되어야 하는지를 규정
- 모든 람다식은 **익명함수의 형태**이다.
- **오직 하나의 변수만을 받는 함수**이다. 여러가지 변수를 사용할 경우,  [currying](https://en.wikipedia.org/wiki/Currying)을 통해서 구현한다.

| Syntax |    Name     |                         Description                          |
| :----: | :---------: | :----------------------------------------------------------: |
|   x    |  Variable   | A character or string representing a parameter or mathematical/logical value |
| (λx.M) | Abstraction | Function definition (M is a lambda term). The variable x becomes [bound](https://en.wikipedia.org/wiki/Free_variables_and_bound_variables) in the expression. |
| (M N)  | Application | Applying a function to an argument. M and N are lambda terms. |

- 표기법은 **λ(대상).(expr)** ==> 대상에 대해 dot을 기준으로 표현식으로 설명

![{\displaystyle \operatorname {square\_sum} (x,y)=x^{2}+y^{2}}](https://wikimedia.org/api/rest_v1/media/math/render/svg/6020e0858d923aa15ab308584dac8af2d003b879)

위 함수는 익명 form으로 아래와 같이 표현할 수 있다.

![{\displaystyle (x,y)\mapsto x^{2}+y^{2}}](https://wikimedia.org/api/rest_v1/media/math/render/svg/89bf7c479bc1935d1ddd0519cde149591d0e541b)

(read as "a tuple of *x* and *y* is [mapped](https://en.wikipedia.org/wiki/Map_(mathematics)) to ![{\textstyle x^{2}+y^{2}}](https://wikimedia.org/api/rest_v1/media/math/render/svg/2acda359ee232e747298436227bc8bee4ef82203)



----

함수 

![\operatorname {id} (x)=x](https://wikimedia.org/api/rest_v1/media/math/render/svg/e64f26d868eb6952a36c600035ede967568c973f)

도  역시 다음과 같이 익명 form으로 표현할 수 있다.

![x \mapsto x](https://wikimedia.org/api/rest_v1/media/math/render/svg/033c0ae81eaf4c65cbb0759d7aa2c4f434c00f02)

The **second simplification** is that the **λ-calculus only uses functions of a single input.** An ordinary function that requires two inputs, for instance the {\textstyle \operatorname {square\_sum} }![{\textstyle \operatorname {square\_sum} }](https://wikimedia.org/api/rest_v1/media/math/render/svg/b1452ce7cbdc7fd26d4b880eddf9b28d0c4965a7) function, can be reworked into an equivalent function that accepts a single input, and as output returns *another* function, that in turn accepts a single input. For example,

![{\displaystyle (x,y)\mapsto x^{2}+y^{2}}](https://wikimedia.org/api/rest_v1/media/math/render/svg/89bf7c479bc1935d1ddd0519cde149591d0e541b)

can be reworked into

![{\displaystyle x\mapsto (y\mapsto x^{2}+y^{2})}](https://wikimedia.org/api/rest_v1/media/math/render/svg/012fc8f19ed14bf232ee8deefe4ae84dc507875d)

This method, known as [currying](https://en.wikipedia.org/wiki/Currying), transforms a function that takes multiple arguments into a chain of functions each with a single argument.

[Function application](https://en.wikipedia.org/wiki/Function_application) of the {\textstyle \operatorname {square\_sum} }![{\textstyle \operatorname {square\_sum} }](https://wikimedia.org/api/rest_v1/media/math/render/svg/b1452ce7cbdc7fd26d4b880eddf9b28d0c4965a7) function to the arguments (5, 2), yields at once

![이미지](https://wikimedia.org/api/rest_v1/media/math/render/svg/928ef499250ddf3fae99e9a0e7e81bd4aa57e3b9)

![{\textstyle =5^{2}+2^{2}}](https://wikimedia.org/api/rest_v1/media/math/render/svg/80c505b7a93daffe13a057837fb7071280cda48f)

![{\textstyle =29}](https://wikimedia.org/api/rest_v1/media/math/render/svg/d026d595296c5d7351c05ffd86b0ffec19fe88b1)



## Currying과 고차함수

```swift
typealias Method = (Int, Int) -> Int
func _calculate(_ method: Method, v1: Int, v2: Int) -> Int {
 		return method(v1, v2)
}
func calculate(_ method: @escaping Method) -> (Int) -> (Int) -> Int {
 		return { v1 in
 				return { v2 in
 						return method(v1, v2)
 				}
 		}
}
/// 장점1 : 연산과 값을 분리하여 여러번 호출 할 수 있음
/// 장점2 : 추상화 단계를 조절하여 하나의 함수에 대해 유연하게 프로그래밍 가능.
calculate(+)(10)(3)
let adder = calculate(+)	/// 추상화를 calculate(+) 까지만 하여 adder라는 함수로 명명
adder(5)(3)	/// 8
let adder100 = adder(100)	/// 추상화를 calculate(+)(100) 까지만 하여 adder100이라는 함수로 명명
adder100(3)	/// 103
adder100(5)	/// 105

let multiply = calculate(*) /// 추상화를 calculate(*) 까지만 하여 multiply 함수로 명명
multiply(4)(5)	/// 20
let doubled = multiply(2)		/// 추상화를 calculate(*)(2) 까지만 하여 doubled 함수로 명명
doubled(22)			/// 44
doubled(100)		/// 200
```



#  함수형 프로그래밍(함수 중심 프로그래밍)

> 자료 처리를 수학적 **함수의 계산**으로 취급하고
> 상태와 가변 데이터 대신 **불변 데이터**를 프로그래밍 패러다임

- 순수 함수 **Pure Function**
- **Immutable 타입**
- 일급 함수와 고차 함수
- 자동 메모리 관리
- 타입 시스템 (타입 추론)



## cf. 튜링머신

![이미지](/Users/hw/Desktop/스크린샷 2019-07-01 오전 11.26.42.png)

https://www.youtube.com/watch?v=PvLaPKPzq2I

- 입력의 현재상태와 다음에 들어오는 내용에 대해 모든 조건에 따른 절차를 만들면, 해당 프로그램의 계산이 끝나고, 

  상태표들의 조합을 만들어낼 수 있다.

- 이론의 맹점
  - 입력이 무한하다면 계산의 완료가 불가능. (Input String must be finite)
  - 튜링머신의 Tape도 무한하면 안된다. (Tape must be finite)
- 한계
  - 모든 조건에 대해 일렬로 나열하는 방식. 구조화도 되어있지 않다.. (천공카드 시절)





> HW는 놔두고 SW를 개선하여 처리해보자
>
> 현실의 문제(현상)를 프로그래밍으로 처리하는 부분으로 관심사가 옮겨짐
>
> 객체(인스턴스), 변화, 상대성, 현실세계, 클래스(본질)
>
> 일반화 | 추상화 | 개념 | 무형 | 이론 | <—>  구체 | 개별화 | 구상화 | 유형 | 실체 
>
> ​					클래스코드 						<—> 				객체 인스턴스 



## 여러 데이터를 한꺼번에 다루자

 **in swift**

- 값을 저장하기 위한 프로퍼티property 선언
- 기능을 제공하기 위한 메서드method 선언
- 서브스크립트로 접근할 수 있는 문법 지원
- 초기 상태를 위한 초기화 메서드 제공

```swift
struct SomeStructure {
	// 정의부
}
struct Resolution {
	var width = 0
	var height = 0
}
// 선언부
let someResolution = Resolution()
let vga = Resolution(width: 640, height: 480)
```



# OOP

> 어떻게 하면 좀 더 효율적으로 데이터를 다룰 수 있을까?
>
> "객체"에 정보를 담아서 처리하도록 해보자

**객체 중심 프로그래밍**

- 프로퍼티 property와 메소드 method
- 캡슐화 encapsulation
- 상속 inheritance
- 다형성 polymorphism
- 클래스 객체 class와 객체 인스턴스 instance
- 객체 디자인 패턴 design pattern



## 구조체 vs 클래스

> 초기에는 객체에 정보를 담아 처리하는 것을 struct로만 구현 (ex: C )
>
> OOP에 대해 좀 더 발전하고나서는 구조체를 넘어 클래스를 도입

**in swift** 

- 두 가지 방식을 다 지원한다. 
- 개발자의 의도와 선택에 따라 각자 다른 해결방식으로 구현

|                            struct                            |                            class                             |
| :----------------------------------------------------------: | :----------------------------------------------------------: |
| 프로퍼티에 값을 저장할 수 있다<br/>함수로 원하는 기능을 제공할 수 있다<br/>서브스크립션으로 값에 접근할 수 있다<br/>초기(상태)값을 위해 생성함수를 정의할 수 있다 | 프로퍼티에 값을 저장할 수 있다<br/>함수로 원하는 기능을 제공할 수 있다<br/>서브스크립션으로 값에 접근할 수 있다<br/>초기(상태)값을 위해 생성함수를 정의할 수 있다 |
|                        no inheritance                        |      inheritable<br />상위/하위 클래스 타입으로 형변환       |
|                              -                               |             deinit() 에서 불필요한 리소스를 해제             |
|       의미 있는 값<br />Value semantic<br />직접 참조        |  의미 있는 레퍼런스<br />Reference semantic<br />간접 참조   |
|                              -                               | 인스턴스별 참조 개수 관리 필요<br />ARC/weak reference를 통한 메모리 누수 제거 |



>## 			객체 속성을 가져오지 말고, 객체가 일하도록 시켜라

특성 명령형 접근방식 함수형 접근방식

 중요함 없음
실행 순서 중요함 중요도 낮음
제어 흐름 반복문, 조건문, 함수 호출 

|             특성             |                   명령형 접근방식                   |                 함수형 접근방식                  |
| :--------------------------: | :-------------------------------------------------: | :----------------------------------------------: |
| **프로그래머<br/>관심 사항** | 작업을 수행하는 방법 (알고리듬)<br />상태 변경 추적 | 원하는 정보가 무엇인가<br/>어떤 변환이 필요한가  |
|        **상태 변경**         |                        중요                         |                       없음                       |
|        **실행 순서**         |                        중요                         |                   중요도 낮음                    |
|         **제어흐름**         |               반복문 조건문 함수 호출               |             재귀를 비롯한 함수 호출              |
|        **구현 단위**         |                 구조체 또는 클래스                  | 함수 사용<br />(using 일급 객체와 데이터 콜랙션) |



> ​		**프로토콜**		<< 일반화, 추상화 <<			**클래스코드** 		<< 일반화, 추상화 <<			**객체** **인스턴스** 
>
> ​							 >> 구체화, 개별화 >>									  >> 구체화, 개별화 >>			



## 순수함수

- 부작용 (side-effect) 없는 함수

- 변경 불가한 데이터

- 참조 투명성

- 느긋한 계산 **Lazy Evaluation**

- 순수성과 **부작용**

- 테스트 가능한 함수 

  ```swift
  func pure(x:Int) -> Int {
  		 return x * 2								// 테스트가 명확하다.
  } 
  func impure(x:Int) -> Int {
   		 return Int(rand()%10) * x	//테스트가 불가능한 로직이 포함
  } 
  ```

  





## 익명함수 vs 클로저

함수의 형태는 다음과 같다

```swift
func squared(input : Int) -> Int { return input * input }
```

클로저의 형태는 다음과 같다.

```swift
let closure1: (Int) -> Int = { n in return n * n}	//파라미터와 반환값을 클로저 타입에 명시
let closure2 = { (n:Int) -> Int in return n * n }	//파라미터와 반환값을 클로저 내에 명시
```

- 클로저는 람다식의 구현체이다.
- 클로저는 `anynomous function` 으로 작성가능하다.
- 선언된 범위`scope` 의 변수를 캡쳐해서 저장하고 닫힌다.
- swift의 클로저는 captured variable을 참조( `reference` )한다.





## 타입 기반 개발

- `typealias` 를 통해 사용자 지정 데이터 타입을 명시하여 보다 명확하게 코드를 작성한다.

- 특정 파일 내에서만 사용하는 경우에는 접근 지정자를 명시 ex: `private typealias`

  



## 일급함수

- 함수(나 클로저)는 일급객체(일급시민)으로 다른 함수의 파라미터나 리턴값으로 쓰일 수 있다는 것이 특징이다.

```swift
public typealias RouterHandler = (request: RouterRequest, response: RouterResponse, next:
()->Void) -> Void 
/// next의 인자는 클로저이다. 


private func routingHelper(method: RouterMethod, pattern: String?, handler:
RouterHandler) -> Router {
 		routeElems.append(RouterElement(method: method, pattern: pattern, handler: handler))
 		return self			/// 리턴값이 함수이다. 
} 

public func get(handler: RouterHandler) -> Router {
		return routingHelper(.Get, pattern: nil, handler: handler)
} 
```





## Lazy Evaluation

- 적극적 계산(strict evaluation)에서는 함수 호출 전에 모든 인자 목록을 계산해 놓는다.
- 실제 함수 계산시에 해당 값이 필요하기 전까지 계산을 하지 않는다.
- 가령, for-loop를 돌릴 때, 해당 argument가 필요하면 호출하고, 불필요하면 무시하는 방향으로 성능을 끌어올릴 수 있다.



> print_length([2+1, 3*2, 1/0, 5-4])
>
> S.E : 배열 내 모든 요소를 컴파일 단계에서 계산함
>
> L.E : 해당 값이 호출되기 전에 계산을 하지 않음