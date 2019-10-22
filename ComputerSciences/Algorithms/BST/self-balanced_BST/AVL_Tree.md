## Self-Balanced BST (1) - AVL Tree

https://www.geeksforgeeks.org/avl-tree-set-1-insertion/



AVL tree 는 자가 균형 이진 탐색 트리이다.

>  **자가균형 트리란, 모든 노드에 대해 **
>
> **left/right 서브트리의 높이 차이가 오직 하나 이하** 임을 의미한다.

<img src="https://media.geeksforgeeks.org/wp-content/cdn-uploads/AVL-Tree1.jpg" width= "300px">

위 트리는 AVL 트리의 조건을 만족한다. left/right subtree의 높이 차이가 1 이하이다.

<img src="https://media.geeksforgeeks.org/wp-content/cdn-uploads/Not-AVL1.jpg" width="300px">

위 트리는 AVL 트리 조건을 만족하지 못한다. 8과 18의 서브트리 높이 차이가 1보다 크다.



### **Why AVL Trees?**

- Red Black Tree 와 동일하다. 높이 h = O(log n) (n은 노드 개수)임을 보장하므로 연산의 성능도 O(log n )임을 보장할 수 있다.





### Insertion

- 주어진 트리가 삽입 후에도 AVL 트리를 유지함을 보이기 위해서, 표준 BST의 삽입에 있어서 re-balancing 과정에 대해 논의해보자. 

- 아래는 BST의 키 제약 특징을 어기지 않는 BST 리밸런싱을 위한 2가지 기본 연산이다. 

  1) Left Rotation
  2) Right Rotation

```
T1, T2 and T3 are subtrees of the tree 
rooted with y (on the left side) or x (on 
the right side)           
     y                               x
    / \     Right Rotation          /  \
   x   T3   - - - - - - - >        T1   y 
  / \       < - - - - - - -            / \
 T1  T2     Left Rotation            T2  T3
Keys in both of the above trees follow the 
following order 
 keys(T1) < key(x) < keys(T2) < key(y) < keys(T3)
So BST property is not violated anywhere.
```



### 삽입 단계

새로 삽입할 노드를 `w`  라 하자.

**1)** w에 대해 BST의 표준 삽입 연산을 수행한다.
**2)** w부터 시작하여, 위로 탐색한다. 탐색 과정에서 불균형한 첫번째 노드 `z`를 찾는다.

`w` 는 `T1` 혹은  `T2`에 존재한다고 할 때.

`z` 는 첫번째 불균형 노드를 의미한다. 

`y` 는 `w` 에서 `z` 까지의 경로에 오는 `z` 의 자식이다.

`x`는 `w` 에서 `z` 까지의 경로에 오는 `z의 손자` 이다. 

```tex
     				    z                  
     				   / \                        
   				    y   T4     
             / \          
   				  x   T3   
 				   / \
 				 T1   T2
```

**3)** `z` 를 root로 하는 서브트리에서 **적절한 회전**을 수행하여 **트리의 균형을 재조정** 한다. 

  x, y, z를 **4가지 방식**으로 배열 할 수 있으므로 처리해야 할 경우가 **4 가지** 있습니다. 

z의 자식인 y, y의 자식인 x가 각각 부모의 왼쪽/오른쪽 자식인지에 따른 4가지 입니다.



a) `y` 가 `z` 의 **왼쪽 자식** 이고, `x` 가 `y` 의 **왼쪽 자식** 인 경우 (Left Left Case)

b) `y` 가 `z` 의 **왼쪽 자식 ** 이고,  `x` 가 `y` 의 **오른쪽 자식**인 경우 (Left Right Case)

c) `y` 가 `z` 의 **오른쪽 자식 **이고,  `x` 가 `y` 의 **오른쪽 자식**인 경우(Right Right Case)

d)  `y` 가 `z` 의 **오른쪽 자식 **이고,  `x` 가 `y` 의 **왼쪽 자식**인 경우(Right Left Case)

단지 z를 root로 하는 subtree에 대해 리밸런싱을 취함으로써 complete tree는 서브트리의 높이에 대해 균형을 갖게 된다.

