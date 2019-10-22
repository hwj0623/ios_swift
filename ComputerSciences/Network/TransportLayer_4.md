# 전송계층 - 4 Congestion Control 



## Congestion Control 접근 방법

2가지 방식이 존재한다.

### 1)  End-to-End congestion control

- **실제 인터넷 구현 방식** **/ TCP 방식**

- 네트워크로부터 명시적인 피드백이 없음

- end system으로부터 관측된 loss, delay에 의해 혼잡을 유추한다.

  

### 2) Network-assisted congestion control

- 라우터가 end system에 피드백을 제공하는 방식
- 단일 비트로 혼잡도를 가리키는 방법 
- sender는 명시적인 rate를 전송시에 제공한다.



----

----



## TCP 혼잡제어 방식은 3가지 주요 phase로 구성

### phase 1) Slow start

- 병목 bandwidth를 모르는 상태이다. 0,1 MSS 부터 시작해서 빠르게 전송량을 늘린다.

- 처음에 느리게 시작하여 **<u>Threshold보다 작을 때는</u> 2배씩 전송량(window size)을 늘린다**.

- 증가 속도는 1,2,4,8…등 exponential 하게 증가한다. 

  - 숫자단위는 **1 MSS(Maximum Segment Size, window size)** 

- ThreshHold에 가까워지면 페이즈 2로 넘어간다.

  - timeout 발생한 크기의 1/2 크기 (threshold) 쯤에 Expo -> Linear로 전환

  

### phase 2) Additive increase

- 임계점(Threshold)에 다가워짐을 알아차린다.

-  <u>Threshhold 지점 이후에는 linear 하게 증가</u>시킨다. 
  - **(손실 탐지 전까지) 매 RTT마다 ** **<u>Congestion Window Size</u>**를 **1 MSS(Maximum Segment Size, window size)**씩 증가시킨다.
- 추가적인 증가로 packet loss등이 유발되면 다음 페이즈로 넘어간다.



### phase 3) Multiplicative decrease

- packet loss를 탐지하면(ACK가 많아지면), **Threshold = CongWin/2**로 줄인다.

- 그리고 **CongWin = Threshold** 로 설정

  

  <img src="./images/TPL_4/스크린샷 2019-10-04 오후 3.54.42.png">

  - y축은 전송량을 의미
  - (파란색은 Tahoe 방식이다. 지금은 안쓰인다. ) loss 발생시점이 12라면 threshold를 8으로 설정. (2/3지점)
    - 패킷 유실시 전송량을 감소시켜서 1 MSS부터 다시 시작
  - Reno 방식 
    - `3 dup ACK에 의한 패킷 손실` 이라면 CongWin = 1/2 CongWin(=new Threshold) 부터 linear하게 시작한다.
    - `timeout에 의한 패킷 손실` 이라면 1MSS 부터 slow start로 시작한다.

  ### Tahoe 방식 vs Reno 방식

  - **Tahoe 방식 (TCP v1)**: Loss 발생시 threshold = loss 직전의 Congestion window의 1/2 크기로 설정한다.
    -  <u>loss의 원인과 상관없이 전송량을 1MSS까지 확 낮춘다.</u> 
    - 다시 2배씩 증가시키는 페이즈 1로 넘어간다.

  - **Reno 방식(TCP v2):** packet <u>loss의 두 원인인 timeout / 3 dup ACK</u>에 대해 심각도 더 큰것은 timeout이다. 따라서 3 dup ACK에 초점맞춘 개선 방식이다.
    - <u>timeout에 의한 패킷 유실이라면</u> Tahoe 방식과 동일하게 **전송량을 현저하게 줄인다.**
    - **3 dup ACK에 의한 패킷 유실이라면 CongWin을 threshold(CongWin/2)부터 linear로 증가시킨다.** (페이즈 1로 가지 않고 페이즈 2로 간다)

  

---

---



### Detail 

**전송 상한선** 

- LastByteSent - LastByteAcked <= Congestion Window

##### 전송속도, 전송률

```tex
Rate = [ Congestion Window / RTT ] Bytes/sec
```

- 가령 1 MSS = 500 bytes & RTT = 200 msec 라면 **slow start의 초기 rate = 20 kbps** 
  - RTT보다는 Congestion Window가 가변적
  - 전송속도는 CongWin에 의해 좌우된다.
  - CongWin은 전체 네트워크 혼잡도에 의해 좌우된다.

##### TCP 처리율(throughput)

- 윈도우 크기와 RTT 함수로써 TCP 평균 처리율 계산

- slow start는 무시하고, 항상 데이터 송신을 가정하여 계산한다.

- **loss 발생시 윈도우 크기가 W**라면 

- **평균 window 크기**  = 3/4 * W

- 평균 처리율은 **RTT 당 3/4 * W**

