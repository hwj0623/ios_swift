# 전송계층 - 2

- Segment 구조
- Reliable
- Flow control
- Congestion control



## 1) segment 구조

#### Point to Point

- TCP는 Point to Point의 통신만 관장한다.

#### Reliable, in-order bytes stream

- 메시지의 경계가 존재하지 않는다.

#### Pipelined

- pipeline 방식으로 한번에 window 크기(receiver의 buffer 단위 크기) 만큼 전송한다.

- TCP의 **혼잡 및 흐름 제어가 window의 크기를 설**정한다.



#### Full duplex data

- Sender/Receiver 의 경계가 없다. 각각의 host는 둘의 역할을 겸한다. 



#### Connection-oriented

- handshaking(control 메시지 교환) 이 데이터 교환 이전에 sender/receiver의 상태를 초기화한다.



#### Flow controlled

- sender는 receiver의 허용을 뛰어넘는 흐름을 전달하지 않는다.

##### P1 <—TCP —>P2

Sender     ——> Receiver

Receiver  <—— Sender 

각자 sender Buffer와 Receiver Buffer를 지니고 있다.

P1의 Sender버퍼는 P2의 Receiver 버퍼와 연결되어 있다. P2의 Sender도 P1의 Recevier 버퍼와 연결



### TCP Segment 구조

- App의 메시지(편지내용)를 TCP의 전송단위인 Segment(편지봉투)로 담는다.
- 역시 네트워크 레이어에서는 패킷 (= 세그먼트 + header) 이 기본단위
- 링크 레이어에서는 Frame ( = 패킷 + header) 이 기본단위

<img src="./images/TPL_2/스크린샷 2019-10-04 오후 1.13.10.png" width="500px">



- source port / dest port : 각각 16 bits 씩 할당. ==> 이론상 한 컴퓨터 내의 포트 번호 범위(0~65535)  **(same as UDP)**
- sequence number (32 bits) **(TCP only)** **데이터의 바이트들에 의해 계산됨**(*)
- acknowledgement number (32 bits) **(TCP only)** **데이터의 바이트들에 의해 계산됨(*)**
  - **TCP의 ACK 10** : GBN와 동일. **9번까진 잘받았다. 10번부터 달라는 의미**이다.
- checksum (16bits) : 네트워크 전송간에 에러를 탐지하기 위한 비트들 **(same as UDP)**
- Receive window = **Sender의 Receiver 버퍼**에 얼마만큼의 여유 공간이 있는지 **상대방에게 알리기 위한 정보**가 담긴다. **(TCP only)**
- head len / not used 외 1비트짜리 데이터들은 순서대로 **UAPRSF** 이다. 각각 URG, ACK, PSH, RST, SYN, FIN
  - URG : 긴급 데이터 여부 (일반적으로 안쓰임)
  - PSH :  데이터를 지금 푸시할 것을 나타냄 (일반적으로 안쓰임)
  - RST, SYN, FIN : 연결을 설정하기 위한 비트들 (셋업, 종료 등)



#### 데이터의 바이트들에 의해 계산됨(*)

- Seq # : segment의 **전송 데이터 중 첫번째 바이트를 Seq # 로** 잡는다.
- ACKs : **다음 기대되는 byte 번호**의 seq#를 의미. 가령, ACK 79 = seq 78까지 수신완료 후 79번 바이트 요청

Message (100bytes) 주어질 때, 가령 10bytes 단위로 구분한다고 하면 seq # 는 아래와 같다.

- 0~9 bytes의 byte의 맨 앞 번호인 0이 처음 전송할 segment의 seq # 가 된다.

- 10~19 bytes의 맨 앞 byte 번호인 10이 다음 전송할 segment의 seq #가 된다.



#### 예시 

<img src="./images/TPL_2/스크린샷 2019-10-04 오후 1.25.12.png" width="500px">

1) `Host A`에서 seq=42, data='C', ACK=79 인 data를 `Host B`에 전송했다고 하자. 

- **Seq=42, data='C'** : A가 보낼 데이터는 42까지고, 그 데이터는 'C'임을 의미. 
- **ACK 79 :** A가 받은 데이터와 관련된 정보로, B의 seq # 78까지고, B의 Seq# = 79부터 보내라

2) `Host A`의 데이터 전송이 끝나면 `Host B`는 42까지 받았으므로 ACK = 43, Seq = 79를 보내며, 받은 데이터 'C'를 에코로 돌려준다.

- **'C'가 에코데이터인지, Host B의 로부터 전달되는 고유 데이터인지는** App Layer에서 Message를 구성하는 **Message header로 판별**한다.

