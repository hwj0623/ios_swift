# 알고리즘 정리

1) 링크드 리스트

- 싱글
- 더블
- **circular**
  - **single**
  - double



# 순환 링크드 리스트 - single

***Circular linked list*** 는 모든 노드가 원의 형태로 연결된 링크드리스트를 말한다. null 혹은 nil 포인트의 끝노드가 존재하지 않는다. 순환 링크드 리스트는 싱글 혹은 더블 링크드 리스트로 구현 가능하다.

![cll](https://cdncontribute.geeksforgeeks.org/wp-content/uploads/CircularLinkeList.png)

### 장점

**1)** 어떠한 노드도 스타트 포인트가 될 수 있다. 전체 리스트를 임의의 스타트 포인트로부터 순회할 수 있다. 단지, traverse를 시작한 첫 노드가 재방문 되는 경우에만 stop을 하면 된다.

**2)** queue를 구현하는데 유용하다.

​	 Unlike [this ](http://quiz.geeksforgeeks.org/queue-set-2-linked-list-implementation/)implementation, 순환 링크드 리스트에서는 두 포인터 (front / rear)를 유지할 필요가 없다.

​	마지막에 삽입된 노드 포인터(last)만 관리하면, front 노드는 항상 last 노드의 다음 노드로 찾을 수 있다.

**3)** 순환 리스트는 리스트를 반복해서 탐색하는 애플리케이션에서 유용하다.

- 예를 들어, 여러 응용 프로그램이 PC에서 실행되는 경우 운영 체제가 실행중인 응용 프로그램을 목록에 넣은 다음 해당 응용 프로그램을 순환하여 각 응용 프로그램에 실행 시간을 부여한 다음 대기하게 만드는 것이 일반적입니다. 

- CPU가 다른 응용 프로그램에 제공되는 동안. 운영 체제가 순환 목록을 사용하는 것이 편리하므로 목록의 끝에 도달하면 목록의 앞쪽으로 순환 할 수 있습니다.  

**4)** 이중 연결리스트로 이루어진 순환 리스트는 피보나치 힙[Fibonacci Heap](http://en.wikipedia.org/wiki/Fibonacci_heap) 과 같은 더 진보된 자료구조를 구현하는데 쓰입니다.



### Java code 예제 - 순환 리스트에서 삽입 / 순회

   ```java
/**
 * 
 * @테스트케이스 
2
7
374 363 171 497 282 306 426
2
162 231
 */
public class Circular_Linked_List_Traversal {
	
	static class Node {
		int data;
		Node next;
	}
	static Node push(Node head, int data){
		Node addedNode = new Node();
		Node temp = head;
		addedNode.data = data;
		addedNode.next = head;
		///head가 널이 아니면 추가된 노드를 last node로 설정한다. 
		if (head != null) {
			while (temp.next != head)
				temp = temp.next;
			temp.next = addedNode;
		}else{
			addedNode.next = addedNode;
		}
		/// 새로 추가된 노드를 head로 설정한다. 
		head = addedNode;
		return head;
	}

	static void printList(Node head){
		Node temp = head;
		if (head != null){
			do{
				System.out.print(temp.data+" ");
				temp = temp.next;
			}while(temp != head);
		}
	}
	
	public static void main(String[] args) {		  
		Scanner sc = new Scanner(System.in);
		
		int T = sc.nextInt();
		for (int i=0; i<T; i++){
			Node head = null;
			int N = sc.nextInt();
			for(int j = 0; j<N; j++){
				int curData = sc.nextInt();
				head = push(head, curData);
			}
			printList(head);
			System.out.println();
		}
	}
}
   ```



### 순환 싱글 리스트 - 삽입![CircularSinglyLinkedList](https://media.geeksforgeeks.org/wp-content/uploads/CircularSinglyLinkedList.png)

#### 구현 

- 리스트의 마지막 노드 `last`를 가리키는 외부 포인터를 하나 별도로 둔다.
- `last` 의 다음 노드는 `first` 노드를 가리킨다.

![CircularSinglyLinkedList1](https://media.geeksforgeeks.org/wp-content/uploads/CircularSinglyLinkedList1.png)

- start node 포인터보단 last node 포인터를 취급하면 삽입시에 전체 리스트를 탐색할 필요가 없다.
- 리스트의 처음 삽입 or 리스트의 끝 삽입 은 결국 리스트 길이만큼의 시간복잡도 차이가 난다.



#### 삽입 과정

- 노드는 네 가지 방식으로 삽입될 수 있다.
- 0) Insertion in an empty list
- 1) Insertion at the **beginning** of the list
- 2) Insertion at the **end** of the list
- 3) Insertion in **between** the nodes



##### 0) Insertion in an empty list

- 먼저 empty list에 삽입하는 경우, last 포인터는 null일 것이다.

- 노드 T를 삽입하고 나면, T는 last node가 된다. 또한, 노드 T는 동시에 first node가 된다.

