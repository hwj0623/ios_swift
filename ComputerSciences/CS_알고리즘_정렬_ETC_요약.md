# 자료구조

### 정렬방식 비교정리 

![이미지](https://gmlwjd9405.github.io/images/algorithm-shell-sort/sort-time-complexity.png)

- ### 삽입 (insertion sort)

  - 자료 배열의 모든 요소를 앞에서부터 차례대로 이미 정렬된 배열 부분과 비교,  자신의 위치를 찾아 삽입함으로써 정렬을 완성

    ```java
    void insertionSort(int[] arr){
       for(int index = 1 ; index < arr.length ; index++){	//두 번째 원소부터 시작
          int temp = arr[index];								//temp = n번째 원소의 요소
          int aux = index - 1;									//n번째 요소의 직전 인덱스부터 0번 인덱스까지 비교
    			// 보조인덱스가 0보다 크고, 
          // 보조인덱스의 요소가 비교하고자하는 temp의 값보다 크다면 둘을 비교요소를 뒤로 옮긴다.
          while( (aux >= 0) && ( arr[aux] > temp ) ) {		
             arr[aux+1] = arr[aux];
             aux--;
          }
          arr[aux + 1] = temp;
       }
    }
    ```

  - 시간복잡도 : ![O(n^{2})](https://wikimedia.org/api/rest_v1/media/math/render/svg/6cd9594a16cb898b8f2a2dff9227a385ec183392)

    - ![n](https://wikimedia.org/api/rest_v1/media/math/render/svg/a601995d55609f2d9f5e233e36fbe9ea26011b3b)개의 데이터가 있을 때, 최악의 경우는 ![{\displaystyle \sum _{i=1}^{n-1}{i}=1+2+3+4+\cdots +(n-1)={\frac {n(n-1)}{2}}}](https://wikimedia.org/api/rest_v1/media/math/render/svg/6fd040d16ddcc273c6928e0e06485727f2c3c2cf)번의 비교를 하게 되므로.

  - 안정 정렬(stable)

  - in-place (변수 하나정도외 별도 메모리 공간 필요 x)

    <img src="https://upload.wikimedia.org/wikipedia/commons/e/ea/Insertion_sort_001.PNG" width="300px">

- ### 버블

  -  두 인접한 원소를 검사하여 정렬

  - in-place 정렬

  - 시간복잡도 : ![O(n^{2})](https://wikimedia.org/api/rest_v1/media/math/render/svg/6cd9594a16cb898b8f2a2dff9227a385ec183392)

  - ```java
    void bubbleSort(int[] arr) {
        int temp = 0;
    	for(int i = 0; i < arr.length; i++) {
    		for(int j= 1 ; j < arr.length-i; j++) {
    			if(arr[j]<arr[j-1]) {
    				temp = arr[j-1];
    				arr[j-1] = arr[j];
    				arr[j] = temp;
    			}
    		}
    	}
    	System.out.println(Arrays.toString(arr));
    }
    ```

----



- ### 선택정렬

  - 1) 주어진 리스트 중에 최소값을 찾아서

  - 2) 그 값을 맨 앞에 위치한 값과 교체한다(pass)

  - 3) 맨 처음 위치를 뺀 나머지 리스트를 같은 방법으로 교체한다.

    ```java
    void selectionSort(int[] list) {
        int indexMin, temp;
        for (int i = 0; i < list.length - 1; i++) {
            indexMin = i;
            for (int j = i + 1; j < list.length; j++) {
                if (list[j] < list[indexMin]) {
                    indexMin = j;
                }
            }
            temp = list[indexMin];
            list[indexMin] = list[i];
            list[i] = temp;
        }
    }
    ```

    

  - **in-place** 알고리즘

  - 알고리즘이 단순하며 사용할 수 있는 메모리가 제한적인 경우에 사용시 성능 상의 이점

    - 선택 정렬은 **버블 정렬보다 항상 우수**
    - 삽입 정렬(insertion sort) : 삽입 정렬은 k번째 반복 이후, 첫번째 k 요소가 정렬된 순서로 온다는 점에서 유사합니다. 하지만 **선택 정렬**은 **k+1 번째 요소를 찾기 위해 나머지 모든 요소들을 탐색**하지만 **삽입 정렬은 k+1 번째 요소를 배치하는 데 필요한 만큼의 요소만 탐색**하기 때문에 **삽입 정렬이 훨씬 효율적으로 실행**된다는 차이가 있음
    - 합병 정렬(merge sort) : **선택 정렬**은 합병 정렬과 같은 **분할 정복 알고리즘을 사용**하지만 **일반적으로 큰 배열보다 작은 배열(요소 10~20개 미만)에서 더 빠릅니다**

  - **시간복잡도** : ![O(n^{2})](https://wikimedia.org/api/rest_v1/media/math/render/svg/6cd9594a16cb898b8f2a2dff9227a385ec183392) /  공간복잡도 : O(1)

    | 패스 |        테이블         | 최솟값 |
    | :--: | :-------------------: | :----: |
    |  0   | [**9,1,6,8,4,3,2,0**] |   0    |
    |  1   | [0,**1,6,8,4,3,2,9**] |   1    |
    |  2   | [0,1,**6,8,4,3,2,9**] |   2    |
    |  3   | [0,1,2,**8,4,3,6,9**] |   3    |
    |  4   | [0,1,2,3,**4,8,6,9**] |   4    |
    |  5   | [0,1,2,3,4,**8,6,9**] |   6    |
    |  6   | [0,1,2,3,4,6,**8,9**] |   8    |

  

- ### 쉘

  - 삽입 정렬의 성질을 이용하여 보완한 삽입정렬의 일반화 알고리즘

    - [삽입정렬의 성질 1] : 입력되는 초기리스트가 "*거의 정렬* "되어 있는 경우 효율적
    - [삽입정렬의 성질 2] : 삽입 정렬은 한 번에 한 요소의 위치만 결정되기 때문에 비효율적

  - #### [ 작동 방식 ]

    - 1) 주어진 자료 리스트를 특정 매개변수 값의 길이를 갖는 부파일(subfile)로 쪼개서, 각 subfile에서 정렬을 수행
    - 2) 매개변수 값에 따라 subfile이 발생
    - 3) 매개변수값을 줄이며 이 과정을 반복하고 결국 매개변수 값이 1이면 정렬은 완성

  - #### **[ 알고리즘 ]**

    - 1) 자료리스트를 2차원배열로 나열 : 데이터를 십수 개 정도 듬성듬성 나누어서 삽입 정렬한다.
    - 2) 각 배열의 열들에 대해 : 데이터를 다시 잘게 나누어서 삽입 정렬한다.
    - 3) 이렇게 계속 하여 마침내 정렬이 된다.

  - #### [ 장점 ] 

    - 연속적이지 않은 부분 리스트에서 자료의 교환이 일어나면 **더 큰 거리를 이동**한다. 따라서 교환되는 요소들이 삽입 정렬보다는 최종 위치에 있을 가능성이 높아진다.
    - 부분 리스트는 어느 정도 정렬이 된 상태이기 때문에 부분 리스트의 개수가 1이 되게 되면 셸 정렬은 기본적으로 삽입 정렬을 수행하는 것이지만 삽입 정렬보다 더욱 빠르게 수행된다.
    - 알고리즘이 간단하여 프로그램으로 쉽게 구현할 수 있다.
      

  - #### [ 예제 ]

    - [2 5 3 4 3 9 3 2 5 4 1 3] 로 리스트가 주어졌을 때 이 리스트를 셸 정렬로 정렬해 보자.

    1. 3행으로구성된 행렬로 나열하여 열단위로 정렬한다.

       | 2 5 3 4 |      | 2 4 1 2 |
       | :-----: | :--: | :-----: |
       | 3 9 3 2 |  ⇒   | 3 5 3 3 |
       | 5 4 1 3 |      | 5 9 3 4 |

    2. 정렬된 3행 행렬을 6행렬로 나열하여 마찬가지로 열단위로 정렬한다.

       | 2 4  |      | 1 2  |
       | :--: | :--: | :--: |
       | 1 2  |      | 2 3  |
       | 3 5  |  ⇒   | 3 4  |
       | 3 3  |      | 3 4  |
       | 5 9  |      | 3 5  |
       | 3 4  |      | 5 9  |

    3. 정렬된 행렬을 한 열단위로 나열해서 삽입 정렬 한다.

       | 1 2 2 3 3 4 3 4 3 5 5 9 |  ⇒   | 1 2 2 3 3 3 3 4 4 5 5 9 |
       | :---------------------: | :--: | :---------------------: |
       |                         |      |                         |

  - 코드

    ```java
    public class Main {
    	//gap만큼 떨어진 요소들을 삽입 정렬
    	//정렬의 범위는 first에서 last까지
    	public static void inc_insertion_sort(int list[], int first,
                                            int last, int gap) {
    		int i, j, key;
    		for (i = first + gap; i <= last; i = i + gap) {
    			key = list[i]; // 현재 삽입될 숫자인 i번째 정수를 key 변수로 복사
    
    			// 현재 정렬된 배열은 i-gap까지이므로 i-gap번째부터 역순으로 조사한다.
    			// j 값은 first 이상이어야 하고
    			// key 값보다 정렬된 배열에 있는 값이 크면 j번째를 j+gap번째로 이동
    			for (j = i - gap; j >= first && list[j] > key; j = j - gap) {
    				list[j + gap] = list[j]; // 레코드를 gap 만큼 오른쪽으로 이동
    			}
    			list[j + gap] = key;
    		}	
    	}
    	//shell sort
    	public static void shellSort(int list[], int n) {
    		int i, gap;
    		for(gap = n/2; gap>0; gap=gap/2) {
    			if((gap%2)==0) {
    				gap++;// gap이 짝수면 홀수값으로 만든다.
    			}
    			//부분 리스트의 개수는 gap과 같다. 
    			for(i=0; i<gap; i++) {
    				// 부분 리스트에 대한 삽입 정렬 수행 
    				System.out.println("부분 삽입정렬 ");
    				inc_insertion_sort(list, i, n-1, gap);
    			}
    		}
    	}
      
    	static int list[] =  {10, 8, 6, 20, 4, 3, 22, 1, 0, 15, 16};
    	
    	public static void main(String[] args) {
    		int n = 11;
    		shellSort(list, n);
    		//정렬 결과 출력 
    		for(int i=0; i<list.length;i++) {
    			System.out.print(list[i]+ " ");
    		}
    	}
    }
    ```

