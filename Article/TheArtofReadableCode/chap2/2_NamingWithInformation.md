# PART ONE - 가독성 향상 - surface level

>  이름에 정보를 담자



[0목차](#home)

[1. 특정단어 고르기](#특정-단어-고르기)

[2. 보편적인 이름 피하기](#보편적인-이름-피하기)

[3. 추상적인 이름보다 구체적인 이름 선호](#추상적인-이름보다-구체적인-이름-선호)

[4. 추가적인 정보를 이름에 추가](#추가적인-정보를-이름에-추가)



### 1. 특정단어 고르기

- 네이밍 시 매우 구체적인 단어를 선택하여 무의미한 단어를 피한다.

```python
def  getPage(url)  
```

- fetchPage() 이나 downloadPage()가 더 의미가 명확할 것이다.

```java
class BinaryTree{
  	int size();
  	...
}
```

- size가 의미하는 것이 트리의 높이인지, 노드의 개수인지, 메모리사용량인지 알 길이 없다.
- height, numNodes, memoryBytes 등의 구체적인 이름을 사용



Thread 동작과 관련해서도 stop() 보다는 kill() , pause() (resume() 호출이 가능한 경우) 등으로 세분화하는 것이 좋다.



> 재치있는 이름보다 명확하고 간결한 이름이 더 좋다. 



### 2. tmp나 retval 같은 보편적인 이름 피하기

> 변수의 목적이나 담고 있는 값을 설명해 주는 더 좋은 이름을 사용해라

retval += v[i] 

sum_squares += v[i] //제곱에 덧셈이 있을 수 없으므로 버그에 대해 가독성도 높다.

**tmp?**

> 대상이 짧게 임시적으로만 존재하고, 임시적 존재 자체가 변수의 가장 중요한 용도일때 한해서 사용해야 한다.

- 메서드 내에서 임시저장소 외에 다른 용도 없는 경우에는 사용 가능
- 주기가 짧아도 다른 정보를 더 내포할 수 있다면 그에 맞는 변수명으로 바꿔줘야 한다.

```java
String user_info =  user.name();	
user_info += " "+user.phoneNumber();
user_info += " "+user.email();
//...
template.set("user_info", user_info);
```

**tmp단어가 필요하나, 이름 전체가 아니라 일부분에 tmp를 써야하는 경우**

```java
tmpFile = tempfile.NamedTemporaryFile()
//...
SaveData(tmpFile);
```



**Loop iterator**

i, j, iter, it 같은 인덱스/루프반복자로 사용되는 것에도 혼동을 초래할 여지가 있다.

```c++
for (int i=0; i<clubs.size(); i++){
  for (int j=0; j<clubs[i].members.size(); j++){
    for (int k=0; k<users.size(); k++){
      if (clubs[i].members[k] == users[j])	//members와 users는 잘못된 인덱스 사용중
        	cout << "user[" << j << "] is in club [" << i << "]" endl;
    }
  }
}
```

- 잘못된 인덱스를 사용해도 알아보기 힘들다. 이럴 때는 좀 더 명확하게 club_i, members_i, users_i 혹은 ci, mi, ui 같은 이름을 사용하는게 좋다.

```c++
if clubs[ci].memebers[ui] == users[mi] // 버그 발생! 첫 문자가 일치하지 않음
if clubs[ci].memebers[mi] == users[ui] // 일치!
```



### 추상적인 이름보다 구체적인 이름을 선호하라

- 변수/함수/요소에 이름 붙일 때, 추상적인 방식이 아니라 구체적인 방식으로 묘사
- TCP/IP 포트 사용 검사 메서드는 ServerCanStart() 보다는 CanListenOnPort()가 더 구체적이다.



Ex) DISALLOW_EVIL_CONSTRUCTOR

- C++에서는 클래스를 위한 복사생성자(copy constructor)나 할당 연산자(assignment operator)를 생략시 자동으로 기본값을 제공한다. 편리하나, memory leak나 다른 문제를 야기할 수 있다.
- In google, accept policy to disallow creating this kind of evil constructor using macro

```c++
class ClassName{
  private:
  	DISALLOW_EVIL_CONSTRUCTOR(ClassName);
  public:
  	...
};

//매크로 정의
#define DISALLOW_EVIL_CONSTRUCTOR(ClassName)	
	ClassName(const ClassName);					///class의 private 놓였기때문에 
	void operator=(const ClassName);		//두 메서드는 우연히 사용될 수 없다.
```

- 여기서 `DISALLOW_EVIL_CONSTRUCTOR` 라는 이름은 별로 좋지 못함. EVIL이 의미하는 바가 모호함
- 매크로가 금지하는 대상이 무엇인지 드러나도록 해야 함
  - 해당 매크로는 operator=()를 금지하므로 다음과 같이 변경

```c++
#define DISALLOW_COPY_AND_ASSIGN(ClassName)...
```



### 추가적인 정보를 이름에 추가하기

```c++
string id; //Ex "af85e3f53cd8"
//16진수 문자열 담는 변수라면 다음과 같이 하는 편이 더 낫다
string hex_id;
```



### 단위를 포함하는 값들

```javascript
var start = (new Date()).getTime();
..
var elapsed = (new Date()).getTime()-start
document.writeln("Load time was : "+elapsed+" seconds");
```

- Date의 getTime이 초가 아니라 밀리세컨드를 반환하므로 아래와 같이 수정한다.

```javascript
var start_ms = (new Date()).getTime();
..
var elapsed_ms = (new Date()).getTime()-start_ms
document.writeln("Load time was : "+elapsed_ms / 1000 +" seconds");
```



| 함수                          | 인수 단위 포함하게 재작성 |
| ----------------------------- | ------------------------- |
| Start(int delay)              | delay -> delay_secs       |
| CreateCache(int size)         | size -> size_mb           |
| ThrottleDownlaod(float limit) | limit -> max_kbps         |
| Rotate(float angle)           | angle -> degrees_cw       |



### 다른 중요한 속성 포함하기

- 프로그램이 전달받는 일부 데이터가 아직 불완전 하다는 사실을 인지하지 못했을 때, 보안 취약점이 발생할 수 있다.

| 상황                                                         | 변수명   | 더 나은 이름       |
| ------------------------------------------------------------ | -------- | ------------------ |
| 패스워드가 plaintext에 담겨있고, 추가적인 처리 전에 반드시 암호화 해야 하는 경우 | password | plaintext_password |
| 사용자에게 보여주는 comment가 화면에 나타나기전에 escaping 처리되야 함 | comment  | unescaped_comment  |
| html의 바이트가 UTF-8으로 변환됨                             | html     | html_utf8          |
| 입력데이터가 'url encoded' 됨                                | data     | data_urlenc        |



### 이름은 얼마나 길어야 하는가?

- 좋은 이름 선택할 때, 이름이 지나치게 길면 안된다는 제한이 암묵적으로 존재.
- 좁은 범위에서는 짧은 이름이 괜찮다.
- 긴 이름 입력하기는 메서드/변수 자동완성 기능으로 더 이상 문제가 되지 않는다.
- 약어와 축약형은 관용적인 경우를 제외하고는 지양해야 한다.
- 불필요한 단어는 제거할 수 있다.
  - ConvertToString() -> ToString()



### 이름 포맷팅으로 의미 전달하기

- 구글 오픈소스 C++ Code 
  - 클래스명을 CamelCase로, 변수명은 lower_seperated로 쓰기
  - 변수는 변수명 끝에 _를 붙인다.
  - 상수값으로 CONSTANT_NAME -> kConstantName과 같은 형태를 쓰면 #define 매크로와 구별된다.

```c++
static const int kMaxOpenFiles = 100;
class LogReader {
	public:
		void OpenFile(string local_file);
	private:
		int offset_:
		DISALLOW_COPY_AND_ASSIGN(LogReader);
}
```



- javascript 포맷팅

  ```javascript
  var x = new DatePicker(); // 생성자 함수는 대문자로 표시
  var y = pageHeight(); //함수는 camelCase
  ```

```javascript
var start = (new Date()).getTime(); //페이지 맨 위.getTime은 초가 아니라 밀리세컨드를 반환한다.
...
var elapsed = (new Date()).getTime() - start ; //페이지의 맨 아래
document.writeln("Load time was : "+elapsed+" seconds");
```

```javascript

var start = (new Date()).getTime(); //getTime은 초가 아니라 밀리세컨드를 반환한다.
...
var elapsed = (new Date()).getTime() - start ; //페이지의 맨 아래
document.writeln("Load time was : "+elapsed+" seconds");



##  summary

