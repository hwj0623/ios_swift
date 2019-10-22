//
//  SingleLinkedList.swift
//  SWIFT_ALGORITHM_SOLVING
//
//  Created by hw on 25/08/2019.
//  Copyright © 2019 hwj. All rights reserved.
//
/// https://www.journaldev.com/20995/swift-linked-list

import Foundation

public class SNode<T> {
    var value: T
    var next: SNode<T>?
    
    init(value: T){
        self.value = value
    }
}

class SingleLinkedList<T>{
    var head: SNode<T>?
    
    public var isEmpty: Bool {
        return head == nil
    }
    
    public var first: SNode<T>? {
        return head
    }
    ///  Appending Elements in a Swift LinkedList
    public func append(value: T){
        let newNode = SNode.init(value: value)
        if var curHead = head {
            while curHead.next != nil {
                curHead = curHead.next!
            }
            curHead.next = newNode
        }else {
            head = newNode
        }
    }
    /// Inserting an Element at a Position
    // we need to :
    /// Set the previous Node NEXT reference to the new element.
    /// Set the NEXT of the new element to the current element present at that point.
    func insert(data: T, at position: Int){
        let newNode = SNode(value: data)
        if ( position == 0 ) {
            newNode.next = head
            head = newNode
        }
        else {
            var previous = head
            var current = head
            for _ in 0..<position{
                previous = current
                current = current?.next
            }
            newNode.next = previous?.next
            previous?.next = newNode
        }
    }
    
    func delete(at position: Int){
        if head == nil {
            return
        }
        var temp = head
        
        if position == 0 {
            head = temp?.next   //change head to nil
            return
        }
        
        for _ in 0..<position-1 where temp != nil {
            temp = temp?.next
        }
        if temp == nil || temp?.next == nil{
            return
        }
        let nextToNextNode = temp?.next?.next
        temp?.next = nextToNextNode
    }
    
    func printList() {
        var current: SNode? = head
        while (current != nil) {
            print("LL item is: \(current?.value as? Int ?? 0)")
            current = current?.next
        }
    }
    
    func printReverseRecursive(node: SNode<T>?) {
        if node == nil{
            return
        }
        printReverseRecursive(node: node?.next)
        print("LL item is: \(node?.value as? Int ?? 0)")
    }
    
    func printReverse() {
        printReverseRecursive(node: first)
    }
}
