## Application Layer 2 

- 각 Layer는 하위 Layer로부터 서비스를 제공받고, 상위 Layer에 서비스
- UDP는 checksum을 통한 **1) 에러 체크**, **2) multiplexing / demux**를 제공한다.
- TCP는 UDP가 제공하는 기능 외에도 연결을 위한 혼잡제어 등을 수행한다.
  - reliable data transfer를 위해 transport layer에서 수행하는 작업에 대해 알아보자.
  - transport layer 하위 layer에서의 작업들은 unreliable하다!





### Principle of Reliable Data Transfer

- unreliable channel에서는 **[ 메시지 에러/ 메시지 손실 ]**과 같은 일이 발생한다.

- Reliable Data Transfer protocol 이 필요.
- RDT protocol은 각 state에 따라 정해진 action을 취하는 방식으로 구성됨.

<img src="./images/스크린샷 2019-10-03 오후 5.37.29.png" width="500px">

### Rdt1.0 : 완벽한 채널에서의 데이터 전송 (비현실적)

- 패킷에러 존재하지 않음
- 패킷손실 없음
- 보내는대로 다 갈 것



### Rdt 2.0 패킷에러가 가능한 채널(손실은 없음)

 에러를 처리하기 위해 필요한 매커니즘은 ?

- #### 에러 탐지 

  - checksum bits를 추가한다.

- #### Feedback 을 준다.

  - Acknowledgements (ACKs) : 리시버가 센더에게 패킷을 정확하게 수신했음을 알리는 신호를 보낸다.
  - Negative Acknowledgements (NAKs) : 리시버가 센더에거 패킷이 에러를 지님을 알린다.

- #### 재전송

  - 센더는 NAK 수신한 패킷을 재전송한다.



##### 즉, 아래와 같은 매커니즘이 필요하다.

> 에러 탐지
>
> 피드백(ACK/NACK)
>
> 재전송



##### 그런데, 이걸로 충분한가?

#### Rdt 2.1 : 피드백에 에러가 있다면?

- `센더` 가 데이터 보내고, `리시버` 가 **피드백(ACK)**을 줄 때, **에러 발생**한다면?
- `리시버` 가 피드백에서 ACK를 보냈는지 NAK를 보냈는지 모른다면, `센더` 는 **중복 패킷(Duplicate packets)을 보내는 행동을 취한다.**
- 그런데, `리시버` 는 그 패킷이 이전 패킷과 중복되는 패킷인지 알 수가 없다.
- 따라서, `sender`는 애초에 응답을 보낼 때, `sequence number` 를 같이 추가하여 보낸다.
- 그렇다면 리시버는 중복 패킷을 수신 후, 그냥 버린다.

<img src="./images/스크린샷 2019-10-03 오후 5.45.21.png" width="500px">

### Rdt2.1 : 패킷 에러 요약

#### Sender

- 1) seq # 추가 : seq #를 패킷에 추가한다.
- 2) 피드백 오류 체크 : 수신한 ACK/NAK에 오류 발생 여부를 체크한다.
- 3) 재전송 : NAK나 오염된 피드백에 대해 재전송을 실시한다.

#### Receiver 

- 1) 중복 패킷 검사 : 수신한 패킷이 중복된지 검사한다.
- 2) 정상수신 혹은 재전송 피드백 : 정상 패킷 수신의 경우 ACK, 패킷이 오류난 경우 NAK를 sender 에 전달한다.

<img src="./images/스크린샷 2019-10-03 오후 5.49.32.png" width="500px">

#### sequence number의 상한

- 무한대로 커지나 ? x 
- 단순하게 패킷을 1개씩 보내는 상황에서는 seq number는 2개 (0,1)면 충분하다. (이전 것을 제대로 받은 경우에 0 -> 1, 1->0으로 다음 seq를 설정 )



### Rdt 3.0 : loss & packet errors 가능한 채널

- 패킷 손실(loss) 에 대해 취할 매커니즘 ? 
  - **타이머!**
- Sender는 합리적인 수준으로 ACK를 기다리는  `Time-out` 을 설정하고 기다린다.
- 패킷(or ACK)가 단지 딜레이 상황이라면..
  - 타이머를 짧게 잡은 경우, **패킷 재전송**이 이뤄진다. 
  - 재전송된 패킷은 **중복 패킷**이다. **그러나 seq # 사용으로 이를 커버할 수 있다.**



<img src="./images/스크린샷 2019-10-03 오후 5.56.53.png" width="500px">

<img src="./images/스크린샷 2019-10-03 오후 5.57.17.png" width="500px">