```java
static Node addToEmpty(Node last, int data){
		if(last != null)
			return last;
		/// empty
		Node temp = new Node();
		temp.data = data;
		last = temp;
		/// 현재 last next도 last이다.
		last.next = last;
		return last;
	}
```





##### 1) Insertion at the **beginning** of the list 

- 리스트의 처음에 노드를 삽입하는 경우 다음의 스텝을 따른다

  - 노드 T를 생성한다.

  - T의 `next 노드 포인터` 를 last 노드의 `next 노드 포인터` 와 일치시킨다.

  - last의 `next 노드 포인터` 를 **T**로 설정한다.![CircularSinglyLinkedlist-4](https://media.geeksforgeeks.org/wp-content/uploads/CircularSinglyLinkedlist-4.png)

    ![CircularSinglLinkedList5](https://media.geeksforgeeks.org/wp-content/uploads/CircularSinglLinkedList5.png)

  ```java
  static Node addBegin(Node last, int data){
  		if (last == null)
  			return addToEmpty(last, data);
  		Node temp = new Node();
  		temp.data = data;
  		temp.next = last.next;
  		last.next = temp;
  		return last;
  }
  ```

  





##### 2) Insertion at the **end** of the list

- 리스트의 마지막에 노드를 삽입하는 경우 다음의 스텝을 따른다

  - 노드 T 생성

  - 노드 T의 `next 포인터` = last 의 `next 포인터`

  - last의 `next 포인터` = 노드 T

  - last = 노드 T

    ![CircularSinglyLinkedlist-6](https://media.geeksforgeeks.org/wp-content/uploads/CircularSinglyLinkedlist-6.png)

    

  ![CircularSinglyLinkedlist-7](https://media.geeksforgeeks.org/wp-content/uploads/CircularSinglyLinkedlist-7.png)

  ```java
  static Node addEnd(Node last, int data){
  		if (last == null)
  			return addToEmpty(last, data);
  		Node temp = new Node();
  		temp.data = data;
  		temp.next = last.next;
  		last.next = temp;
  		last = temp;
  		return last;
  }
  ```







##### 3) **Insertion in between the nodes**

- 노드를 리스트의 가운데에 넣는 것은 마지막 삽입의 유형과 비슷하다.

  - 노드 T를 생성
  - T가 놓일 노드의 직전 노드를 찾는다. (노드 P)
  - 노드 T의 next = P의 next
  - P의 next = 노드 T
  - 가령 12가 10 이전에 삽입되어야 한다면 

  ![circularll-1](https://media.geeksforgeeks.org/wp-content/uploads/circularll-1.png)

  ![CircularSinglyLinkedList9](https://media.geeksforgeeks.org/wp-content/uploads/CircularSinglyLinkedList9.png)

  ```java
  static Node addAfter(Node last, int data, int item){
  		if (last == null)
  			return null;
  		Node temp, p;
  		p = last.next;
  		do {
  			if (p.data == item){
  				temp = new Node();
  				temp.data = data;
  				temp.next = p.next;
  				p.next = temp;
  				
  				if (p==last)
  					last = temp;
  				return last;
  			}
  			p = p.next;
  		}while(p != last.next);
  		
  		return last;
  }
  ```







### 삭제 과정

- 리스트가 비어있는 경우

  - 단순히 리턴

- 비어있지 않은 경우

  - 리스트가 비어있지 않다면, 두 포인터 (**cur**rent, **prev**)를 정의합니다.
  - cur 포인터는 head node로 초기화 합니다.
  - 리스트를 순회하면서 삭제될 노드를 찾고, **cur 노드에 cur.next 노드를 할당하기 전에**, **prev 노드를 항상 cur 노드로 할당**합니다.
  - 만약 노드를 찾았다면, 노드가 리스트의 유일한 노드인지 체크합니다. 만약 유일한 노드라면 head를 null로 할당합니다. (free cur)
  - 만약 노드가 하나 이상이라면, 
    - 삭제할 노드(cur)가 리스트의 첫 노드인지 파악합니다.
      - 만약 첫 노드라면, prev노드를 last 노드로 옮깁니다. 
      - 그 다음에 **`head = head.next`**, **`prev.next = head`** 로 할당하며 `cur 노드를 삭제`합니다.
    - 삭제할 노드가 리스트의 마지막 노드라면, 먼저 역시 리스트의 유일한 노드인지 파악합니다. 
      - (cur.next == head로 체크)
      - 만약 삭제할 노드가 리스트의 마지막 노드라면, **`prev.next = head `** 하고 cur 노드를 삭제합니다.
    - 삭제 노드가 첫노드도, 마지막 노드도 아니라면, **`prev.next = temp.next `** 로 설정하고 cur 노드를 삭제합니다.

  ```java
  static Node delete(Node head, int key){
  		if (head == null){
  			return null;
  		}
  		Node cur = head;
  		Node prev = new Node();
  		while (cur.data != key){
  			if(cur.next == head){
  				System.out.println("not found in the list");
  				break;
  			}
  			prev = cur;
  			cur = cur.next;
  		}
  		/// only one node in the list, 
  		if (cur.next == head){
  			head = null;
  			return head;
  		}
  		
  		///삭제할 노드 (cur)가 head 노드라면, prev(last)와 head.next를 잇는다.
  		if (cur == head) { 
              prev.next = head;    
  		}else if ( cur.next == head){ ///삭제 노드가 last 노드라
  			prev.next = head;
  		}else{
  			prev.next = cur.next;
  		}
  		return cur;
  }
  ```

  

### 전체 코드 

```java

	static class Node {
		int data;
		Node next;
	}
	static Node addToEmpty(Node last, int data){
		if(last != null)
			return last;
		/// empty
		Node temp = new Node();
		temp.data = data;
		last = temp;
		/// 현재 last next도 last이다.
		last.next = last;
		return last;
	}
	static Node addBegin(Node last, int data){
		if (last == null)
			return addToEmpty(last, data);
		Node temp = new Node();
		temp.data = data;
		temp.next = last.next;
		last.next = temp;
		return last;
	}
	static Node addEnd(Node last, int data){
		if (last == null)
			return addToEmpty(last, data);
		Node temp = new Node();
		temp.data = data;
		temp.next = last.next;
		last.next = temp;
		last = temp;
		return last;
	}
	static Node addAfter(Node last, int data, int item){
		if (last == null)
			return null;
		Node temp, p;
		p = last.next;
		do {
			if (p.data == item){
				temp = new Node();
				temp.data = data;
				temp.next = p.next;
				p.next = temp;
				
				if (p==last)
					last = temp;
				return last;
			}
			p = p.next;
		}while(p != last.next);
		
		return last;
	}
	static void traverse(Node last) { 
	    Node p; 
	    // If list is empty, return. 
	    if (last == null)  { 
	        System.out.println("List is empty."); 
	        return; 
	    } 
	    // Pointing to first Node of the list. 
	    p = last.next; 
	  
	    // Traversing the list. 
	    do { 
	        System.out.print(p.data + " "); 
	        p = p.next; 
	    } 
	    while(p != last.next); 
	} 
	  
	// Driven code 
	public static void main(String[] args) 
	{ 
	    Node last = null; 
	  
	    last = addToEmpty(last, 6); 
	    last = addBegin(last, 4); 
	    last = addBegin(last, 2); 
	    last = addEnd(last, 8); 
	    last = addEnd(last, 12); 
	    last = addAfter(last, 10, 8); 
	  
	    traverse(last); 
	} 
```



### 삭제 샘플코드 

- 출처 : https://www.geeksforgeeks.org/deletion-circular-linked-list/

```java
package CircularLinkedList_single;
/*
Input : 2->5->7->8->10->(head node)
        data = 5 deleted
Output : 2->7->8->10->(head node)

Input : 2->5->7->8->10->(head node)
        data = 7 deleted
Output : 2->5->8->10->2(head node)


 */
public class Circular_SLL_Deletion {
	static class Node {
		int data;
		Node next;
	}
	
	/// 리스트의 맨 앞 위치에 삽입하는 방식 
	static Node push(Node start, int data){
		Node newNode = new Node();
		newNode.data = data;
		newNode.next = start;
		
		///if list is not empty, 현재의 마지막 노드를 갱신 
		if (start != null){
			Node temp = start;
			while(temp.next != start){
				temp = temp.next;
			}
			temp.next = newNode;
		}else {	// empty list
			newNode.next = newNode;
		}
		start = newNode;
		return start;
	}

	static void printList(Node head) { 
        Node temp = head; 
        if (head != null) { 
            do { 
                System.out.printf("%d ", temp.data); 
                temp = temp.next; 
            } while (temp != head); 
        } 
        System.out.printf("\n"); 
    } 
	
	static Node delete(Node head, int key){
		if (head == null){
			return null;
		}
		Node cur = head;
		Node prev = new Node();
		while (cur.data != key){
			if(cur.next == head){
				System.out.println("not found in the list");
				break;
			}
			prev = cur;
			cur = cur.next;
		}
		/// only one node in the list, 
		if (cur.next == head){
			head = null;
			return head;
		}
		
		///삭제할 노드 (cur)가 head 노드라면, prev(last)와 head.next를 잇는다.
		if (cur == head) { 
            prev.next = head;    
		}else if ( cur.next == head){ ///삭제 노드가 last 노드라
			prev.next = head;
		}else{
			prev.next = cur.next;
		}
		return cur;
	}
	public static void main(String args[]) { 
        /* Initialize lists as empty */
        Node head = null; 
  
        /* Created linked list will be 2.5.7.8.10 */
        head = push(head, 2); 
        head = push(head, 5); 
        head = push(head, 7); 
        head = push(head, 8); 
        head = push(head, 10); 
  
        System.out.printf("List Before Deletion: "); 
        printList(head); 
  
        delete(head, 7); 
  
        System.out.printf("List After Deletion: "); 
        printList(head); 
    } 
}
```

