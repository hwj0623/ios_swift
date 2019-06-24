//
//  main.swift
//  test
//
//  Created by hw on 13/05/2019.
//  Copyright © 2019 hwj. All rights reserved.
//

import Foundation


func swap (lhs: Int, rhs: Int)  {
    let temp : Int = rhs
    let rhs = lhs
    let lhs = temp
}

print("call by value")
var a = 1
var b = 2

swap(lhs: a, rhs: b)
print("a, b : \(a), \(b)")


///----
func swap (lhs: inout Int, rhs: inout Int)  {
    let temp : Int = rhs
    rhs = lhs
    lhs = temp
}


print("call by value")
var c = 1
var d = 2

swap(lhs: &c, rhs: &d)
print("c, d : \(c), \(d)")

class Person {
    private var age : Int = 8
    var number : Int = 0
    init(){}
    var description : String {
        return "age : \(self.age) , number : \(self.number)"
    }
}

func increase(value : Person){
    print("increase number of Person class")
    value.number += 1
}

var me: Person = Person()
increase(value: me)
var you = me
print("me : \(me.description)")
print("you : \(you.description)")


struct People {
    private var age : Int = 5
}
var here: People = People()
var there = here
print(there)


