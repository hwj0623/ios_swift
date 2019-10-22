# 알고리즘  Bipartite Matching

- A 집단이 B 집단을 선택하는 방법에 대한 알고리즘
  - <u>가장 효과적으로 매칭</u>시켜 줄 수 있는 경우를 찾는 것.
    - **최대 매칭을 의미** 
  - 최대 유량 문제와 동일하게 풀 수 있음
- 다만 최대 유량 문제와 달리 DFS 로 더 편하게 풀 수 있다. 
  - 시간 복잡도가 Edmond-karp 최대유량 알고리즘인 O(V*E^2) 보다 빠르다.



참고 : [안경잡이 개발자 블로그](https://blog.naver.com/PostView.nhn?blogId=ndb796&logNo=221240613074&parentCategoryNo=&categoryNo=128&viewDate=&isShowPopularPosts=false&from=postList)



```java

import java.util.*;

//시간복잡도 : O(V*E)
//- dfs를 정점의 개수만큼 수행, 각 정점별로 최대 간선의 개수만큼만 수행
public class BipartiteMatching {
	//정점의 최대 개수 
	static int MAX = 101;
	//간선정보 
	static ArrayList<Integer> edges[] = new ArrayList[MAX];
	//특정 정점을 점유하는 노드의 정보 
	static int d[] = new int[MAX];
	//특정 정점을 이미 처리했는지 여부를 저장.
	static boolean check[] = new boolean[MAX];
	static int N = 3;
	
	public static void main(String[] args) {
		for(int i=0; i<edges.length; i++) {
			edges[i] = new ArrayList<Integer>();
		}
		edges[1].add(1);
		edges[1].add(2);
		edges[1].add(3);
		edges[2].add(1);
		edges[3].add(2);
		int count = 0;
		//매번 매칭을 시도할 때마다 check 배열을 초기화 한다.
		for(int i=1; i<=N; i++) {
			Arrays.fill(check, false);
			if(dfs(i)) count++;
		}
		System.out.println(count+"개의 매칭이 이뤄짐 ");
		for(int i=1; i<=100; i++) {
			if(d[i] != 0 ) {
				System.out.println(d[i]+"->"+i);
			}
		}
	}
	
	//매칭 성공시 true, 실패시 false 를 리턴하는 함수
	static boolean dfs(int x) {
		//특정 정점 x와 연결된 모든 노드에 대해서 진입가능한지 시도 
		for(int i=0; i<edges[x].size(); i++) {
			int t = edges[x].get(i);
			//이미 처리한 노드는 더 이상 볼 필요없다. 
			if(check[t]) 
				continue;
			check[t] = true; //점유(처리)
			//현재 점유하려는 대상이 누군가에게 점유되어있지 않거나, 
			//점유 중이라면, 점유중인 노드가 다른 노드를 택할 수 있는지 체크   
			if(d[t] == 0 || dfs(d[t])) {
				//매칭 가능
				d[t] = x;
				return true;
			}
		}
		return false;
	}
}
```



예제 - 2188 축사 



```java
/*
입력
5 5
2 2 5
3 2 3 4
2 1 5
3 1 2 5
1 2
결과
4
*/
import java.util.*;

public class BOJ_2188 {
	static ArrayList<Integer> edges[] ;
	static boolean check[];
	static int own[];
	public static void main(String[] args) {
		Scanner sc = new Scanner(System.in);
		int N = sc.nextInt();
		int M = sc.nextInt();
		edges = new ArrayList[N+1];
		own = new int[M+1]; 		//M개의 축사에 대해 점유중인 대상을 저장 
		check = new boolean[M+1];	//M개의 축사의 방문여부 체크 
		Arrays.fill(own, -1);
		for(int i=0; i<edges.length; i++) {
			edges[i] = new ArrayList<>();
		}
		
		//간선 초기화 
		for(int v=1; v<=N; v++) {
			int numberOfHouse = sc.nextInt();
			for(int j=0; j<numberOfHouse; j++) {
				int dest = sc.nextInt();
				edges[v].add(dest);
				
			}
		}
		
		int count = 0;
		//이분매칭
		for(int i=1; i <= N; i++) {
			Arrays.fill(check, false);
			if(dfs(i)) {
				count++;
			}
		}
		System.out.println(count);
	}

	static boolean dfs(int x) {
		for(int i=0; i<edges[x].size(); i++) {
			int t = edges[x].get(i);
			if(check[t]) continue;
			check[t] = true;
			if(own[t] == -1 || dfs(own[t])) {
				own[t] = x;
				return true;
			}
		}
		return false;
	}
}
```