### Rdt 3.0의 성능 측정

- 1 Gbps 링크로 연결되어있고, e-e prop, delay에 15ms가 소요. 패킷의 크기는 1KB라면
- Transmit 시간 = L (packet 길이) / R(전송률, bps) = 8kb/pkt **/** 10^9 b/sec = 8 microsec
- U(utilization) = 전체 시간중에서 센더가 네트워크를 사용하는 비율 
  - 효율성 측면에서, U는 크면 클 수록 좋다. 

<img src="./images/스크린샷 2019-10-03 오후 5.58.37.png">

<img src="./images/스크린샷 2019-10-03 오후 6.07.35.png">

#### Stop - and - wait operation

- sender의 패킷의 첫번째 bit가 전송될 때 (t = 0 )

- sender의 패킷의 마지막 bit가 전송 될 때(t = L/R)

- RTT : 마지막 bit 전송으로부터 ACK 도착까지의 시간

- 다음 패킷을 보내는 시각(t)의 base는 **= RTT + L/R** 이다. 

  - 다시 next packet의 마지막 bit 전송은 (t = RTT+2L/R ) 이 된다.

- 따라서 **센더의 Utilization**은 전체 시간 **(RTT+L/R) 분의 L/R**이다.  

  - U sender = ( L / R ) **/** ( RTT+L / R) = .008 / 30.008 = 0.00027
    - 매 30msec 마다 1KB pkt 전송 -> 1Gbps 링크에 대해 33kB/s  소요
    - 네트워크 프로토콜이 물리작 자원의 사용을 매우 제한하는 구조이다.

  

### Pipelined Protocols

- TCP는 파이프라이닝된 프로토콜들로 작동된다.
- pipelined protocol을 형성하기 위해 일반적으로 다음의 2가지 방식으로 작동한다.
  - 1) go-Back-N 방식
  - 2) selective repeat 방식

<img src="./images/스크린샷 2019-10-03 오후 6.06.37.png">

### 1) go-Back-N 방식

| 0 - 1 - 2 - 3 | - 4 - 5 - 6 - 7 - 8 - 9 - ..

window = 4

  각각 패킷 사이에는 타이머가 존재.

- Sender는 한번에 많은 양의 패킷을 피드백 없이 몰아 보낸다.

- window = **ACK 피드백 없이 보내는 패킷의 크기**를 의미

- window size = 4라면 0,1,2,3 패킷은 ack 수신없이 한번에 전송한다.

- ACK(n) : ACKs는 n을 포함한 모든 패킷에 대해 누적해서 정상 수신했음을 말한다. 

  - ex ACK 11 : 0~11번 패킷까지 정상수신 완료했다. 12번 달라.

  - ##### 만약 위 예제에서 ACK(3) 이전에  timer 0 이 timeout 되었다면, 0~3 패킷을 재전송하게 된다.

##### GBN에서 리시버는 순정파이다. 본인이 기다리는 패킷이 아닌 다른 것이오면 버린다.

- 가령 PCK 0 수신 후, ACK 0 보내고, PCK 1 기다리는데, PCK 2가 먼저오면, ACK 0을 피드백으로 보내고, PCK 2는 drop 한다.
- 이후에 PCK 1이 오면 ACK 1을 보내고, PCK 2를 기다리는데, PCK 3이 오더라도 ACK 1을 센더에 전달한다.



#### GBN in Action

- PCK 0을 기다리는 동안 timer 0 이 작동한다. 

  - 수신 후 ACK 0 보낸다. timer는 1로 바꾸고 그에 따라 window size 4의 범위도 1~4가 된다.

- PCK 1을 기다리는 동안 timer 1 이 작동한다.

  - 수신 후 ACK 1 보낸다. timer는 2로 바꾸고 그에 따라 window size 4의 범위도 2~5가 된다.

- PCK 2을 기다리는 동안 timer 2 이 작동한다.

  - PCK 2를 기다리는데, PCK 3오면, 받고, 버리고 ACK1 보낸다.
  - PCK 2를 기다리는데, PCK 4오면, 받고, 버리고 ACK1 보낸다.
  - PCK 2를 기다리는데, PCK 5오면, 받고, 버리고 ACK1 보낸다.

- PCK 2의 timer가 timeout되었다. 

  - Sender는 2부터 모든 패킷을 재전송한다.

  

