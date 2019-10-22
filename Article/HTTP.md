# HTTP / HTTPS / TLS 

- HTTP Method ( GET / POST / PUT / DELETE )

- Client / Server
- HTTP 1.1 vs HTTP 2.0 다른 파일에서 서술



### Header / Body

- Client 와 서버가 주고받는 데이터(패킷정보)는 크게 2가지로 나뉜다. 

- Header : 서버 주소 등 요청에 필요한 정보를 담는다.

- Body : 요청과 관련된 정보를 담는다. (POST에서 주로 사용)

  

###  GET 요청을 하는 경우  

- 요청 URL에 query string을 붙여서 전달하기도 함.
  - www.google.com?q=abc&lc=kor&…. 
  - 사용자에게 요청 정보가 노출된다.
  - parameter로 보낼 수 있는 데이터 크기가 256 bytes로 제한되어있음



### POST 요청

- header에는 요청 데이터 포맷 정보등
- body에 요청을 위한 정보/데이터를 담아서 전달
  - multipart 등으로 이미지 전송 가능
- 요청 url에 query string 불필요.
  - 단, 패킷 정보가 숨겨지거나 암호화되는 것은 아님



### HTTP 시절

- 대칭키를 사용하여 body에 암호화된 정보를 함께 보냄.
  - 가령, `123` 입력시 `hash` 함수를 통해 **`!@#`**로 변환된다면, `!@#` 자체를 body에 담아서보냄. 
  - 단, 리버스 엔지니어링을 바탕으로 암호화 무력화 가능..
- How ?  **md5  해시 알고리즘** 은 **같은 입력 -> 같은 결과** 가 나옴
  - `salt(pepper) value` 를 집어넣어서 원래의 암호를 알 수 없게 하는 방식
- 복호화가 불가능한 정보로 변환(단방향 암호화) 하기도
- 패킷에 대한 **`sniffing`** 에 취약



## SSL vs TLS (Transport Layer Security, a.k.a latest SSL)

#### 공통점

- 암호화 통신 프로토콜 
- 서버와 클라이언트와의 네트워크 통신간에 `인증`과 `데이터 암호화` 

#### 차이점

- 버전, TLS는 SSL의 최신버전 및 그를 보완한 시큐리티 레이어 방식이다.

https://www.globalsign.com/en/blog/ssl-vs-tls-difference/



#### SSL (Secure Socket Layers)

- 넷스케이프사에서 웹 서버와 브라우저 사이의 보안을 위해 고안
- **Certificate Authority(CA)** 라 불리는 서드파티로부터 서버와 클라이언트의 인증을 하는데 사용됨

#### SSL 작동 방식 

- https://wiki.kldp.org/HOWTO/html/SSL-Certificates-HOWTO/x70.html

- 1) **[웹브라우저]** 

  - SSL로 암호화된 페이지를 요청하게 된다 (https://)

- 2) **[서버]** 

  - **`Public key`** 를 **인증서와 함께 전송**한다.

- 3) **[웹브라우저]**  

  - 인증서가 자신이 신용있다고 판단한 **CA**(일반적으로 trusted root CA라고 불림)로부터 서명된 것인지 확인한다. 
  -  날짜가 유효한지, 그리고 인증서가 접속하려는 사이트와 관련되어 있는지도 확인한다.

- 4) **[웹브라우저]**

  -  Public Key를 사용해서 **랜덤 대칭 암호화키(Random symmetric encryption key)**를 비릇한 URL, http 데이터들을 **암호화해서 전송**한다.

- 5) **[서버]**

  -  **`Private Key`**를 이용해서 랜덤 대칭 암호화키와 URL, http 데이터를 **복호화**

- 6) **[서버]**

  - **요청받은 URL에 대한 응답**을 웹브라우저로부터 받은 **랜덤 대칭 암호화키**를 이용하여 암호화해서 브라우저로 전송

- 7) [브라우저]

  - 브라우저가 지닌 **랜덤 대칭 키를 이용**해서 http 데이터와 html문서를 **복호화**하고, 화면에 정보를 나타낸다.

  

#### TLS

- 기존의 SSL을 보완한 것. 
- SSL 3.0 을 기반으로 만들어짐

- TLS는 통신간의 암호화에 대한 약속만 있을 뿐, 암호화 유형에 대해 구체적으로 정하지는 않는다.
- RSA (비대칭키) 방식이 선호됨

#### cf. iOS App Transfer Security 

- TLS 1.2v 이상 지원하는 경우에만 통신을 허용



### 

### HTTPS (TLS 1.2v ~ , based on RSA 2048 or RSA 4096)

- TLS 기반의 HTTP 를 의미

- 국제적인 기관등을 통한 인증서를 받아서 인증

- SSL 인증서 : 클라이언트와 서버간의 통신을 제3자가 보증해주는 전자화된 문서

  - 클라이언트가 서버에 접속한 직후에 서버는 클라이언트에게 이 인증서 정보를 전달
  - 클라이언트는 이 인증서 정보가 신뢰할 수 있는 것인지를 검증 한 후에 다음 절차를 수행
    - 통신 내용이 공격자에게 노출되는 것을 막을 수 있다. 
    - 클라이언트가 접속하려는 서버가 신뢰 할 수 있는 서버인지를 판단할 수 있다.
    - 통신 내용의 악의적인 변경을 방지할 수 있다. 

- 인증서 내부에는 **브라우저-서버** 간의 공개키가 존재.

- 클라이언트는 이 인증서내의 공개키를 기반으로 암호화하여 서버와 통신

  

#### 공인인증서

- RSA 방식 (공개키)
- private key가 인증서 내부에 저장되있으므로 보안에 취약
- 클라이언트에게 private key의 관리 책임을 전가



참고 사이트

[HTTPS와 SSL 인증서](https://opentutorials.org/course/228/4894)

[SSL/TLS의 이해와 TLS 1.3으로 업그레이드해야 하는 이유](http://www.itworld.co.kr/howto/113007)

[정보보안 - SSL](https://12bme.tistory.com/80)

[SSL과 인증서](https://wiki.kldp.org/HOWTO/html/SSL-Certificates-HOWTO/x70.html)