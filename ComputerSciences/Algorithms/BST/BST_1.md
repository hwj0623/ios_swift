## 알고리즘 1 - Binary Search Tree 

https://www.geeksforgeeks.org/binary-search-tree-set-1-search-and-insertion/

https://www.geeksforgeeks.org/binary-search-tree-set-2-delete/



바이너리 서치 트리는 **노드 기반 바이너리 트리 데이터 구조**로 다음의 특징을 갖는다. 

- 한 노드의 **왼쪽 서브트리**에는 **그 노드의 키값보다 작은 노드들만이 포함**된다.

- 한 노드의 **오른쪽 서브트리**에는 그 **노드의 키값보다 큰 노드들만이 포함**된다.

- 왼쪽/오른쪽 **서브트리는 각각 바이너리 서치 트리**의 형태이다. (재귀적 정의)

- **중복되는 키**를 지닌 노드들은 **존재하지 않는다**.

- **full binary tree나, complete binary tree가 반드시 성립하는 것이 아니다.**

  

<img src="https://media.geeksforgeeks.org/wp-content/uploads/BSTSearch.png" width="300px">



The above properties of Binary Search Tree provide an ordering among keys so that the operations like search, minimum and maximum can be done fast. If there is no ordering, then we may have to compare every key to search a given key.

시간 복잡도 : O(h)  h는 트리의 높이. left/right skewed tree라면 시간복잡도는 O(n) n은 노드 전체 크기



**Some Interesting Facts:**

- Inorder traversal of BST always produces sorted output.
- We can construct a BST with only Preorder or Postorder or Level Order traversal. Note that we can always get inorder traversal by sorting the only given traversal.

**Related Links:**

