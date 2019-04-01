import UIKit


//STEP 1-1
var str = "=== 1-1 Hello, playground ===\n"

print (str)

//STEP 1-2
str = "==== 1-2 times tables : nogada ===="
print (str)
print("> tables coefficient- 2 ")
print("2 * 1= \(2*1) ")
print("2 * 2= \(2*2) ")
print("2 * 3= \(2*3) ")
print("2 * 4= \(2*4) ")
print("2 * 5= \(2*5) ")
print("2 * 6= \(2*6) ")
print("2 * 7= \(2*7) ")
print("2 * 8= \(2*8) ")
print("2 * 9= \(2*9) ")

print("> tables coefficient- 5 ")
print("3 * 1= \(3*1) ")
print("3 * 2= \(3*2) ")
print("3 * 3= \(3*3) ")
print("3 * 4= \(3*4) ")
print("3 * 5= \(3*5) ")
print("3 * 6= \(3*6) ")
print("3 * 7= \(3*7) ")
print("3 * 8= \(3*8) ")
print("3 * 9= \(3*9) ")

//STEP 1-3
str = "\n==== 1-3 times tables : nogada ===="
print (str)
let first = 4
let second = 5
var result = 1 // set default

print("> tables coefficient- 4 ")
result = first * 1
print("4 * 1= \(result) ")
result = first * 2
print("4 * 2= \(result) ")
result = first * 3
print("4 * 3= \(result) ")
result = first * 4
print("4 * 4= \(result) ")
result = first * 5
print("4 * 5= \(result) ")
result = first * 6
print("4 * 6= \(result) ")
result = first * 7
print("4 * 7= \(result) ")
result = first * 8
print("4 * 8= \(result) ")
result = first * 9
print("4 * 9= \(result) ")

print("> tables coefficient- 5 ")
result = second * 1
print("5 * 1= \(result) ")
result = second * 2
print("5 * 2= \(result) ")
result = second * 3
print("5 * 3= \(result) ")
result = second * 4
print("5 * 4= \(result) ")
result = second * 5
print("5 * 5= \(result) ")
result = second * 6
print("5 * 6= \(result) ")
result = second * 7
print("5 * 7= \(result) ")
result = second * 8
print("5 * 8= \(result) ")
result = second * 9
print("5 * 9= \(result) ")

str = "\n==== 1-4 times tables : for Loop ===="
print (str)
let third = 6
let fourth = 7
result = 1
var i = 1
print("> tables coefficient- 6 ")
while(i < 10){
    print( "\(third) * \(i) = \(third * i)")
    i=i+1
}
print("> tables coefficient- 7 ")
i = 1
for i in i..<10 {
    print( "\(fourth) * \(i) = \(fourth * i)")
}


str = "\n==== 1-5 times tables : if condition and Double for Loop ===="
print (str)
let fifth = 8
let sixth = 9
i = 2
var j = 1

for _ in i..<10 {
    j=1
    if( i % 2 == 0){
        
    }else{
        for _ in j..<10 {
            print( "\(i) * \(j) = \(i*j)")
            j = j+1
        }
        print("\n")
    }
    i = i+1
}

str = "==== 1-6 times tables ; Arrays and Subroutine ===="
print (str)
let input = 0
var gugudan = [Int].init(repeating: input, count : 9)
var two = 2
var index = 1
for i in gugudan {  // 여기서 i는 let constant 이다
    gugudan[i] = gugudan[i]+2
    print("\(two) * \(index) : \(gugudan[i])")
    index = index + 1
//    i = i + 1
}

// Subroutine
func multiply( input: Int, range : Int ) -> Void {
    print("--- \(input) times table print --- \n")
    for index in 1...range {
        print("\(input) * \(index) = \(input * index) \n")
    }
}

multiply(input: first, range: 9)
multiply(input: second, range: 9)




