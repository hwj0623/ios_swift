

# Part 03 Language Basics (1)

## Stored Class and Access Range(ch03)

- #### 지역변수 

  -  하나의 코드 블록 { } 내부에서 사용되는 변수 

- #### 중첩된 코드블록에서 동일한 변수 이름 사용하면?

  - 가장 인접한 코드블록의 변수를 우선적으로 사용한다. 
  - 안티패턴

- #### 정적 변수 

  -  `static` 키워드를 사용해서 선언

  - 코드블록 내부/외부에 선언 가능

  - 선언위치에 따라 접근 가능 범위가 달라짐 

    ```objective-c
    void doSomething(){
      static int a = 0;
      a += 1;
      NSLog(@"%i", a);
    }
    ```

  - **doSomething() 함수 호출과 무관하게** **<u>a 변수는 처음 실행될 때 한번만 초기화</u>**된다. 

  - <u>지역변수가 함수의 실행 종료 후 메모리 해제</u>가 되는 것과 달리, 

    - 전역변수는 프로그램 종료시까지 메모리에 유지

  - **Local Scope** : 코드 블록 내에서 선언된 정적변수는 지역변수와 접근범위가 동일

    ```objective-c
    void useLocalVariable(){
      int a = 0;
     	a += 1;
      NSLog(@"Local Variable : %i", a);
    }
    void useStaticVariable(){
      static int a = 0;
      a += 1;
      NSLog(@"Static Variable : %i", a);
    }
    int main (int argc, const char * argv[]){
      useLocalVariable();	//Local Variable : 1
      useLocalVariable();	//Local Variable : 1
      useLocalVariable();	//Local Variable : 1
      
      useStaticVariable();	//Static Variable : 1
      useStaticVariable();	//Static Variable : 2
      useStaticVariable();	//Static Variable : 3
      
      return 0;
    }
    ```

- #### 전역변수 vs 외부 변수 (Objective-C)

  - **File Scope** : 전역변수는 기본적으로 <u>동일한 파일 내부에서 접근</u>

  - static 변수를 코드블록 외부에서 선언시 File Scope의 내부 전역 변수가 된다.

  - **`Internal Linkage`**: **내부** 전역변수는 **<u>다른 파일에서 접근이 불가능한</u>** 특징

  - **`External Linkage`**: **static 키워드 없이 선언된 외부 전역변수**가 다른 파일에서 접근 가능한 Global Scope 를 지니는 특징

    ```objective-c
    //objective-C Scope/GlobalVariables/global.m
    int a = 12;
    //objective-C  Scope/GlobalVariables/main.m
    extern int a;	//다른 파일에 선언된 전역변수를 지시할 뿐, 실제 메모리 변수를 생성x
    int main (int argc, const char * argv[]){
    	NSLog(@"%i", a);	//12
      return 0;
    }
    ```

    - 다른 파일에 선언된 전역변수 a에 접근하기 위해 `extern` 키워드 사용하여 다시 선언한다.
    - **외부변수** : 다른 파일에 선언된 전역변수를 지시할 뿐, 실제 메모리 변수를 생성하지 않는 변수.
      - 반드시 **다른 파일에 선언된 전역변수와 동일한 자료형/이름으로 선언** else compile error!

- Objective-C 전역변수 : 사용여부와 관계없이 메모리공간을 점유하여 메모리 낭비가 심함



### 전역변수 vs 외부 변수 (Swift)

- 전역변수가 <u>코드블록 외부에 선언</u>되는 것은 동일
- **내부 전역 변수 / 외부 전역 변수의 구분 없음**

- 동일한 모듈 내 외부 변수 선언 없이 자유롭게 접근 가능

- 전역변수가 처음으로 접근하는 시점에 초기화 된다.

  - 메모리 공간 효율성 높음

- Swift의 전역변수는 `Lazy Stored Property` 

  - 선언시 lazy 키워드를 사용하지 않아도 지연 초기화를 수행

  ---

  #### lazy 키워드

  - `Lazy` is only valid for **members of a struct or class **에러
    - lazy  키워드는 **구조체/클래스의 멤버(프로퍼티)에만 쓸 수 있다.**
  - `lazy` must not be used on an already-lazy global 에러
    - **이미 static 선언된** 구조체/클래스 내부 **프로퍼티에 lazy를 쓰는 경우 발생**하는 컴파일 에러
    - 이미 전역적으로 lazy인 대상에게 사용할 수 없음을 내포한다.

  ```swift
  struct LazyStruct {
      lazy var k = 10;
  }
  var lazyStrcut = LazyStruct();
  ```

  ---

- 전역변수 이름 == 지역변수 이름 이면 지역변수의 우선순위가 높다.



### 레지스터 변수(Objective-C)

- RAM에 저장되는 변수 : [ **지역변수, 정적변수, 전역변수** ]는 메인 메모리에 저장

- 레지스터 변수 

  - `register` 키워드 사용

    ```objective-c
    register int a;
    ```

  - CPU에 내장된 레지스터에 저장. 처리속도 매우 빠름

  - **짧은 시간**동안 **반복적으로 사용**되고 **크기가 작은** 변수는 레지스터에 저장 가능

  - **선언 가능한 변수** : `지역변수` 와 `파라미터` 로 제한됨



### 네임스페이스

##### Objective-C

- 네임스페이스가 없음. 충돌 피하기 위해 접두어 붙임

##### Swift

- **모듈 기반**의 네임스페이스 제공 

- 일반적으로 하나의 iOS 프로젝트는 하나의 모듈과 동일 ==> 동일 네임스페이스

- 만약 두 개 이상의 모듈(외부 라이브러리 포함)에서 동일한 식별자 사용시 

  - **식별자 앞에 모듈 이름을 추가하여 정확한 식별자를 지정** 

    `ModuleName.Identifier`



----



## Optional(ch04)

- 값이 없음을 표현하는 방식

##### Objective-C

- null에서 파생된 nil 을 주로사용

- 객체/포인터 같은 **참조 형식 만을 대상**으로 함

- Foundation 프레임워크의 Objective-C 메소드들은 검색 결과가 없을 경우 NSNotFound 상수 리턴하기도 함

  ----

##### Swift

- **swift의 옵셔널 형식** : nil 값을 가질 수 있는 <u>참조 타입</u>과 <u>값 타입</u>
  - **`ExpressibleByNilLiteral`** 프로토콜을 채택

- 옵셔널 값으로 `값이 없음` 을 표현

  - ```swift
    var 변수명: 자료형?
    ```

- **<u>value type / reference type 모두 nil 사용</u>**하여 `값이 없음` 을 표현

- nil 값을 가질 수 없는 나머지 형식들은 비옵셔널 형식

- 비옵셔널 형식에 nil 대입하거나 초기화 없이 접근시 에러 발생

  ```swift
  var optionalName: Int?
  print(optionalName) // nil
  
  var nonOptionalNum: Int
  print(nonOptionalNum) //Error
  nonOptionalNum = nil //Error 
  
  var optionalString: String? = "hello"
  optionalString = nil
  optionalString = "new Value"
  optionalString = nil
  ```



#### 옵셔널

- **옵셔널은 열거형으로 구현**되어있다.

  - **None, Some(T)** 를 Associated Value로 갖고 있다.

     ```swift
    enum Optional <Wrapped> : ExpressibleByNilLiteral { 
    	case none
    	case some(Wrapped)	
    } 
     ```