- 평균 TCP 처리율 = **3/4 * W/RTT**(segment bytes/sec) 가 된다.

  참고 : https://m.blog.naver.com/PostView.nhn?blogId=lyshyn&logNo=221273731113&proxyReferer=https%3A%2F%2Fwww.google.com%2F



#### Sender는 congestion을 어떻게 인지하나?

- `loss event` = timeout 발생 혹은 중복된 3개의 ACKs (총4개)
- TCP sender는 loss event 이후에 rate를 줄인다.
  - AIMD(Additive-Increase, Multiplicative-Decrease) / slow start / conservative after timeout event 







### TCP 공평성 (Fairness)

>  목적 : K개의 TCP 세션이 **대역폭(bandwidth) R의 동일한 병목 링크를 공유**한다고 할 때, 각각의 **이상적인 평균 속도는 R/K** 여야 할 것이다. 

- 실제로도 fair에 근접하게 된다.
- 혼잡에 의해 1/2씩 전송량을 줄이므로(그만큼 다른 유저가 그 부분을 확보할 수 있고) 반복적으로 시간이 흐를수록 모든 유저에게 공평한 대역폭을 할당하게 된다.

<img src="./images/TPL_4/스크린샷 2019-10-04 오후 4.23.55.png" width="500px">



- 정말 공평한가?
  -  TCP 커넥션을 많이 연 유저에게는 그만큼의 몫이 더 많이 할당하게 된다.



----

---





## 세그먼트 구조 Review

<img src="https://t1.daumcdn.net/cfile/tistory/994511465AF2DC262D" width="500px">

#### 1)  **Sourse/Destination Port Number (각 16 비트)**             

- 데이터를 생성한 애플리케이션에서 사용하는 포트번호

- 목적지 애플리케이션에서 사용하는 포트번호

#### 2) **Sequence number** **(32 비트)**             

- 전송되는 데이터의 가상 회선을 통해 데이터의 모든 바이트에는 고유한 일련번호가 부여된다.

- 네트워크가 불안하여 패킷을 **분실, 지연 등으로** **세그먼트가 순서가 어긋나게 도착 할 수 있기 때문에** sequence number를 이용하여 **데이터를 올바른 순서로 재배열** 할 수 있다.

#### 3) **acknowledgement number (32 비트)**             

- 수신하기를 기다리는 다음 바이트 번호 

- 마지막 수신성공 seq 번호 +1 .. 순서로 할당



#### 4) **HLEN = Header Length (4 비트)**             

- 헤드의 길이를 32비트 단위로 나타낸다. 최소 필드 값은 5 (5 * 32 = 160bit or 20Byte )  최대 값 15 (15 * 32 = 480bit or 60byte)

#### 5) 예약 **(6 비트)**             

\- 추후 사용을 위한 예약된 필드

#### 6)  **Flag Bits** 

- 6개의 플래그 비트

- TCP **세그먼트 전달과 관련**되어 TCP 회선 및 데이터 관리 제어 기능을 하는 플래그

- **URG(Urgent)** : Urgent Pointer 필드가 가리키는 세그먼트 번호까지 긴급 데이터를 포함되어 있다는 것을 뜻한다.
  - 이 플래그가 설정되지 않았다면 Uregent Pointer 필드는 무시되어야 한다.

- **ACK(Acknowledgment)** : **확인 응답** 메시지

- **PSH(Push)** : **데이터를 포함한다는 것**을 뜻한다.

- **RST(Reset)** : **수신 거부**를 하고자 할때 사용

- **SYN(Synchronize)** : 가상 회선이 **처음 개설될 때** 두 시스템의 TCP 소프트웨어는 의미 있는 확인 메시지를 전송하기 위해  일련 번호를 서로 동기화해야 한다.

- **FIN(Finish)** : 작업이 끝나고 가상 회선을 종결하고자 할 때 사용

##### 다음의 두 비트는 End to End 혼잡 제어에는 없음

- CWR :(Congestion Window Reduced) – 혼잡 윈도우 크기 감소

- ECN :(Explicit Congestion Notification) – 혼잡을 알림

#### 7)  **Windows Size(16 비트)**

- 흐름제어를 위해 사용하는 필드

#### 8)  **CheckSum** **(16 비트)**

- TCP 세그먼트의 내용이 유효한지 검증하고 손상 여부를 검사 할 수 있다.

#### 9)  **Urgent Pointer** **(16 비트)**

\- TCP 세그먼트에 포함된 긴급 데이터에 대한 마지막 바이트에 대한 일련번호

```
현재 일련번호(sequence number)로부터 긴급 데이터까지의  바이트 오프셋(offset). 
해당 세그먼트의 일련번호에 urgent point 값을 더해 긴급 데이터의 끝을 알수있음
```