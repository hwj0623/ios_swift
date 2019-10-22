//
//  LinkedList.swift
//  SWIFT_ALGORITHM_SOLVING
//
//  Created by hw on 25/08/2019.
//  Copyright © 2019 hwj. All rights reserved.
//

import Foundation

public class Node<T>{
    var value: T
    var next: Node<T>?
    weak var previous: Node<T>?
    init (value: T){
        self.value = value
    }
}

public class LinkedList<T> {
    var head: Node<T>?
    var tail: Node<T>?
    var length: Int64 = 0
    public var isEmpty: Bool {
        return head == nil
    }
    
    public var first: Node<T>?{
        return head
    }
    public var last: Node<T>?{
        return tail
    }
    
    /// 맨 끝에 추가
    public func append(_ value: T){
        let newNode = Node(value: value)
        if let currentTailNode = tail {
            newNode.previous = currentTailNode
            currentTailNode.next = newNode
        }else {
            head = newNode
        }
        tail = newNode  /// update tail
        length += 1
    }
    
    public func nodeAt(_ index: Int) -> Node<T>?{
        if index >= 0 {
            var node = head
            var i = index
            while node != nil {
                if i == 0 {
                    return node
                }
                i -= 1
                node = node!.next
            }
        }
        return nil
    }
    
    public func removeAll(){
        head = nil
        tail = nil
        length = 0
    }
    /// 현재 노드를 삭제
    public func removeNode(node: Node<T>) -> Node<T>{
        let prev = node.previous
        let next = node.next
        if let prev = next{
            prev.next = next //1 리스트의 첫 노드를 제거하는 게 아니면 next 포인터를 갱신한다.
        }else {
            head = next // 2 리스트의 첫 노드를 제거하는 것이라면 head를 갱신한다.
        }
        next?.previous = prev   // 3 삭제할 노드 다음 노드의 이전 노드로, 삭제 노드의 이전 노드를 연결
        if next == nil {
            tail = prev         // 4 마지막 노드를 제거한다면, tail을 마지막노드의 이전 노드로 연결
        }
        node.previous = nil
        node.next = nil
        length -= 1
        return node
    }
    
    /// 인덱스 처음으로부터의 index 번째 노드를 삭제
    func delete(at position: Int) -> Node<T>? {
        if head == nil {
            return nil
        }
        var temp = head /// head 부터 탐색
        if position == 0 {  /// 1. 삭제노드가 head node 라면
            head = temp?.next   //change head to nil
            return temp
        }
        for _ in 0..<position-1 where temp != nil { ///n-1 번 이동하여 temp는 삭제할 노드의 직전 노드가 되도록 한다.
            temp = temp?.next
        }
        if temp == nil || temp?.next == nil{    /// 해당 위치에 삭제노드의 직전노드나 삭제할 노드가 존재하지 않다면 리턴
            return nil
        }
        let nextToNextNode = temp?.next?.next   /// 삭제노드의 다음 노드의 next를 찾음
        let deleted = temp?.next
        temp?.next = nextToNextNode             ///
        length -= 1
        return deleted
    }
}

extension LinkedList: CustomStringConvertible {
    public var description: String {
        var text = "["
        var current: Node? = head
        while current != nil {
            if let value = current!.value as? String {
                text += "\(value)"
                current = current?.next
                if current != nil { text += ", "}
                continue
            }
            if let value = current!.value as? Int {
                text += "\(value)"
                current = current?.next
                if current != nil { text += ", "}
                continue
            }
        }
        text += "]"
        return text
    }
}
