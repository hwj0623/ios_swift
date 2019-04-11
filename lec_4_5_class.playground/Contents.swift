import UIKit

//기능

//텔레비전이라는 대상들을 표현하겠다
class Television {
    
    // 2) 특징 - 프로퍼티 ; 기능 수행을 위한 특징
    var isTurnOn: Bool = false
    var volume: UInt = 5
    var channel: UInt = 1
    var screenSize: Float = 65.3
    var resolution: CGSize = CGSize(width: 1920, height: 1080)
    
    // 1) 기능 - 메서드 ; 능동적으로 하는 동작. 어떤 Type에 구현된 함수
    func change(channel: UInt) {
        // 채널 변경
    }
    
    func turn(on: Bool) {
       
        
    }
    
    func change(volume: UInt) {
        
    }
    
    func reboot(){
        if (self.isTurnOn){
            self.isTurnOn = !self.isTurnOn
            self.isTurnOn = !self.isTurnOn
        }
    }
    // async
    func order(something: String) -> Any {
        return something
    }
}

class RemoteController {
    var owner: String?
    var pairedTelvision: Television?
    
    func turn(on: Bool) {
        pairedTelvision?.turn(on: on) // 연결된 television이 있는지 체크 후 tv인스턴스의 메서드 호출
    }
}

let television: Television = Television()
let remoteController: RemoteController = RemoteController()

//리모컨에 tv연결 후 turn
remoteController.pairedTelvision = television
remoteController.turn(on: true)         // message를 전달 ; 객체간의 소통

//사람과 tv간 소통(메시지 전달) - 주문
var owner: Any = String()
owner = television.order(something: "옷")