#### 옵셔널의 종류

- enum + general (열거형 + 일반형 )

#### 암시적 추출 옵셔널 (열거형 옵셔널, 느낌표 옵셔널)

- 열거형은 느낌표를 써서 나타내고, 암시적 추출 옵셔널이라 부른다. 

- 기존 변수처럼 사용 가능 (nil 할당도 가능)

- 런타임 오류 발생 가능

  ```swift
  var implicitNum: Int! 
  
  var optionalValue: Int! = 100
  
  // optionalValue 자체는 열거형이므로 switch 구문에서 값의 여부를 체크 가능
  swtich optionalValue { 
  case .none:				//값이 없다면 
  	print(“This Optional variable is nil”)
  case .some(let value) :		//값이 있다면 
  	print(“Value is \(value)”)
  }
  
  // 암시적 추출 옵셔널은 기존 변수처럼 사용이 가능하다
  optionalValue = optionalValue + 1
  
  // nil 할당이 가능
  optionalValue = nil
  
  // 잘못된 접근으로 인한 런타임 오류 발생 가능
  optionalValue = optionalValue + 1
  ```

#### 일반형 옵셔널 (물음표 옵셔널)

- 일반형은 물음표를 써서 나타낸다.

- switch 구문에서 값의 여부를 체크 가능한 것은 암시적 추출 옵셔널과 동일

- nil 할당 가능

- 기존 변수처럼 사용은 불가능 (일반 타입값과 다른 타입이므로 연산 불가능 )

  ```swift
  var generalOptNum: Int?
  
  var optionalValue : Int? = 100
  // switch 구문에서 값의 여부를 체크 가능. 
  // ! 와 동일
  
  swtich optionalValue { 
  case .none:				//값이 없다면 
  	print(“This Optional variable is nil”)
  case .some(let value) :		//값이 있다면 
  	print(“Value is \(value)”)
  }
  
  // nil 할당이 가능
  optionalValue = nil
  
  // 기존 변수처럼 사용이 불가 ; 옵셔널 타입은 일반 타입 값과는 다른 타입이므로 연산이 불가능하다. 
  optionalValue = optionalValue + 1
  ```



### Wrapping & Unwrapping 

#### 1) 강제 추출 방식 (!)

- ```swift
  옵셔널 표현식!
  var optioanlStr: String? = "hello"
  print(optionalStr)	//Optional(hello)
  print(optionalStr!) // hello
  
  var notInitStr: String?
  print(optionalStr!) // 에러발생
  ```



#### 2) 자동 추출 방식(암시적 Unwrapping)

- 선언시 ! 로 선언한 옵셔널 형식(Implicitly Unwrapped Optional) 의 경우 값에 접근시 자동 추출된다.

  ```swift
  var optioanlStr: String! = "hello"
  print(optionalStr)	//hello
  ```



#### 3) 옵셔널 바인딩

- nil 할당되어있을 때 값을 추출하면 런타임 오류 발생

- 값의 유효성을 먼저 확인하는 작업으로 안전하게 추출하는 것

  ##### [1] if let/var 이름 = 옵셔널 표현식

  ```swift
  var optioanlStr: String? = "hello"
  if let str = optionalStr {  //[ 상수이름 = 옵셔널 표현식 ] 형식으로 바인딩
    print(str)	// 바인딩 성공시 실행할 코드
  }
  
  // 조건식 where (혹은 boolean 절)를 추가할 수 있다.
  if let str = optionalStr (where) str == "hello" {
    print(str) //hello
  }
  ```



#### cf. guard 문

- 코드 실행 위한 조건을 판단하고, 조건이 충족되지 않ㅇ르 경우, 조기에 실행을 즉시 중단하는 패턴 구현에 유용

```swift
var optionalStr: String? = "hello"
guard var str = optionalStr where str == "guard" else{
	return 
}
```



## 연산자 (ch05)

- 항등연산자 (swift only)

  - 참조 형식의 비교를 위해 값뿐만 아니라 인스턴스의 메모리 주소를 비교하는 연산자.

  | 연산자 | 피연산자 수 | 연산결과                                                     | 표현식  |
  | ------ | ----------- | ------------------------------------------------------------ | ------- |
  | ===    | 2           | 두 피연산자의 참조(인스턴스 메모리주소)가 동일시 true, 동일하지 않으면 false | a === b |
  | !==    | 2           | 두 피연산자의 참조가 동일하지 않으면 true, 동일하면 false    | a !== b |

  ```swift
  func === (lhs: AnyObject?, rhs: AnyObject?) -> Bool
  ```

  ```swift
  let str1 = NSString(format: "%@", "str")
  let str2 = NSString(string: str1)
  if str1 == str2 {
    print("str1 is equal to str2")
  }//"str1 is equal to str2"
  
  if str1 === str2 {
    print("str1 is identical to str2")
  }else {
    print("str1 is Not identical to str2")
  }//"str1 is Not identical to str2"
  ```



## 반복문 ch(07)

Labeled Statements (Swift Only)

- 자바와 유사
- 반복문, switch 조건문에 이름 지정 가능

```swift
OUTER: for i in 0..<3 {
  for j in 0...10{
    if j>2 {
      break OUTER
    }
    print("inner \(j)")
  }
  print("OUTER \(i)")
}
//inner 0
//inner 1
//inner 2
```



## Memory & pointer (ch08)

- #### 2의 보수 표기법

  - 양수의 비트 값을 `~` 비트연산 하고, +1 하여 음수를 표현
  - ~ 비트 연산 : 비트가 1인 경우 0, 0인 경우 1
  - -22 의 보수 표기법
  - 1) |22| = 00010110 
  - 2) ~(00010110) = 11101001
  - 3) +1 => 11101010
    - 맨 앞의 1비트는 sign bit
    - MSB <-> LSB 7비트(1101001)는 데이터 비트가 된다. 

- #### 빅엔디언/리틀엔디언

  - 바이트 배열 방식에 따라
  - 최상위 비트가 먼저 배열되면 빅엔디언
  - 최하위 비트가 먼저 배열되면 리틀엔디언 (intel)
  - 현재 시스템의 바이트 오더 처리 방법 : CFByteOrderGetCurrent()
  - 바이트 오더 변호나 함수 : CFSwapXXXBigToHost(), CFSwapXXXLittleToHost() 등

- #### 메모리 공간 분류

  - 스택
    - 지역변수, 파라미터, 리턴 값 등이 저장됨. 
    - LIFO 방식의 스택으로 메모리 공간 관리
    - 함수 실행시 함수에서 사용하는 모든 지역변수, 리턴값이 스택 영역에 추가. 
    - 함수 종료시 스택 프레임이 스택영역에서 제거됨
  - 힙
    - 동적 할당 데이터 저장
  - 데이터영역
    - 정적 변수, 전역 변수 저장
  - 코드영역
    - 기계어로 변환된 프로그램 code 저장

