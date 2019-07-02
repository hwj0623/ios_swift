## fizzbuzz 예제를 통한 함수 | 클로저 | 고차함수 | 클로저 개념 알아보기





# #1

- index를 기반으로 for loop

```swift
func fizzbuzz() {
  	for index 1...100{					
      	let isFizz = index % 3 == 0
       	let isBuzz = index % 5 == 0
      	switch(isFizz, isBuzz){
          case (true, true):
          		print("fizzbuzz")
          case (true, _):
          		print("fizz")
          case (_, true):
          		print("buzz")
          default:
          		print("\(index)")
        }
    }
}
```



# #2

- `forEach` 를 사용하여 loop 

```swift
func fizzbuzzEach() {
 		(1...100).forEach { index in
 				let isFizz = index % 3 == 0
 				let isBuzz = index % 5 == 0
				switch (isFizz, isBuzz) {
			 	case (true, true):
 						print("fizzbuzz")
 				case (true, _):
 						print("fizz")
 				case (_, true):
 						print("buzz")
 				default:
 						print("\(index)")
 				}
 		}
}
```



# #3

- fizz와 buzz 클로저를 사용하여 추상화

  

```swift
func fizzbuzzClosure() {
 		let fizz: (Int) -> String = { index in index % 3 == 0 ? "fizz" : ""}
		let buzz: (Int) -> String = { index in index % 5 == 0 ? "buzz" : ""}

		(1...100).forEach { index in
 				let result = fizz(index) + buzz(index)
 				let output = result.isEmpty ? "\(index)" : result
 				print(output)
 		}
}
```





# #4

- `#3`에 이어서 fizz&&buzz인 클로저도 생성
- output에 대해서도 클로저로 작성

```swift
func fizzbuzzDeclarative() {
		let fizz: (Int) -> String = { index in index % 3 == 0 ? "fizz" : ""}
		let buzz: (Int) -> String = { index in index % 5 == 0 ? "buzz" : ""}
		let fizzbuzz: (Int) -> String = { index in
			 { result in
				 result.isEmpty ? "\(index)" : result
			 }(fizz(index) + buzz(index))
 		}
 		let output: (String) -> () = { print($0) }
		///실행부 
		(1...100).map(fizzbuzz).forEach(output)
}
```



# #4-1

- `#4` 의 클로저에서 타입 명시를 생략

```swift
func fizzbuzzDeclarativeCompact() {
		let fizz = { $0 % 3 == 0 ? "fizz" : ""}
		let buzz = { $0 % 5 == 0 ? "buzz" : ""}
		let fizzbuzz = { index in
				{ $0.isEmpty ? "\(index)" : $0
				}(fizz(index) + buzz(index))
		}
		let output = { print($0) }
		(1...100).map(fizzbuzz).forEach(output)
}
```



# #5

- 연산자 함수를 만들어서 fizzbuzz 클로저의 내부 연산 분리

```swift
func + (_ s1: String?, _ s2: String?) -> (String?) {
		if s1 == nil, s2 == nil { return nil }
		if s1 != nil, s2 == nil { return s1 }
		if s1 == nil, s2 != nil { return s2 }
		return s1! + s2!
}
func fizzbuzzMonad() {
		let fizz = { $0 % 3 == 0 ? "fizz" : nil}
		let buzz = { $0 % 5 == 0 ? "buzz" : nil}
		let fizzbuzz = { index in fizz(index) + buzz(index) ?? String(Index) }
		let output = { print($0 ?? "") }
		(1...100).map(fizzbuzz).forEach(output)
}
```



# #6

- map과 forEach에 대해 `iterate` 메서드 내 메서드로 추상화 

```swift
func fizzbuzzInterate() {
		func iterate<A>(_ arr: [A], _ f: ((A) -> ())) {
				arr.forEach({ f($0) })
 		}
		let fizz = { $0 % 3 == 0 ? "fizz" : nil}
		let buzz = { $0 % 5 == 0 ? "buzz" : nil}
		let fizzbuzz = { index in fizz(index) + buzz(index) ?? String(index) }
		let output = { print($0 ?? "") }
		iterate(Array(1...100)) { index in output(fizzbuzz(index)) }
}
```



# #7

- 연산자 재정의를 활용
- 함수의 결과를 다른 함수의 인자로 사용하기에 효과적

```swift
/// 연산자의 우선순위, 적용방법(associativity) 설정
precedencegroup ForwardPipe {
 		associativity: left
 		higherThan: LogicalConjunctionPrecedence
}
/// 중위연산자로 선언
infix operator |> : ForwardPipe
public func |> <A,B,C>(lhs: @escaping (A) -> B, rhs: @escaping (B) -> C) -> (A) -> C {
		 return { result in rhs(lhs(result)) }
}

func fizzbuzzPipe() {
		 func iterate<A>(_ arr: [A], _ f: ((A) -> ())) {
				 arr.forEach({ f($0) })
		 }
 		let fizz = { $0 % 3 == 0 ? "fizz" : nil}
 		let buzz = { $0 % 5 == 0 ? "buzz" : nil}
	 	let fizzbuzz = { index in fizz(index) + buzz(index) ?? String(index) }
	 	let output = { print($0 ?? "") }

 		iterate(Array(1...100), fizzbuzz |> output )
}
```

