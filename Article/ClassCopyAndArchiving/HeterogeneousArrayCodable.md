# Decoding subclasses, inherited classes, heterogeneous arrays

@godrm (A.k.a JK) 께서 제기한 이슈로, Codable을 채택한 상속구조의 클래스 배열을 저장할 때 하위 클래스에 대한 정보가 사라지는 아래와 같은 이슈가 발생함.
[출처](https://gist.github.com/godrm/24ce6b64c3944da2074a020de84a9048)
```swift
class Animal : Codable {
    var type : String {
        return "animal"
    }
}
​
​class Dog : Animal {
    ​override var type : String {
    ​   return "dog"
    ​}
​}
​
​class Cat : Animal {
    ​override var type : String {
        ​return "cat"
    ​}
​}
​
​var array : [Animal] = [Dog(), Cat(), Dog(), Cat()];
​
​var data = try PropertyListEncoder().encode(array)
​var restoreArray = try? PropertyListDecoder().decode(Array<Animal>.self, from: data)
​
​restoreArray?.forEach{ print($0.type) } ///animal만 4개 나옴
```

서로 이질적인 요소(상속관계의 인스턴스들)을 같은 자료구조에 저장 후 복원하는 좋은 방법이 없을까 공부하다가 아래의 글을 찾아서 학습 내용을 정리하였습니다. 

[ 미디엄 출처 ](https://medium.com/tsengineering/swift-4-0-codable-decoding-subclasses-inherited-classes-heterogeneous-arrays-ee3e180eb556) 



- 스위프트 4에서 Codable이라는 유용한 API를 도입하였음. 그러나 필자가 REST APIs를 통해 작업하는 중에 이슈상황에 직면함



### Codable protocols 

- Encodable 프로토콜과 Decodable 프로토콜을 합친 typealias protocol이다.
- 데이터타입들을 JSON과 같은 외부 표현방식에 대해 인코딩/디코딩 가능하게 해준다.



기본적인 Codable 사용법은 공식문서를 참고하도록 하자

[Encoding and decoding Custom Types](https://developer.apple.com/documentation/foundation/archives_and_serialization/encoding_and_decoding_custom_types)

[얼티밋 가이드 to JSON Parsing with Swift 4](https://benscheirman.com/2017/06/swift-json/)

[Swift 4 Decodable: Beyond The Basics 📦](https://medium.com/swiftly-swift/swift-4-decodable-beyond-the-basics-990cc48b7375)

- 이 문서들에 대해서는 다음 글에서 별도로 정리한다.



### Decoding Heterogeneous Arrays

- heterogeneous array는 JSON 데이터를 받았을때,  JSONObject의 value로 들어오는 Array에 **서로 다른 오브젝트가 여럿 포함되는 경우**를 말한다.

  ```swift
  var drinks = """
  {
      "drinks": [
          {
              "type": "water",
              "description": "All natural"
          },
          {
              "type": "orange_juice",
              "description": "Best drank with breakfast"
          },
          {
              "type": "beer",
              "description": "An alcoholic beverage, best drunk on fridays after work",
              "alcohol_content": "5%"
          }
      ]
  }
  """
  ```



###  문제상황

- 단순히 이들을 하나의 상위 클래스 배열에 담는 경우, subclass의 프로퍼티에 해당하는 `alcohol_content` 값이 소실되는 문제가 발생한다. 
- 네트워크 통신을 통해 받은 정보를 클래스객체에 매핑시킬때 뿐만이 아니라, 클래스 배열에 서브클래스 원소를 담기 위해 업캐스팅을 하는 다른 상황에서도 codable에 의한 내부적인 encode 작업 간에 이러한 서브클래스 프로퍼티와 타입이 소실된다.



### 해결방식

- struct를 활용하거나,  계층구조가 없는 경우에만 class에 Codable을 적용한다.
- 만약 계층구조가 있는 class라면 NSCoding을 적용하는 수밖에 없다.



- 아래는 제 3의 방식으로, class에 대한 custom encode, init(decoder:)와 struct를 접목시키는 방식의 예제이다.



### 1) Decodable 프로토콜을 따르는 Superclass 모델을 정의하자.

- 우선, Decodable protocol을 따르는 모델을 정의한다.

- 모델은 super class(base class) 부터 정의하고, subclass에 대해 정의하자.

  ```swift
  class Drink: Decodable{
    	var type: String
    	var description: String
    	private enum CodingKeys: String, CodingKey{
        	case type
        	case description
      }
  }
  ```

  - 기본 클래스에 대한 정의와 속성에 대한 정의가 이뤄졌다. 별도의 작업은 없으며, 단지 표준 API를 활용하기만 했다.



### 2) Subclass 정의

​	

```swift
class Beer: Drink {
  	var alcohol_content: String
  	private enum CodingKeys: String, CodingKey{
      	case alcohol_content
    }
  
  	required init(from decoder: Decoder) throws {
      	let container = try decoder.container(keyedBy: CodingKeys.self)
      	self.alcohol_content = try container.decode(String.self, forKey: .alcohol_content)
      	try super.init(from: decoder)
    }
}
```

- 서브 클래스에 대해 프로퍼티를 추가하고, 이에 대해 Decodable을 만족하기 위해 `required init(from decoder: Decoder)`을 추가한다. 

  1) required init에서는  decoder를 통해 서브클래스에서 정의한 CodingKey를 준수하는 enum을 키로 하는 컨테이너를 추출한다.

  2) 서브클래스 프로퍼티를 컨테이너로부터 얻어낸 프로퍼티 값으로 초기화한다.

  3) 수퍼클래스의 init(from: decoder)를 생성한다.

  - Codable을 채택한 최상위 수퍼클래스의 경우, init(from decoder: Decoder)가 내부적으로 자동완성되어있다고 보면 된다.
  - 서브클래스에서 사용한 디코더와 동일한 디코드를 넘겨준다.



### 3) 직렬화 

- 직렬화 과정은 json을 메모리의 클래스인스턴스로 변환하는 과정이다. 역시 별로 어려울 것은 없다. 

- 그러나 우리는 **Heterogenous arrray**를 포함하는 Drinks 구조체를 추가적으로 정의한다. 

  - 역시 Decodable 프로토콜을 따르도록 한다.

  ```swift
  let jsonDecoder = JSONDecoder()
  do {
      let results = try jsonDecoder.decode(Drinks.self,
                         from:drinks.data(using: .utf8)!)
      for result in results.drinks {
          print(result.description)
          if let beer = result as? Beer {
              print(beer.alcohol_content)
          }
      }
  } catch {
      print("caught: \(error)")
  }
  ```

  

### 4) Heterogenous Array 를 소유 & Decodable을 채택한 구조체를 정의

```json
{
    "drinks": [
        {	
            "type": "water",
            "description": "All natural"
        },
        {
            "type": "orange_juice",
            "description": "Best drank with breakfast"
        },
        {
            "type": "beer",
            "description": "An alcoholic beverage, best drunk on fridays after work",
            "alcohol_content": "5%"
        }
    ]
}
```

- 위 json 객체의 계층구조를 참고하여 CodingKey를 만든다. 
  - (1) 우선 drinks에 대한 `CodingKey를 따르는 enum `이 필요합니다.
  - (2) 내부적으로 type에 따라 서브 클래스를 분류하기 위해서 type에 대한 `CodingKey를 따르는 enum` 을 만듭니다.
  - (3) 또한 이 type의 종류에 대해 구분짓기 위해 `Decodable을 채택한 enum`을 만들어둡니다.

```swift
struct Drinks: Decodable{
  	let drinks: [Drink]
  	
  	enum DrinksKey: CodingKey{	/// Drinks의 프로퍼티를 담은 코딩키 enum 정의
      	case drinks
    }
  	enum DrinkTypeKey: CodingKey{	/// type 프로퍼티로 구분짓기 위해
      	case type
    }
  	enum DrinkTypes: String, Decodable {		///type 프로퍼티의 종류에 대해 정의
      	case water = "water"
      	case orangeJuice = "orange_juice"
      	case beer = "beer"
    }
  
  	/// Decodable을 준수하기 위한 이니셜라이저 생성
  	init(from decoder: Decoder) throws {
      	/// drinks 배열을 추출하기 위한 컨테이너를 추출합니다.
      	let container = try decoder.container(keyedBy: DrinksKey.self)
      	/// 타입에 대해 [Drink] 배열을 만들기 위해 코딩키로 키가 없는 컨테이너 (배열)를 추출합니다.
        /// 배열의 각 요소는 키가 존재하지 않으므로 데이터 타입은 UnkeyedDecodingContainer 입니다.
      	var drinksArrayForType = try container.nestedUnkeyedContainer(forKey: DrinksKey.drinks)
      	var drinks = [Drink]()  /// 타입을 보전한 요소를 담기 위한 임시 배열
      	
      	var drinksArray = drinksArrayForType
      	while (drinksArrayForType.isAtEnd) {	/// UnkeyedContainer를 끝까지 탐색
          	/// UnkeyedDecodingContainer인 배열 [] 내부에는 type과 description 등의 key/value르르 갖는 요소가 존재합니다. 따라서 nestedContainer로 type에 따라 key가 존재하는 내부 컨테이너를 추출할 수 있습니다.
          	let drink = try drinksArrayForType.nestedContainer(keyedBy: DrinkTypeKey.self)
          	/// 이제 type을 디코딩하여 서브클래스를 분류하는 작업을 수행합니다.
          	/// drink는 { type(key): String(value), description(key): String(value)} 형태의  키를 지닌 컨테이너  KeyedDecodingContainer<Drinks.DrinkTypeKey> 입니다. 키는 DrinkTypeKey, 즉 type 프로퍼티 입니다.
          	/// 디코딩할 value가 관련된 `type`을 프로퍼티를 키로 하여 type을 추출합니다.
          	/// type 속성에 대한 디코드작업입니다. type은 Drinks.DrinkTypes 의 case로 분류됩니다.
            let type = try drink.decode(DrinkTypes.self, DrinkTypeKey.type)
          	switch type {
            case .water, .orangeJuice:
              	print("found drink")
              	drinks.append(try drinksArray.decode(Drink.self))	/// Drink 클래스 타입으로 디코드 작업을 하여 임시배열에 추가합니다.
            case .beer:
              	print("found beer")
              	drinks.append(try drinksArray.decode(Beer.self))
            }
        }
  			self.drinks = drinks
    }
}
```

- 코드에 주석으로 설명을 추가하였습니다.



### 결과화면

```
found drink
found drink
found beer
All natural
Best drank with breakfast
An alcoholic beverage, best drunk on fridays after work
5%
```



### 5) Class/Struct -> JSON 과정에서 subclass property 유지하기

- 앞서 1~4의 과정은 JSON -> class 변환시에 서브클래스의 형태를 유지시키는 것이 목적이었습니다.

- 그렇다면 반대로 in-memory 표현방식인 클래스/구조체에서 JSON으로 변환할 때, **서브 클래스**가, 상위 클래스 배열에 요소로 추가될 때 업캐스팅되어 JSONEncoding 과정에서 서브클래스의 프로퍼티를 상실하는 문제를 해결해보고자 합니다.

- 위 예제 코드를 기반으로 추가작성합니다.
  - 수퍼클래스인 Drink 객체는 코드상의 변화는 없습니다. 
    - (encode 메서드를 구현해도 되고 최상위 클래스이므로 안해도 무방합니다. )

  - subclass인 Beer 객체는 encode 메서드를 override 해줍니다.

  ```swift
  class Beer: Drink {
      var alcohol_content: String
      
      private enum BeerCodingKeys: String, CodingKey {
          case alcohol_content
      }
      
      init(type:String, description: String, alcohol: String){
          alcohol_content = alcohol
          super.init(type: type, description: description)
      }
      
      override func encode(to encoder: Encoder) throws {
          var container = encoder.container(keyedBy: BeerCodingKeys.self)
          try container.encode(alcohol_content, forKey: .alcohol_content)
          try super.encode(to: encoder)
      }
      
      required init(from decoder: Decoder) throws {
          let container = try decoder.container(keyedBy: BeerCodingKeys.self)
          self.alcohol_content = try container.decode(String.self, forKey: .alcohol_content)
          try super.init(from: decoder)
      }
  }
  ```



- 실제 호출부분에서 [Drink] 를 직접 다루지 않고, 역시 Struct 내의 프로퍼티로 놔둡니다. (Drinks 구조체 유지)

  ```swift
  let beerTest = Beer.init(type: "beer", description: "맛좋은 봉구비어", alcohol: "5%")
  let water = Drink.init(type: "water", description: "에비앙 생수")
  let orangeJuice = Drink.init(type: "orange_juice", description: "어륀지 주스")
  var drinkList = Drinks()
  drinkList.drinks.append(beerTest)
  drinkList.drinks.append(water)
  drinkList.drinks.append(orangeJuice)
  /// encode
  let jsonEncoder = JSONEncoder()
  jsonEncoder.outputFormatting = [.prettyPrinted, .sortedKeys]
  let jsonString = try jsonEncoder.encode(drinkList)
  print(String(data: jsonString, encoding: .utf8)!)
  ```

- 인코딩 결과화면

  ```swift
  {
    "drinks" : [
      {
        "alcohol_content" : "5%",
        "description" : "맛좋은 봉구비어",
        "type" : "beer"
      },
      {
        "description" : "에비앙 생수",
        "type" : "water"
      },
      {
        "description" : "어륀지 주스",
        "type" : "orange_juice"
      }
    ]
  }
  ```

  - Beer의 프로퍼티가 보존되어 인코딩 되었음을 알 수 있습니다.



- 다시 Struct Drinks로 decode 하는 코드와 결과화면은 아래와 같습니다.

  ```swift
  
  func testmain2(){
      do {
          let results = try jsonDecoder.decode(Drinks.self, from: jsonString)
          for result in results.drinks {
              print(type(of: result))
              if let beer = result as? Beer {
                  print(beer.alcohol_content)
              }
          }
      } catch {
          print("caught: \(error)")
      }
  }
  testmain2()
  ```

  ```swift
  Beer
  5%
  Drink
  Drink
  ```



- cf. 만약에 구조체를 거치지 않고 단순히 상위 클래스 배열에 서브클래스 요소를 추가한 값을 인코딩하면 위의 encode 메서드 오버라이드로 json 데이터는 잘 보존되지만, 다시 decode 하는 과정에서 타입이 유실됩니다.

  ```swift
  var drinkList =  [Drink]()
  //drinkList.drinks.append(beerTest)
  //drinkList.drinks.append(water)
  //drinkList.drinks.append(orangeJuice)
  
  drinkList.append(beerTest)
  drinkList.append(water)
  
  let jsonEncoder = JSONEncoder()
  jsonEncoder.outputFormatting = [.prettyPrinted, .sortedKeys]
  let jsonString = try jsonEncoder.encode(drinkList)
  print(String(data: jsonString, encoding: .utf8)!)
  
  func testmain2(){
      do {
          let results = try jsonDecoder.decode([Drink].self, from: jsonString)
          for result in results {
              print(type(of: result))
              if let beer = result as? Beer {
                  print(beer.alcohol_content)
              }
          }
      } catch {
          print("caught: \(error)")
      }
  }
  testmain2()
  ```

  ```swift
  /// encode
  [
    {
      "alcohol_content" : "5%",
      "description" : "맛좋은 봉구비어",
      "type" : "beer"
    },
    {
      "description" : "에비앙 생수",
      "type" : "water"
    }
  ]
  /// decode
  Drink
  Drink
  ```

  
  ### 결론
  ##### 문제
  - Codable 채택한 클래스의 배열을 직접 저장하려고 하면 서브 클래스의 데이터가 유실되는 문제가 발생합니다.
  ##### 해결방안 - 클래스 유지, 클래스 배열에 대해서는 별도의 구조체 정의
  **[ 디코딩 시 ]** 
  - 위와 같이 **Heterogenous arrray**를 포함하는 Drinks 구조체를 추가적으로 정의하는 방식으로 구성하여, 이 구조체 타입으로 디코딩을 합니다.
        키가 존재하는 컨테이너나 키가 없는 컨테이너(배열)을 접근하여, 각각에 대해 루프를 돌리면서 **서브클래스로 변환가능한지를 시도**해 봅니다.
        서브클래스를 특정짓는 프로퍼티가 없는 경우, 모든 서브클래스에 대해 타입캐스팅을 시도하는 방식으로도 고려해 볼 수 있습니다. (대신 비효율적..)
  **[ 인코딩 시 ]**  
  - `func encode(to encoder: Encoder)` 함수를 override 합니다.  
    
  #### 해결방안 - NSCoding 을 사용하는 방식
  - 단점 : NSCoding으로 encode, init(aCoder: NSCoder) 를 사용하는 경우, 상속관계를 유지할 수 있습니다. 다만, **JSONEncoder를 사용할 수 없습니다.** JSONEncoder의 대상은 Codable 프로토콜을 채택해야 하기 때문입니다.
     (내부에 plist 형태로 저장은 가능하나..)
    
  #### 해결방안 - 구조체로 변환
 - 별도의 커스텀 코드가 필요없기 때문에 권장되는 방식입니다. JSONEncoder를 사용하기에도 무리는 없습니다.
  - 서브 클래스의 프로퍼티에 대해서는 **옵셔널 타입을 선언하는 방식**으로 계층구조를 없애버립니다.
  - 상속관계가 복잡한 경우에는 프로퍼티에 대한 unwrapping을 시도하면서 별도의 계층구조 클래스로 변환시켜주는게 좋을 것 같습니다. 
