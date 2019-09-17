//
//  Solution.swift
//  SWIFT_ALGORITHM_SOLVING
//
//  Created by hw on 13/06/2019.
//  Copyright © 2019 hwj. All rights reserved.
//

import Foundation


class Solution_LeetCode_700{
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
    
    func makeSubtreeByInorder(_ root: TreeNode?) -> TreeNode? {
        guard var rootNode = root else{
            return root
        }
        rootNode = TreeNode(rootNode.val)
        if root?.left != nil {
            rootNode.left = makeSubtreeByInorder(root?.left)
        }
        if root?.right != nil {
            rootNode.right = makeSubtreeByInorder(root?.right)
        }
        return rootNode
    }
    
    func searchBST(_ root: TreeNode?, _ val: Int) -> TreeNode? {
        var result : TreeNode?
        if let rootNode = root {
            if rootNode.val == val {
                result = makeSubtreeByInorder(root)
                return result
            }else if rootNode.val > val {
                result = searchBST(rootNode.left, val)
            }else {
                result = searchBST(rootNode.right, val)
            }
        }else{
            return nil
        }
        return result
    }
    func inorder(_ root: TreeNode?){
        if let rootNode = root {
            print(rootNode.val)
            if let rootNodeLeft = root?.left{
                inorder(rootNodeLeft)
            }
            if let rootNodeRight = root?.right{
                inorder(rootNodeRight)
            }
        }
    }
    func start(){
        var sol = Solution_LeetCode_700()
        var root = TreeNode(4)
        root.left = TreeNode(2)
        root.right = TreeNode(7)
        root.left!.left = TreeNode(1)
        root.left!.right = TreeNode(3)
        guard let result = sol.searchBST(root, 2) else {
            return
        }
        inorder(result)
        
    }
}

