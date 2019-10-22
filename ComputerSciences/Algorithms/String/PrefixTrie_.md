# 알고리즘 (2) Trie

##### Advantages of Trie Data Structure

https://www.geeksforgeeks.org/advantages-trie-data-structure/



- 문자열을 담는 자료구조 
- 자식노드의 개수는 일반적으로 알파벳 크기와 같다(배열을 쓸 경우), 해시자료구조를 쓰는 경우는 다름
- 검색, 삽입, 삭제 연산에 O(L) 시간이 소요된다. **L**은 검색단어(word)인 key의 길이

### 해싱 

- 해싱으로 인해 검색/삽입/삭제 연산의 평균 시간복잡도 O(L)의 연산을 보장한다.
- 키를 작은 값으로 변환시키고, 그 값은 인덱스 데이터로 사용된다.

### self Balancing BST

- 자기 균형적인 BST(레드블랙트리, AVL 트리, Splay 트리 등) 검색/삽입/삭제 연산의 시간복잡도는 O(L log n) 이다. ( n은 총 단어의 갯수, L은 단어의 길이)
- 자기 균형 BST의 장점은 최소, 최대, 가장 가까운(floor 또는 ceiling) 및 k 번째로 큰 작업을 더 빠르게 수행하는 순서를 유지한다는 것이다.



### **Why Trie?**