### 추가자료 

- https://gmlwjd9405.github.io/2018/05/08/algorithm-shell-sort.html

- #### 셸 정렬(shell sort) 알고리즘의 개념 요약

  - ‘Donald L. Shell’이라는 사람이 제안한 방법으로, 삽입정렬을 보완한 알고리즘이다.
  - 삽입 정렬이 어느 정도 정렬된 배열에 대해서는 대단히 빠른 것에 착안
    - **삽입 정렬의 최대 문제점** : 요소들이 **삽입될 때,** **이웃한 위치로만 이동**
    - 즉, 만약 삽입되어야 할 위치가 현재 위치에서 상당히 멀리 떨어진 곳이라면 많은 이동을 해야만 제자리로 갈 수 있다.
    - 삽입 정렬과 다르게 **셸 정렬은 전체의 리스트를 한 번에 정렬하지 않는다.**
  - 과정 설명
    - 1) 먼저 정렬해야 할 리스트를 일정한 기준에 따라 분류
    - 2) 연속적이지 않은 여러 개의 부분 리스트를 생성
    - 3) 각 부분 리스트를 삽입 정렬을 이용하여 정렬
    - 4) 모든 부분 리스트가 정렬되면 다시 전체 리스트를 더 적은 개수의 부분 리스트로 만든 후에 알고리즘을 반복
    - 5) 위의 과정을 부분 리스트의 개수가 1이 될 때까지 반복

