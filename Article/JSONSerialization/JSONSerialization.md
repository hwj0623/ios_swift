## JSONSerialization

- An object that converts between JSON and the equivalent Foundation objects.

```swift
class JSONSerialization : NSObject
```

- JSON 직렬화 클래스를 사용하여 JSON 을 메모리 표현방식인 Foundation class로 변환하거나, 반대로 인스턴스 클래스를 JSON 으로 변환할 수 있다.
- Foundation 객체가 JSON으로 변환되기 위해서는 반드시 다음의 특성을 따라야 한다.
  - 최상위 객체는 `NSArray  `이거나` NSDictionary ` 이어야 한다.
  - 모든 객체들은 `NSString, NSNumber, NSArray, NSDictionary 또는 NSNull` 의 인스턴스들로 구성되어있어야 한다.
  - 모든 딕셔너리 키값들은 `NSString 인스턴스`들 이어야 한다.
  - 숫자는 NaN(Not a Number) 혹은 infinity여서는 안된다.
- [`isValidJSONObject(_:)`](https://developer.apple.com/documentation/foundation/jsonserialization/1418461-isvalidjsonobject) 를 호출하거나 변환하는 시도가 현재의 주어진 객체가 JSON 데이터가 될 수있는지 확인할 수 있는 가장 좋은 방법이다.
- JSONSerialization은 `Thread Safety` 하다. (iOS 7, macOS 10.9 이상부터 )



### 예제 - String to JSON Data

sample code로 다음과 같은 jsonString을 프로그램에 하드코딩했다고 해봅시다.

```swift
let jsonString = """
        [{"date":"1월1일", "subtitle":"신정"},
        {"date":"2월16일", "subtitle":"구정"},
        {"date":"3월1일", "subtitle":"삼일절"},
        {"date":"5월5일", "subtitle":"어린이날"},
        {"date":"5월22일", "subtitle":"석가탄신일"},
        {"date":"6월6일", "subtitle":"현충일"},
        {"date":"8월15일", "subtitle":"광복절"},
        {"date":"9월24일", "subtitle":"추석"},
        {"date":"10월3일", "subtitle":"개천절"},
        {"date":"10월9일", "subtitle":"한글날"},
        {"date":"12월25일", "subtitle":"성탄절"}]
    """
```

- 해당 string을 직렬화 하기 위해 `Data` 타입으로 변환시키려고 합니다. 우선 아래와 같이 guard else 구문을 활용하여 Data 타입으로 변환을 시도합니다. String 구조체 타입에 기본으로 구현된 `.data(using:)` 메서드를 호출하면 됩니다. 파라미터로는 인코딩 포맷 형식을 지정하면 됩니다.

  ```swift
  guard let jsonData = jsonString.data(using: .utf8) else {
    	return
  }
  ```

- 이제  `Data` 타입의 jsonData를 직렬화하는 함수를 만들자. 위 코드 아래에 다음과 같이 작성해봅니다.

  ```swift
  guard let result = convertJsonToDictionaryArray(jsonData) else {
    	return
  }
  ```

- jsonString 문자열 형식과 같이 `[ [String : String] ]` 형태, 즉 `key`가 `date`, `subtitle` 인 딕셔너리들을 저장하는 배열을 만들 것이다. JSONSerialization 클래스에서 jsonObject 메서드를 호출합니다.

  ```swift
  private func convertJsonToDictionaryArray(_ data: Data) -> [[String:String]]? {
   	 guard let object = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
   	 as? [[String: String]] else {
     	 	return nil
   	 }
     return object
  }
  ```

  - options는 세 가지가 존재한다. 문서 설명을 보니 현재 문제에서 가장 적합한 방식은 `mutableContainers` 라고 생각합니다. (옵션을 설정하지 않는다면 빈 문자열 [] 를 작성하면 됩니다.)

    - **allowFragments** 

      - 파서가 최상위 객체가 NSArray나 NSDictionary가 아닌 객체를 허용하는 방식이다. 
      - Specifies that the parser should allow top-level objects that are not an instance of `NSArray` or `NSDictionary`.

    - **mutableContainers** 

      - 배열과 딕셔너리를 mutable 객체들로 생성하는 방식이다.
      -  Specifies that arrays and dictionaries are created as mutable objects.

    - **mutableLeaves** 

      - JSON 객체 그래프 속의 leaf 문자열들을 `NSMutableString` 인스턴스로 생성한다.
      - Specifies that leaf strings in the JSON object graph are created as instances of `NSMutableString`.

      

### 함께 알아볼 키워드

 [`NSArray`](https://developer.apple.com/documentation/foundation/nsarray)

[`NSDictionary`](https://developer.apple.com/documentation/foundation/nsdictionary)

[`NSString`](https://developer.apple.com/documentation/foundation/nsstring)

[`NSNumber`](https://developer.apple.com/documentation/foundation/nsnumber)

[`NSNull`](https://developer.apple.com/documentation/foundation/nsnull)



### 참고 사이트

https://developer.apple.com/documentation/foundation/jsonserialization

https://developer.apple.com/documentation/foundation/jsonserialization/1415493-jsonobject

https://developer.apple.com/documentation/foundation/jsonserialization/readingoptions

https://www.hackingwithswift.com/example-code/system/how-to-parse-json-using-jsonserialization

