# 알고리즘 KMP

- 접두사와 접미사 개념을 활용
- 반복되는 연산을 얼마나 줄일 수 있을지 판별하여 매칭할 문자열을 빠르게 점프하는 기법

- 매칭 실패시 얼마나 JUMP할지에 대한 실패 함수를 구현한다.

예시

`abacaaba` 라는 문자열에 대해

접두사 |  | 접미사

`abc` |ca|`aba`



- #### 접두사와 접미사가 일치하는 최대 길이를 찾는다.

| 길이 | 문자열           | 최대 일치 길이 |
| ---- | ---------------- | -------------- |
| 1    | a                | 0              |
| 2    | ab               | 0              |
| 3    | **a**b**a**      | 1              |
| 4    | abac             | 0              |
| 5    | **a**bac**a**    | 1              |
| 6    | **a**baca**a**   | 1              |
| 7    | **ab**aca**ab**  | 2              |
| 8    | **aba**ca**aba** | 3              |

- 접두사와 접미사가 <u>일치하는 경우에 한해서는 JUMP를 수행할 수</u> 있다. 
- 접두사와 접미사의 **<u>최대 일치 길이</u>**는 다음과 같이 구한다.



##### 찾을 문자열 `abacaaba`의 길이가 N = 8이라 할 때, 다음과 같이 pattern에 대해 접두|접미사 테이블을 만든다. 

- 1) 최대 길이를 저장할 d[N] 배열과 j와 i라는 index를 사용한다. j는 0번, i는 j+1인 1번 인덱스부터 시작 (j=0, i=1)
- 2) j와 i의 문자가 서로 일치하지 않으면 i++, d[i] = 0 이다. (j=0, i=2)
- 3) i=2에서 **서로 일치하면** **d[2] = 1. i와 j를 각각 1씩 증가**시킨다. (j=1, i =3)

- 4) 만약 j != i 라면 (j=1, i=3 에서)
  - ( j > 0 인 상황에서 ) **인덱스 j 를 d[j-1] 의 값으로 이동**시킨다. (j=0)
  - d[i] = d[3] = 0 이다.
  - i를 1증가 (i=4)
- 5) j=0, i=4 에서 문자를 비교한다. 일치하므로 d[4] = 1이다.
  - i++, j++ ==> (j=1, i = 5)
- 6) j=1, i = 5에서 문자 비교시 **b!=a 불일치.** **인덱스 j를 d[j-1] 의 값으로 이동**
  - a == a 가 되어 d[5] = 1
  - i++, j++ (j=1, i=6)
- 7) j=1, i=6 비교하면  b==b 이므로 d[6] = **j+1** = 2이 된다.
  - i++, j++ (j=2, i = 7)
- 8) j=2, i=7 비교시 a == a 이므로 d[7] = j+1 = 3 이 된다.
  - i가 문자열의 끝에 도달했으므로 테이블 d를 반환 



### Pattern의 Table 생성 함수 

```java
static int[] makeTable(String pattern) {
		int arr[] = new int[pattern.length()];
		int patternSize = pattern.length();
		int j = 0;
		int i = 1;
		for( i=1; i<patternSize; i++) {
			//j가 0보다 클때, 두 인덱스 문자가 일치하지 않으면 
			//j-1의 테이블 값으로 j 인덱스를 이동 
			while(j > 0 && pattern.charAt(i) != pattern.charAt(j)) {
				j= arr[j-1];
			}
			if (pattern.charAt(i)== pattern.charAt(j)) {
				arr[i] = ++j;
			}
		}
		return arr;
}
```



### KMP search 함수 

- 위 테이블 생성 식과 유사
- 부모의 i번째 문자와 pattern의 j번째 문자를 비교하여 
  - 불일치하면 j = table[j-1]로 이동	
  - 일치하면 j= pattern.length()-1 인지 체크
    - j=pattern.length()-1 이라면 j=table[j] 로 이동하여 다음 매칭 탐색 
    - j<pattern.length()-1 이라면 j++ 후 다음 Loop 탐색 

```java
//table 만드는 로직과 유사 
static void search(String parent, String pattern) {
		int table[] = makeTable(pattern);
		for(int i=0; i<table.length; i++) {
			System.out.print(table[i]+" ");
		}
		System.out.println();
		
		int parentSize = parent.length();
		int patternSize = pattern.length();
		int j=0;
		for(int i=0; i< parentSize; i++) {
			//pattern과 i부터의 본문의 문자 비교하여 불일치 하는 경우,
			//불일치한 위치-1의 table 값은 1. 즉 맨 0번, 1번 인덱스 까지는 일치했음을 알 수 있다.
			//그러면 pattern의 인덱스는 0부터가 아니라 j=1부터 다시 비교하게 된다.
			while(j > 0 && parent.charAt(i) != pattern.charAt(j)) {
//				System.out.println(i+", "+j+" 는 불일치 ");
				j = table[j-1];
			}
			//만약 같다면 , 
			if(parent.charAt(i)== pattern.charAt(j)) {
				//패턴 길이만큼 탐색하는 경우 
				 if(j == patternSize-1) {
					 System.out.println((i-patternSize+2)+"번째에서 found");
					 j = table[j];
				 }else { //전체 탐색이 아니면 j를 1증가시켜서 다음 인덱스끼리 탐색
					 j++;
				 }
			}
		}
}
```





### 전체 코드

```java
public class KMP {
//	static int table[] = new int[8];
	
	static int[] makeTable(String pattern) {
		int arr[] = new int[pattern.length()];
		int patternSize = pattern.length();
		int j = 0;
		int i = 1;
		for( i=1; i<patternSize; i++) {
			//j가 0보다 클때, 두 인덱스 문자가 일치하지 않으면 
			//j-1의 테이블 값으로 j 인덱스를 이동 
			while(j > 0 && pattern.charAt(i) != pattern.charAt(j)) {
				j= arr[j-1];
			}
			if (pattern.charAt(i)== pattern.charAt(j)) {
				arr[i] = ++j;
			}
		}
		return arr;
	}
	
	//table 만드는 로직과 유사 
	static void search(String parent, String pattern) {
		int table[] = makeTable(pattern);
		for(int i=0; i<table.length; i++) {
			System.out.print(table[i]+" ");
		}
		System.out.println();
		
		int parentSize = parent.length();
		int patternSize = pattern.length();
		int j=0;
		for(int i=0; i< parentSize; i++) {
			//pattern과 i부터의 본문의 문자 비교하여 불일치 하는 경우,
			//불일치한 위치-1의 table 값은 1. 즉 맨 0번, 1번 인덱스 까지는 일치했음을 알 수 있다.
			//그러면 pattern의 인덱스는 0부터가 아니라 j=1부터 다시 비교하게 된다.
			while(j > 0 && parent.charAt(i) != pattern.charAt(j)) {
//				System.out.println(i+", "+j+" 는 불일치 ");
				j = table[j-1];
			}
			//만약 같다면 , 
			if(parent.charAt(i)== pattern.charAt(j)) {
				//패턴 길이만큼 탐색하는 경우 
				 if(j == patternSize-1) {
					 System.out.println((i-patternSize+2)+"번째에서 found");
					 j = table[j];
				 }else { //전체 탐색이 아니면 j를 1증가시켜서 다음 인덱스끼리 탐색
					 j++;
				 }
			}
		}
	}

	public static void main(String[] args) {
		String parent = "ababacabacaabacaaba";
		String pattern = "abacaaba";
		int temp[] = makeTable(pattern);
		search(parent, pattern);
	}
}
```

