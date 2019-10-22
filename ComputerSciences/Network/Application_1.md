## Application Layer 1

### 소켓 프로그래밍 

소켓이란 ?

- 애플리케이션과 네트워크 간의 통신을 위한 인터페이스

  - 애플리케이션은 Socket 을 만든다.
  - 소켓의 type은 커뮤니케이션 스타일을 지정한다. 
    - reliable (TCP) vs best effort (UDP)
      connection-oriented (TCP) vs connectionless (UDP)
  - 일단 소켓이 설정되면, 애플리케이션은 다음과 같은 일을 할 수 있다.
    - send data : 네트워크 전송으로 소켓을 통해 데이터를 전달
    - receive data : 다른 호스트에 의해 네트워크로 전송된 데이터를 수신 

- 소켓의 두 가지 에센셜 타입들 

  #### [1] SOCK_STREAM (TCP) 

  - 스트림 기반 소켓. 전송 데이터를 스트림이라 부름

  - reliable delivery / 신뢰할 수 있는 전송
  - 순서가 보장됨 
  - 연결 지향적
  - 쌍방향(bidirectional) 통신 

  [2] SOCK_DGRAM (UDP, Datagram)

  - 전송 데이터의 기본 단위를 데이터그램이라 부름 
  - Unreliable delivery 
  - 순서가 보장되지 않음
  - 각각의 패킷에 대해 연결의 개념이 존재하지 않음. 애플리케이션이 각 패킷에 대해 단지 목적지만 제공한다.
  - 전송 또는 수신의 역할을 수행 (쌍방에 대해 둘 중 하나의 역할만 수행)



SOCKETs APIs

- 소켓을 생성하고 Setup 하는 api
-  연결을 설정하는 기능 (TCP)
- 데이터 전송/수신 기능 (공통)
- 연결을 종료하는 기능 (TCP)



## TCP의 소켓 작동 방식 예

#### 서버

1) socket() : 서버에서 소켓을 생성.

2) bind() : 서버에서 잘 알려진 포트로 소켓을 바인딩 한다

3) listen() : 서버는 해당 소켓으로 요청이 들어오는 것을 기다리는 상태로 놓는다 **/ listen은 non-blocking**

4) 클라이언트로부터 연결이 올때까지 block 상태이다.

5) accept() : 클라이언트의 연결을 허용한다. 이후에는 클라이언트의 요청(3)에 따라 데이터를 read() 한다.  **/ accept는 blocking**

6) write() : read() 한 데이터에 대해 프로세스 내부의 요청에 따라 **쓰기** 기능을 수행하여 이를 응답 데이터로 보낸다. 클라이언트에서는 이 응답을 read 하는 작업을 수행한다.

7) read() : 클라이언트의 close() 요청을 읽는다. 

8) close() : 해당 연결을 종료한다. 



#### 클라이언트

1) socket() : 소켓을 생성한다.

2) connect() : 서버에 연결을 시도한다. 3 way handshake 과정에 속한다.  / **connect는 blocking**

3) write() : data request. 데이터를 요청하는 작업을 수행한다. 

4) read() : 요청에 대한 응답으로 데이터가 오면 이를 read() 한다.

5) close() : 연결을 끊는 작업을 수행한다. 서버에게 연결 종료를 알린다.





---

### Creation and Setup Socket

#### 1) socket : 소켓 생성 함수 

```c++
include <sys/socket.h>
int socket(int domain, int type, int protocol);
```

소켓을 생성하는 함수로, 정상 실행시 file descriptor(소켓의 ID) 혹은 -1을 리턴한다. 실패시 에러 넘버를 반환한다. 

domain : 프로토콜 family를 의미한다. (address family와 동일하다.)

- 일반적으로는 PF_INET은 IPv4이다. (IPv6 PF_ROUTE, PF_UNIX 등 일 수 있다.)

type : 통신 커뮤니케이션 스타일이다.

- TCP : SOCK_STREAM (PF_INET)
- UDP : SOCK_DGRAM (PF_INET)



### Establishing a Connection (TCP 예)

#### 2) bind

```c
int bind (int sockfd, struct sockaddr* myaddr, int* addrlen);
```