- #### 포인터

  - **Objective-C** : 변수 선언시 자료형과 변수 이름 사이에 `*` 추가하여 포인터 변수 생성

    ```objective-c
    int a = 7;
    int * ptr = &a;
    NSLog(@"%p", ptr); //0x7ff5fbff7fc
    NSLog(@"%p", &a); //0x7ff5fbff7fc
    int value = *ptr;
    NSLog(@"%d", value); //7
    *ptr = 123;
    NSLog(@"%d", *ptr); //123
    NSLog(@"%p", a);	//123
    ```

    - ptr 변수에는 a 변수의 주소가 저장됨.
    - ptr 변수가 가리키는 주소에 저장된 값을 출력할 때는 * 연산자를 사용

  - const 키워드 사용시 포인터 자체가 상수가 되거나, 포인터가 가리키는 대상이 상수가 됨

    ```objective-c
    1) 자료형* const 포인터 이름; 
    // 상수 포인터 - 포인터가 가리키는 곳의 값을 변경할 수는 있음
    int b = 123;
    int* const constPtrToValue = &b;
    *constPtrToValue = 12345;
    NSLog(@"%d, %d", *constPtrToValue, b); //12345, 12345
    // 가리키는 대상은 변경 불가.
    constPtrToValue = &a; //Error
    ```

  - const 키워드가 *문자 앞에 있는 경우는 포인터 변수가 됨.

    ```objective-c
    2) const 자료형* 포인터 이름;
    int c = 123;
    int b = 12345;
    //ptrToConstValue 가 상수가 되지는 않는다. ptrToConstValue포인터가 가리키는 곳의 값을 상수화 한다.
    const int* ptrToConstValue = &c;
    NSLog(@"%d, %d", *ptrToConstValue, c); //123, 123
    ptrToConstValue = &b;
    NSLog(@"%d", *ptrToConstValue); //12345
    // 포인터가 가리키는 곳의 값을 변경할 수 없다.
    *ptrToConstValue = 7; //에러
    ```

    

  #### Swift 포인터

  - 직접 생성하고 조작하지 않음. 안티패턴임

  - 호환성을 위해 문법적으로만 제공

  - 주소 전달시에는 & 연산자 사용

  - Unsafe가 포함된 이름을 가진 제네릭 자료형으로 포인터를 선언

    > UnsafePointer<자료형>
    >
    > UnsafeMutablePointer<자료형>
    >
    > AutoreleasingUnsafeMutablePointer<자료형>

    | C 포인터          |      | Swift 포인터                              |
    | ----------------- | ---- | ----------------------------------------- |
    | const 자료형 *    |      | UnsafePointer<자료형>                     |
    | 자료형 *          |      | UnsafeMutablePointer<자료형>              |
    | 자료형 * const *  |      | UnsafePointer<자료형>                     |
    | 자료형 * __strong |      | UnsafeMutablePointer<자료형>              |
    | 자료형 * *        |      | AutoreleasingUnsafeMutablePointer<자료형> |

    | Objective-C                      |      | Swift                  |
    | -------------------------------- | ---- | ---------------------- |
    | const 자료형 * _Nonnull          |      | UnsafePointer<자료형>  |
    | const 자료형 * _Nullable         |      | UnsafePointer<자료형>? |
    | const 자료형 * _Null_unspecified |      | UnsafePointer<자료형>! |

    

  

  



## value & reference(ch09)

### 1. Value Type

#### 종류

- 정수/실수/Bool/문자 등 기본자료형
- 구조체
- 열거형

#### 저장위치

- 선언과 동시에 메모리 공간 자동 생성

- 메모리의 **스택 영역에 저장**

#### 소멸 시점

- 속한 범위의 코드 실행 종료시 자동으로 제거

#### 비교 방식

- 스택에 저장된 실제 값 비교



### 2. Reference Type

#### 종류

- 클래스
- 문자열
- 배열
- 블록 / 클로저

#### 저장위치

- 스택과 힙 영역에 각각 하나씩, 두개의 메모리 공간 필요
  - **참조 형식 값**은 **힙** 영역에 저장되고 
  - **<u>스택</u>**에는 <u>**힙 영역에 저장된 값의 주소가 저장**</u>됨

- 선언 후 값 초기화 없으면 기본으로 NULL

- 직접 메모리 공간을 생성해야 함 (alloc, 생성자 )

  ```objective-c
  //Objective-C
  NSString* str = [[NSString alloc]] initWithString:@"Hello"];
  //Swift
  var str: NSString = NSString(string: "Hello");
  ```

#### 소멸 시점

- 직접 제거하기 전까지 메모리공간에서 사라지지 않음.
  - C => free
  - Objective-C / Swift 
    - MRC => 참조 형식에 nil 할당
    - ARC => 컴파일 단계에서 자동으로 해제 작업을 고려함

#### 특징

- 파라미터로 전달되거나 리턴값으로 사용될 때, **<u>힙 공간에 저장된 값 대신 스택공간에 저장된 주소가 전달.</u>**
  - 참조형식에 저장된 값은 보통 2개 이상 —> 값 형식보다 데이터가 크다. 
  - 따라서 값의 복사로 복사본 생성시 메모리 낭비 심함

#### 비교 방식

- objective-c 

  - 주소 비교 방식과 힙에 저장된 값을 비교하는 방법을 별도로 제공

  - 힙 영역 저장된 실제 값 비교 : 메소드를 통해 비교 (NSString의 isEqualToString(_:) 등)

  -  `스택`에 저장된 `참조 형식의 주소` 의 비교 : 비교 연산자 (==, !=) 

    

- swift 

  - 값 비교는 비교연산자 (==, !=) , 
  - **주소 비교**는 **항등 연산자 (===, !==)** 를 사용



### 박싱 / 언박싱 (Objective-C)

- #### 박싱 : 값 타입 -> 참조 타입

  - int a —> NSArray 배열에 저장하려면 NSNumber 클래스로 박싱
  - 실제 대상의 타입을 변경하는 것은 아님. 값 형식과 동일한 값을 가진 새로운 참조 형식을 생성

- #### 언박싱 : 참조 타입 -> 값 타입

  - 참조 형식의 힙 영역에 저장된 값과 동일한 값을 가진 새로운 값 형식을 생성

- #### 박싱/언박싱 과정에서 자료형 불일치로 인한 값의 손실 발생 가능에 유념



----

## Function(ch13)

- 함수 파라미터

  - Objective-c : 변수
  - Swift : 상수
    - 파라미터로 전달되는 값이 의도와 다르게 변경되는 오류를 방지 
    - 코드의 유연성 저하

- Swift

  - 파라미터 기본값 제공
  - Argument Label & Parameter Name 제공

- ### Call by Value vs Call by Ref

  - 파라미터에 인자 전달 방식

  - 구조체 : call by value

    - 인자의 값을 전달

  - 클래스 : call by reference

    - 인자의 값이 저장된 메모리 주소를 전달
    - swift에서는 Call by Value 전달된 파라미터는 상수이므로 함수 내부에서 값 변경 불가 (상수 취급)
      - Call by ref로 전달된 파라미터는 값을 변경할 수 있다.

  - 입출력 파라미터 (**inout**, Swift only)

    - 포인터 대신 inout 키워드 씀

    - 파라미터 자료형 앞에 쓰임

      ```swift
      func functionName(paramName: inout paramType){}
      ```

- #### Swift의 함수 특징

  - 파라미터의 자료형과 리턴형으로 구성된 `함수 데이터 타입`으로 표현 가능 

  - ```swift
    (Int, Int) -> Int
    
    //Ex
    func add(_ a: Int, _ b: Int) -> Int{
        print(#function)    //add(_:_:)
        return a+b
    }
    func subtract(_ a: Int, _ b: Int) -> Int{
        print(#function)    //subtract(_:_:)
        return a-b
    }
    add(1,2) 
    subtract(5,3)	
    ```