- [Binary Search Tree Delete Operation](http://quiz.geeksforgeeks.org/binary-search-tree-set-2-delete/)
- [Quiz on Binary Search Tree](http://quiz.geeksforgeeks.org/data-structure/binary-search-trees/)
- [Coding practice on BST](https://practice.geeksforgeeks.org/tag-page.php?tag=BST&isCmp=0)
- [All Articles on BST](https://www.geeksforgeeks.org/binary-search-tree/)

#### **Searching a key**

#### Insert key

```java
class Node {
	int key;
	Node left, right;
	public Node(int key){
		this.key = key;
	}
}
public class BinarySearchTree {
	static Node root;
	BinarySearchTree(){
		root = null;
	}
	public static Node search(Node root, int key){
		if (root==null || root.key == key){
			return root;
		}
		if (root.key > key){
			return search(root.left, key);
		}
		return search(root.right, key);
	}
	
	public static Node insertImpl(Node root, int key){
		if (root == null){
			root = new Node(key);
			return root;
		}
		if (key < root.key){
			root.left = insertImpl(root.left, key);
		}else {
			root.right = insertImpl(root.right, key);
		}
		return root;
	}
	public static void insert(int key){
		root = insertImpl(root, key);
	}
	public static void inorder(Node root){
		inorderRec(root);
	}
	
	public static void inorderRec(Node root){
		if (root != null){
			inorderRec(root.left);
			System.out.println(root.key);
			inorderRec(root.right);
		}
	}
	public static void main(String[] args) { 
  
        /* Let us create following BST 
              50 
           /     \ 
          30      70 
         /  \    /  \ 
       20   40  60   80 */
		insert(50);
		insert(30);
		insert(20);
		insert(40);
		insert(70);
		insert(60);
		insert(80);

		// print inorder traversal of the BST
		inorder(root); 
    } 
}
```



### 삭제 

- 삭제의 경우에는 몇가지 고려할 사항이 존재한다.

#### 1) 삭제될 노드가 leaf node

- 단순히 삭제하면 된다.

  ```tex
       50                            50
             /     \         delete(20)      /   \
            30      70       --------->    30     70 
           /  \    /  \                     \    /  \ 
         20   40  60   80                   40  60   80
  ```

  

#### 2) 삭제할 노드가 하나의 자식을 지닌 경우

- 자식 노드를 복사하고, 해당 자식 노드는 지운다.

- 복사한 자식노드는 삭제할 현재의 노드에 위치한다.

  ```tex
               50                            50
             /     \         delete(30)      /   \
            30      70       --------->    40     70 
              \    /  \                          /  \ 
              40  60   80                       60   80
  ```

  

#### 3) 삭제할 노드가 두 자식을 지닌 경우

- 노드의 inorder successor를 찾는다. 

- inorder successor는 왼쪽 자식에서 찾을 수 있는 최대값이거나, 오른쪽 자식노드에서 찾을 수 있는 최솟값이 될 것이다.

- 해당 노드를 찾아서 복사후 현재 위치에서 삭제하고, 삭제할 노드자리에 위치시킨다.

  ```tex
                50                            60
             /     \         delete(50)      /   \
            40      70       --------->    40    70 
                   /  \                            \ 
                  60   80                           80
  ```

  

```java
public static void delete(int key){
  root = deleteRec(root, key);
}

public static Node deleteRec(Node root, int key) {
  // base case : tree is empty
  if (root == null)
    return root;

  // recursively search tree
  if (key < root.key) {
    root.left = deleteRec(root.left, key);
  } else if (key > root.key) {
    root.right = deleteRec(root.right, key);
  } else if (root.key == key) {
    // case : 자식이 하나만 있거나 없는 경우
    if (root.left == null)
      return root.right;
    else if (root.right == null)
      return root.left;
    // case : two children
    // Find inorder successor(smallest in the right subtree)
    root.key = getSuccessorValue(root.right);

    root.right = deleteRec(root.right, root.key);
  }
  return root;
}

public static int getSuccessorValue(Node root) {
  int minValue = root.key;
  while (root.left != null) {
    minValue = root.left.key;
    root = root.left;
  }
  return minValue;
}
public static void main(String[] args) { 
  
  /* Let us create following BST 
              50 
           /     \ 
          30      70 
         /  \    /  \ 
       20   40  60   80 */
  insert(50);
  insert(30);
  insert(20);
  insert(40);
  insert(70);
  insert(60);
  insert(80);

  // print inorder traversal of the BST
  System.out.println("Inorder traversal of the given tree"); 
  inorder(root); 
  System.out.println("\nDelete 20"); 
  delete(20);
  System.out.println("Inorder traversal of the modified tree"); 
  inorder(root); 

  System.out.println("\nDelete 30"); 
  delete(30); 
  System.out.println("Inorder traversal of the modified tree"); 
  inorder(root); 

  System.out.println("\nDelete 50"); 
  delete(50); 
  System.out.println("Inorder traversal of the modified tree"); 
  inorder(root); 
} 
```

**Time Complexity:** The worst case time complexity of delete operation is **O(h)** where **h is height of Binary Search Tree**. **In worst case**, we may **have to travel from root to the deepest leaf node.** The height of a skewed tree may become **n** and the time complexity of delete operation may become **O(n)**



- 두 자식인 경우에 해당하는 로직을 개량해보자.

- 종전의 코드는 아래와 같다.

  ```java
  public static void delete(int key){
    root = deleteRec(root, key);
  }
  public static Node deleteRec(Node root, int key) {
    // base case : tree is empty
    if (root == null)
      return root;
    // recursively search tree
    if (key < root.key) {
      root.left = deleteRec(root.left, key);
    } else if (key > root.key) {
      root.right = deleteRec(root.right, key);
    } else if (root.key == key) {
      // case : 자식이 하나만 있거나 없는 경우
      if (root.left == null)
        return root.right;
      else if (root.right == null)
        return root.left;
      // case : two children
      // Find inorder successor(smallest in the right subtree)
      root.key = getSuccessorValue(root.right);
  	  // 재귀호출로 successor를 지운다. 
      root.right = deleteRec(root.right, root.key);
    }
    return root;
  }
  
  public static int getSuccessorValue(Node root) {
    int minValue = root.key;
    while (root.left != null) {
      minValue = root.left.key;
      root = root.left;
    }
    return minValue;
  }
  ```

- 재귀호출로 successor를 지우기 때문에 재귀호출이 한번 더 일어난다. 

  사실 이 `getSuccessorValue`부분에서 successor를 지워되 된다.

  ```java
  public static int getSuccessorValue(Node root) {
    int minValue = root.key;
    while (root.left != null) {
      minValue = root.left.key;
      root = root.left;
    }
    root = null; // successor를 현재 위치에서 삭제 
    return minValue;
  }
  ```

  

- `getSuccessorValue` 메서드와 함께 이를 최적화해보자.

```java
	/// root.right = deleteRec(root.right, key); 로직을 없앤 개량 코드 
	public static Node deleteNode(Node root, int key) {
		// basis
		if (root == null)
			return root;
		// recur
		if (root.key > key) {
			root.left = deleteNode(root.left, key);
		} else if (root.key < key) {
			root.right = deleteNode(root.right, key);
		} else if (root.key == key) { /// 최적화 
			// case : 자식이 하나만 있거나 없는 경우
			if (root.left == null) {
				return root.right;
			} else if (root.right == null) {
				return root.left;
			} else { /// case : 자식이 둘 다 있는 경우
				Node successorParent = root.right;
				Node successor = root.right;
				while (successor.left != null) {
					successorParent = successor;
					successor = successor.left;
				}
				// successor를 현 위치에서 삭제.
				// successor는 항상 successor부모의 왼쪽 자식이므로
				// successor의 바로 오른쪽 자식을 부모의 왼쪽 자식으로 대체할 수 있다.
				// successor는 항상 leaf node가 된다.
				successorParent.left = successor.right;
				root.key = successor.key;
				successor = null;
			}
		}
		return root;
	}
```