소켓을 로컬 IP 주소와 포트번호에 연결한다.

- sockfd: 소켓의 ID (socket() 함수로부터 리턴되는 값)

- myaddr : IP주소와 포트번호를 지닌 구조체

- port number : 값이 0이면 커널에 의해 지정된다. 사용자가 값을 지정하는 경우 그 숫자대로 설정된다.

- addrlen: 주소 구조체의 길이를 의미한다. 

#### 3) listen

```c
int listen (int sockfd, int backlog);
```

- 소켓을 수동적인 상태에 놓이게 한다.
- 해당 소켓은 연결을 직접 시도하기보다는 연결이 오는 것을 기다린다. 
- 성공시 0, 실패시 에러번호와 -1을 리턴
- sockfd: 소켓의 ID (socket() 함수로부터 리턴되는 값)
- backlog : 아직 accept 되지 않은, 연결을 담을 큐의 길이 상한을 의미 (연결 백로그). **즉, 동시에 들어오는 연결 요청들을 담을 큐를 의미**. 커널이 처리를 다룰 것이다. 높은 값으로 설정해주는게 좋다. 
- **listen 은 논블로킹이다.** 다시말해, 즉시 리턴한다.



#### 5) accept

```c
int accept(int sockfd, struct sockaddr* cliaddr, int* addrlen);
```

- 새로운 연결을 허용한다. 
- 소켓ID( file descriptor) 나 -1을 리턴한다. 실패시 에러번호를 설정하낟. 
- cliaddr : 클라이언트의 IP주소와 포트번호를 지닌 구조체이다. 

**accept는 블로킹이다.** 리턴 전에 연결을 기다린다.



#### 6) connect

```c
int connect(int sockfd, struct sockaddr* servaddr, int addrlen);
```

- 다른 소켓과 연결을 시도
- 성공시 0. 실패시 -1과 에러번호 리턴
- servaddr : 서버의 IP주소와 포트번호를 담은 구조체 

- **connect는 블로킹이다.**



### Send / Receive Data

#### write 

```c
int write (int sockfd, char* buf, size_t nbytes);
```

- 데이터를 스트림(TCP)에 쓰는 함수이다. 
- 쓰여진 바이트의 개수를 리턴하거나 -1을 리턴한다. 
- buf : 데이터 버퍼를 의미
- nbytes : 쓰기를 시도한 bytes의 수
- **write는 blocking 작업이다. 데이터를 전송한 후에 리턴한다.**



#### read

```c
int read(int sockfd, char*buf, size_t nbytes);
```

- 데이터를 스트림으로부터 읽어오는 함수이다. 
- 파라미터에 대한 설명은 write와 동일
- **read는 blocking 작업이다. 데이터를 수신한 후에 리턴한다.**

#### 주의

클라이언트는 bind (특정 포트에 바인드 하는 것)을 할 필요가 없다. 남아도는 곳을 할당하면 되므로. 

서버는 bind가 필요하다. 그래야 클라이언트에서 통신을 담당하는 소켓이 위치한 포트를 찾을 수 있다.



### Tearing Down a Connection (TCP)

#### close

```c
int close(int sockfd);
```

- 소켓 사용이 끝났을 떄, 소켓은 닫혀야 한다.
- 성공적으로 닫힌 경우 0, 실패시 -1
- 소켓을 닫을 때, 사용된 포트도 해제된다. 



### 포트 해제 

- 원래는 close에서 자연적으로 해제되어야 하나, 포트 해제까지 수분이 소요될 수 있다.

- 이러한 문제의 가능성을 줄이기 휘애서 아래와 같은 코드를 보통 추가해야 한다.

  ```c
  #include <signal.h>
  void cleanExit(){exit(0);}
  
  //socket code에서 
  signal(SIGTERM, cleanExit);
  signal(SIGINT, cleanExit);
  ```



------



## Multiplexing / demultiplexing

인터넷 계층(5계층)은 아래와 같다.