### Nested Functions (Swift)

- 함수 내부에 또 다른 함수를 구현할 때, 이 내포된 함수를 일컫는 말

- 사용범위가 자신을 포함하는 함수의 범위로 제한됨 —> 은닉성

  ```swift
  func selectOperator(operator op: String) -> ((Int, Int) -> Int)? {
    let str = "call nested function"
  	func add(_ a: Int, _ b: Int) -> Int{
      print("\(str) [\(#function)]")    //add(_:_:)
      return a+b
  	}
    func subtract(_ a: Int, _ b: Int) -> Int{
        print("\(str) [\(#function)]")    //subtract(_:_:)
        return a-b
    }
    func multiply(_ a: Int, _ b: Int) -> Int{
        print("\(str) [\(#function)]")   //multiply(_:_:)
        return a*b
    }
    func divide(_ a: Int, _ b: Int) -> Int{
        print("\(str) [\(#function)]")    //divide(_:_:)
        return a/b
    }
    switch op {
      case "+":
      	return add
      case "-":
     		 return subtract
      case "*":
     		 return multiply
      case "/":
  	    return divide
      default:
      	return nil
    }
  }
  ```

  - Nested 함수는 자신을 포함한 함수에 선언된 변수와 파라미터의 값에 접근하거나 다른 Nested 함수를 자유롭게 호출

## Closure & block (ch14)

### Objective-C : block

#### 선언

```objective-c
//1. 블록 선언
^리턴형 (파라미터 목록){
  // 실행 코드
}
//리턴형과 파라미터 목록 생략 가능
^{
  // 실행코드
}

//2. 블록 변수 선언
블록의 리턴형 (^블록 변수 이름) (파라미터 데이터 타입 목록)
void (^simpleBlock)(void) = ^{
  NSLog(@"Hello, world");
};
simpleBlock();
simpleBlock = nil
simpleBlock(); //에러
```

- 블록은 참조형식이므로 nil 가능

##### 블록에 파라미터 전달 방식 

```objective-c
void (^simpleParameterBlock)(NSString *) = ^(NSString* str){
  NSLog(@"Hello, %@", str);
};
simpleParameterBlock(@"Objective-C Blocks");
//Hello, Objective-C Blocks
```

##### 리턴값 명시하지 않으면 블록 내 return 명령문을 통해 결정

```objective-c
^(NSString * str){
  return [NSString stringWithFormat:@"Hello, %@", str];
};
```

##### 리턴값 명시하지 않고, 2개이상의 return 문 존재시 Data Type이 다르면 컴파일 오류 발생. 동일 자료형을 리턴해야 한다.

```objective-c
^(int a, double b){
  if( a < b){
    return b;
  }else {
    return a; //Error --> (double) a;로 변경
  }
};
```



### Swift : Closure

- 3가지 형태 
  - 이름을 가진 클로저 : 전역 함수, 내포 함수
  - 익명 함수
  - 인라인 클로저

#### 선언

```swift
//기본 방식
{ (파라미터 목록) -> 리턴형 in 실행 코드}
// 파라미터와 리턴형 없는 경우 생략
{ 실행 코드 }
```

##### 파라미터와 리턴형 갖는 클로저

```swift
let simpleClosure = { (str : String) -> String in 
		return "hello, \(str)"
}
let result = simpleClosure("Swift Closure")
print(result) //hello, Swift Closure
```



##### Closure를 파라미터로 받는 함수

```swift
func performClosure(_ c: (String) -> (String)){
  let result = c("Swift Closure")
  print(result)
}
```



##### 클로저를 인자로 전달시, 변수/상수/인라인 클로저로 전달 가능

```swift
func performClosure(_ c: (String) -> (String)){
  let result = c("Swift Closure")
  print(result)
}
//상수 클로저를 전달
let simpleClosure = { (str : String) -> String in 
		return "Hello, \(str)"
}
performClosure(simpleClosure) //Hello, Swift Closure
//인라인 클로저
performClosure({ (str: String) -> (String) in 
               return "Hello, \(str)"
})//Hello, Swift Closure
```

인라인 클로저가 하나의 return 문으로 구현시 return 키워드 생략 가능 

```swift
performClosure({ str in 
		"Hello, \(str)"
})
//인자 생략 후 번호로 대체 
performClosure({
		"Hello, \($0)"
})
```



### Capture Value

- 클로저는 자신이 선언되어있는 범위에 있는 변수에 접근 가능
- 클로저 외부에 선언된 변수를 클로저 내부에서 사용하기 위해 값을 획득 

- 클로저가 획득한 값은 원래 범위 벗어나더라도 클로저가 실행되는 동안 메모리에 유지됨

#### 값을 획득하는 방식 1 - 클로저 내부로 복사본 전달 : Objective-C 블록 기본동작

##### **예제 1)- 블록 외부에 선언된 num 변수 값을 블록 내부에서 접근하는 코드**

```objective-c
NSUInteger num = 0;
void (^block)(void) = ^{
  NSLog(@"inside of block: %d", num);
};
num += 10;
NSLog(@"outside of block: %ld", num);
block();
//outside of block: 10
//inside of block: 0
```

- num 변수는 블록이 선언되는 시점에 복사되어 **복사본**(0)이 블록 내부로 전달된다.
- 외부에서 num 변수 값을 변경하더라도 **복사본의 값은 획득된 시점의 값(0)을 유지**

##### 예제 2) -  획득된 **값을 `블록 내부에서 변경`하는 경우**

```objective-c
NSUInteger num = 0;
void (^block)(void) = ^{
  num += 10;	// Error 외부에서 캡쳐한 값 변경 불가.
  NSLog(@"inside of block: %ld", num);
};
NSLog(@"outside of block: %ld", num);
block();
```

- 기본적으로 획득된 변수의 값을 변경 불가

##### 예제 3) - 획득한 값을 변경하려면 — 블록 외부에서 대상변수에 키워드 선언 : `__block`

```objective-c
__block NSUInteger num = 0;
void (^block)(void) = ^{
  num += 10;	
  NSLog(@"inside of block: %ld", num);
};
NSLog(@"outside of block: %ld", num);
block();
NSLog(@"outside of block: %ld", num);
//outside of block: 0
//inside of block: 10
//outside of block: 10
```

- 클로저 작동방식과 동일
- __block 키워드 선언시 **복사본 대신 참조가 전달**된다.

- __block 선언된 변수는 <u>자신이 포함된 범위</u>와 <u>블록의 범위</u>가 **<u>모두 종료될 때까지 유지</u>**

----





#### 값을 획득하는 방식 2- 복사본 대신 참조가 내부로 전달되는 것 : Swift Closure 기본 동작

##### 예제 1) - 클로저 외부에 선언된 num 변수 값을 클로저 내부에서 접근하는 코드

```swift
var num = 0
let closure = { print("inside of block: \(num)")}
num += 10 
print("outside of block: \(num)")
closure()
//outside of block: 10
//inside of block: 10
```

- Swift 코드에서는 클로저가 선언된 시점에 num의 **참조**가 클로저 내부로 전달됨
- 외부에서 num 변수의 값을 변경하면 **블록 내부에서 접근하는 num의 값도 변경**됨



