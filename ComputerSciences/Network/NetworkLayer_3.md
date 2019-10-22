# Network Layer 03

- IPv4는 1975년 도입
  - 주소공간 부족 문제
  - 보안 문제

## NAT

- 라우터에서 동작하는 기법



<img src="./images/NetworkLayer/스크린샷 2019-10-12 오후 2.08.55.png" width="500px" >



- 내부적으로 동작하는 host의 ip를 **Public IP로 변환**하여 외부 WAN과 통신
- **리턴 패킷은 Public IP로 반환**되므로 라우터에서 이를 처리하여 host로 전달한다.



### Layering Violation 발생

- IP 주소 / Port 변경으로 인해 src ip/port와 일치하지 않는 문제가 발생

- 라우터가 port 넘버를 보존하지 않음
  - 네트워크 계층은 IP header 에 대해서만 신경쓴다. port number는 신경쓰지 않음
- End-toEnd 요소를 침해
  - 네트워크의 노드들이 packet 정보를 바꾸기 때문
- 보안을 염두한 IPv6가 더 나음..

### IPv6(1996) 으로 갈지 새로운 방향(Future Internet Architecture)으로 갈지 아직 미정





-----

----



## Dynamic Host Configuration Protocol (DHCP)

IP : **192. 168. 1**. 47    :     (**Network ID** / hostID)

mask : **255. 255. 255.** 0

route : **192. 168. 1. 1** : host의 바로 앞에 존재하는 first router의 ip 주소. **host ID의 1번에 위치**한다.

DNS : **192. 168. 1. 1** : Local Name Server의 IP 주소. 

- DNS 주소와 route 주소가 같다? : router 내부에 LNS가 동작하고 있음을 알 수 있다.



## DHCP



- host가 네트워크에 들어올 때, IP를 `동적으로 지정`하는 역할을 담당한다.

- IP는 active한 정도만큼만 필요. (Address Pool을 통해 유연하게 재사용가능)
  - 단, 할당한 IP주소를 일정시간 후에 회수 함. 
  - 할당한 주소가 connected on 상태일때 재사용 허락
  - 더 필요하면 재요청/재할당
  - 모바일 유저들에게도 지원. (더 짧은 주기로)

#### DHCP overview

- [선택사항] 호스트는 DHCP **discover** 메시지를 broadcast 한다.
- [선택사항] DHCP 서버는 DHCP **offer** 메시지로 반응한다.
- 호스트는 IP 주소를 요청한다. DHCP **request** 메시지로 요청
- DHCP 서버는 DHCP **ack** 메시지로 주소를 전달한다.



#### cf. 고정 IP정책

- host 마다 IP가 필요



### DHCP client-server scenario

<img src="./images/NetworkLayer/스크린샷 2019-10-12 오후 3.13.58.png" width="500px" >

<img src="./images/NetworkLayer/스크린샷 2019-10-12 오후 3.14.02.png" width="500px" >

#### 1) DHCP discover 메시지 

- 클라이언트에서 DHCP 서버 (223.1.2.5) 로 요청 메시지 전달
  - source : 0.0.0.0, 68
  - dest : 255.255.255.255, 67
    - 모든 address 주소가 1, 즉 **서브넷마스크가 모두 1인 경우**는 **broadcast를 의미**한다.
    - **broadcast** 라면 **subnet의 모든 멤버 device에게 전달**하는 요청 메시지이다.
    - DHCP 서버의 포트번호는 67번이다.
  - yiaddr: 0.0.0.0
  - transactionID: 654
    - 호스트에서 랜덤 설정한 번호

- 브로드캐스트된 메시지를 다른 디바이스들은 무시한다. (DHCP 서버만 반응)
  - how to? : DHCP 서버의 67번 포트만 listen중이므로 / 나머지 디바이스는 67번포트 잠겨있으므로 drop

#### DHCP offer

- DHCP 서버도 broad cast를 시전한다.
  - why? : 어느 장비에서 브로드캐스트로 요청을 했는지 모르므로.
    - 단지, 요청에서 설정한 transaction ID를 같이 보내므로, 해당 요청한 호스트는 자기에게 오는 메시지임을 식별한다.
    - src: 223.1.2.5.67
    - dest: 255.255.255.255 68
    - **yiaddrr: 223.1.2.4** // 호스트에게 동적으로 할당한 주소
    - transaction ID : 654 // 호스트 식별을 위한 트랜잭션 아이디
    - lifetime: 3600 secs // 호스트에게 부여한 대여 시간



#### DHCP request

- **offer에 대한 응답으로 IP 요청을 날리는 단계**. <u>아직 동적으로 할당된 IP를 확정된 상태가 아니다.</u>
  - 따라서 src : 0.0.0.0 68 그대로 사용
- dest : 255.255.255.255 67 // 브로드캐스트로 요청
- yiaddr: 223.1.2.4 // DHCP 서버가 제공하려는 주소에 대해 
- transaction ID : 655 // **새로운 트랜잭션 아이디 = offer 트랜잭션 아이디+1 설정**
- lifetime : 서버가 설정한 유효한 IP주소 임대 시간



#### DHCP ACK

- 서버가 요청에 대한 응답을 하는 단계
- DHCP offer와 동일, Transaction ID만 request와 동일하게



#### why offer가 아니라 ack에서 실질적으로 할당하는가?

- DHCP 서버가 여러개 존재 가능. 
  - 호스트의 discover에 대해 각 DHCP서버가 offer를 제공하므로 **request를 통해 이중에서 하나를 선택하는 방식**이다.
  - 다른 DHCP 서버들도 간접적으로 이를 알 수 있다.



### Gateway Router가 수행하는 역할들

- #### Name server (DNS)

- #### DHCP 

- #### 포워딩 (포워딩 테이블)

- #### NAT (네트워크 주소 변환 기법)

- #### Firewall (방화벽)



### DHCP 예제

<img src="./images/NetworkLayer/스크린샷 2019-10-12 오후 3.28.09.png" width="500px" >

<img src="./images/NetworkLayer/스크린샷 2019-10-12 오후 3.55.40.png" width="500px" >

----

### cf. IP datagram format

#### IP datagram overhead (min 40 bytes)

 = 20 bytes of TCP header 

`+` 20 bytes of IP header

`+` app layer overhead



## IP fragmentation , reassembly

#### Maximum Transfer Unit ( MTU )

- Link 별로 전송 가능한 최대 단위를 의미
- 링크별로 다를 수 있다. 
- 처리할 수 있는 MTU 보다 더 큰 사이즈가 들어오면 현재 링크의 MTU 에 맞게 분리 전송 후 재조립한다.



##### Ex) 4000 bytes 패킷이 MTU 1500 bytes인 링크를 만난다면 (header = 20 bytes라고 가정)

##### 3980 bytes를 3묶음으로 분할. header=20bytes는 세 파편에 공통으로 적용

<img src="./images/NetworkLayer/스크린샷 2019-10-12 오후 3.55.44.png" width="500px" >

**|0~1479|**

length = 1500, ID=x로 동일, frag flag = 1(뒤에 파편 존재함), offset = 0 

**|1480~2959|**

length = 1500, ID=x로 동일, frag flag = 1("" ), offset = 185 (=1480/8)

**|2960~3980|**

length = 1040, ID=x로 동일, frag flag = 0 (뒤에 파편 없음 ), offset=370(=2960/8)



##### 만약 3개 중 하나 유실되면 reassembly가 되지 않으므로 timeout -> 그냥 전체 패킷을 다시 재전송요청