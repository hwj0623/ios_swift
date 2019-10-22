# 전송계층 - 3 Flow Control 

> 흐름 제어 : sender는 **리시버의 버퍼를 초과하여 더 많은 데이터를, 더 빠르게 전송하지 않는다.** TCP 통신하는 두 Host 사이의 데이터 흐름을 조절하는 것
>
> 4 way handshake - time out을 두는 이유



참고 : https://m.blog.naver.com/cmw1728/220435200782

- TCP는 Flow Control(흐름 제어)와 Congestion(혼잡 제어)라는 두 개의 매커니즘을 이용해 end-to-end 간의 신뢰성 있는 전송을 보장한다.

- 흐름제어는 송신 측이 수신 측으로부터 advertised window의 크기를 받은 후 그것보다 작게 보내서 네트워크 상의 흐름을 제어한다.

- 혼잡제어는 sender가 네트워크의 상황을 보고 스스로 흐름을 제어하는 방법이다.



**1. 흐름제어 (Flow Control)**

- 송신 측과 수신 측의 데이터 처리 속도 차이를 해결하기 위한 기법이다.

- **송신 측이 수신 측보다 속도가 빠를 때 문제가 발생**한다. 수신 측에서 수신된 데이터를 처리해서 상위 계층으로 서비스하는 속도보다 송신 측에서 데이터를 보내는 속도가 더 빠르게 되어 수신 측의 제한된 저장 공간을 초과하여 데이터가 손실될 수 있기 때문이다. 손실이 발생하게 되면 불필요한 응답과 데이터의 재전송이 발생하게 된다.

- 흐름 제어는 **송신 측의 데이터 전송량을 수신 측에 따라 조절**한다.



**2. TCP의 흐름제어 : 슬라이딩 윈도우(Sliding Window)**

- **수신 측에서 설정한 윈도우 크기만큼은 송신 측이 확인 응답없이 세그먼트를 전송할 수 있게** 하여 데이터의 흐름을 **동적으로 조절하는 제어기법**이다. 

- 송신 버퍼의 크기를 수신 측의 여유 버퍼 크기를 반영하여 동적으로 바뀌게 함으로 흐름제어를 수행하게 한다.

- 슬라이딩 윈도우는 일단 **윈도우에 포함되는 모든 패킷을 전송**하고 그 패킷들의 **전달이 확인되는대로 이 윈도우를 옆으로 옮김(slide)으로 다음 패킷을 전송**한다.

- **윈도우 크기만큼은 수신 측의 확인 응답을 받지 않고도 전송이 가능**하므로 매번 확인 응답을 받아야만 다음 패킷을 전송하는 stop-and-wait방식보다 훨씬 효율적으로 사용할 수 있다.





### 1) 흐름 제어의 특징

- TCP의 리시버측은 **리시브 버퍼**를 지닌다.
  - Receive 버퍼는 아래와 같이 구성되어있다.
  - **RevBuffer** 내의 TCP data 외에 **빈 공간** **RevWindow** 라 한다.
    - App process에서 읽은 data 만큼 버퍼를 비운다.
    - RcvWindow = RcvBuffer - [Last Byte Received - Last Byte Read]
  - 리시버는 남아있는 공간 정보를 Sender에게 보낸다.

  

- cf. 가령 극단적인 예로, 리시버에서 공간이 0임을 Sender에 전달한다면 Sender는 전송을 중지할 것이다.(Sender는 Receiver의 신호를 기다린다.) 그리고 리시버는 Buffer를 비우고 Sender로부터 데이터를 기다리는 상황이 된다. 양측의 무작정 기다리는 상황을 어떻게 해결할까?

  - **Sender는 무작정 기다리지 않고, 주기적으로 segment를 보내서 (data 없거나 1bytes) Receiver의 ACK를 유도한다.**

- 앱 프로세스는 버퍼로부터 읽어들일때 약간 느릴 수 있다.
- **Speed-matching service :** 
  
  - 전송률을 수신률에 맞춘다.



### 2) Connection management

- 양측에 **Send/Receive Buffer 세팅, 나의 Seq #, 상대방의 Seq #를 세팅**하는 것이 연결의 초기 작업이다.
- 초기화 하는 TCP 변수들:
  - seq #s
  - buffers, flow control info(e.g. RcvWindow)
- 클라이언트는 연결을 시작하는 시도륵 먼저 한다. 
  - new Socket("hostname", "port number"); 
- server : 클라이언트로부터의 접촉을 허용한다. 
  - Socket connectionSocket = welcomSocket.accept();



## 3 way handshake (TCP 연결 시작)

#### Step1 : 클라이언트 host는 TCP `SYN` segment를 서버에 전송

- 초기 seq #를 구체화한다.
- 데이터는 없다.
- SYN bit는 1이다. 
- `Seq # = x`라 하자.



#### Step 2 : 서버는 SYN를 받고, `SYN+ACK` segment를 보낸다.

- 서버는 버퍼를 할당한다.
- 초기 seq #를 구체화한다.
- **ACK number = ` x(클라이언트의 seq #) +1`** 이다.
- 서버의 `Seq # = y` 라하자.
- SYN, ACK bit는 각각 1이다.



#### Step 3 : 클라이언트는 SYN+ACK segment를 수신하고,` ACK` segment(with data) 로 응답한다.

- 이때의 ACK segment에는 **data가 포함될 수** 있다.
- **ACK = `y (서버의 seq #) + 1`**





## TCP 연결 종료 (4 way handshake)

<img src="https://img1.daumcdn.net/thumb/R720x0.q80/?scode=mtistory&fname=http%3A%2F%2Fcfile29.uf.tistory.com%2Fimage%2F2207B44B523125480697C2" width="500px">

