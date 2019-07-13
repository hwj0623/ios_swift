
import Foundation

print("begin", CFAbsoluteTimeGetCurrent())
let url = URL(string: "http://www.apple.com/v/home/ek/images/heroes/watch-series-4/watch__csqqcayzqueu_large.jpg")!
let data = try Data.init(contentsOf: url)
print("recv", CFAbsoluteTimeGetCurrent())
print("done")

var data2 : Data!
print("begin2", CFAbsoluteTimeGetCurrent())
DispatchQueue.global().async {
    do {
        data2 = try Data.init(contentsOf: url)
    }
    catch {
        
    }
}
print("recv2", CFAbsoluteTimeGetCurrent())
print("done2")
