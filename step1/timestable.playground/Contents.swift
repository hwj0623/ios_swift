import UIKit


//STEP 1-1
var str = "1-1 Hello, playground \n"

print (str)

//STEP 1-2
str = "==== 1-2 time tables ===="
print (str)

func multiply( input: Int, range : Int ) -> Void {
    print("--- \(input) times table print --- \n")
    for index in 1...range {
        print("\(input) * \(index) = \(input * index) \n")
    }
}

multiply(input: 2, range: 9)
multiply(input: 3, range: 9)