#####  예제 2) - 획득한 값을 클로저 내에서 변경

```swift
var num = 0
let closure = { 
  num += 10 
  print("inside of block: \(num)")
}
	
print("outside of block: \(num)")
closure()
print("outside of block: \(num)")

//outside of block: 0
//inside of block: 10
//outside of block: 10
```

- 획득한 값을 변경할 수 있고, 클로저 내부에서 num 변경시 외부의  변수도 같은 값으로 변경된다.

- 순환 참조 주의



### 클로저 활용 예

#### 1) GCD

#### 2) Enumeration

- 컬렉션 —> 블록 통해 열거 성능 높이는 방법 제공 ex) NSArray —> enumerateObjects

  ```swift
  let list: NSArray = ["Apple" , "Orange", "Melon"]
  #if swift(>=3.0)
  list.enumerateObjects(options: NSEnumerationOpetions.concurrent){
    (element, index, stop) in 
    print(element)
  }
  ```

#### 3) 고차함수 Map, Reduce,Filter



## Collection(ch16)

- 데이터 모음을 쉽게 처리하기 위한 자료형
  - Array, Dictionary, Set
  - 요쇼 : 컬렉션에 저장된 개별 데이터
  - Entry : Key값의 묶음을 지칭하는 말.
- Foundation 컬렉션에 저장할 수 있는 요소는 `객체` 로 제한됨.



### 컬렉션 가변성

- 컬렉션은 초기화 후에 요소를 편집(추가, 수정, 삭제) 할 수 있는가에 따라 Mutable Type과 Immutable 타입으로 구분됨.
- Immutable Collection : 개별 요소에 **접근**하고 모든 요소를 **열거**, **검색** 기능을 제공
- Mutable Collection : Imuutable Collection 기능 + 요소 편집/추가/삭제 기능
- Foundation 프레임워크 : 3가지 불변 컬렉션 클래스와 이를 상속한 가변 컬렉션 클래스를 제공
  - NSArray / NSMutableArray
  - NSDictionary / NSMutableDictionary
  - NSSet / NSMutableSet
- 스위프트 : 별도의 자료형 구분 x, `let`, `var` 키워드로 컬렉션의 가변성 결정

- 컬렉션의 가변성은 **컬렉션에 저장된 요소의 가변성과는 무관**하다. 영향을 주지 않음
  - 가변 컬렉션 내 불변 문자열 : 컬렉션에 새 문자열 추가는 가능하나, 불변 문자열의 내용 변경 불가
  - 불변 컬렉션 내 가변 문자열 : 새 문자열 추가 불가. 가변 문자열은 수정 가능
- copy-on-write : 메모리 공간 낭비를 막기 위한 정책
  - Swift Collection도 cow 최적화 적용
  - 매번 복사를 수행하지 않고, 실제 복사가 필요한 시점까지 연기



### Array

- 요소 순서정렬 / 인덱스 사용 / 중복 요소 저장 가능
- Foundation : NSArray, NSMutableArray
- Swift : Array
  - 참조형식 / 값 형식 저장 가능
  - 모든 요소의 자료형이 동일해야 함

#### Objective-C

- @[ 와 ] 사이에 요소를 나열한 형태로 표현

  ```objective-c
  @[ 요소1, 요소2, 요소3, 요소N ]
  @[]//빈 배열
  ```

##### 선언과 동시에 초기화

- ```objective-c
  NSArray* stringArray = @[@"Apple", @"Orange", @"Banana"];
  ```

##### 생성자 사용한 초기화 

- arrayWithObjects(_:) 메서드 사용시 반드시 마지막에 nil 전달해야 함

  ```objective-c
  NSArray* stringArray = [NSArray arrayWithObjects]:@"Apple", @"Orange", @"Banana", nil];
  ```

##### 빈 배열 생성

- ```objective-c
  NSMutableArray* emptyArray = [NSMutableArray array];
  ```

- 가변 배열을 빈배열로 선언

##### 배열 요소의 수 -  count / 빈 배열 체크 - isEmpty

- ```objective-c
  NSArray* fruits = @[@"Apple", @"Orange", @"Banana"];
  NSUInteger countOfFruits = fruits.count;
  
  if (countOfFruits > 0 ){
    NSLog(@"%ld element(s)", countOfFruits);
  }else {
    NSLog(@"emtpy array");
  }
  // 3 element(s)
  ```

##### 요소 접근

- objectAtIndex(_:) : NSArray 내 특정 인덱스 안에 있는 요소를 리턴하는 메서드

- ```objective-c
  NSArray* fruits = @[@"Apple", @"Orange", @"Banana"];
  NSString* fruit = [fruits objectAtIndex: 0];
  NSLog(@"%@", first);
  //Apple
  NSString* last = [fruits objectAtIndex: fruits.count - 1];
  NSLog(@"%@", first);
  //Banana
  ```





-----



#### Swift

- 배열 리터럴은 [ 요소, 요소 ...] 

- Foundation / Swift 상관없이 동일한 리터럴 사용

  ```swift
  [ 요소1, 요소2, 요소3, 요소N ]
  [] //emtpy
  ```

##### 선언과 동시에 초기화

- ```swift
  let stringArray = ["Apple", "Orange", "Banana"] //swift
  let stringArray: NSArray = ["Apple", "Orange", "Banana"] //Foundation
  ```

##### 생성자 사용한 초기화 

- ```swift
  let stringArray = Array(["Apple", "Orange", "Banana"])
  let stringArray = NSArray(objects: "Apple", "Orange", "Banana" )
  ```

##### 빈 배열 생성

- ```swift
  let emtpyArray1: NSMutableArray = []
  let emtpyArray2 = NSMutableArray()
  
  var emtpyStringArray1: Array<String> = []
  var emtpyStringArray2: Array<String>()
  var emtpyStringArray3: [String] = [] //sugar syntax
  var emtpyStringArray4 = [String]()
  
  
  ```

- 다만 빈 배열은 타입추론이 불가능하므로 타입정보 있어야 함

  ```swift
  var emtpyArray = [] //error
  ```

##### 배열 요소의 수 -  count / 빈 배열 체크 - isEmpty

- ```swift
  let fruits = ["Apple", "Orange", "Banana"]
  let countOfFruits = fruits.count
  if !fruits.isEmtpy {
    print("\(countOfFruits) element(s)")
  }else {
    print("empty array")
  }
  // 3 element(s)
  ```



##### 요소접근 

- ```swift
  let fruits = ["Apple", "Orange", "Banana"]
  let first = fruits[0]
  let last = fruits[fruits.count-1]
  let first = fruits[fruits.startIndex]
  let last = fruits[fruits.endIndex-1]
  ```



##### 요소 검색 

- ```swift
  if fruits.contains("Apple") {
      print("Apple Found")
  }
  ```

  



## Enumeration(ch17)

- 서로 연관된 상수 집합에 이름을 붙이고 새로운 자료형으로 만드는 매우 단순한 역할
- 코드의 가독성을 높여줌
- `enum` 키워드로 선언
- 열거형/열거형 멤버 이름은 CamelCase 방식으로 지정



 

### Objective-C

- C 스타일 열거형

