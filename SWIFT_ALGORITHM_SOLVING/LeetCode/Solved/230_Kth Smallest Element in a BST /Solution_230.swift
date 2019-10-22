//
//  Solution.swift
//  SWIFT_ALGORITHM_SOLVING
//
//  Created by hw on 14/06/2019.
//  Copyright © 2019 hwj. All rights reserved.
//

import Foundation
/**
 * Definition for a binary tree node.
 * public class TreeNode {
 *     public var val: Int
 *     public var left: TreeNode?
 *     public var right: TreeNode?
 *     public init(_ val: Int) {
 *         self.val = val
 *         self.left = nil
 *         self.right = nil
 *     }
 * }
 */
class Solution_LeetCode_230 {
    class TreeNode{
        public var val: Int
        public var left: TreeNode?
        public var right: TreeNode?
        public init(_ val: Int) {
            self.val = val
            self.left = nil
            self.right = nil
        }
    }
    init(){}
    func kthSmallest(_ root: TreeNode?, _ k: Int) -> Int {
        guard let rootNode = root else {
            return -1
        }
        var count = 0
        var kthTreeNode: TreeNode?
        kthTreeNode = inorderCount(root, count: &count, target: k)
        return kthTreeNode?.val ?? rootNode.val
    }
    
    private func inorderCount (_ root: TreeNode?, count : inout Int, target : Int) -> (TreeNode?){
        guard let rootNode = root else {
            return root
        }
        var leftSubTreeFound: TreeNode?
        var rightSubTreeFound: TreeNode?
        //visit left subtree
        if rootNode.left != nil {
            leftSubTreeFound = inorderCount(root?.left, count: &count, target: target)
            if (count == target){
                return (leftSubTreeFound)
            }
        }
        //visit current Node
        count += 1
        if count == target {
            return root
        }
        //visit right subtree
        if rootNode.right != nil {
            rightSubTreeFound = inorderCount(root?.right, count: &count, target: target)
            if (count == target){
                return (rightSubTreeFound)
            }
        }
        return root
    }
    /*
        3
      /  \
     1   4
     \
      2
             5
            / \
           3   6
          / \
         2   4
        /
       1
     */
    func start(){
        var sol = Solution_LeetCode_230()
        var root = TreeNode(3)
        root.left = TreeNode(1)
        root.right = TreeNode(4)
        root.left!.right = TreeNode(2)
        print(sol.kthSmallest(root, 4)) // 1
//        print("test 2")
        root = TreeNode(5)
        root.left = TreeNode(3)
        root.right = TreeNode(6)
        root.left!.left = TreeNode(2)
        root.left!.right = TreeNode(4)
        root.left!.left!.left = TreeNode(1)
        print(sol.kthSmallest(root, 6))// 3
    }
    
    private func findSmallestNode(_ root: TreeNode?) -> TreeNode?{
        var result : TreeNode? = root
        //노드가 없다면
        guard let rootNode = root else {
            return nil
        }
        //왼쪽 노드 존재시
        if let left = rootNode.left {
            result = findSmallestNode(root?.left)
        }
        return result
    }
}
