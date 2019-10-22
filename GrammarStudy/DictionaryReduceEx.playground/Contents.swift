import Cocoa

var histSet = [
    "top": 3,
    "hotsix": 6,
    "milk" : 2
]

let mapped = histSet.map { (val1: String, val2: Int) -> Int in return val2}

let total = mapped.reduce(0) { (s1: Int, s2:Int) -> Int in
    
    return s1+s2
    
}

print(total)