- 선언 순서에 따라 0부터 시작하는 정수형 원시값을 갖는다.

  - 정수형 원시값을 직접 지정하려면 선언 시점에 값을 직접 할당.

  ```objective-c
  enum EnumName{
    enumMember1, enumMember2, enumMemberN
  };
  enum Weekday { Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday};
  NSLog(@"%d", Sunday);
  //0
  enum Weekday { Sunday, Monday, Tuesday, Wednesday, Thursday = 10, Friday, Saturday};
  NSLog(@"%d", Thursday);
  //10
  ```

- 열거형 변수 선언

  - 열거형 앞에 enum 키워드

  ```objective-c
  enum Weekday week = Sunday;
  //실제 사용방법 - 열거형에 typedef로 새 이름 부여 후 enum 키워드 없이 일반 자료형처럼 사용
  typedef enum _Weekday { Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday } Weekday;
  Weekday week = Sunday;
  ```

- ##### 열거형 변수에 저장된 값  비교 - switch 조건문

- ```objective-c
  typedef NS_ENUM(NSUInteger, Weekday) { Sunday = 1, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday };
  NSCalendar* calendar = [NSCalendar currnetCalendar];
  Weekday week = [calender component:NSCalendarUnitWeekday fromDate:[NSDate date]];
  switch (week) {
    case Sunday:
      NSLog(@"Today is Sunday");
      break;
      //..
  }
  ```

#### objective-c 열거형 문제점

- 열거형 멤버의 원시 값과 일치하지 않는 정수 할당해도 컴파일러에서 오류 체크 불가

  ```objective-c
  Weekday week = 100; //정상처리됨
  ```

- 열거형 비교시 반드시 원시 값 이외의 값을 처리할 수 있는 코드를 작성해야 함.

- 두 열거형의 원시값이 같은 경우, 논리적 오류 발생 

  ```objective-c
  enum Weekday { Sunday=1, Monday=1, Tuesday, Wednesday, Thursday = 10, Friday, Saturday};
  NSLog(@"%d", Thursday);
  if (week == Sunday){
    //..
  }else if (week == Monday){
    //..
  }
  ```

  





---

---



### Swift

- C 스타일 열거형의 단점 개선
- 클래스, 구조체의 기능들 적용
  - **associated Value, 인스턴스 메서드, 생성자** 보유 가능.
  - **프로토콜** 채택 가능
- **일급 객체**로 일반 자료형과 동일 지위

- 열거형 멤버 나열시 `case` 키워드 사용
- 하나의 case에서 여러 멤버 동시 나열시 `,` 로 구분
- 멤버 이름은 `camelBack` 방식



- ```swift
  enum 열거형이름{
    case member1
    case member2
    case member3, member4, member5
  }
  enum Weekday{
    case sunday, monday, tuesday, wednesday, thursday, friday, saturday
  }
  ```

- 명시적으로 원시값 지정하지 않는 한, 원시값 없음

- 타입추론 -> **변수의 자료형 직접 지정시, 열거형 이름 생략 가능**

  ```swift
  if Weekday.sunday == 0 { //error
  }
  let week: Weekday = .sunday
  let week = .sunday //error
  ```

##### 원시 값

- 선언 시점에 원시 값의 자료형 지정하면 rawValue 지님

- 문자열, 실수 등 다양한 자료형이 rawValue로 가능

  ```swift
  enum 열거형이름: rawValueType{
    case member1
    case member2
    case member3, member4, member5
  }
  enum Weekday: Int{
    case sunday, monday, tuesday, wednesday, thursday, friday, saturday
  }//0부터 1씩 증가하는 값으로 초기화 
  ```

  - 0부터 1씩 증가하는 값으로 초기화
  - Float, Double도 동일
  - 특정 멤버의 원시값 직접 지정 가능 
  - **서로 다른 두 멤버에 동일한 원시값 지정시 컴파일 에러**

  ```swift
  enum WeekdayName: String{
    case sunday = "SUN", monday, tuesday, wednesday, thursday, friday, saturday
  }
  print(WeekdayName.sunday) //sunday
  print(WeekdayName.sunday.rawValue) // SUN
  print(WeekdayName.monday) //monday
  print(WeekdayName.monday.rawValue) //monday
  ```



#### 연관 값 (Associated Value)

- 열거형 멤버에 부가적인 정보 저장 가능 

- **원시값과 달리** 각각의 멤버가 **서로 다른 자료형 사용** 가능.

- 자료형의 종류에 제한 없음

- rawValue는 열거형 선언 시점에 초기화

  - 초기화 이후에 변경 불가. 
  - 동일 열거형 멤버는 동일한 원시값 지님

- associated Value 는 **열거형을 자료형으로 사용하는 <u>변수나 상수를 초기화 할 때</u>**, 멤버 중 하나를 기반으로 **<u>초기화</u>**

  - 초기화 이후에 다른 값을 할당 가능
  - 동일멤버, 서로다른 연관값 가능 
  - 타언어의 Variants, Tagged Unions, Discriminated Unions 등과 유사 기능

- ```swift
  enum DateFormat{
    case long(Int, Int, Int, String)	//year-month-day-요일
    case short(Int, Int)							//month-day
  }
  ```

- 열거형 멤버가 **<u>연관 값을 가지도록 선언할 경우에는 원시 값을 가질 수 없음</u>**
- **연관값을 갖는 열거형 멤버를 원시값으로 초기화**하거나 **rawValue 속성에 접근하는 코드**는 **컴파일 오류를 발생**시킴

- ```swift
  enum DateFormat{
    case long(Int, Int, Int, String) = (1970, 1,1, "thursday")	//Error
    case short(Int, Int) = (1,1)					//Error
  }
  ```

- 열거형 멤버의 **연관값은 열거형을 변수/상수에 할당하는 시점에 초기화** 된다. **생성자를 통해 값을 생성**한다.

- ```swift
  let startDate = DateFormat.long(2016, 5, 1, "Sunday")
  var endDate = DateFormat.long(2016, 5, 7, "Saturday")
  endDate = .short(8, 31)
  endDate = .short(9,2)
  
  switch startDate {
    case .long(let year, let month, let day, let weekday):
    	print("\(year)-\(month)-\(day) \(weekday)")
    case .short(let month, let day):
    	print("\(month)-\(day)")
  }
  //2016-5-1 Sunday
  ```

- 연관 값 사용하는 경우 switch에서 **각 case에 값 바인딩 구문을 사용하여** <u>연관 값을 변수나 상수로 받아올 수 있음</u>

  - startDate는 **.long** 에 매칭되므로 **.long**에 할당된 **<u>날짜/요일이 값 바인딩 구문의 각 상수에 순서대로 할당</u>**된다.

- 특정 요소 사용하지 않는 경우 `_` 로 값 바인딩에서 제외 

  ```swift
  switch endDate {
    case .long(let year, let month, let day, let weekday):
    	print("\(year)-\(month)-\(day) \(weekday)")
    case .short(let month, _):
    	print("\(month)")
  }
  //9
  ```

  



## Struct & class (ch18) **



#### 구조체와 클래스 비교

|                    | Objective-C 구조체 | swift 구조체 | Objective-C 클래스 | swift  클래스 |
| :----------------: | :----------------: | :----------: | :----------------: | :-----------: |
|        형식        |      값 형식       |   값 형식    |     참조 형식      |   참조 형식   |
|     속성 구현      |         O          |      O       |         O          |       O       |
|    생성자 구현     |         X          |      O       |         O          |       O       |
|    소멸자 구현     |         X          |      X       |         O          |       O       |
|    메소드 구현     |         X          |      O       |         O          |       O       |
|     subscript      |         X          |      O       |         O          |       O       |
| extension으로 확장 |         X          |      O       |         O          |       O       |
|   protocol  채택   |         X          |      O       |         O          |       O       |
|        상속        |         X          |      X       |         O          |       O       |
|    참조 카운팅     |         X          |      X       |         O          |       O       |