- 만약 중간에 window가 3~6으로 설정되었을 때, **PCK 6을 유실했다**고 하자.
- PCK 3 수신 -> ACK 3, window는 [4,5,6,7]
- PCK 4 수신 -> ACK 4, window는 [5,6,7,8]
- PCK 5 수신 -> ACK 5, window는 [6,7,8,9]
- PCK 6이 손실 -> ACK 5  window는 [6,7,8,9]
- PCK 6이 손실 -> ACK 5  window는 [6,7,8,9]
- PCK 6이 손실 -> ACK 5  window는 [6,7,8,9] 
- PCK 6이 손실 -> ACK 5  window는 [6,7,8,9]
- PCK 6이 손실 -> ACK 5… timeout 6 발생
- 현재 sender는 (정상단계라면) [10,11,12,13] 를 보내려고 하는 타이밍에 timeout 6 발생한다. 따라서 window Size=4 만큼 이전으로 돌아가서 **6부터 다시 보낸다.**
- window는 한번에 보내는 패킷의 양을 의미하기도하지만, receiver가 해당 패킷을 받았는지 확실하지 않은 패킷들을 의미하기도 한다. 따라서 재전송 시점의 패킷묶음이 된다.



- 단, GBN은 **window 사이즈가 클 수록 비효율적으로 작동**하게 된다.



![img](/Users/hw/CodeSquard/ComputerSciences/Network/images/스크린샷 2019-10-03 오후 6.21.47.png)

---

### 2) selective repeat 방식

- **유실된 패킷에 대해서만 재전송**하는 것을 선택적으로 반복하는 방식
- 리시버는 모든 정상 수신 패킷에 대해 개별적으로 ACK를 보낸다.
- GBN의 ACK (11) 처럼 누적한 ACK를 보내는 것이 아니라 **개별 패킷 ACK 11을 의미**하게 된다.
- 센더는 **수신되지 않은 ACK에 대해서만 패킷 재전송을 실시**한다.
- 센더는 **모든 unACKed 패킷에 대해 타이머를 작동**시킨다.



#### Selective repeat in Action 

- 센더가 전송하는 **2번 패킷이 리시버에게 오기 전에 유실**되었다.
- 리시버는 **3번 패킷부터는 수신하면 버퍼에 저장**하고 각각 ACK 3~5를 보낸다.
- 센더는 <u>2번 패킷의 ACK 2를 받지 못하여 timeout </u>발생. **<u>2번 패킷만 재전송</u>**한다. 
- 리시버는 **2번 패킷을 수신후**에, window size = 4이므로 **버퍼에서 3~5 패킷을 꺼내서** **패킷 2,3,4,5가 상위 레이어로 전달**된다. ACK 2를 보낸다.

<img src="./images/스크린샷 2019-10-03 오후 6.39.38.png" width="500px">

#### Selective repeat의 딜레마

- 상황1 : **window size (N)에 대해** **seq # (N+1) 사용시 문제 발생**

  - 최소한의 범위를 가진 seq #를 제공해야 header field 크기가 작아진다.
  - 가령 window size = 3 일때, seq #를 4개 사용한다고 보자. (0,1,2,3)

  - pkt 0 수신, pkt 1 수신, pkt 2 수신이 이뤄질 때, 각각에 대해 ACK 0,1,2가 sender에게 도달하지 않는 상황이라고 보자.

  - receiver 의 window는 [ 3, 0, 1 ] 을 설정해두고있다.

  - 이 상황에서 timeout 발생으로 재전송이 이뤄지면 sender에서 전송하는 것은 [0,1,2] 가 되는데, 리시버는 이 0을 3 다음의 0으로 인식할 수 있다. 즉, 재전송되는 패킷 윈도우(슬라이드 a 상황)를 새로 전송되는 패킷윈도우(슬라이드 b 상황)로 착각하는 문제가 발생

  - #### **결론. seq # 는 최소한 window size의 2배보다 커야 한다.**

- window size 별로 seq #를 늘린다? 

  - 헤더필드 최소화 제약에 의해 최선의 방법이 아니다.

  - **Selective Repeat 방식의 seq size(K)와 window size(N)**를 안전하게 이용할 수 있는 관계는 ?

  - **K = 2*N** (즉, maximum seq #(K)의 절반 >= maximum window size(N) ) 이 되어야 **window에 의한 seq # 중복을 방지**할 수 있다. 



### GBN의 경우 Seq # 크기와 window size

- maximum window 크기는 **seq # - 1 범위까지** 

- 만약  transport protocoll that uses pipelining and use a **8-bit** long sequence number (0 to 255) 라면, 
- **GBN의 max window size (w)** = seq # - 1 =  **2^8 -1**  = **255**
- seq # = 256개 (0~255)

- maximum window size(w) = maximum number of unique sequence numbers - 1.