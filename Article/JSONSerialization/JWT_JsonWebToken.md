## JWT (Json web token)

- WEB API를 통한 인증
- 인증을 통해 권한이 있는 사람에게만 API 요청을 허용
- API Request에 Token을 함께 전달하여 요청
  - 토큰은 **쿠키**나 **헤더**에 넣어서 전달가능
  - 토큰 자체에 **의미있는 값**이 들어있음
  - 토큰은 **Encoding**되어있음



#### 기존의 쿠키/세션 방식과의 차이

- 기존 방식은 API를 사용하기 위해 `login` 을 해야하는 절차가 필요.
- 중앙에서 세션을 관리해야할 시스템이 잘 작동해야 API 제공이 원활함



### Example

POST /login (id, pw) 대신에 

-> JWT (ID, Name / ISAdmin) 으로 토큰을 받음

이후에 news/1 + token 값으로 GET 요청



### cf REST API vs WEB API vs 일반 HTTP응답

- #### Restful API

  - 로이 필딩이 만듦
  - (과거) http 요청 > html 문서 받기 였음
  - API 도입으로 http 요청 방식이 잘 지켜지지 않음 
  - 자원에 대한 설명을 명세한 규칙

  

- #### Web API 

  - `JSON` / `XML` (only Data) 로 전달받음 
  - Restful API 를 포함함

  

- #### 일반 HTTP 응답

  - `html` (디자인 등표현 방법 + 데이터) 로 전달받음





생코 Ouath 2.0,  JWT 참고