1. 트라이를 사용하면 문자열 검색과 삽입에 O(L) 시간을 소요하며 이는 일반적으로 BST보다 명백하게 빠르다. 구현 방법으로 인해 일반적인 해싱보다도 빠르다. 왜냐하면 다른 해시함수를 필요로하지 않기 때문이다. 다른 충돌 기법 ( [open addressing](https://www.geeksforgeeks.org/hashing-set-3-open-addressing/) 이나 [separate chaining](https://www.geeksforgeeks.org/hashing-set-2-separate-chaining/))이 요구되지도 않는다.
2. Another advantage of Trie is, we can [easily print all words in alphabetical order ](https://www.geeksforgeeks.org/sorting-array-strings-words-using-trie/)which is not easily possible with hashing.
3. We can efficiently do[ prefix search (or auto-complete) with Trie](https://www.geeksforgeeks.org/auto-complete-feature-using-trie/).



### **Issues with Trie **

- 문자열을 담는데 많은 메모리가 소요된다는 점이 단점이다.
- 각각의 노드를 위해 많은 노드 포인터들(알파벳의 캐릭터 수와 동일하거나 더 많은)을 필요로 한다.
- 만약 공간제약이 신경쓰이는 경우라면, **Ternary Search Tree**가 사전 구현에 있어서 더 선호될 수 있다.  **Ternary Search Tree** 의 검색 연산은 O(h)이며, (h는 트리의 높이) 터너리 탐색 트리는 트라이에서 지원하는 prefix 검색, 알파벳 순서 프린트, 가장 가까운 이웃 탐색 등을 지원한다.

The final conclusion is regarding *tries data structure* is that they are faster but require *huge memory* for storing the strings.



##### 참고자료 - Overview of Data Structures | Set 3 (Graph, Trie, Segment Tree and Suffix Tree)

https://www.geeksforgeeks.org/overview-of-data-structures-set-3-graph-trie-segment-tree-and-suffix-tree/

##### **참고자료 - Advantages of BST over Hash Table**

https://www.geeksforgeeks.org/advantages-of-bst-over-hash-table/

```java
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

//https://www.programcreek.com/2014/05/leetcode-implement-trie-prefix-tree-java/

class TrieNode{
	char c;
	HashMap<Character, TrieNode> children = new HashMap<Character, TrieNode>();
	boolean isLeaf;
	public TrieNode(){}
	public TrieNode(char c){
		this.c = c;
	}
}
public class PrefixTreeTrie {
	static private TrieNode root;
	public PrefixTreeTrie(){
		root = new TrieNode();
	}
	//insert 
	public static void insert(String word){
		HashMap<Character, TrieNode> children = root.children;
		for (int i=0; i<word.length(); i++){
			char c = word.charAt(i);
			
			TrieNode t;
			if (children.containsKey(c)){
				t = children.get(c);
			}else {
				t = new TrieNode(c);
				children.put(c, t);
			}
			children = t.children;
			//set if leaf node
			if (i == word.length()-1){
				t.isLeaf = true;
			}
		}
	}
	//search by prefix String
	public static boolean startsWith(String prefix){
		if (searchNode(prefix) == null){
			return false;
		}
		return true;
	}
	
	public static boolean search(String word){
		TrieNode t = searchNode(word);
		if (t != null && t.isLeaf){
			return true;
		}else {
			return false;
		}
	}
	
	public static TrieNode searchNode(String word){
		Map<Character, TrieNode> children = root.children;
		TrieNode t = null;
		for (int i=0; i<word.length(); i++){
			char c = word.charAt(i);
			if(children.containsKey(c)){	///자식 노드를 계속 찾아감
				t = children.get(c);
				children = t.children;
			}else {
				return null;
			}
		}
		return t;
	}
	///삭제 
	/*
	 * 1. 키가 트라이에 없는 경우 
	 * 	- 트라이를 변경하지 않는다.
	 * 2. 키가 트라이의 유일한 키인 경우
	 *   (키들이 다른 키의 prefix가 아니고, 다른 키의 prefix를 포함하지 않는 경우) 
	 *  - 모든 노드를 삭제한다.
	 * 3. 키가 다른 긴 키의 prefix 키인 경우.
	 *  - leaf node 여부만 해제한다.
	 * 4. 하나 이상의 키를 prefix key로 포함하는 키를 지우는 경우
	 *  - 다음으로 긴 prefix key를 만날 때 까지 키의 끝에서부터 삭제한다.
	 * 
	 * 
	 * 
	 * */
	public static boolean isEmpty(TrieNode root){
		Iterator<Character> it = root.children.keySet().iterator();
		while(it.hasNext()){
			char nextChar = it.next();
			if (root.children.containsKey(nextChar)){
				return false;
			}
		}
		return true;
	}
	// https://www.geeksforgeeks.org/trie-delete/
	public static TrieNode remove(TrieNode root, String key, int depth){
		if (root == null)	// tree is empty
			return null;
		// If last character of key is being processed 
		if (depth == key.length()) {
			
			// 주어진 키를 지우고 나면 해당 노드는 더이상 word의 끝이 아니게 된다.
			if (root.isLeaf){
				root.isLeaf = false;
			}
			///만약 해당 노드가 더이상 다른 노드의 prefix가 아니라면 
			if(isEmpty(root)){
				root = null;
			}
			return root;
		}
		/// 만약 키의 마지막 char가 아니라면, 재귀함수로 자식노드를 탐색한다.
		char nextChar = key.charAt(depth);
		TrieNode removal = remove(root.children.get(nextChar), key, depth+1);
		/// 재귀호출의 결과값인 자식노드의 상태가 null이면 children 맵에서 자식캐릭터를 제거
		/// 아니면 변경된 값으로 갱신
		if (removal == null){
			root.children.remove(nextChar);
		}else{
			root.children.put(nextChar, removal);
		}
		// 만약 루트가 다른 자식을 갖고 있지 않다면, (유일한 자식이 곧 지워질 것이라면), 
		// 그리고 해당 루가 다른 단어의 끝이 아니라면 해당 루트를 지워준다.
		if (isEmpty(root) && root.isLeaf == false){
			root = null;
		}
		return root;
	}
	
	public static void main(String[] args) {
		String keys[] = {"the", "a", "there", "answer", "any", 
                "by", "bye", "their"}; 
        String output[] = {"Not present in trie", "Present in trie"}; 
        root = new TrieNode();
        int i;
        for (i = 0; i < keys.length ; i++) 
            insert(keys[i]); 
//        if(search("the") == true) 
//            System.out.println("the --- " + output[1]); 
//        else System.out.println("the --- " + output[0]); 
//          
//        if(search("these") == true) 
//            System.out.println("these --- " + output[1]); 
//        else System.out.println("these --- " + output[0]); 
//          
//        if(search("their") == true) 
//            System.out.println("their --- " + output[1]); 
//        else System.out.println("their --- " + output[0]); 
//          
//        if(search("thaw") == true) 
//            System.out.println("thaw --- " + output[1]); 
//        else System.out.println("thaw --- " + output[0]); 
        
        System.out.println("remove : their");
        remove(root, "their", 0);
        if(search("their") == true) 
            System.out.println("their --- " + output[1]); 
        else System.out.println("their --- " + output[0]); 
        
	}

}

```

