## Previously Recap

인터넷의 delay / loss 발생 원인

- 패킷은 라우터의 버퍼들에 큐의 형태로 대기하며 존재한다.
  - 패킷의 도착률이 다시 링크를 통해 나가는 링크를 초과하는 경우 지연이 발생한다.
  - 패킷은 큐에 들어가고, 자기 차례를 기다린다.

- 지연원인 1. 라우터의 패킷 헤더정보 처리 : 라우터에서 처리할 한계보다 많이들어와서 생기는 Delay
- 지연원인 2. 큐에 넣어두고 대기
- 지연원인 3. 버퍼에 유휴공간이 없으면 큐의 한도크기로 인해 packet drop 으로 인한 loss



HTTP overview

- 서버와 클라이언트 사이의 request/ response로 메시지가 이뤄짐

- 서버는 요청된 파일을 전달할 뿐이므로 stateless Protocol. 상태를 유지하지 않음

- HTTP는 App Layer 프로토콜이므로 Transport Layer에서 TCP의 지원을 받아야 함.

  - 즉, HTTP는 TCP를 사용함.

  - TCP는 reliable한 전송방식

  - HTTP는 **TCP 연결을 재사용하느냐 여부에 따라 2가지 방식**으로 나뉨

    - ##### non-persistent HTTP

      - 최대 한개의 object만이 하나의 TCP 연결로 전송된다.
      - 연결은 바로 끊어진다.
      - 여러 objects를 다운로드하는 것은 여러 연결을 필요로 한다.

    - ##### persistent HTTP (default 채택 in HTTP 1.1)

      - 여러 objects가 서버-클라이언트 간의 단일 TCP 연결에서 전송된다.



#### Sample Problem

- persistent HTTP 사용하면서 pipeline 사용하지 않는 경우
  - Control 메시지(TCP 핸드쉐이크, HTTP 요청 등) 는 **K** bit 길이
  - HTML object 기본 크기 = **L** bits
  - **L** bit 길이마다 **N** 개의 참조 objects 존재.
  - 링크 대역폭 = **R** bps
  - 전파 딜레이 = **d** 초

Ans : 3 way hand shake 에 마지막에는 data를 포함한다.

1) [client -> server ] TCP SYN packet 전송 시간 = **K/R + d**

2) [client <-server ]  SYN+ACK 전송시간 = **K/R + d**

3) [client -> server ] HttpRequest + ACK = **K/R + d**

4) [client <- server ] 요청 데이터 전송 = **L/R + d**

5) [client -> server ] N개의 참조 객체에 대해 파이프라인 없이 요청+전달 = **2(L/R+d) * N**개

​	- 파이프라인 적용시 한번에 N개 내보낼 것이므로 <u>2(L/R+d)</u>



**HTTP Proxy**

**DNS** 

**UDP vs TCP**

UDP :  header의 필드 4개 (소스포트/목적지 포트/헤더포함한 세그먼트 길이/오류 파악 위한 체크섬)

- App Protocol인 DNS, SNMP 등 에서 사용

- 손실에 둔감하고, 전송률에 민감한 통신에서 사용
- reliable transfer over UDP : **Add reliability at application layer**



#### Reliable Data Transfer 원칙 

- RDT가 필요한 이유 : UDP가 unreliable하므로

  - unreliable한 경우 
    - 1) 패킷 에러를 위한 매커니즘
      - **에러 탐지** -> **피드백** -> **재전송** & 재전송 여부 구분위한 **sequence number #**
    - 2) 패킷 손실을 위한 매커니즘
      - **timeout** 을 두고, loss로 판단.

- Pipelined protocols

  - 파이프라이닝 : 패킷의 도착여부를 몰라도 Sender가 패킷 여러개를 전송상태로 두는 것을 허용하는 방식
    - seq # 의 범위는 증가해야 한다.
    - sender/receiver의 버퍼링이 문제가 될 수 있따.
  - 파이프라이닝 프로토콜을 위한 두가지 일반적인 형식 : GBN, selective repeat
    - GBN 장점
      - 동작이 단순. 
      - 리시버는 저장공간 필요 없음. 
      - 단순히 하나의 ACK만 기다림 (ACK(n)은 누적한 n개의 정상도착을 의미)
      - 하나의 timeout만 관리
    - GBN 단점
      - 하나의 패킷 k를 손실시, **k부터 seq #가 k보다 큰 window 내의 모든 패킷을 재전송**하므로 오버헤드가 크다.
  - Selective Repeat
    - 리시버가 개별적으로 모든 수신된 패킷을 확인한다.
    - sender는 ACK를 수신하지 못한(유실된) 패킷만 재전송한다.
    - Selective Repeat 장점
      - 유실된 패킷만 재전송한다.
    - Selective Repeat 단점 
      - 리시버가 좀 더 지능적이어야 함
      - 저장공간 크게 확보 필요.
      - Sender는 모든 unACKed 패킷마다 timer를 지녀야 함.

