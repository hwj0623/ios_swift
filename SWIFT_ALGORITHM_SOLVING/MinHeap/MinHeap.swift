//
//  MinHeap.swift
//  SWIFT_ALGORITHM_SOLVING
//
//  Created by hw on 06/09/2019.
//  Copyright © 2019 hwj. All rights reserved.
//

import Foundation

//https://wkdtjsgur100.github.io/heaps/
/*
 [ 최소 힙이란? ]
 - 부모 노드가 자식 노드보다 항상 작은 트리 구조를 말한다.
 - 완전 이진 트리이고, 배열로 구현된다.
 배열로 구현된다는 말은,
  부모 노드의 index가 parentIndex라고 하면
  왼쪽 자식 노드의 인덱스는 parentIndex*2,
  오른쪽 자식 노드의 인덱스는 parentIndex*2+1 이라는 의미
 [ 삽입 ]
 - 최고 깊이에서 가장 오른쪽에 삽입된다.
 - 새로 삽입된 노드의 부모 노드를 계속 bottom-up 하면서, 부모 노드가 자신보다 더 클 경우 부모 노드와 자신 노드를 swap한다.
 
 [ 최소 값 꺼내기 ]
 최소 값(루트 노드)을 꺼낸다음, 트리의 가장 루트 노드를 가장 마지막으로 삽입된 값(최고 깊이에서 가장 오른쪽 노드)로 대체한다.
 그 다음, 힙정렬의 성질을 유지하기 위해 루트 노드에서 부터 자식 노드들을 top-down 하며
 자신보다 더 작은 자식 노드가 있으면 자신과 자식노드를 swap한다.
 만약 왼쪽 자식과 오른쪽 자식이 둘 다 자신보다 작다면, 둘 중에 더 작은 자식과 swap 해야한다.
 */

class MinHeap {
    private var heap = [Int]()
    private var size: Int = 0
    private var maxSize: Int = 0
    let FRONT: Int = 1    /// root node index를 1로 하면 코드가 간결해짐ㄴ
    
    init(_ maxSize: Int){
        self.maxSize = maxSize
        self.size = 0
        heap = [Int].init(repeating: 0, count: maxSize+1)
        heap[0] = Int.min
    }
    private func getParent(pos: Int) -> Int {
        return pos/2
    }
    private func leftChild(pos: Int) -> Int{
        return pos*2
    }
    private func rightChild(pos: Int) -> Int{
        return (pos*2)+1
    }
    /// leaf node인지 판별
    private func isLeaf(pos: Int) -> Bool {
        if pos >= size/2 && pos <= size {
            return true
        }
        return false
    }
    // Function to heapify the node at pos
    private func minHeapify(pos: Int){
        if (!isLeaf(pos: pos)) {
            //자식보다 부모노드값이 더 크면 스왑하므로
            let leftChildIndex = leftChild(pos: pos)
            let rightChildIndex = rightChild(pos: pos)
            if (heap[pos] > heap[leftChildIndex] || heap[pos] > heap[rightChildIndex]) {
                if heap[pos] >  heap[leftChildIndex] {
                    heap.swapAt(pos, leftChildIndex)
                    minHeapify(pos: leftChildIndex)
                }
                else {
                    heap.swapAt(pos, rightChildIndex)
                    minHeapify(pos: rightChildIndex)
                }
            }
        }
    }
    // Insert a node into the heap
    func insert(element: Int){
        if (size >= maxSize) {
            return
        }
        heap[size+1] = element
        size += 1
        var current = size
        
        while(heap[current] < heap[getParent(pos: current)]) {
            heap.swapAt(current, getParent(pos: current))
            current = getParent(pos: current)
        }
    }
    
    func printHeap(){
        for index in 1...(size/2){
            print("parent: \(heap[index]), left: \(heap[index*2]), right: \(heap[index*2+1])")
        }
    }
    
    func minHeap(){
        for pos in stride(from: size/2, to: 1, by: -1){
            minHeapify(pos: pos)
        }
    }
    
    func remove() -> Int{
        var popped = heap[FRONT]
        heap[FRONT] = heap[size]
        size -= 1
        minHeapify(pos: FRONT)
        return popped
    }
    
    func start(){
        print( " The Min Heap is ")
        var minHeap = MinHeap.init(15)
        minHeap.insert(element: 5)
        minHeap.insert(element: 3)
        minHeap.insert(element: 17)
        minHeap.insert(element: 10)
        minHeap.insert(element: 84)
        minHeap.insert(element: 19)
        minHeap.insert(element: 6)
        minHeap.insert(element: 22)
        minHeap.insert(element: 9)
        minHeap.minHeap()
        minHeap.printHeap()
        print("The Min val is: \(minHeap.remove())")
    }
}