(See [this ](http://www.youtube.com/watch?v=TbvhGcf6UJU)video lecture for proof)



#### 1) Left Left Case (LL)

- `z` 에 대해 **right rotate**를 실시한다.

```
T1, T2, T3 and T4 are subtrees.
         z                                      y 
        / \                                   /   \
       y   T4      Right Rotate (z)          x      z
      / \          - - - - - - - - ->      /  \    /  \ 
     x   T3                               T1  T2  T3  T4
    / \
  T1   T2
```



#### 2) Left Right Case (LR)

- `y` 에 대해 **Left rotate** 실시하고, `z` 에 대해 **right rotate**를 실시한다.

```
     z                               z                           x
    / \                            /   \                        /  \ 
   y   T4  Left Rotate (y)        x    T4  Right Rotate(z)    y      z
  / \      - - - - - - - - ->    /  \      - - - - - - - ->  / \    / \
T1   x                          y    T3                    T1  T2 T3  T4
    / \                        / \
  T2   T3                    T1   T2
```





#### 3) Right Right Case (RR)

- `z` 에 대해  **Left rotate** 실시한다.

```
  z                                y
 /  \                            /   \ 
T1   y     Left Rotate(z)       z      x
    /  \   - - - - - - - ->    / \    / \
   T2   x                     T1  T2 T3  T4
       / \
     T3  T4
```



#### 4) Right Left Case ( RL )

`y` 에 대해 **Right rotate** 실시하고, `z` 에 대해 **Left rotate**를 실시한다.

```
   z                            z                            x
  / \                          / \                          /  \ 
T1   y   Right Rotate (y)    T1   x      Left Rotate(z)   z      y
    / \  - - - - - - - - ->     /  \   - - - - - - - ->  / \    / \
   x   T4                      T2   y                  T1  T2  T3  T4
  / \                              /  \
T2   T3                           T3   T4
```



### 쉽게 외우기 위해...

1) `w~z` 사이의 **z의 자식인 y/y의 자식인x(z의 손자)**가 각각 부모에 대해 위치한 바에 따라 LL, LR, RR, RL로 나뉜다.

2) 두 문자가 같은 LL과 RR은 z에 대해 각각 right, left rotate 1회만 진행된다.

3) LR과 RL은 자식/손자의 위치가 그대로 자식/부모의 rotate 방향이 된다.

- LR : 자식 y 를 left rotate, 부모 z를 right rotate
- RL : 자식 y 를 right rotate, 부모 z를 left rotate



#### 필요한 함수는 아래와 같을 것이다.

- 1) 불균형되는 노드 찾기 
  - **2) 불균형 계산 메서드**
    - **균형계수**(현재 노드의 왼쪽 서브트리 높이와 오른쪽 서브트리 높이 차이) 찾는 식
    - 높이 구하는 식
- 3) 삽입 노드(w)로부터 z 까지의 y와 x 찾는 메서드 
- 4) 현재 노드를 root로 하는 left rotate
- 5) 현재 노드를 root로 하는 right rotate





#### 키값 14인 노드를 집어넣는 경우 - 균형