- #### TCP Overview

  - p2p 통신방식
  - reliable통신방식. 순서있는 byte stream
  - piplelined 방식 : TCP 혼잡 제어/흐름제어가 window 크기를 결정한다.
  - send & receive buffers 필요
  - 동일 연결에 양방향 데이터 흐름이 존재한다. 
  - MSS (maximum segment size) 
  - 연결 기반 : sender-receiver간 데이터 전송 이전에 핸드세이크 필요.
  - 흐름 제어 : sender의 전송 데이터량은 receiver의 수신한도를 초과하지 않도록 한다.

- #### TCP segment 구조

  - **source port(16bits) | dest port (16bits)**
  - sequence number(32bits) - segments가 아니라 **data의 bytes를 카운트하여 계산**
  - ack number(32bits) - segments가 아니라 **data의 bytes를 카운트하여 계산**
  - headlen | not used bit | URG | ACK | PSH | RST | SYN | FIN | 이상 16bits | Receive window (수신 가능한 바이트 크기)
  - **checksum (16bits )** | Urg data pointer (16bits)
  - Options(가변 길이)
  - application data (가변길이)

- ##### TCP의 ACK는 누적된 정상 수신을 의미

  - 중간에 ACK 몇개 유실되도 timeout 내에 마지막 ACK만 제대로 오면 정상 작동 



#### Fast Retransmit

- **timeout** 은 종종 패킷 손실을 파악하기에 <u>상대적으로 길다</u>는 문제가 있다.
  - 손실 후 재전송까지 오랜 delay가 요구됨
- 패킷 유실을 빠르게 판단하기 위함
  - sender는 종종 많은 segments를 반복적으로 보낸다.
  - 만약 segment가 유실되었다면, 많은 중복된 ACKs가 있을 것이다.
- 만약 sender가 동일 데이터에 대해 3개의 ACK를 받았다면, ACKed 데이터 후의 segment가 유실되었음을 추정할 수 있다.
- 패스트 재전송은 timeout 이전에 이러한 유실을 파악하여 세그먼트를 재전송하는 기법을 말한다.



---



### Sample problem of fast retransmit

- Draw a detailed packet-exchange diagram (e.g, seq#, ack#) until the reception of complete file 
  - Assume that TCP connection has been established between A and B
  - Host A will transmit **600-byte** file
  - The **seq#** of the first data packet(from A) = **300**
  - All data packets are **100 bytes**
  - Window size = **1000** **bytes**
  - Retransmission timeout = **500ms**, RTT = **50ms**
  - **Second data packet is lost**. (두번째 패킷은 유실)
  - Host A uses <u>fast retransmit.</u>



**Sender : A, Receiver : B**

**600 Bytes / 100 bytes** = 패킷은 **6개**

**window size = 1000 bytes** 이므로 window 하나에 넣어서 보낼 수 있음

첫번째 패킷의 seq = 300~399, 400~499, 500~599, 600~699, 700~799, 800~899

##### [A가 하는 일]

timer가 첫번째 패킷에서 세팅. (500ms)

- RTT 50ms 이므로 최소 5번 오고가는것 까지 여유

이후 패킷 전송

##### [B가 하는일]

A가 보낸 두번째 패킷이 유실되면 B는 ACK 400 보낸다.

A가 보낸 세번째 패킷 (500)이 도착하면 B는 ACK 400 보낸다.

- recv buffer에 500 저장

A가 보낸 네번째 패킷 (600)이 도착하면 B는 ACK 400 보낸다.

- recv buffer에 600 저장

A가 보낸 다섯번째 패킷 (700)이 도착하면 B는 ACK 400 보낸다.

- recv buffer에 700 저장

A가 보낸 여섯번째 패킷 (800)이 도착하면 B는 ACK 400 보낸다.

- recv buffer에 800 저장

...

##### [A가 하는 일]

1) [정상수신] B가 보낸 첫번째 ACK (400)가 도착하면 A는 timer를 2번째 패킷으로 옮긴다.

2) [3dp 의 1st] B가 보낸 두번째 ACK (400)가 도착하면 A는 하는 일 없음

3) [3dp의 2nd] B가 보낸 세번째 ACK (400)가 도착하면 A는 하는 일 없음

4) [3dp의 3rd] B가 보낸 네번째 ACK (400)가 도착하면 A는 재전송을 한다.

- A가 seq 400 전달
- B는 이를 받고 recv buffer에 400을 넣는다.
- B는 이후에 **ACK를 900** 보낸다. (나머지는 버퍼에 저장하고 있으므로.)

****



#### TCP 혼잡제어 : 점진적으로 증가, 기하적으로 감소 전략

- Congestion Window Size를 손실 탐지 전까지 **매 RTT마다 1MSS 만큼 증가**.

- 손실 탐지 후 Congestion Window Size 를 **절반으로 줄임**

- 패킷 손실의 원인이 timeout 이라면 1 MSS 로 줄인다.
- 패킷 손실의 원인이 3 dup ACK라면 **Congestion Window Size**를 
  - Reno : 혼잡 직전의 Threshold 만큼 줄인다. Threshold 갱신
  - Tahoe: 1 MSS로 줄인다. 