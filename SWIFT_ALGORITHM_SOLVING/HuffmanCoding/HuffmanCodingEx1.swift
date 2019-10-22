//
//  HuffmanCodingEx1.swift
//  SWIFT_ALGORITHM_SOLVING
//
//  Created by hw on 06/09/2019.
//  Copyright © 2019 hwj. All rights reserved.
//
// https://wkdtjsgur100.github.io/huffman/
// https://softwareji.tistory.com/5

/*
 주어진 문자열을 트리를 이용해 2진수로 압축하는 알고리즘 중 하나이다. 최소 힙을 이용한다.
 
 절차
 [ 허프만 트리 제작 ]
 1. 빈도 수와 문자 하나 저장할 수 있는 Node 클래스를 정의한다.
 2. 문자의 출현 빈도수를 센 후, 해당 문자와 출현 빈도 수를 Node로 만들어 최소 힙에 저장한다.
 3. 최소 힙에서 Node 두 개를 꺼낸다.
 4. 두 Node를 왼쪽 자식, 오른쪽 자식으로 하는 부모 Node 를 만든 후 최소 힙에 넣는다.(부모 Node의 빈도 수 값은 왼쪽 자식 Node의 빈도 수와 오른쪽 자식 Node의 빈도 수의 합이다.)
 5. 최소 힙이 비어있을 때까지 다시 1번으로 돌아가 진행한다.
 (2, 3, 5, 7, 9, 13) 이라는 리스트가 주어졌을 때(각각의 숫자는 빈도 수를 의미), 허프만 트리의 제작을 시각화 하면 아래 그림과 같다.
 */
import Foundation

class HuffmanEx {
    class Node {
        var character: Character
        var frequency: Int
        var left: Node?
        var right: Node?
        init(frequency: Int, alphabet: Character){
            self.character = alphabet
            self.frequency = frequency
            left = nil
            right = nil
        }
    }
    class MinHeap {
        var list : [Node] = [Node].init(repeating: Node.init(frequency: 0, alphabet: "a"), count: 54)
        
    }
}
