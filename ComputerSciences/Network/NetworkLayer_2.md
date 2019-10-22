# Network Layer 02

## IP datagram format (총 20 bytes)

- <img src="./images/NetworkLayer/스크린샷 2019-10-12 오전 11.10.41.png" width="500px" >
- IP protocol version number** : IPv4 or IPv6 

- **head length** 정보

- **type of service** : data의 "type" 정보

- **length** : 전체 datagram 길이 (bytes) 정보

- **16-bit identifier / flags / fragment offset**  : fragmentation 혹은 reassembly 를 위한 정보들
- IP source address (32 bits or 128 bits )
- IP Destination address ("")
- **Time To Live (TTL)** : sender가 정한 수에서 router를 거칠때마다 -1씩 감소시켜서 0이 되는 순간 패킷을 버린다. 
  - network 상에서 어떠한 일이 잘못되어, 무한 루프를 도는 것을 방지하기 위해 한정시간 동안만 네트워크에 존재하도록 하기 위함.
- upper layer : receiver 측에서 사용. TCP로 올릴지, UDP로 올릴지 구분하기 위함.
-  options (if exists) 

- data (TCP or UDP segment)





- ##### cf. TCP Header도 20 bytes 이다.

- **40 bytes 패킷** == ACKs (no data)



## IP Address (IPv4)

- unique한 **32-bit** 숫자
- interface( on a host, on a router,..)를 식별한다.
  - IP주소는 **host 내의 network interface를 지칭하는 주소**이다.
- 8-bit 마다 `.` 구분으로 표현

<img src="./images/NetworkLayer/스크린샷 2019-10-12 오전 11.33.34.png" width="500px" >

### IPv6

- **128 bit** 숫자



### Grouping Related Hosts

- 인터넷은 "inter - network"
  - 호스트가 아니라, 네트워크를 연결하기 위해 사용
    - 호스트를 연결하는데 라우팅 테이블 사용시 라우팅 테이블이 무지막지하게 커짐
  - 호스트 그룹인 `network` 을 위한 주소체계가 필요
- IP 주소는 **`network ID(주소) + host ID(주소)`** 로 구분한다.

- 같은 네트워크에 속하는 host 들은 같은 network ID를 갖는다.

<img src="./images/NetworkLayer/스크린샷 2019-10-12 오전 11.44.18.png" width="500px" >

### Scalability Challenge

- host가 무차별적인 주소를 지니고 있다고 가정해보자
  - 모든 라우터는 각 호스트 별로 직접 패킷 전달방향을 지시하기 위해서 매우 큰 **forwarding table** 을 보유해야 한다.



### Hierarchical Addressing: IP Prefixes

- IP 주소는 네트워크/호스트 부분으로 나뉜다.

- **12.34.158.0/24** 는 24-bit를 prefix로 사용

  - prefix는 host 주소 부분을 말한다.
  - 즉 12.34.158이 하나의 네트워크 주소가 된다.
  - **prefix ID = subnet ID = network ID**

- IP 주소의 networkID/hostID 구분은 `Subnet Mask` 를 통해서 한다.

- IP 주소가 **12.34.158.5 이고, Mask가 **255.255.255.0** 이라면, 

  - **연속하는 1로 이루어진 255.255.255 부분이 네트워크 ID**에 해당한다.

- 라우터의 **포워딩 테이블**은 **네트워크 ID에 해당하는 정보**만 담아둔다. 

  - 새로 추가되는 host는 임의의 host ID를 부여하면 되므로

  

<img src="./images/NetworkLayer/스크린샷 2019-10-12 오전 11.53.24.png" width="500px" >

### Class A(/8), Class B(/16), Class C(/24)

#### Class A

- network ID 마다 이론상 host 주소가 2^24 개 확보 가능

- network ID = 128 기관 한정

  - 인터넷 선구자에 의해 선점됨 (e.g MIT = 18.0.0.0/8)

  <img src="./images/NetworkLayer/스크린샷 2019-10-12 오전 11.53.15.png" width="500px" >

#### Class B 

- 2^16개 호스트 주소
- 2^16개 기관에 네트워크 할당
  - 다 할당됨 (e.g. Princeton = 128.122.0.0/16)

#### Class C

- 2^24 네트워크 주소 할당 가능

- 2^8 = 255개 호스트 주소



90년대 중반에 class 개념 개선한 CIDR 방식 도입

### Classless Inter-Domain Routing (CIDR)

