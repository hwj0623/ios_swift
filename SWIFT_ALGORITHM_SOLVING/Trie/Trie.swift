//
//  Trie.swift
//  SWIFT_ALGORITHM_SOLVING
//
//  Created by hw on 07/09/2019.
//  Copyright © 2019 hwj. All rights reserved.
//
//https://www.geeksforgeeks.org/trie-insert-and-search/

import Foundation

class Trie {
    var ALPHABET_SIZE = 26
    var root: TrieNode?
    class TrieNode {
        var children: [TrieNode?] = [TrieNode?].init(repeating: nil, count: 26)
        var isEndWord: Bool = false
        init(){ }
    }
    func insert(_ key: String){
        var level = 0
        var length = key.count
        var index = 0
        var pCrawl = root
        for lev in 0..<length {
            index = Int(key[key.index(key.startIndex, offsetBy: lev)].asciiValue!) - Int(Character("a").asciiValue!)
            
            if pCrawl?.children[index] == nil {
                pCrawl?.children[index] = TrieNode.init()
            }
            pCrawl = pCrawl?.children[index]
        }
        pCrawl?.isEndWord = true
    }
    
    func search(_ key: String) -> Bool {
        var level = 0
        var length = key.count
        var index = 0
        var pCrawl = root
        for lev in 0..<length {
            index = Int(key[key.index(key.startIndex, offsetBy: lev)].asciiValue!) - Int(Character("a").asciiValue!)
            
            if pCrawl?.children[index] == nil {
                return false
            }
            pCrawl = pCrawl?.children[index]
        }
        return pCrawl != nil && pCrawl!.isEndWord
    }
    
    func isEmpty(root: TrieNode) -> Bool {
        for i in 0..<ALPHABET_SIZE {
            if (root.children[i] != nil){
                return false
            }
        }
        return true
    }
    
    func remove(root: inout TrieNode?, key: String, depth: Int = 0) -> TrieNode? {
        
        if root == nil {
            return nil
        }
        // If last character of key is being processed
        if depth == key.count {
            if root!.isEndWord {
                root!.isEndWord = false
            }
            if (isEmpty(root: root!)){
                root = nil
            }
            return root
        }
        // If not last character, recur for the child
        // obtained using ASCII value
        var index = Int(key[key.index(key.startIndex, offsetBy: depth)].asciiValue!) - Int(Character("a").asciiValue!)
        var next = root?.children[index]
        root?.children[index] = remove(root: &next, key: key, depth: depth+1)
        // If root does not have any child (its only child got
        // deleted), and it is not end of another word.
        if isEmpty(root: root!) && root!.isEndWord == false {
            root = nil
        }
        return root
    }
    
    func start(){
        let keys = ["the", "a", "there", "answer", "any",
                    "by", "bye", "their"]
        let outputs = ["Not present in trie", "Present in trie"]
        root = TrieNode.init()
        var i = 0
        for  key in keys{
            insert(key)
        }
        
        if search("the") == true {
            print("the --- \(outputs[1])")
        }else {
            print("the --- \(outputs[0])")
        }
        
        if search("these") == true {
            print("these --- \(outputs[1])")
        }else {
            print("these --- \(outputs[0])")
        }
        
        if search("their") == true {
            print("their --- \(outputs[1])")
        }else {
            print("their --- \(outputs[0])")
        }
        if search("thaw") == true {
            print("thaw --- \(outputs[1])")
        }else {
            print("thaw --- \(outputs[0])")
        }
        remove(root: &root, key: "the")
        if search("the") == true {
            print("the --- \(outputs[1])")
        }else {
            print("the --- \(outputs[0])")
        }
        if search("their") == true {
            print("their --- \(outputs[1])")
        }else {
            print("their --- \(outputs[0])")
        }
    }
    
}
