import Foundation


class 탈것 {
    internal var 경적소리 = "Bang"
    private let serialNumber : Int = 1234
    func 사운드 () {
        print (self.경적소리)
    }
}

class 자동차 : 탈것 {
    override var 경적소리 : String {
        get {
            return "BBB"
        }
        set {
            self.경적소리 = newValue
        }
    }
    override func 사운드 () {
        print (self.경적소리)
    }
}

var car = 자동차()
탈것().사운드()

//car.사운드()
car.경적소리 =  "CCC"
car.사운드()



