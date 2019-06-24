import Foundation
/// init(repeating:count:)에 대한 고찰
/// repeating 값에 referenceType이 오는 경우..?

/// 우선 @inlinable public init(repeating repeatedValue: Element, count: Int) 의 설명은 아래와 같다.
/// Creates a new array containing the specified number of a single, repeated
/// value.
///
/// Here's an example of creating an array initialized with five strings
/// containing the letter *Z*.
///
///     let fiveZs = Array(repeating: "Z", count: 5)
///     print(fiveZs)
///     // Prints "["Z", "Z", "Z", "Z", "Z"]"
///
/// - Parameters:
///   - repeatedValue: The element to repeat.
///   - count: The number of times to repeat the value passed in the
///     `repeating` parameter. `count` must be zero or greater.

class Hand {
    var deck: [Int]
    init(_ value:Int ){
        self.deck = [Int]()
    }
}
class Player {
    private (set) var hand: Hand
    init(){
        hand = Hand(1)
    }
    init(_ bList: Hand){
        self.hand = bList
    }
}

func address(o: UnsafeRawPointer) -> Int {
    return Int(bitPattern: o)
}

/// repeating을 활용하여 클래스 배열을 생성한 경우
var testPlayer = [Player].init(repeating: Player(), count: 6)
/// testPlayer[i]객체의 hand의 deck에 숫자를 하나씩 추가
for index in 0..<testPlayer.endIndex {
    testPlayer[index].hand.deck.append(index)
}
/// 출력해보면 전부 같은 값이 나온다.
for index in 0..<testPlayer.endIndex {
    print("\(index), \(testPlayer[index].hand.deck)")
}
/*
 0, [0, 1, 2, 3, 4, 5]
 1, [0, 1, 2, 3, 4, 5]
 2, [0, 1, 2, 3, 4, 5]
 3, [0, 1, 2, 3, 4, 5]
 4, [0, 1, 2, 3, 4, 5]
 5, [0, 1, 2, 3, 4, 5]
 */
/// Swift 4,5에서 메모리 출력하는 방법 중 하나 -- https://stackoverflow.com/questions/24058906/printing-a-variable-memory-address-in-swift/41666807
for index in 0..<testPlayer.endIndex{
//    print(Unmanaged.passUnretained(testPlayer[index].hand).toOpaque())
    print("each player's hand's deck address : \(NSString(format: "%p", address(o: &testPlayer[0].hand.deck)))")  //모두 0x600001db8920
    print("each player's hand address : \(ObjectIdentifier(testPlayer[index].hand))")   //모두 ObjectIdentifier(0x000060000249d9a0)
    print("each player address : > \(ObjectIdentifier(testPlayer[index]))")             //모두 ObjectIdentifier(0x000060000249d960)
}


struct Hand2 {
    var deck: [Int]
    init(_ value:Int ){
        self.deck = [Int]()
    }
}
struct Player2 {
    var hand: Hand2
    init(){
        hand = Hand2(1)
    }
    init(_ bList: Hand2){
        self.hand = bList
    }
}
/// repeating을 활용하여 클래스 배열을 생성한 경우
var testPlayer2 = [Player2].init(repeating: Player2(), count: 6)
/// testPlayer[i]객체의 hand의 deck에 숫자를 하나씩 추가
for index in 0..<testPlayer2.endIndex {
    testPlayer2[index].hand.deck.append(index)
}
/// 출력해보면 전부 다른 값이 나온다.
for index in 0..<testPlayer2.endIndex {
    print("\(index), \(testPlayer2[index].hand.deck)")
}
/*
 0, [0]
 1, [1]
 2, [2]
 3, [3]
 4, [4]
 5, [5]
 */

/// Swift에서 struct  메모리 출력하는 방법 중 하나 -- https://stackoverflow.com/questions/24058906/printing-a-variable-memory-address-in-swift/41666807
for index in 0..<testPlayer2.endIndex{
    print("struct \(index) deck address : > \(NSString(format: "%p", address(o: &testPlayer2[index].hand.deck[0])))")  //각각 같음 0x7ffee9127ba8
    print("struct \(index) hand address : > \(NSString(format: "%p", address(o: &testPlayer2[index].hand)))")       //각각 같음 0x7ffee8e40cb0
    print("struct \(index) player address : > \(NSString(format: "%p", address(o: &testPlayer2[index])))")       //각각 같음 0x7ffee8e40cb0
}

/// ObjectIdentifier 란, 클래스 인스턴스의 고유 식별자를 의미. 메모리 주소값에 따라 다르다.
/// A unique identifier for a class instance or metatype.
///
/// In Swift, only class instances and metatypes have unique identities. There
/// is no notion of identity for structs, enums, functions, or tuples.


///Unmanaged란?
/// A type for propagating an unmanaged object reference.
///
/// When you use this type, you become partially responsible for
/// keeping the object alive.

/// passUnretained 메소드란 ?
/// Creates an unmanaged reference without performing an unbalanced
/// retain.
///
/// This is useful when passing a reference to an API which Swift
/// does not know the ownership rules for, but you know that the
/// API expects you to pass the object at +0.

/// toOpaque()메소드란?
/// Unsafely converts an unmanaged class reference to a pointer.
///
/// This operation does not change reference counts.
///
///     let str0 = "boxcar" as CFString
///     let bits = Unmanaged.passUnretained(str0)
///     let ptr = bits.toOpaque()
///
/// - Returns: An opaque pointer to the value of this unmanaged reference.
/// public func toOpaque() -> UnsafeMutableRawPointer