| 데이터                  | host 계층 | 데이터 형식     | host 계층 |
| :---------------------- | --------- | --------------- | --------- |
| 메시지                  | App       | <—— Message ——> | App       |
| Segment = 헤더+메시지   | Transport | <——Segment ——>  | Transport |
| Packet = 헤더 + Segment | Network   | <——Packet ——>   | Network   |
| Frame = 헤더 + Packet   | Link      | <——Frame ——>    | Link      |
|                         | Physical  |                 | Physical  |

segment = header fields(source port & dest port) + 애플리케이션 데이터(메시지)

데이터그램(Packet)은 **source IP address**, **destination IP address**



#### Multiplexing 

- 호스트에 데이터를 전달하기 위해서 여러 소켓들로부터 데이터를 모으고, 각각의 계층에서 데이터를 헤더로 감싸는 작업을 수행한다.
- 이는 다음 호스트로 데이터를 전달하는 과정에서 알맞는 Layer에게 데이터를 올바르게 전달하기 위함이다. 즉, next host의 App을 돌리는 프로세서에게 데이터를 정확하게 전달하기 위함.



#### Demultiplexing at receive host

- 수신한 segments를 적합한 소켓으로 전달하기 위한 작업을 의미

- host는 IP datagrams를 수신한다.
  - 각각의 데이터그램은 **source IP address**, **destination IP address**를 지닌다.
  - 각각의 데이터그램은 1개의 전송계층 segment를 운반한다.
  - 각각의 segment는 **source/destination 포트번호**를 지닌다.

- 호스트는 IP주소들과 포트번호들을 사용하여 적절한 소켓에 segment를 지정한다.





## UDP의 demux 예

#### 클라이언트 1

- DatagramSocket mySocket2 = new DatagramSocket(**9157**);
- 통신하기 위해 Datagram 소켓을 연다 (**9157**)
- **segment의 헤더**로 **소스포트 9157**과 **목적지 포트 6428**을 설정
- **Packet(datagram) 의 헤더**로 **소스 IP와 목적지 IP**를 설정.



#### 서버

- DatagramSocket serverSocket = new DatagramSocket(**6428**);

- 서버의 소켓은 **6428** 번호이다. 

- 요청에 대한 응답으로 데이터 보낼때, **segment의 헤더**로 **소스포트 6428**과 **목적지 포트 9157**을 설정

  

#### 클라이언트 2

- DatagramSocket mySocket2 = new DatagramSocket(**5775**);
- 통신하기 위해 Datagram 소켓을 연다 (**5775**)
- 역시 클라1처럼 **segment 헤더로 src 5775, dest 6428**을 설정



### UDP 정리 

- UDP Segment 
  - **header**(1. source port / 2. dest port / 3. lenght of bytes / 4. checksum ) + message
  - **checksum** **(error checking)** : 전송 도중에 에러 발생여부를 판단한다. 에러발생시, 상위 Application Layer로 올리지 않고, drop시킨다. 
  - 각각의 field는 16bit이다. 포트번호의 크기는 (0~65535)

- best effort 서비스. / 연결 설정에 대한 딜레이가 존재하지 않음.

- UDP의 segment는 손실가능 / 데이터 응답에 순서가 없음 (delivered out of order to app)

- 무연결

  - sender와 receiver 간의 **handshaking은 없다.** 즉, 연결 상태가 없음
  - segment header의 크기가 작다.
  - 혼잡 제어가 존재하지 않기때문에 원하는만큼 빠르게 전달 가능.
  - 각각의 UDP segment는 독립적으로 처리된다. 

- 스트리밍 멀티미디어 애플리케이션을 위해 사용

  - loss에 tolerant하고, 
  - rate sensitive한 것들

- UDP 사용예

  - DNS
  - SNMP

  



## TCP의 demux 예

- dest IP / dest port 가 같더라도, source IP, source No에 따라 서버의 각각 다른 소켓이랑 통신한다.



### 요약

- UDP의 경우 demux는  **dest IP & dest Port No. 만을 사용하여** 어떤 소켓에 데이터를 올릴지에 대한 demux가 진행된다.

- TCP의 경우 demux는 **dest IP & dest Port No. & source IP & source Port No.** 가 모두 동일한 경우에만 같은 소켓으로 데이터를 보낸다. **넷 중 하나라도 다른 경우 다른 서버소켓에 할당될 것이다.**