![avlinsert1](https://media.geeksforgeeks.org/wp-content/uploads/AVL-Insertion-1.jpg)

- 14로부터 올라갔을 때, 1~-1 이하의 균형조건 내이므로 문제 없음



#### case LL : 노드 3을 삽입 시...



![avlinsert2-jpg](https://media.geeksforgeeks.org/wp-content/uploads/AVL-Insertion1-1.jpg)

- 노드의 균형이 깨지게 된다. 
- 삽입한 노드 3(w)에서 찾은 첫번째 불균형 노드(`z`)는 노드 10 이다. 
- w와 z사이에서 z의 자식 y는 5, 손자 x는 4에 해당한다. 
- 해당 트리는 `Left child Left grandchild` 에 해당하므로 z에 대해 **right rotate**를 실시한다.
- 노드 10에 대해 Right rotate를 실시한다.





#### case RR : 노드 45 삽입

![avlinsert3](https://media.geeksforgeeks.org/wp-content/uploads/AVL_INSERTION2-1.jpg)

- 현재 트리에서 `노드 45(w)` 를 삽입한다. 불균형 지점인 `z`는 30이다.
- `z`에서 `w` 사이의 자식 `y`은 35, 손자 `x`는 40이다.  
- y는 z의 right, x는 y의 right 이므로 RR에 해당한다.
- `z (노드 30)`  를 기준으로 **left rotate**를 취하면 된다.





#### case LR - 노드 7 삽입

![avlinsert4](https://media.geeksforgeeks.org/wp-content/uploads/AVL_Insertion_3-1.jpg)

- 노드 7을 삽입한다.  
- 현재 노드로부터 최초의 불균형 지점은 10에 해당한다. 10이 `z` 다.

- `y` 는 `z` 의 왼쪽자식이고, w 까지의 y의 자식 `x` 는 `y의 오른쪽 자식`이다. 따라서 **LR**이다.
- **`y` 에 대해 left rotate**를 취하고, 다시 **`z` 에 대해 *right rotate***를 취한다.



#### case RL - 노드 15 삽입

![avlinsert5](https://media.geeksforgeeks.org/wp-content/uploads/AVL_Tree_4-1.jpg)

- w로부터 불균형 노드 9(z)를 찾는다. 
- z의 자식 y 는 right child, 손자 x는 (y 에 대해 ) left child 이다. (x == w 이다.)
- **`y` 에 대해 *right rotate*** 를 취하고, 다시 **`z` 에 대해 *left rotate***를 취한다.



### 구현 Implementation

- 다음은 AVL 트리 삽입에 대한 구현입니다. 
- 다음 구현에서는 **재귀 BST 삽입**을 사용하여 **새 노드를 삽입**합니다. 
- 재귀 BST 삽입에서 **삽입 후 모든 조상에 대한 포인터를 상향식으로 하나씩 가져옵니다.** 
- 따라서 우리는 여행을 위해 **부모 포인터가 필요하지 않습니다.** 
- **재귀 코드 자체는 위로 이동하여 새로 삽입 된 노드의 모든 조상을 방문**합니다.



(1) 새 노드 w에 대해**정상적인 BST 삽입**을 수행하십시오.  **삽입 과정에서 탐색 경로상의 조상 노드를 모아둡니다.**

(2) `현재 노드`는 **새로 삽입 된 노드의 조상 중 하나** 여야합니다. `현재 노드의 높이를 업데이트`하십시오.

(3) `현재 노드`의  `균형 계수(왼쪽 하위 트리 높이 – 오른쪽 하위 트리 높이)`를 가져옵니다.

(4) `균형 계수`가 **1보다 크면** 현재 노드의 균형이 맞지 않으며`LL` 또는 `LR` 에 있습니다. 

- `LL` 여부를 확인하려면 새로 삽입 한 `w`의 키를 **왼쪽 하위 트리의 루트의 키**와 비교하십시오.

5) 균형 계수가 **-1보다 작으면** 현재 노드의 균형이 맞지 않으며 `RR`  또는 `RL` 의 상황입니다.

- `RR` 인지 확인하려면 새로 삽입 한 `w`의 키를 **오른쪽 하위 트리 루트의 키**와 비교하십시오.



### Code Implementation

```java
class Node {
	int key;
	int height; 
	Node right, left;
	Node (int key){
		this.key = key;
		this.height = 1;
	}
}
```

- node에는 height 정보를 담는다. 초기값은 1



AVL 트리에는 다음과 같은 메서드를 구현한다.

```java
public class AVLTree {
	Node root;							/// 루트 노드
	int height(Node N){}		/// 각 노드의 높이 구하는 메서드
	int max(int a, int b) {}	///두 정수값 비교하는 보조함수 
  Node rightRotate(Node z){}	///z를 축으로 right 회전
  Node leftRotate(Node z){ }  ///z를 축으로 left 회전
  int getBalance(Node N){}   ///균형계수 구하기 
  Node insert(Node root, int key){} /// 삽입 함수
  void preOrder(Node node) { }  /// 전위 출력 함수 
}
```



##### height구하기, max 메서드

```java
int height(Node N){
  if (N == null)
    return 0;
  return N.height;
}
int max(int a, int b) {
  return (a > b) ? a : b;
}
```



##### right/left Rotate 메서드  y / z \ T1 —>  T / y \ z

```java
Node rightRotate(Node z){
  Node y = z.left;	///z자리에 올라갈 것은 z.left child이다.
  Node rightSubTreeOfY = y.right; 
  // y가 z자리를 차지하면서 right child로 z를 가지므로, z의 left child 에 붙여줄 subtree를 백업
  
  // rotate right
  y.right = z;
  z.left = rightSubTreeOfY
   
  z.height = max(height(z.left), height(z.right))+1;
  y.height = max(height(y.left), height(y.right))+1;
  
  return y;
}

Node leftRotate(Node z){
  Node y = z.right;
  Node leftSubTreeOfY = y.left;
  
  //rotate left
  y.left = z;
  z.right = leftSubTreeOfY
  //높이 갱신은 동일
  z.height = max(height(z.left), height(z.right))+1;
  y.height = max(height(y.left), height(y.right))+1;
  
  return y;
}
```



##### 균형계수 구하는 메서드 ; left child height - right child height 를 리턴 

```java
int getBalanceFactor(Node N){
  if (N == null) return 0;
  return height(N.left) - height(N.right);
}
```



##### insert 메서드 

```java
Node insert(Node root, int key){
  ///일반적인 BST와 동일
  if (root == null)
    return new Node(key);
  
  if (root.key < key){
    root.right = insert(root.right, key);
  }else if (root.key > key){
    root.left = insert(root.left, key);
  }else {
    return root; //duplicated key is not allowed
  }
  //2. 삽입 노드의 조상들의 높이를 갱신한다.
  root.height = 1+max(height(root.left), height(root.right));
  /// 3. 조상노드에 대해 균형계수 찾아서 어느 노드에서 불균형한지 찾는다. 
  int balanceFactor = getBalanceFactor(root);
  
  //1) LL
  if (balanceFactor > 1 && root.left.key < key){
    return rightRotate(root);
  }
  //2) RR
  if (balanceFactor < -1 && root.right.key < key){
    return leftRotate(root);
  }
  //3) LR
  if (balanceFactor > 1 && root.left.key < key){
    root.left = leftRotate(root.left);
    return rightRotate(root);
  }
  
  //4) RL
  if (balanceFactor < -1 && root.right.key > key){
    root.right = rightRotate(root.right);
    return leftRotate(root);
  }
  return root;
}
```





### 전체 코드

```java
class Node {
	int key;
	int height; 
	Node right, left;
	Node (int key){
		this.key = key;
		this.height = 1;
	}
}
public class AVLTree {
	Node root;
	int height(Node N){
		if (N == null)
			return 0;
		return N.height;
	}
	
	int max(int a, int b) {
		return (a > b) ? a : b;
	}
	
	Node rightRotate(Node z){
		Node y = z.left;
		Node T2 = y.right;
		/// rotate
		y.right = z;
		z.left = T2;
		/// update height
		y.height = max(height(y.left), height(y.right))+1;
		z.height = max(height(z.left), height(z.right))+1;
		//현재 서브트리의 루트가 된 노드를 리턴  
		return y;
	}
	
	Node leftRotate(Node z){ 
		Node y = z.right;
		Node T2 = y.left;
		/// rotate
		y.left = z;
		z.right = T2;
		/// update height
		z.height = max(height(z.left), height(z.right))+1;
		y.height = max(height(y.left), height(y.right))+1;
		//현재 서브트리의 루트가 된 노드를 리턴  
		return y;
	}
	
	// Get Balance factor of node N 
	// N의 left subtree height - N의 right subtree height
	int getBalanceFactor(Node N){
		if (N == null)
			return 0;
		return height(N.left) - height(N.right);
	}
	
	Node insert(Node root, int key){
		/// 1. 일반적인 BST 삽입과정 
		if (root == null){
			return new Node(key);
		}
		if (root.key > key){
			root.left = insert(root.left, key);
		}else if (root.key < key){
			root.right = insert(root.right, key);
		}else {
			return root;	/// duplicated is not allowed
		}
		/// 2. 삽입 노드의 조상들의 높이 갱신
		root.height = 1 + max(height(root.left), height(root.right));
		/// 3. 조상노드에 대해 균형계수 찾아서 어느 노드에서 불균형한지 찾는다. 
		int balanceFactor = getBalanceFactor(root);
		
		/// 4. 노드가 불균형한 경우, 4가지 경우에 대해 검사
		/// - 균형계수가 1보다 크거나 -1보다 작다면 일단 불균형이다. 
		///   1보다 큰 경우는 z에 대해 y가 left child, -1보다 작은 경우는 right child임을 의미.
		/// - root(z)와 삽입노드 사이에 존재하는, y의 자식 x는 z의 left/right child 에 존재하는 y의 key값과 비교하여 판단이 가능하다.
		///   - 균형계수로부터 먼저 y의 위치를 판단하고, y값의 키값과 비교하는 것이다!!
		
		///  1) Left Left Case 
        if (balanceFactor > 1 && key < root.left.key) {	
            return rightRotate(root); 
        }
        
        //  2) Right Right Case 
        else if (balanceFactor < -1 && key > root.right.key) 
            return leftRotate(root); 
  
        //  3) Left Right Case 
        else if (balanceFactor > 1 && key > root.left.key) { 
        	root.left = leftRotate(root.left); 
            return rightRotate(root); 
        } 

        //  4) Right Left Case 
        else if (balanceFactor < -1 && key < root.right.key) { 
        	root.right = rightRotate(root.right); 
            return leftRotate(root); 
        } 
		
		return root;
	}
	
	void preOrder(Node node) { 
        if (node != null) { 
            System.out.print(node.key + " "); 
            preOrder(node.left); 
            preOrder(node.right); 
        } 
    } 
	
	public static void main(String[] args) {
		AVLTree tree = new AVLTree(); 
		  
        /* Constructing tree given in the above figure */
        tree.root = tree.insert(tree.root, 10); 
        tree.root = tree.insert(tree.root, 20); 
        tree.root = tree.insert(tree.root, 30); 
        tree.root = tree.insert(tree.root, 40); 
        tree.root = tree.insert(tree.root, 50); 
        tree.root = tree.insert(tree.root, 25); 
  
        /* The constructed AVL Tree would be 
             30 
            /  \ 
          20   40 
         /  \     \ 
        10  25    50 
        */
        System.out.println("Preorder traversal" + 
                        " of constructed tree is : "); 
        tree.preOrder(tree.root); 

	}
}
```