#### STEP 0 : 클라이언트는 소켓을 닫는다.

- clientSocket.close();

#### STEP 1 : 클라이언트 종단 시스템은 TCP `FIN` control segment 를 서버에 보낸다.

#### STEP 2 : 서버는 FIN을 수신하고, `ACK` 를 보낸다. 연결을 종료하면서 `FIN`를 보낸다.

#### STEP 3 : 클라이언트도 `FIN` 을 수신한다. 이후 `ACK` 로 응답한다.

- timed wait - 수신한 FIN에 대한 ACK의 응답을 서버가 받는 동안 **대기상태**로 들어간다.
- **대기상태 이후에 소켓의 closed가 완료** 된다.
- 대기상태는 **2MSL 대기 상태(2MSL wait status)**라고도 한다.
  - MSL : Maximum Segment Lifttime)

#### STEP 4 : 서버는 `ACK` 를 수신하고 연결을 종료한다.

- 만약 서버로 수신할 ACK가 유실되었다면 서버는 FIN을 계속 다시 보낼 것이다. 따라서 이를 기다리는 시간을 둔다.





#### cf. TIME_WAIT(2MSL wait status)

- 출처 : https://m.blog.naver.com/cmw1728/220448146710

- TIME_WAIT는 TCP의 4-Way Handshaking 과정을 통한 소켓 종료 과정 중의 상태이다.

- TIME_WAIT 상태가 되는 조건은 자신이 종료를 위해 FIN패킷을 보내고 그에 대한 응답으로 ACK 패킷을 받는다. 그런 다음 상대방의 FIN 패킷을 받고 그에 대한 응답으로 ACK 패킷을 보내고 TIME_WAIT가 된다.

- TIME_WAIT 상태는 2MSL 대기 상태(2MSL wait status)라고도 하는데, 여기서 MSL(Maximum Segment Lifttime)이란 패킷이 폐기되기 전에 네트워크에서 살아있을 수 있는 시간을 말한다.

- 모든 IP패킷은 TTL(time-to-live)라는 값을 가지는데 이 값이 0이 되면 해당 패킷은 폐기된다. 모든 라우터는 패킷을 통과시키면서 이 TTL값을 1만큼 감소시킨다.

-  소켓이 TIME_WAIT 상태가 되면 MSL의 두배만큼의 시간동안 TIME_WAIT상태를 유지한다. 이로 인해 ACK 패킷이 TTL에 의해 소실되어도 ACK패킷을 재전송하여 FIN패킷이 재선송될 수 있다. TIME_WAIT상태가 끝나면 소켓은 CLOSED상태가 된다.

##### TIME_WAIT가 필요한 이유

(1) 지연 패킷 문제 : 송신한 데이터를 모두 수신하기 전에 새로운 연결이 이미 진행되었다면 송신한 데이터, 즉 지연 패킷이 뒤늦게 도착해 문제가 발생한다. 드문 경우이지만 SEQ까지 동일하다면 데이터 무결성에도 문제가 생긴다

<img src="https://mblogthumb-phinf.pstatic.net/20150812_61/cmw1728_14393087363651hz8W_PNG/duplicate-segment.png?type=w2" width="400px">

(2) 연결 종료 문제 : 마지막 ACK 손실 시, 상대방은 LAST_ACK 상태에 빠지게 된다. 따라서 새로운 연결을 위해 SYN패킷을 보내도 RST를 리턴하며 실패한다.

<img src="https://mblogthumb-phinf.pstatic.net/20150812_83/cmw1728_1439308832186c7C6X_PNG/last-ack.png?type=w2" width="400px">



## Congestion Control 접근 방법

2가지 방식

### 1)  End-to-End congestion control (v)

- **실제 인터넷 구현 방식** **/ TCP 방식**

- 네트워크로부터 명시적인 피드백이 없음

- end system으로부터 관측된 loss, delay에 의해 혼잡을 유추한다.

  



### 2) Network-assisted congestion control

- 라우터가 end system에 피드백을 제공하는 방식
- 단일 비트로 혼잡도를 가리키는 방법 
- sender는 명시적인 rate를 전송시에 제공한다.







## 요약

### 연결

1) 클라이언트 소켓생성

STEP 1 : **클라이언트에서 서버로** Sequence number와 함께 `SYN`  bit=1 을 보낸다.

STEP 2: 서버는 SYN 수신후 연결을 생성.  ACK =1, SYN =1 비트를 보낸다.

​	`ACK` bit = 1, **ACK number**는 **클라이언트의** **seq # +1** 값으로 설정한다.

​	`SYN` bit = 1과 함께 서버의 Seq #를 보낸다.

STEP 3: 클라이언트는 SYN=1, ACK=1을 수신한다. 이후 ACK를 보낸다.

​		`ACK` bit = 1, ACK number는 **서버의 seq # +1 값**으로 설정한다.

​		세그먼트에 data를 포함할 수 있다.



### 종료

클라이언트는 socket.close()호출

STEP 1 : **클라이언트에서 서버로** `FIN` 을 보낸다.

STEP 2 : 서버는 이를 수신하고 1) **클라이언트에게** `ACK`를 보낸다. 이후에 서버의 소켓 종료 close() 호출로 2) **클라이언트에게**  `FIN`을 보낸다.

STEP 3 :  `FIN` 수신에 대한 응답으로 **클라이언트에서 서버로** `ACK`를 보낸다. 클라이언트는 TIME_WAIT (240초 기본) 으로 잉여 패킷을 기다린다.

STEP 4: 서버는 클라이언트의 `ACK` 를 받고 연결을 종료한다.

클라이언트도 대기시간 이후에 socket.close() 종료



 