3) `Host A`는 ACKs와 에코된 'C'를 수신한다. **Host B의 요청 데이터인 Seq=43을 보내고**, **Host B로부터 79까지 수신했음을 알리는 ACK=80**을 보낸다.



Host A의 Seq는 Host B의 리시버 버퍼를 통해 B의 ACK와 대응된다.

Host B의 Seq는 Host A의 리시버 버퍼를 통해 A의 ACK와 대응된다.



## Timeout - RTT(Round Trip Time) 함수

- **RTT(Round Trip Time)** :  Segment가 Host A에서 B를 왕복하는데 걸리는 시간.

- TCP의 timeout 값을 어떻게 세팅?
  - RTT보다 길게 설정. but, RTT도 다양하다.
- 너무 짧게하면 조기 타임아웃으로 불필요한 재전송 유발
- 너무 길게 하면 segment 손실에 대한 느린 대응을 초래



### RTT 측정 방법

- SampleRTT는 `segment 전송으로부터  ACK수신까지의 ` 측정시간

- #### EstimatedRTT = (1-alpha) * EstimatedRTT + alpha* SampleRTT

  - 지금까지 축적된 값에 (7/8)의 가중치, 현재 막 측정된 값에 (1/8) 가중치를 주어서 보정 RTT를 계산
  - 지수 가중 평균법으로 구성
  - alpha는 통상 0.125 (1/8)



##### DevRTT(DeviationRTT) = (1-beta)*DevRTT + beta * |SampleRTT - EstimatedRTT|

- 오차를 감내하기 위한 보정값을 지수평활RTT에 4개를 더한다.

실제 사용하는 **`TimeoutInterval = EstimatedRTT + 4*DevRTT`**





## 2) Reliable data transfer (rdt)

- TCP는 신뢰할 수 없는 IP의 서비스 위에 rdt 서비스를 만들었다.

- **pipelined segments 가** 기본

- ACKs 는 **cumulative, 누적적으로 잘 받았음**을 알림

- TCP는 **단일 재전송 타이머를 사용**한다.

- `재전송`은 2가지에 의해 발생한다.

  - #### **timeout 이벤트**

  - #### **중복 ACKs** 



### TCP sender의 이벤트

##### Data received from app :

- seq #와 함께 segment를 생성
- seg #는 세그먼트의 첫번째 바이트 스트림 번호
- 타이머 시작 (타이머는 가장 오랫동안 ACK를 받지 못한 segmet와 같다)
- TimeOut Interval 측정



##### Timeout : 

- timeout에 의해 segment 재전송이 일어난다.
- 타이머를 재시작한다.



##### ACK received : 

- 만약 ACK가 이전의 unAcked된 segements에 관한 것이라면
  - acked 된 것으로 업데이트한다.
  - 다른 segment에 대해 타이머를 시작한다.



### 예시 - TCP의 retransmission 시나리오들 

#### ACK 유실 시나리오

Host A가 타어머와 함께 전송한 데이터는 Seq=92이고, 데이터 크기는 8bytes 라 하자. 

Host B는 92~99(8 bytes)를 수신후,  ACK=100를 보냈으나 유실.

Timeout으로 인해, Host A는 92~99의 Seq=92를 Host B로 재전송

Host A는 Host B로부터 ACK 100을 수신함



#### 조기 Timeout 시나리오 

1) Host A는 Seq=92, 8 bytes를 보내고, 이어서 Seq=100, 20bytes data를 보냈다.

2) Host B는 둘 다 받고 ACK=100과 ACK=120을 순차적으로 보낸다.

3) 이때, Seq=92에 대한 ACK=100이 Seq=92 타이머동안 오지 않았다.

4) Host A는 Sendbase=92이므로 Seq=92만 재전송한다. 이 두번째 타이머 기간동안 ACK=100과 ACK=120이 Host A에 들어온다.

- Host A는 ACK=100수신후, Sendbase = 100, ACK=120 수신후 Sendbase=120이 된다. 
- Host A는 Seq=92 타이머를 리셋하고 Seq=120 타이머를 시작한다.

- Host B는 120번을 기다리므로 재전송된 패킷은 drop 한다.



#### 누적 ACK 시나리오

1) Host A 가 Seq=92, 8 bytes를 보낸다.

2) ACK =100이 유실되었다.

3) Host A가 Seq=100, 20bytes를 보낸다.

4) Host A가 timeout 내에 ACK=120을 받으면 SendBase는 120이 된다. Cumulative ACK이므로 ACK=100은 받지 못했어도 데이터 수신이 정상적이었음을 가정하게 된다. 



### TCP의 Fast retransmission

- **Fast retransmission of 3 duplicated ACK** : ACK 10이 연속으로 3번 (총 4번) 오는 경우, timeout 이전에 재전송을 시작하는 기능.

  