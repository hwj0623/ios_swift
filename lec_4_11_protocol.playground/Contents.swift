import UIKit


/// 프로토콜의 프로퍼티가 겹치는 경우는 구조체 등에서 프로퍼티 충돌이 일어난다.
protocol Drivable{
//    var drivingLicense: Int { get }
    func drive()
    var drivingLicense: String { get }
}
/// 프로토콜
protocol Brewable {
    func brewCoffee()
}

/// 프로토콜 : '~할 수 있는'의 형식으로 네이밍
protocol SecretaryQualifiable: Drivable, Brewable { // Drivable, Brewable 을 "상속"받은 프로토콜
    func manageSchedule ()      // 함수를 구현하지 않는다.
    func brewCoffee()
    func drive()
    /// get - readable property
    var certification: String { get }
    var drivingLicense: String { get }
}

// struct Secretary: SecretaryQualifiable, Drivable { // --> 에러 : 프로퍼티 중복
struct Secretary: Drivable, Brewable {  /// Secretary는 Drivable, Brewable 프로토콜을 "adopt"했다
    func manageSchedule() {
        print("Mananging schedule welldone!")
    }
    func brewCoffee() {
        print("I drip a any cup of coffee")
    }
    func drive() {
        print("drive anywhere")
    }
    
    var certification: String
    var drivingLicense: String
}

/// Secretary는 SecretaryQualifiable 프로토콜을 "채택"했다
//struct Assistant: SecretaryQualifiable {
struct Assistant: Drivable, Brewable {
    func manageSchedule() {
        print("Mananging schedule so so!")
    }

    func brewCoffee() {
        print("I drip only cold brew coffe")
    }

    func drive() {
        print("drive in highway")
    }

    var certification: String
    var drivingLicense: String
}

struct CEO {
//        var secretary: SecretaryQualifiable     // 프로토콜에 부합하는 자는 모두 secretary가 될 수 있다.
        var secretary: Drivable&Brewable
//    var secretary : SecretaryQualifiable // secretary1은 SecretaryQualifiable을 준수하지 못한다.
}

/// 프로토콜을 "conform(준수)" 한 구조체 선언 및 초기화
let secretary1: Secretary = Secretary(certification: "KoreaUniv_Bachelor", drivingLicense: "2종 자동")
//let secretary2: Assistant = Assistant(certification: "KoreaUniv_Master", drivingLicense: "1종 자동")

var master: CEO = CEO(secretary: secretary1)
master.secretary = secretary2