- 정해진 크기 없이 네트워크의 크기에 맞춰서 네트워크/호스트를 구분
- **a.b.c.d/`x`** 에서 `x`는 IP 주소에서 subnet bits의 영역을 의미 
- ex ) `/22` ==> 1024개 호스트 할당 가능 
- Network number = IP address + Mask

- 필요한 호스트에 맞게 forwarding table의 크기가 결정됨

<img src="./images/NetworkLayer/스크린샷 2019-10-12 오후 1.37.36.png" width="500px">

### Seperate Forwarding Entry Per Prefix

#### Prefix-based forwarding

- Network prefix 별로 Forwarding Entry를 구분

- prefix가 매칭되는 목적지 주소로 매핑한다.

  - outgoing interface로 포워딩 

  <img src="./images/NetworkLayer/스크린샷 2019-10-12 오후 1.40.54.png" width="500px" >

#### CIDR의 문제 : Packet Forwarding을 힘들게 한다

- Forwarding table은 많은 일치관계에 놓일 수 있다. 
- 가령, 포워딩 테이블 내의 엔트리들인 201.10.0.0/21 과 201.10.6.0/23에 대해 
- IP 주소 **201.10**.6.17은 둘다에게 매칭된다.

- 이를 극복하기 위해 나온 **포워딩 매칭 방식이 Longest Prefix Match** 이다.

<img src="./images/NetworkLayer/스크린샷 2019-10-12 오후 1.42.56.png" width="500px" >





### Longest Prefix Macth Forwarding

- 목적지 기반 포워딩
- 패킷이 목적지 주소를 가진다.
- 라우터는 가장 긴 prefix 매칭을 확인한다
- Cute 알고리즘 문제 : 매우 빠르게 조회 가능



<img src="./images/NetworkLayer/스크린샷 2019-10-12 오후 1.44.47.png" >

포워딩 테이블에서 201.10.0.0/21 을 먼저 검사 

destination IP = **201.10.0000**0110.00001001

**|201.10.00000|(prefix)**000.00000000 

- prefix 일치

다음에 201.10.6.0/23 검사

**|201.10.00000110|**0.00000000

- prefix 일치

= > prefix가 가장 큰 /23 을 따라 outgoing link를 연결한다.





### Subnet 

- **같은 인터페이스( same subnet ID ==same prefix)를 가진 device의 집합**
- **라우터를 거치지 않고 접근이 가능한 host 들의 집합.**

- subnet ID / subnet part - 높은 위치의 bits 
- host poart - 낮은 위치의 bits





## Network Address Translation (NAT)

### NATs 역사

- IPv4 기반의 IP 주소공간은 부족

  - IPv6 (1996년) = 128bit 주소공간 2^128 bits

- #### 현존하는 IP 주소체계 : IPv4.. How?

  - 현존하는 호스트의 변화없이 <u>새로운 수많은 장비들과 IP주소를 공유</u>하며 IPv4 유지하는 방식

  - short-term 해결책 : IPv6보다 더 많이 보급됨
  - 근본 해결책은 아님..

<img src="./images/NetworkLayer/스크린샷 2019-10-12 오후 2.04.53.png" width="500px" >

- How
  - Outbound : 내부의 host의 source IP Address를 그대로 내보내지 않고, 게이트웨이를 통해 rewrite 하여 내보낸다.
    - host의 IP 주소는 내부적으로만 유효한 src IP 주소이다.
  - Inbound : 목적지 IP 주소를 rewrite하여 host IP 주소로 변경
  - 라우터의 NAT 게이트웨이를 거쳐서 `rewrite` 시에는 Port 번호도 변경해준다. 
    - 라우터에서 외부로 내보낼때 Port 변경하는 것은 내부 host IP의 Port 충돌을 방지하기 위함





<img src="./images/NetworkLayer/스크린샷 2019-10-12 오후 2.07.32.png" width="500px" >

<img src="./images/NetworkLayer/스크린샷 2019-10-12 오후 2.08.55.png" width="500px" >

- network layer device인 라우터(우체부)가 편지봉투를 뜯어서 내용물을 바꾸는 격

- 라우터에 의한 계층 침해, header/data 변경이 이뤄지는 잠재적인 문제

- port 번호를 NAT에서 임의로 변경하는 문제 존재

  - ##### NAT 내부에 있는 네트워크에서는 서버 유지를 위한 port 번호를 사용할 수 없다!!

