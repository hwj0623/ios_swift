//
//  Queue_LinkedList.swift
//  SWIFT_ALGORITHM_SOLVING
//
//  Created by hw on 25/08/2019.
//  Copyright © 2019 hwj. All rights reserved.
//

import Foundation

public struct Queue<T>{
    var list = LinkedList<T>()
    public var isEmpty: Bool {
        return list.isEmpty
    }
    public mutating func enqueue(_ element : T){
        list.append(element)
    }
    public mutating func dequeue() -> T?{
        guard !list.isEmpty, let element = list.first else { return nil }
        list.removeNode(node: element)
        return element.value
    }
    public mutating func peek() -> T?{
        return list.first?.value
    }
    public mutating func search(at index: Int) -> T?{
        return list.nodeAt(index)?.value
    }
    
}
