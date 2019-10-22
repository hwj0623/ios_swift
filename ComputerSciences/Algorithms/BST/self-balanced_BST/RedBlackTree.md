## Red-Black Tree 

https://www.geeksforgeeks.org/red-black-tree-set-1-introduction-2/

### Introduction

 레드-블랙 트리는 자가 균형 BST이며 아래의 규칙을 따른다.

[![RedBlackTree](https://www.geeksforgeeks.org/wp-content/uploads/RedBlackTree.png)](https://www.geeksforgeeks.org/wp-content/uploads/RedBlackTree.png)
**1)** 모든 노드는 red or black의 색을 지닌다.

**2)** 트리의 Root는 항상 black이다. 

**3)** 두 가지 인접한 red nodes는 존재하지 않는다. 인접이란, 부모 자식간의 연결을 의미한다.

**4)** (Root를 포함한) 한 노드로부터 leaf 까지 black 노드의 개수는 모두 동일하다. 



### **Why Red-Black Trees?**

대부분의 BST의 연산(검색, 최대,최소, 삽입, 삭제)은 O(h)의 시간이 소요된다. (h는 BST 높이)

편향 이진 트리의 경우 이 연산의 비용은 O(n) 으로 증가한다. 따라서 만약에 우리가 모든 삽입/삭제 후의 BST 트리의 높이가 O(log n)임을 보장할 수 있다면, 우리는 모든 연산의 비용 상한을 O(log n)으로 보장할 수 있다. R-B Tree의 높이는 항상 O(log n) 이며, n은 트리의 노드의 개수를 의미한다.



### AVL Tree 와의 비교 