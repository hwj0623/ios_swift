import Foundation

class Card {
    private class CardNumber {  //정의, 저장프로퍼티가 아님
        var number: Int
        init (_ num: Int){
            self.number = num
        }
    }
    enum CardType: String, CustomStringConvertible, CaseIterable {
        case spade
        case heart
        case diamond
        case clover
        
        var description: String{
            switch self{
            case .spade:
                return "\u{2663}" ///"♠️"
            case .heart:
                return "\u{2764}" //"♥️"
            case .diamond:
                return "\u{2666}"// "🔶"     //
            case .clover:
                return "\u{2618}"// "☘"     //
            }
        }
    }
    
    private var type : CardType = .clover
    private var number : CardNumber
    var displayType : CardType {
        get {
            return self.type
        }
    }
    var displayNumber: Int {
        get{
            return self.number.number
        }
    }
    
    init(input:String, num: Int){
        if input == "spade" {
            self.type = .spade
        }else {
            self.type = .diamond
        }
        number = CardNumber.init(num)
    }
    func isClover() -> Bool{
        if self.type == .clover{
            return true
        }
        return false
    }
    
}

let spade = Card.init(input: "spade", num: 10)
//print(spade.type == .spade)
print(spade.displayType)
print(spade.displayNumber)


