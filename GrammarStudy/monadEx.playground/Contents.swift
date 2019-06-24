import UIKit


//
//var optional: Array<Int?> = [ 10, 42, nil, nil, 5 ]
//print("init : \(optional)")
////
//var mapfunctor = optional.map { (value) -> Int? in
//    guard let val = value else {
//        return nil
//    }
//    return val * 2 as Int?
//}
//
//print("map adapted : \(mapfunctor)")
//
//let flatMapFunctor = optional.compactMap{(value) -> Int? in
//    guard let val = value else {
//        return nil
//    }
//    return val * 2 as Int?
//}
//print("flatMapFunctor adapted : \(flatMapFunctor)")
//
////내부의 값을 알아서 더 추출해준다. 내부에 포장된 값도 추출해낸다.
//let result: [Int] = optional.flatMap { $0 }.map( {$0 * 2 })
//print("flatMap adapted : \(result)")
//
//
//////함수와 플랫맵의 사용
func doubledEven (_ num : Int ) -> Int? {
    print("here?")
    if num % 2 == 0 {
        return num*2
    }
    return nil
}
//
let mapOddNumberResult = Optional(3).map(doubledEven)
//let mapNoneResult = Optional.none.map(doubledEven)
//print("map mapOddNumberResult : \(mapOddNumberResult)")
//print("map mapNoneResult : \(mapNoneResult)")
//
//let caseOddNumberResult = Optional(3).flatMap(doubledEven) // nil == Optional.none
//let caseNoneResult = Optional.none.flatMap(doubledEven) // nil
//print("flatMap caseOddNumberResult : \(caseOddNumberResult)")
//print("flatMap caseNoneResult : \(caseNoneResult)")


///중첩 컨테이너에서 맵과 플랫맵의 차이
let multipleContainer = [ [1, 2, Optional.none], [3, nil], [4,5,Optional.none] ]

let mapped = multipleContainer.map {$0.map{$0}}
/// flatmap은 내부의 값을 1차원적으로 펼쳐놓는 작업도 수행
let flatmapped = multipleContainer.flatMap{$0.flatMap{$0}} //[1, 2, 3, 4, 5]
let hybrid1 = multipleContainer.map {$0.flatMap{$0}}    //[ [1, 2], [3], [4, 5] ]
let hybrid2 = multipleContainer.flatMap({$0.map{$0}})   //[Optional(1), Optional(2), nil, Optional(3), nil, Optional(4), Optional(5), nil]
print(multipleContainer)
print(mapped)
print(flatmapped)
print(hybrid1)
print(hybrid2)


/// 범주론에서 스위프트의 배열은 모나드이다. (컨텍스트가 map을 거쳐서 컨텍스트를 보존한채로 반환되므로)
/// Array는 map을 통해서 Array컨텍스트 타입이 반환되므로 모나드이다 (functor이기도 하다)
[ 1,2,3,4,5].map { (element) -> Int in
    return element * 2
    }.map{(element) -> Int in
        return element / 2
}

let set: Set<Int> = [1,2,3,4,5]
type(of: set.map { (element) -> Int in return element * 2})
/// map이 구현되있으면 모나드는 아니지만 functor에 해당한다.

///map은 다음과 같이 컬렉션을 배열로 반환한다.
//@inlinable public func map<T>(_ transform: (Element) throws -> T) rethrows -> [T]

///마찬가지로 string을 map으로 나타내면 String이 아니라 character array가 반환되므로 모나드는 아니다.
let chars = "abcde".map { (char)-> Character in
    return char
}
print(chars)
let result = ["a", "b", "c", "d", "e"].reduce(""){ (string , next) -> String in
        string + next
}
print(result)



struct Stack  {
    init(initialItems: [Int] ){
        items = initialItems
    }
    private var items: [Int]
    mutating func push(_ newItem: Int){
    }
    mutating func pop()-> Int{
        return items.removeLast()
    }
    func map (_ transform: (Int)-> Int) -> Stack { //
        //...
        return self
    }
}