- Objective-C 구조체는 런타임 이점을 사용할 수 없으므로 사용자 정의 자료형을 Value type으로 구현하는 것을 제외하고는 클래스로 구현하는 것이 일반적
- Swift 구조체는 여러 기능이 구현 가능
  - Swift는 값 형식인 구조체를 선호
  - **동적 바인딩, Dynamic Dispatch** 등 <u>클래스 사용시 발생하는 부하 비용</u>을 **피할 수 있기 때문**

//Objective-C 구조체 설명 생략





----

### Swift 구조체

```swift
struct StructName{
  var/let member1: dataType
  var/let member2: dataType
}
struct Person {
  var name: String
  var age: Int
}
```

- 구조체 변수 선언 방법은 일반 변수와 동일
- 구조체 멤버 값을 읽거나 새로운 값 할당하기 전에 **반드시 유효한 값으로 초기화 되어야 함**
- 초기화 : 생성자 사용
- 생성자 직접 구현않는 경우 : **멤버별 생성자가 자동 제공**

```swift
var someone = Person(name: "John Kim", age: 0)
```



---



### Objective-C 클래스

- 선언과 구현이 분리됨
- 헤더파일(.h)에 선언 코드 작성
- 구현파일(.m)에 구현 코드 작성
- 파일 이름은 클래스 이름과 동일하게 지정하는 것이 관례
  - 클래스 이름은 프로젝트 내에서 유일해야
- NSObject 클래스를 상속함



#### @interface / @end

- @interface : 클래스 선언 지시어
- @end : 클래스 선언 완료하는 지시어

```objective-c
@interface className : SuperClassName{
  //인스턴스 변수 선언 목록
  //클래스 속성 나타내는 변수들. 
  //클래스 내부에만 접근 가능한 private 변수들을 선언
}
@property 선언 목록 
메소드 선언 목록
@end
```

- 클래스 선언은 클래스 제공하는 공개속성과 메소드를 선언
- 다른 소스파일에서 클래스 사용시 클래스 선언이 포함된 헤더파일을 `import` 해야 함
- 클래스 이름/상위클래스 이름은 필수 요소. (최소한 모든 클래스의 super인 NSObject는 상속해야 함)
- 나머지 선언 목록은 생략 가능

##### 인스턴스 변수 선언 목록

- 클래스 내부에만 접근 가능한 `private` 변수들
- 선언 없는 경우 **{ }** 도 함께 생략 가능

##### @property 선언 목록

- 클래스 외부에서 접근 가능한 `public` 변수들



#### @implementation / @end

- Objective-C 의 클래스 구현을 시작하는 지시어
- @end 지시어로 끝남

```objective-c
@implementation 클래스이름 {
  // 인스턴스 변수 선언 목록
}
메소드 구현 목록
@end
```

- 클래스 이름 뒤에는 상위 클래스 지정 필요 없음 (헤더파일에서 지정했으므로 )
- 변수 선언 목록은 { } 와 함께 생략 가능

##### Person 클래스 선언(Person.h)

```objective-c
@interface Person: NSObject;
@property(strong, nonatomic) NSString* name;
@property(assign, nonatomic) NSUInteger age;
- (void) sayHello;
@end
```

##### Person 클래스 구현 (Person.m)

```objective-c
@implementation Person
- (void) doSomething {
  //..
}
- (void) sayHello {
  NSLog(@"Hello, World! I'm %@.", self.name);
}
@end
```



##### 외부에서 Person class import 하기

- Person 클래스를 사용하는 Car 클래스 (Car.h)
- 헤더파일에서 클래스 헤더를 임포트

```objective-c
#import "Person.h"
@interface Car: NSObject
@property(strong, nonatomic) Person* lessee;
@end
```

- Car.m

```objective-c
@implementation Car
- (void) report {
  NSLog(@"%@", self.lessee.name);
}
@end
```



#### 헤더파일 상호 참조 문제 (순환 import) : Person class에 Car 자료형의 속성 추가하는 경우 

Person.h 에 다음과 같이 Car 자료형 속성 추가하면 오류 발생

```objective-c
#import "Car.h"
@interface Person: NSObject;
@property(strong, nonatomic) NSString* name;
@property(assign, nonatomic) NSUInteger age;
@property(strong, nonatomic) Car* rentedCar; // car 속성 추가
- (void) sayHello;
@end
```

- Car.h 파일과 Person.h 파일이 서로 import 하는 상황에서는 컴파일을 정상완료 할 수 없음
  - 상호 참조를 피하려면 header import 없이 클래스 인식할 수 있는 방법이 필요함. 



#### @class (forward declaration)

- Objective-C에서 `@class` 키워드로 클래스 선언(`클래스 전방 선언`)시 상호 참조 문제를 피할 수 있음
- 상호 참조하는 두 헤더파일 중 하나에만 적용해도 해결 가능.

```objective-c
//Car.h
//#import "Person.h" 삭제
@class Person;

@interface Car: NSObject
@property(strong, nonatomic) Person* lessee;
@end
```

- header 파일에 `클래스 전방 선언` 시 Person이 클래스임을 인식은 시키나 해당 클래스의 속성을 알 수 없으므로 **실제 전방 선언된 클래스를 사용하는 <u>구현부 코드에서 헤더 파일을 임포트</u>**해야 함.

```objective-c
#import "Person.h"

@implementation Car
- (void) report {
  NSLog(@"%@", self.lessee.name);
}
@end
```



#### Objective-C 클래스 초기화 방법

- init 메소드 : 생성자 메소드. 생성자 역할 대신함
- 클래스 인스턴스 생성시 생성자 메소드 호출해야 함.

- 초기화 2단계
  - 1단계 : 메모리에 필요한 공간을 할당. 모든 속성의 값을 0 or  nil 로 설정 (alloc 메소드 담당)
  - 2단계 : 기본 초기화 메소드인 init 호출. 속성의 값을 유효한 값으로 초기화.

```objective-c
//main.m
Person* p = [[Person alloc] init];
Person* p = [Person new]; //new 메소드로 alloc & init을 대체 가능 
```



#### Objective-C 클래스 인스턴스 비교 방법

- == : 메모리 주소 비교
- isEqual : 인스턴스에 저장된 값을 비교

```objective-c
Person* p1 = [[Person alloc] init];
Person* p2 = [[Person alloc] init];

if (p1==p2){
  NSLog(@"%@ == %@", p1, p2);
}else {
  NSLog(@"%@ != %@", p1, p2);
}
//<Person:0x100301580> != <Person: 0x1003031d0>
if ([p1 isEqual:p2]){
  NSLog(@"%@ == %@", p1, p2);
}else {
  NSLog(@"%@ != %@", p1, p2);
}
//<Person:0x100301580> != <Person: 0x1003031d0>
```

- isEqual 메소드는 기본적으로 == 연산자처럼 메모리 주소를 비교함.
- 인스턴스의 값을 비교하려면 isEqual 메소드를 override 하거나 비교 메소드 구현
  - NSString 클래스 : isEqualToString 메소드로 문자열 값 비교

