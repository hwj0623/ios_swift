# Network Layer 04



## 4.4 ICMP : Internet Control Message Protocol

> 사용자 데이터에 관한 것이 아닌, **네트워크 내에서 데이터 운반을 위한 프로토콜**

호스트와 라우터에서 네트워크 수준의 정보를 다루기 위해 사용된다.

- **에러 보고 :** 호스트/네트워크/포트/프로토콜 도달불가능에 대한 
- **echo 요청/응답 (ping)**

ICMP 메시지는 IP datagram 내에서 운반된다.

- IP datagram의 type, code + 처음 8 바이트로 에러 유형을 알린다.

<img src="./images/NetworkLayer/스크린샷 2019-10-12 오후 4.12.34.png" width="300px" >

## IPv6

- 현존 인터넷은 IPv4이므로 알고만 넘어가자.

### IPv6 동기

- 32비트 주소 공간의 추가할당 부족
- 추가적인 동기
  - 헤더포맷이 프로세스/포워딩 속도를 돕는다
  - 헤더포맷의 변화가 QoS(Quality of Service) 를 촉진함

### datagram format

- 고정 길이 40byte 헤더
- fragmentation 허락되지 않음



### IPv6 datagram format

<img src="./images/NetworkLayer/스크린샷 2019-10-12 오후 4.21.01.png" width="500px" >

#### IPv4에서의 다른 변화들

checksum : 각각의 hop의 처리 시간을 줄이기 위해 제거됨

options: 헤더 내부가 아닌 (다음 헤더 필드를 지칭하면서) **헤더 외부에서 허용**됨. 

ICMPv6: 새로운 ICMP 버전 



#### Transition from IPv4 to IPv6

- 모든 라우터를 동시에 업그레이드하는 것은 불가
- 터널링: IPv6 데이터 그램은 IPv4 라우터 사이에서 IPv4의 형태로 운반되어야 한다.



### Tunneling

<img src="./images/NetworkLayer/스크린샷 2019-10-12 오후 4.24.46.png" width="500px" >





## 4.5 routing algorithm

- forwarding table - longest prefix match로 탐지

- ##### but how to init local forwarding table entries ? - routing algorithms



- 라우팅 알고리즘이 네트워크의 end to end 경로를 결정



### 그래프 추상화

node :  라우터

edge : 링크

목적지까지의 최소비용 경로 구하는 문제



### 라우팅 알고리즘 분류

1) Global or decentralized information

- Global: 네트워크 상황을 전부 아는 방법

  - 모든 라우터는 완전한 토폴로지를 보유. 링크 비용 정보를 보유

  - #### link state  알고리즘

- decentralized: 이웃간의 정보를 통해서만 파악하는 방법

  - 라우터는 물리적으로 연결된 이웃으로의 링크 비용만 파악

  - 반복 연산 프로세스로 이웃과 정보를 교환 

  - #### distance vector 알고리즘



### Link state 알고리즘

- 다익스트라 알고리즘을 활용
- link costs는 모든 노드들에 의해 알려져있다.