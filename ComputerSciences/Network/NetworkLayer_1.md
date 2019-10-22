## Network Layer 01

- 네트워크 계층 서비스 모델들
- **IP 프로토콜** 
- 포워딩 vs  라우팅
- 라우터 작동 방식
- 라우팅 (path selection)
- 브로드캐스트, 멀티캐스트

- instantiation, implementation in the Internet



### Network Layer

- 전송 세그먼트를 수신 호스트로 전송하는 역할을 담당한다.
- 전송측에서는 **segments를 캡슐화하여 datagram으로 내보낸다**.
- 수신측에서는 segments를 transport layer로 운반한다.
- network layer 프로토콜은 모든 호스트와 라우터에 존재
- **라우터는** 자신을 거쳐가는 **모든 IP 데이터 그램의 헤더필드를 검사**한다.



### 라우터의 역할

#### 1) 포워딩

- 라우터의 input으로 받은 패킷을 적절한 router output을 통해 패킷을 옮긴다. 
  - 라우터는 내부에 local **forwarding table**을 지닌다. 
  - header value에 맞는 output link로 보내면 목적지로 정해진 다음 라우터로 이동하게 된다.

- Forwarding Table은 우편번호처럼 분류되어있다.
  - 예시
- Longest prefix matching
  - 주어진 목적지 주소를 FT 엔트리와 비교할 때, **가장 긴 주소 접두사가 매칭**되는 목적지 주소로 **링크 인터페이스를 연결**한다.
    - 여러개 매칭이 되어도 가장 길게 매칭되는 것으로 연결시킨다.



#### 2) 라우팅 

// 추후 설명

