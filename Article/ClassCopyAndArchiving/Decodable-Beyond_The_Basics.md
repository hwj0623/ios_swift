# Swift 4 Decodable: Beyond The Basics

다음의 미디엄 글을 바탕으로 학습한 내용을 정리한 것입니다.

[출처](https://medium.com/swiftly-swift/swift-4-decodable-beyond-the-basics-990cc48b7375)



### Basics

```swift
import Foundation

struct Swifter: Decodable {
    let fullName: String
    let id: Int
    let twitter: URL
}

let json = """
{
 "fullName": "Federico Zanetello",
 "id": 123456,
 "twitter": "http://twitter.com/zntfdr"
}
""".data(using: .utf8)! // our data in native (JSON) format
let myStruct = try JSONDecoder().decode(Swifter.self, from: json) // Decoding our data
print(myStruct) // decoded!!!!!
```

- Decodable 프로토콜은 `init(from: Decoder)` 생성자 함수를 반드시 요구한다. 
- 구조체의 경우, 스위프트 컴파일러가 이 생성자 함수를 자동으로 제공한다.





### Conforming to `Decodable`

- 일반적인 primitive 구조체 데이터 타입(strings, numbers, bool 등)은 자동으로 Decodable에 의해 디코딩 될 수 있지만 실제 상황에서 다루는 앱에서는 이보다 더 복잡한 구조의 자료구조를 사용하게 된다. 
- 이를 위해서는 별도의 구현작업이 필요하다.



### `init(from: Decoder)` 구현하기

Decoder

- 이름에서 알 수 있듯, 디코더 프로토콜은 어떠한 자료를 다른 데이터형식으로 변환하는 기능을 담당한다. 
- 즉, native format(e.g. JSON)을 메모리 내부 표현방식(구조체/클래스)로 변환하는 과정을 의미한다고 볼 수 있다.



#### two of Decoder's funtions

- 관심있게 볼 만한 함수는 두 가지 이다.

  1) `container<Key>(keyedBy: Key.Type)`

  2) `singleValueContainer()`

- 두 케이스 모두, 디코더는 **(Data를 지닌) 컨테이너를 반환**한다.

- 첫 번째 함수에서, 디코더는 키로 바인딩된 컨테이너, 즉 [`KeyedDecodingContainer`](https://developer.apple.com/documentation/swift/keyeddecodingcontainer) 를 리턴한다.

  - ```swift
     KeyedEncodingContainer<Class/Struct이름.CodingKeys>
    ```

- 두 번재 함수는 디코더에 키값이 존재하지 않음을 의미한다.즉 [`SingleValueDecodingContainer`](https://developer.apple.com/documentation/swift/singlevaluedecodingcontainer)

는 우리가 원하는 data 자체를 의미한다.





https://medium.com/if-let-swift-programming/migrating-to-codable-from-nscoding-ddc2585f28a4

[https://medium.com/@OutOfBedlam/%EC%8A%A4%EC%9C%84%ED%94%84%ED%8A%B8-json-encoder%EC%99%80-encodable-e61e55f9e535](https://medium.com/@OutOfBedlam/스위프트-json-encoder와-encodable-e61e55f9e535)

https://www.raywenderlich.com/6733-nscoding-tutorial-for-ios-how-to-permanently-save-app-data#toc-anchor-008

https://www.raywenderlich.com/3418439-encoding-and-decoding-in-swift#toc-anchor-008

https://www.raywenderlich.com/6733-nscoding-tutorial-for-ios-how-to-permanently-save-app-data