- #### 셸 정렬(shell sort) 알고리즘의 구체적인 개념

  - 정렬해야 할 리스트의 각 k번째 요소를 추출해서 부분 리스트를 만든다. 
    - 이때, k를 **‘간격(gap)’** 이라고 한다.
    - 간격의 초깃값: **(정렬할 값의 수)/2**
    - 생성된 부분 리스트의 개수는 gap과 같다.
  - 각 회전마다 **간격 k를 절반으로 줄인다.** 즉, 각 회전이 반복될 때마다 하나의 부분 리스트에 속한 값들의 개수는 증가한다.
    - **간격은 홀수로** 하는 것이 좋다.
    - 간격을 절반으로 줄일 때 **짝수가 나오면 +1을 해서 홀수로** 만든다.
  - 간격 k가 1이 될 때까지 반복한다.
  - ![img](https://gmlwjd9405.github.io/images/algorithm-shell-sort/shell-sort-concepts.png)



#### 셸 정렬(shell sort) 알고리즘의 예제

- 배열에 **10, 8, 6, 20, 4, 3, 22, 1, 0, 15, 16 ** 이 저장되어 있다고 가정하고 자료를 오름차순으로 정렬해 보자.

- 홀수 gap으로 나타내어 gap(k) = 11/2 = 5가 된다. 

- 2차원배열의 각 row에 대해 삽입정렬 실시

  

![1회전](https://gmlwjd9405.github.io/images/algorithm-shell-sort/shell-sort.png)



##### 1회전

- 처음 간격을 (정렬할 값의 수:10)/2 = 5로 하고, 다섯 번째 요소를 추출해서 부분 리스트를 만든다. 만들어진 5개의 부분 리스트를 삽입 정렬로 정렬한다.

##### 2회전

- 다음 간격은 = (5/2:짝수)+1 = 3으로 하고, 1회전 정렬한 리스트에서 세 번째 요소를 추출해서 부분 리스트를 만든다. 만들어진 3개의 부분 리스트를 삽입 정렬로 정렬한다.

##### 3회전

- 다음 간격은 = (3/2) = 1으로 하고, 간격 k가 1이므로 마지막으로 정렬을 수행한다. 만들어진 1개의 부분 리스트를 삽입 정렬로 정렬한다.

-----



- ### Merge sort (by John von Neumann)

  - stable 정렬에 속함
  - 분할정복 알고리즘
    - 리스트의 길이가 0 또는 1이면 이미 정렬된 것으로 본다. 그렇지 않은 경우에는
    - 1) 분할 : 정렬되지 않은 리스트를 절반으로 잘라 **비슷한 크기의 두 부분 리스트로 나눈다**.
    - 2) 정복 : 각 부분 리스트를 **재귀적으로 합병 정렬을 이용해 정렬**한다.
    - 3) 결합 : 두 부분 리스트를 **다시 하나의 정렬된 리스트로 합병**한다.
    - 4) 복사 : 임시배열에 저장된 결과를 원래 배열에 복사 

- 퀵

- 힙

- 버킷 정렬

- radix sort (기수 정렬)





---

----



- AVL / RB Tree 동작 방식
- B 트리 / B+ 트리 특징

- 허프만 코딩 작동 방식
- LZW 압축




