//
//  CircularLinkedList.swift
//  SWIFT_ALGORITHM_SOLVING
//
//  Created by hw on 25/08/2019.
//  Copyright © 2019 hwj. All rights reserved.
//

import Foundation

public struct CircularLinkedList<T>{
    var head: Node<T>?
    ///노드리스트가 빈 경우에만 
    mutating func addToEmptyList(node: Node<T>?){
        if (node != nil) {
            return
        }
        head = node
        head?.next = node
    }
    ///맨 앞에 삽입
    mutating func addHead(node: Node<T>){
        if head == nil {
            addToEmptyList(node: node)
        }
        
    }
    ///맨 마지막에 삽입
    ///두 노드 사이에 삽입
    
}
