

# 알고리즘 정리

1) 링크드 리스트

- 싱글
- 더블
- **circular**
  - **single**
  - double

# 순환 링크드 리스트 - double

https://www.geeksforgeeks.org/doubly-circular-linked-list-set-1-introduction-and-insertion/



- 노드의 구조는 2중 링크드 리스트와 같다.

  ```java
  class Node{
  		int data;
  		Node next;
  		Node prev;
  }
  ```

  



![Circular-doubly-linked-list](http://cdncontribute.geeksforgeeks.org/wp-content/uploads/Circular-doubly-linked-list.png)



#### **Insertion in Circular Doubly Linked List**

##### **1) Insertion at the end of list or in an empty list**  

- 리스트가 비었을때 (start == null) 

  - 노드 N(data = 5)가 삽입될 때, N의 직전 노드포인터 `prev` 는 N이고,  N의 다음 노드포인터 `next` 는 N이 되어야 한다.

    ![Insertion-in-empty-list1](http://cdncontribute.geeksforgeeks.org/wp-content/uploads/Insertion-in-empty-list1.png)

- 리스트가 몇개의 노드를 포함한 상황일 때

  - 새로 추가될 노드 M (data = 7)은 현재의 last node 다음에 위치하게 된다. 

  - 노드 M의 prev = last node

  - 노드 M의 next = start node

  - 기존의 last node's next = 노드 M

    기존의 start node's prev = 노드 M

    ![Insertion-in-a-list](http://cdncontribute.geeksforgeeks.org/wp-content/uploads/Insertion-in-a-list.png)

    ```java
    static Node addLast(Node start, int data){
    		if (start == null){
    			Node newNode = new Node();
    			newNode.data = data;
    			newNode.next = newNode.prev = newNode;
    			start = newNode;
    			return start;
    		}
    		//if not empty
    		Node last = start.prev;
    		Node newNode = new Node();
    		newNode.data = data;
    		newNode.next = start;
    		start.prev = newNode;
    		newNode.prev = last;
    		last.next = newNode;
    		return start;
    }
    ```

    

##### **2) Insertion at the beginning of list **  

- 리스트의 맨 앞에 노드 T를 삽입한다면, T의 다음 포인터는 list의 기존 first node가 된다. 

- 마찬가지로 T의 이전 포인터는 기존 last node가 된다.

- 기존의 last node의 next와 first node의 prev는 노드 T로 업데이트 한다.

- **Start 노드를 가장 최근에 추가한 T노드로 변경한다.**

- ![Insertion-at-beginning-of-list](http://cdncontribute.geeksforgeeks.org/wp-content/uploads/Insertion-at-beginning-of-list.png)

  ```swift
  static Node addBegin(Node start, int data){
  		if (start == null){
  			Node newNode = new Node();
  			newNode.data = data;
  			newNode.next = newNode.prev = newNode;
  			start = newNode;
  			return start;
  		}
  		Node last = start.prev;
  		Node newNode = new Node();
  		newNode.data = data;
  		newNode.next = start;	/// 새로 추가된 start노드의 다음노드
  		newNode.prev = last;	///	"" 이전 노드 
  		start.prev = newNode;	///각 노드의 연결고리 업데이트 
  		last.next = newNode;
  		///스타트 포인터 업데이트 
  		start = newNode;
  		return newNode;
  }
  ```



##### **3) Insertion in between the nodes of the list**

![Insertion-in-between-the-list](http://cdncontribute.geeksforgeeks.org/wp-content/uploads/Insertion-in-between-the-list.png)

- 리스트 노드 사이에 노드 삽입하는 경우, 노드가 삽입될 자리의 다음 노드와 새로 삽입할 노드, 2개 노드의 정보가 필요.

  ```java
  ///value1은 새로 삽입할 노드 데이터이고, value2는 새 노드가 삽입할 직전노드의 데이터이다.
  static Node insertAfter(Node start, int value1, int value2){
  		Node newNode = new Node();
  		newNode.data = value1;
  		
  		Node temp = start;
  		while(temp.data != value2){
  			temp = temp.next;
  		}
  		Node next = temp.next;
  		
  		///노드를 사이에 삽입한다.
  		temp.next = newNode;
  		newNode.prev = temp;
  		newNode.next = next;
  		next.prev = newNode;
  		return newNode;
  }
  ```





### Example Code

```java
public class CirculrDLL {

	static class Node{
		int data;
		Node next;
		Node prev;
	}
	
	static Node addLast(Node start, int data){
		if (start == null){
			Node newNode = new Node();
			newNode.data = data;
			newNode.next = newNode.prev = newNode;
			start = newNode;
			return start;
		}
		//if not empty
		Node last = start.prev;
		Node newNode = new Node();
		newNode.data = data;
		newNode.next = start;
		start.prev = newNode;
		newNode.prev = last;
		last.next = newNode;
		return start;
	}
	
	static Node addBegin(Node start, int data){
		if (start == null){
			Node newNode = new Node();
			newNode.data = data;
			newNode.next = newNode.prev = newNode;
			start = newNode;
			return start;
		}
		Node last = start.prev;
		Node newNode = new Node();
		newNode.data = data;
		newNode.next = start;	/// 새로 추가된 start노드의 다음노드
		newNode.prev = last;	///	"" 이전 노드 
		start.prev = newNode;	///각 노드의 연결고리 업데이트 
		last.next = newNode;
		///스타트 포인터 업데이트 
		start = newNode;
		return newNode;
	}
	
	///value1은 새로 삽입할 노드 데이터이고, value2는 새 노드가 삽입할 직전노드의 데이터이다.
	static Node insertAfter(Node start, int value1, int value2){
		Node newNode = new Node();
		newNode.data = value1;
		
		Node temp = start;
		while(temp.data != value2){
			temp = temp.next;
		}
		Node next = temp.next;
		
		///노드를 사이에 삽입한다.
		temp.next = newNode;
		newNode.prev = temp;
		newNode.next = next;
		next.prev = newNode;
		return newNode;
	}
	
	static void display(Node start){
		Node temp = start;
		System.out.println("Traversal in forward direction");
		while(temp.next != start){
			System.out.print(temp.data+" ");
			temp = temp.next;
		}
		System.out.println(temp.data);
		
		System.out.println("Traversal in reverse direction");
		Node last = start.prev;
		temp = last;
		while(temp.prev != last){
			System.out.print(temp.data+" ,");
			temp = temp.prev;
		}
		System.out.println(temp.data);
	}
	
	public static void main(String[] args) {

		Node start = null;
    // Insert 5. So linked list becomes 5->NULL 
    start = addLast(start, 5);

    // Insert 4 at the beginning. So linked  
    // list becomes 4->5 
		start = addBegin(start, 4);

    // Insert 7 at the end. So linked list 
    // becomes 4->5->7 
		start = addLast(start, 7);

    // Insert 8 at the end. So linked list  
    // becomes 4->5->7->8 
		addLast(start, 8);

		insertAfter(start, 6, 5);

		display(start);

	}
}
```





### cf. 특정 인덱스 위치에 삽입하는 경우

```java
public class CirculrDLL {
  // Function to count nunmber of
	// elements in the list
	static int countList(Node start) {
		// Decalre temp pointer to
		// traverse the list
		Node temp = start;

		// Variable to store the count
		int count = 0;

		// Iterate the list and
		// increment the count
		while (temp.next != start) {
			temp = temp.next;
			count++;
		}

		// As the list is circular, increment
		// the counter at last
		count++;

		return count;
	}

	// Function to insert a node at
	// a given position in the
	// circular doubly linked list
	static Node insertAtLocation(Node start, int data, int loc) {
		// Declare two pointers
		Node temp, newNode;
		int i, count;

		// Create a new node in memory
		newNode = new Node();

		// Point temp to start
		temp = start;

		// count of total elements in the list
		count = countList(start);

		// If list is empty or the position is
		// not valid, return false
		if (temp == null || count < loc)
			return start;

		else {
			// Assign the data
			newNode.data = data;

			// Iterate till the loc
			for (i = 1; i < loc - 1; i++) {
				temp = temp.next;
			}

			// See in Image, circle 1
			newNode.next = temp.next;

			// See in Image, Circle 2
			(temp.next).prev = newNode;

			// See in Image, Circle 3
			temp.next = newNode;

			// See in Image, Circle 4
			newNode.prev = temp;

			return start;
		}
	}
	
	// Function to create circular doubly   
	// linked list from array elements  
	static Node createList(int arr[], int n, Node start)  
	{  
	    // Declare newNode and temporary pointer  
		Node newNode, temp;  
	    int i;  
	  
	    // Iterate the loop until array length  
	    for (i = 0; i < n; i++) {  
	        // Create new node  
	        newNode = new Node();  
	  
	        // Assign the array data  
	        newNode.data = arr[i];  
	  
	        // If it is first element  
	        // Put that node prev and next as start  
	        // as it is circular  
	        if (i == 0) {  
	            start = newNode;  
	            newNode.prev = start;  
	            newNode.next = start;  
	        } else {  
	            // Find the last node  
	            temp = (start).prev;  
	  
	            // Add the last node to make them  
	            // in circular fashion  
	            temp.next = newNode;  
	            newNode.next = start;  
	            newNode.prev = temp;  
	            temp = start;  
	            temp.prev = newNode;  
	        }  
	    }  
	    return start; 
	}  

	static void display(Node start) {
		Node temp = start;
		System.out.println("Traversal in forward direction");
		while (temp.next != start) {
			System.out.print(temp.data + " ");
			temp = temp.next;
		}
		System.out.println(temp.data);

		System.out.println("Traversal in reverse direction");
		Node last = start.prev;
		temp = last;
		while (temp.prev != last) {
			System.out.print(temp.data + " ,");
			temp = temp.prev;
		}
		System.out.println(temp.data);
	}
	// Function to display the list  
	static void displayList( Node temp) {  
		Node t = temp;  
	    if (temp == null)  
	        return ;  
	    else {  
	        System.out.println( "The list is: ");  
	        while (temp.next != t) {  
	            System.out.print( temp.data + " ");  
	            temp = temp.next;  
	        }  
	        System.out.println( temp.data );  
	        return ;  
	    }  
	} 

	// Driver Code  
	public static void main(String args[]) {  
	    // Array elements to create  
	    // circular doubly linked list  
	    int arr[] = { 1, 2, 3, 4, 5, 6 };  
	    int n = arr.length;  
	  
	    // Start Pointer  
	    Node start = null;  
	  
	    // Create the List  
	    start = createList(arr, n, start);  
	  
	    // Display the list before insertion  
	    displayList(start);  
	  
	    // Inserting 8 at 3rd position  
	    start = insertAtLocation(start, 8, 3);  
	  
	    // Display the list after insertion  
	    displayList(start);  
	}  
}
```