##### 클래스 내 값 비교를 위한 isEqualToPerson 메소드 구현

```objective-c
//Person.h
@interface Person : NSObject
//..
 - (BOOL) isEqualToPerson: (Person*) p;
@end
```

```objective-c
//Person.m
@implementation Person
//..
- (BOOL)isEqualToPerson: (Person*) p{
  if([self isEqual:p]){
    return YES;
  }
  return [p.name isEqualToString:self.name] && p.age==self.age;
}
```

```objective-c
//main.m
Person* p1 = [[Person alloc] init];
p1.name = @"James";
p1.age = 34;

Person* p2 = [[Person alloc] init];
p2.name = @"James";
p2.age = 34;

Person* p3 = [[Person alloc] init];
p3.name = @"Steve";
p3.age = 50;

//메모리 주소 비교
if (p1 == p2){
  NSLog(@"%@ == %@", p1, p2);
}else{
  NSLog(@"%@ != %@", p1, p2);
}
//<Person:0x100301580> != <Person: 0x1003031d0>
//값 비교
if ([p1 isEqualToPerson:p2]) {
  NSLog(@"%@== %@", p1, p2);
}else {
	NSLog(@"%@!= %@", p1, p2);
}
//<Person:0x100301580> == <Person: 0x1003031d0>
//값 비교
if ([p1 isEqualToPerson:p3]) {
  NSLog(@"%@== %@", p1, p3);
}else {
	NSLog(@"%@!= %@", p1, p3);
}
//<Person:0x100301580> != <Person: 0x1003031ee>
```



##### 값의 크기 비교시 - NSComparisonResult 리턴하는 compare 메소드 구현

- NSComparisonResult: 값의 크기를 비교할 때 사용하는 열거형
- compare: 열거형 NSComparisonResult을 리턴하는 메소드

```objective-c
//Person.h
@interface Person: NSObject
//..
- (NSComparisonResult) compare:(Person*)p;
@end
```

```objective-c
//Person.m
@implementation Person
//..
- (NSComparisonResult) compare:(Person*)p {
  return [@(self.age) compare:@(p.age)];
}
//아래와 같이 compare를 수동으로 구현 가능
- (NSComparisonResult) compare:(Person*)p {
  if(self.age < p.gage){
    return NSOrderedAscending;
  }else if (self.age > p.age){
		return NSOrderedDescending;
  }
  return NSOrderedSame;
}
@end
```

```objective-c
//main.m
Person* p2 = [[Person alloc] init];
p2.name = @"James";
p2.age = 34;

Person* p3 = [[Person alloc] init];
p3.name = @"Steve";
p3.age = 50;

switch([p1 compare:p2]){
  case NSOrderedAscending:
    	//..
    	break;
  case NSOrderedDecending:
    	//..
    	break;
  case NSOrderedSame;
    	//
    	break;
}
```



-----



#### 값 타입 구조체 vs 참조 타입 클래스

#### Value Type

- 값 형식 - 열거형, 구조체, 튜플
- 복사본. 

```objective-c
//objective-c
CGPoint startPoint = CGPointMake(0.0, 0.0);
CGPoint endPoint = startPoint;
endPoint.x = 100;
endPoint.y = 200;
NSLog(@"start point: {%.1f, %.1f}", startPoint.x, startPoint.y);
NSLog(@"end point: {%.1f, %.1f}", endPoint.x, endPoint.y);
//{0.0, 0.0}
//{100.0, 200.0}

//swift
let startPoint = CGPoint (x: 0.0, y: 0.0)
var endPoint = startPoint
endPoint.x = 100
endPoint.y = 200
print("start Point : { \(startPoint.x), \(startPoint.y)}") // {0.0 , 0.0} 
print("end Point : { \(endPoint.x), \(endPoint.y)}")	// { 100.0 , 200.0 }
```



#### cf. Swift 컬렉션 자료형의 특징

- 구조체로 설계
- **Copy - on - write** : 복사시점에 코드 성능에 영향을 주므로 필요한 경우에만 복사 되도록 최적화 수행



#### Reference Type

- 참조를 저장

MyPoint.h

```objective-c
#import <Foundation/Foundation.h>

@interface MyPoint : NSObject
@property CGFloat x;
@property CGFloat y;
- (instancetype)initWithX:(CGFloat)x y:(CGFloat)y;
@end
```

MyPoint.m

```objective-c
#import "MyPoint.h"

@implementation MyPoint
- (instancetype)initWithX:(CGFloat)x y:(CGFloat)y {
    self = [super init];
    if (self) {
        _x = x;
        _y = y;
    }
    return self;
}
@end
```

- main.m

```objective-c
#import <Foundation/Foundation.h>
#import "MyPoint.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // Block1
        {
            CGPoint startPoint = CGPointMake(0.0, 0.0);
            CGPoint endPoint = startPoint;
            
            endPoint.x = 100;
            endPoint.y = 200;
            
            NSLog(@"start point: {%.1f, %.1f}", startPoint.x, startPoint.y);
            NSLog(@"end point: {%.1f, %.1f}", endPoint.x, endPoint.y);
            // start point: {0.0, 0.0}
            // end point: {100.0, 200.0}
        }
        
        // Block2
        {
            MyPoint* startPoint = [[MyPoint alloc] initWithX:0.0 y:0.0];
            MyPoint* endPoint = startPoint;
            
            endPoint.x = 100;
            endPoint.y = 200;
            
            NSLog(@"start point: {%.1f, %.1f}", startPoint.x, startPoint.y);
            NSLog(@"end point: {%.1f, %.1f}", endPoint.x, endPoint.y);
            // start point: {100.0, 200.0}
            // end point: {100.0, 200.0}
        }
    }
    return 0;
}
```



```swift
import Foundation

class MyPoint {
    var x = 0.0
    var y = 0.0
}

let startPoint = MyPoint()
let endPoint = startPoint

endPoint.x = 100
endPoint.y = 200

print("start point: {\(startPoint.x), \(startPoint.y)}")
print("end point: {\(endPoint.x), \(endPoint.y)}")
// start point: {100.0, 200.0}
// end point: {100.0, 200.0}
```

----

---



### Swift Class

- 선언/구현 분리 없음
- 자바나 C#과 동일방식
- 동일 모듈에 있는 클래스 자동인식 — import 불필요
- 다른 모듈 클래스는 import 해야 함

- 상위 클래스 생략 가능 (NSObject 반드시 상속할 필요 없음 )

```swift
class Person {
  var name = ""
  var age = 0
  func sayHello(){
    print("Hello, World! I'm \(name)")
  }
}
let p = Person() //초기화 방법 : 생성자 없는 경우, 파라미터 없는 기본 생성자를 자동 생성
```

- 초기화 방법 
  - 생성자 없는 경우, 파라미터 없는 기본 생성자를 자동 생성



### 클래스 객체

##### Objective-C

- Factory : Objective-C에서 클래스 객체를 부르는 별칭
- `+`: 클래스 메소드 중 `+` 로 선언된 메소드는 팩토리 메소드
  - 새로운 인스턴스 생성하는 역할 수행

##### Swift

- 클래스/구조체/열거형 모두 팩토리 메소드를 가질 수 있음.









-----

-----



