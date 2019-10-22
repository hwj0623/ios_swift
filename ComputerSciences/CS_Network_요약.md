CS_네트워크_요약

### 웹 HTTP 1.1 / 2 특징

[https://medium.com/@shlee1353/http1-1-vs-http2-0-%EC%B0%A8%EC%9D%B4%EC%A0%90-%EA%B0%84%EB%8B%A8%ED%9E%88-%EC%82%B4%ED%8E%B4%EB%B3%B4%EA%B8%B0-5727b7499b78](https://medium.com/@shlee1353/http1-1-vs-http2-0-차이점-간단히-살펴보기-5727b7499b78)

[https://www.popit.kr/%EB%82%98%EB%A7%8C-%EB%AA%A8%EB%A5%B4%EA%B3%A0-%EC%9E%88%EB%8D%98-http2/](https://www.popit.kr/나만-모르고-있던-http2/)

![http1.1vs2](https://miro.medium.com/max/1195/1*rf2AnDQyHfGO_ThYfb-hWA.png)

- HTTP1.1은 기본적으로 연결당 하나의 요청과 응답을 처리

- HTTP1.1은 동시전송 문제와 다수의 리소스를 처리하기에 속도와 성능 이슈

  #### HTTP 1.1 동작방식 

  - **HTTP/1.1는 기본적으로 Connection당 하나의 요청을 처리 하도록 설계**
  - **동시전송이 불가능**
  - **요청과 응답이 순차적**

  <img src="http://www.popit.kr/wp-content/uploads/2016/11/http1-1e8d6f2a-403x600.png" width="400px">

  #### HTTP 1.1 문제점

  - 1) HOL(Head Of Line) Blocking - 특정응답지연

    - 하나의 TCP연결에서 3개의 이미지(a.png, b.png, c.png)를 얻을려고 하는경우 HTTP의 요청순서는 다음 그림과 같다.

      ```
      | --- a.png --- |
                  | --- b.png --- |
                              | --- c.png --- |
      ```

    - 순서대로 첫번째 이미지를 요청하고 응답받고 다음 이미지를 요청하게 되는데 **만약 첫번째 이미지를 요청하고 응답이 지연되면** 아래 그림과 같이 두,세번째 이미지는 당연히 첫번째 이미지의 응답처리가 완료되기 전까지 **대기**하게 되며 이와 같은 현상을 **HTTP의 Head of Line Blocking** 이라 부르며 파이프 라이닝의 큰 문제점 중 하나이다.

    - ```
      | ------------------------- a.png ---------- --- |
                                                | -b.png- |
                                                      | --c.png-- |
      ```

  - 2) RTT(Round Trip TIme) 증가

    - 매 요청별로 connection을 만들게 되고 TCP상에서 동작하는 HTTP의 특성상 [**3-way Handshake**](http://mindnet.tistory.com/entry/네트워크-쉽게-이해하기-22편-TCP-3-WayHandshake-4-WayHandshake) 가 반복적으로 일어나고 또한 불필요한 RTT증가와 네트워크 지연을 초래하여 성능을 저하

  - 3) 무거운 Header구조

    - 사용자가 방문한 웹페이지는 다수의 http요청이 발생하게 되는데, **매 요청시 마다 중복된 헤더값을 전송**

  #### HTTP 1.1 보완 (개발자에 의한 )

  - ##### 이미지 스프라이트

    - 웹페이지를 구성하는 다양한 아이콘 이미지 파일의 요청 횟수를 줄이기 위해 아이콘을 하나의 큰 이미지로 만든다음 CSS에서 해당 이미지의 좌표 값을 지정해 표시

  - ##### 도메인 샤딩

    - 다수의 Connection을 생성해서 병렬로 요청
    - 하지만 브라우저 별로 [Domain당 Connection개수의 제한이 존재](http://www.browserscope.org/?category=network&v=top)

  - ##### CSS/JS 압축

  - ##### Data URI Scheme

    [Data URI 스킴](https://en.wikipedia.org/wiki/Data_URI_scheme)은 Request 수를 줄이기 위해 **HTML문서내 이미지 리소스**를 **Base64로 인코딩된 이미지 데이터로 직접 기술하는 방법**

  - ##### Load Faster

    - CSS를 HTML 문서 상위에 배치
    - JS를 HTML문서 하단에 배치

  #### HTTP 2 특징

  1) **Multiplexed Streams** : 한 커넥션에 여러개의 메세지를 동시에 주고 받을 수 있음

  2) **Stream Prioritization** : 흐름제어 방식 / 요청 리소스간 의존관계를 설정 

  3) **Server Push (PUSH_PROMISE)** : 지연시간 감소 방법 / HTML문서상에 필요한 리소스를 클라이언트 요청없이 보내줄 수 있음

  	- 푸시된 리소스는 클라이언트에 의해 캐시
  	- 다른 페이지에서 재사용 가능
  	- 다른 리소스와 함께 다중화 
  	- 클라이언트에 의해 거부가능
  	- 서버에서 우선순위를 지정함

  4) **Header Compression** : Header 정보를 HPACK압충방식을 이용하여 압축전송

  -  **Header Table**과 **Huffman Encoding** 기법을 사용

  

### DNS(Domain Name System)

- 사람이 읽을 수 있는 도메인 이름(예: www.amazon.com)을 머신이 읽을 수 있는 IP 주소(예: 192.0.2.44)로 변환해주는 시스템

  #### DNS 작동원리 

  - https://www.netmanias.com/ko/post/blog/5353/dns/dns-basic-operation

- 모든 단말(PC)은 **DNS 서버의 IP 주소가 설정**되어 있어야 합니다. 

- 보통 PC는 **DHCP 프로토콜로 IP 주소를 할당** 받으면서 DNS 서버 IP 주소를 DHCP Option 6을 통해 함께 받습니다. (보통 2개의 DNS IP 주소를 받는다. Primary DNS 서버가 죽었을때 Secondary DNS 서버에 물어 보기 위해서...) 

- DNS 서버 주소가 `203.248.252.2`와 `164.124.101.2`로 설정 되어 있습니다. 이 2개의 주소는 LG U+ DNS 서버 주소입니다. ([www.whois.co.kr](http://www.whois.co.kr/)에서 IP 주소 관련 정보 확인이 가능함)

- ### DNS Server

  DNS Server는 IP 주소와 Domain 이름을 **기억**하는 기능과 Client가 이름을 물어보면 IP를 **알려주는** 기능을 갖고 있습니다. 수천대의 서버가 같이 협력합니다.

  - https://zzsza.github.io/development/2018/04/16/domain-name-system/

![img](https://www.netmanias.com/ko/?m=attach&no=1996)

1. 이제 아래 그림과 같이 PC 브라우저에서 www.naver.com을 입력합니다. 그러면 PC는 미리 설정되어 있는 DNS (단말에 설정되어 있는 이 DNS를 Local DNS라 부름, 제 PC의 경우는 203.248.252.2)에게 "www.naver.com이라는 hostname"에 대한 IP 주소를 물어봅니다.

   <img src="https://www.netmanias.com/ko/?m=attach&no=1997" width="600px">

   

2. **Local DNS**에는 "www.naver.com에 대한 IP 주소"가 있을 수도 없을 수도 있습니다. 만약 있다면 Local DNS가 바로 PC에 IP 주소를 주고 끝나겠지요. 본 설명에서는 Local DNS에 "www.naver.com에 대한 IP 주소"가 없다고 가정합니다.

3. Local DNS는 이제 "www.naver.com에 대한 IP 주소"를 찾아내기 위해 **다른 DNS 서버들과 통신(DNS 메시지)을 시작**합니다. 먼저 **1) Root DNS** 서버에게 "너 혹시 www.naver.com에 대한 IP 주소 아니?"라고 물어봅니다. 이를 위해 각 <u>Local DNS 서버에는</u> <u>Root DNS 서버의 정보 (IP 주소)가 미리 설정되어 있어야</u> 합니다.

4. 여기서 "Root DNS"라 함은 좀 특별한 녀석인데요(기능의 특별함이 아니고 그 존재감이..). 이 Root DNS 서버는 전세계에 13대가 구축되어 있습니다. 미국에 10대, 일본/네덜란드/노르웨이에 각 1대씩... 그리고 우리나라의 경우 Root DNS 서버가 존재하지는 않지만 Root DNS 서버에 대한 미러 서버를 3대 운용하고 있다고 합니다.

5. **Root DNS 서버**는 "www.naver.com의 IP 주소"를 모릅니다. 그래서 Local DNS 서버에게 "난 www.naver.com에 대한 IP 주소 몰라. 나 말고 내가 알려주는 다른 DNS 서버에게 물어봐~"라고 응답을 합니다.

6. 이 다른 DNS 서버는 **"2) com 도메인"을 관리하는 DNS 서버**입니다.

7. 이제 Local DNS 서버는 "com 도메인을 관리하는 DNS 서버"에게 다시 "너 혹시 www.naver.com에 대한 IP 주소 아니?"라고 물어봅니다.

8. 역시 "com 도메인을 관리하는 DNS 서버"에도 해당 정보가 없습니다. 그래서 이 DNS 서버는 Local DNS 서버에게 "난 www.naver.com에 대한 IP 주소 몰라. 나 말고 내가 알려주는 다른 DNS 서버에게 물어봐~"라고 응답을 합니다. 이 다른 DNS 서버는 **"3) naver.com 도메인"을 관리하는 DNS 서버**입니다.

9. 이제 Local DNS 서버는 "naver.com 도메인을 관리하는 DNS 서버"에게 다시 "너 혹시 www.naver.com에 대한 IP 주소 있니?"라고 물어봅니다.

10. **"naver.com 도메인을 관리하는 DNS 서버"**에는 **"www.naver.com 호스트네임에 대한 IP 주소"가 있습니다.** 그래서 Local DNS 서버에게 "응! www.naver.com에 대한 IP 주소는 222.122.195.6이야~"라고 응답을 해 줍니다.

11. 이를 수신한 **Local DNS는** www.naver.com에 대한 **4) IP 주소를 캐싱**을 하고(이후 다른 넘이 물어보면 바로 응답을 줄 수 있도록) 그 IP 주소 정보를 단말(PC)에 전달해 줍니다.

### **Recursive Query**

- Local DNS 서버가 여러 DNS 서버를 차례대로 (Root DNS 서버 -> com DNS 서버 -> naver.com DNS 서버) 물어봐서 그 답을 찾는 과정
- http://www.naver.com/index.html     ->  URL
- www.naver.com                            ->  Host Name
- .com                                                ->  Top-level Domain Name
- .naver.com                                     ->  Second-level Domain Name

### Domain

- 도메인 네임 :  네트워크상에서 컴퓨터를 식별하는 host name  혹은 도메인 레지스트리에 등록된 이름

### DHCP

-  [호스트](https://ko.wikipedia.org/wiki/호스트) [IP](https://ko.wikipedia.org/wiki/IP) 구성 관리를 단순화하는 IP 표준
-  DHCP 서버를 사용하여 IP 주소 및 관련된 기타 구성 세부 정보를 [네트워크](https://ko.wikipedia.org/wiki/네트워크)의 DHCP 사용 [클라이언트](https://ko.wikipedia.org/wiki/클라이언트)에게 동적으로 할당



---

------



## IP 구조

-  **IP Address는 32bit(4byte) 길이로 구성된 `논리적인` 주소체계**로서 형태는 OOO.OOO.OOO.OOO (ex. 184.51.65.127)로 표기
- **'.(dot)'으로 구분된 Octet(8bit / 1byte)** 4개가 조합되어 IP주소를 나타냄
- <img src="https://1.bp.blogspot.com/-YDTWPLzikQY/Vm099QF1BAI/AAAAAAAAAJ4/OL1eEwSg4cY/s640/ip_%25EA%25B5%25AC%25EC%25A1%25B0.png">

- 전체 IP의 수는 4,294,967,296개로 약 42억개 정도로 한정

#### 물리적인 주소 체계

- MAC (Media Access Control) 주소
- LAN(Local Area Network) 또는 Ethernet 이라 불리는 망에서 통신을 하기 위하여 사용
  - LAN 내의 통신이므로 MAC은 자신이 속한 네트워크 안에서만 통신
  - 이후 네트워크를 빠져나가는 장치인 Router를 지나게 되면 IP를 이용하여 통신

#### **IP 주소의 NetworkID와 HostID**

-  **하나의 IP주소에는 Network ID와 Host ID가 존재**
  - **인터넷을 사용할 때 Routing으로 목적지를 알아내고 찾아가는 등의 역할을 할 때에는 NetworkID와 HostID가 합쳐진 IP주소** 를 보는 것이다.
- Network ID  / Host ID
  - **Network ID**는 인터넷 상에서 모든 Host들을 전부 관리하기 힘들기에 한 Network의 범위를 지정하여 관리하기 쉽게 만들어 낸 것
  - **Host ID**는 호스트들을 개별적으로 관리하기 위해 사용하게 된 것입니다



#### IP Class 개념

- **IP Class의 경우 A, B, C, D, E Class로 나누어 Network ID와 Host ID를 구분**

  <img src="https://2.bp.blogspot.com/-VWm-qwzH5I8/Vm0_vc2F4tI/AAAAAAAAAKE/ccxmdlSrwVQ/s640/IP%25EC%25A3%25BC%25EC%2586%258C%2B%25EC%25B2%25B4%25EA%25B3%2584.png" width="500px">

- A Class
  -  처음 **8bit(1byte)**가 Network ID, <u>나머지 24bit(3byte)가 Host ID</u>로 사용비트가 0으로 시작하기에 **네트워크 할당은 0~127**입니다 . 즉, 128 곳에 가능하며, 최대 호스트 수는 16,777,214개입니다. 

-  B Class
  -  처음 **16bit(2byte)**가 Network ID이며, <u>나머지 16bit(2byte)가 Host ID</u>로 사용됩니다. 비트가 10으로 시작하기에 네트워크 할당은 16,384 곳에 가능하며, 최대 호스트 수는 65,534개입니다. 

- C Class
  - 처음 **24bit(3byte**)가 Network ID이며, <u>나머지 8bit(1byte)가 Host ID로</u> 사용됩니다. 비트가 110으로 시작하기에 네트워크 할당은 2,097,152 곳에 가능하며, 최대 호스트 수는 254개입니다.

#### Class 구분하는 방법

>  **각각의 Class를 구분하는 방법은 의외로 간단하게 제일 첫 번째 옥텟(Octet)으로 구분**

-  IP가 **164**.58.94.125라고 할 때 첫 번째 Octet은 164

- 첫 번째 Octet에서 0~255까지의 숫자를 5개로 나누어서 A, B, C, D, E Class로 구분 

  A Class : 0 ~ **127** (0.0.0.0 ~ 127.255.255.255) 		

  -  **0**11111111.00000001.00000001.00000001( **127**.1.1.1 )

  - **256 / 2 = 128 - 1 = 127** (A Class 범위 : 0 ~ 127)

  ​	// NW ID  #  : 128 (=127-0+1)

  B Class : **128** ~ **191** (128.0.0.0 ~ 191.255.255.255)	

  - **10**111111.00000001.00000001.00000001( **191**.1.1.1 )

  - **128 / 2 = 64 + 127 = 191** (B Class 범위 : 128 ~ 191)

  ​	// NW ID  #  : (=191-128+1)*2^8 = 16,384

  C Class : **192** ~ **223** (192.0.0.0 ~ 233.255.255.255)

  - **110**11111.00000001.00000001.00000001( **223**.1.1.1 )

  - **64 / 2 = 32 + 191 = 223** (C Class 범위 : 192 ~ 223)

  ​	// NW ID  #  : (=233-192+1)*256 *256 = 2,097,152

  D Class : 224 ~ 239 (224.0.0.0 ~ 239.255.255.255)

  E Class : 240 ~ 255 (240.0.0.0. ~ 255.255.255.255)

----

---



## 서브넷팅

### 서브넷 마스크

- IP에서 `네트워크 ID ` 와 `host ID`를 구별하는 구분자
- PC IP가 192.168.0.1이고, subnet mask 가 255.255.255.0 이라고 가정하면
- Network ID : 192.168.0
- Host ID : 0



### 서브넷팅

- 넷 마스크를 이용하여 네트워크를 나누는 것. <-> 슈퍼넷팅(Super netting)

  <img src="https://2.bp.blogspot.com/-2B8U2ejzoW8/Vqb3g4EXFdI/AAAAAAAAAck/ceYdCHaWHd8/s400/Subnetting.png" width="400px">

-  서브넷 마스크의 형태는 IP주소와 똑같이 32bit의 2진수로 되어 있으며, 8bit(1byte)마다 '.(dot)'으로 구분하고 있습니다. 

- 즉, IP와 똑같은 OOO.OOO.OOO.OOO의 모습을 가지고 있습니다. 그러나 형태가 똑같다고 하여서 역할을 혼동하시면 안 됩니다. **형태가 똑같은 이유는 IP주소와 서브넷 마스크를 AND 연산하기 위해**서입니다.

- 

#### IP주소의 클래스별 기본 서브넷 마스크(Default Subnet Mask)클래스

<img src="./Network/images/Subnet_mask/스크린샷 2019-10-05 오후 2.31.38.png" width="600px">

-  각 클래스마다 Network ID로 사용되는 옥탯에 255가 있다는 점을 확인하실 수 있습니다. 이 때문에 **IP주소의 클래스를 구분할 때 서브넷 마스크를 보시는 분들도 계시겠지만 잘못된 방식**이다.
- **IP주소 뒤에 /24 같은 것들 : 이는 Prefix(접두어)로 서브넷 마스크의 bit 수를 의미**
  - 옥탯의 8bit가 모두 1일 경우 10진수로 255가 되기에 /24는 왼쪽부터 나열된 1bit의 수가 24개라는 뜻
  - 192.168.0.3/24는 IP주소가 192.168.0.3 이며, 서브넷 마스크가 255.255.255.0이라는 의미

#### 서브넷팅의 이해

- A클래스 IP 주소가 1.1.1.1 이라고 할 때, 그대로 할당하면

  - Network ID = 1.0.0.0

  - Host ID = 0.1.1.1 이 된다.
    - Host ID 범위는 0.0.0.0 ~ 0.255.255.255이므로 **할당 가능한 호스트 수**가 16,777,216개 (=2^8* 2^8 *2^8)로 비효율적이게 된다.

- 이제 서브넷팅으로 더 많은 네트워크 영역에서 사용할 수 있도록 계산해보자. 먼저 서브네팅된 A클래스 IP주소는 아래와 같다.

  <img src="./Network/images/Subnet_mask/스크린샷 2019-10-05 오후 2.38.48.png" width="600px">

  -  IP주소는 A 클래스 1.1.1.1을 할당하였으며, Subnet mask를 255.255.0.0으로 변경
  - **IP Address와 Subnet Mask를` AND `연산하게 되면 **
    - **Network ID가 기존의 1.0.0.0이 아닌 1.1.0.0으로 확장됨**
      - 1.0.0.0 ~ 1.255.0.0의 범위 => **256개의 네트워크에 할당**
    - **Host ID**는 Network ID의 범위가 변경됨에 따라 기존의 0.1.1.1이 아닌 0.0.1.1로 변경
      - 0.0.0.0 ~ 0.0.255.255 범위 => **한 네트워크에 65,534개(256 \* 256)의 호스트를 할당**

#### 서브넷팅의 특징

> **2진수로 표현하였을 때 Network ID 부분은 1이 연속적으로 있어야 하며, Host ID 부분은 0이 연속적으로 있어야 합니다**

- 중간에 1이나 0이 섞이면서 나열x
- 서브넷 마스크는 Network ID를 확장하면서 1bit씩 확보
  - 네트워크 할당 가능 수가 2배수로 증가 && 반대로 호스트 할당가능 수가 1/2 로 줄어듦
  - 예를들어 
    - 11111111.11111111.1111111.00000000(255.255.255.0)에서 
    -  네 번째 옥탯에 **1bit를 확보**하면 
    - 11111111.11111111.11111111.**1**0000000(255.255.255.128)이 됩니다.
  - 서브넷팅을 통해 Network ID가 확장되므로 인해 할당할 수 있는 네트워크의 수가 늘어납니다. 하지만 **네트워크가 분리되므로 인하여 서로가 통신하기 위해서는 라우터를 통하여서만 가능**하게 됩니다.
- 서브넷팅은 **특정 몇 군데의 호스트에서 너무 많은 트래픽을 발생시켜서 속도를 저하시키는 문제를 해결**할 때 용이



#### 서브넷팅 계산 방법

- **Host ID를 Network ID로 변화하기 위해 한 Bit씩 가져올 때마다 네트워크 크기는 2배로 증가하고 호스트 수는 2로 나누어지게 됩니다**

- 194.139.10.7/**25** 예시

  - /25는 서브넷 마스크가 25bit라는 의미로 255.255.255.128
  - 호스트에 IP를 할당할 수 있는 범위가 [0~127], [128~255]가 된다.
  - 네트워크는 [**194.139.10**.0], [194.139.10.128]이기에 2개로 나누어지게 됩니다. 
  - 결국 194.139.10.7/25가 속한 네트워크는 [194.139.10.0/25] 대역에 속하게 되며, 다른 서브넷팅 된 네트워크인 [194.139.10.128] 과는 라우터를 통하여서만 통신할 수 있습니다.

- 194.139.10.123/**26** 예시

  - /26은 서브넷 마스크가 26bit이기에 **255.255.255.192**
  - 호스트에 할당 가능한 IP의 범위는 [0~63], [64~127], [128~191], [192~255]
  - 네트워크는 [194.139.10.0], [194.139.10.64], [194.139.10.128], [194.139.10.192] 총 4개로 나누어지게 됩니다.
  - 194.139.10.**123**이 속한 네트워크는 194.139.10.**64**/26에 속하게 되며, 서브넷팅 된 3개의 다른 네트워크와는 라우터를 통하여서만 통신

  #### 중요!!

- 각 네트워크를 구분할 때 각 범위의 가장 첫 번째 IP(0,64, 128, 192 등)를 사용하고 있다는 것입니다. 이를 Network Address 라고 부르며, 사용할 수 없는 IP주소입니다. 또 가장 마지막 IP주소(63, 127, 191, 255 등)는 Broadcast address이기에 사용하실 수 없습니다. 따라서  **각 네트워크의 IP 범위에서 가장 첫 번째 주소와 가장 마지막 주소 두 개는 호스트에 할당할 수 없습니다.** 
- 이는 기본 서브넷 마스크(Default Subnet Mask)를  사용하여 서브넷팅을 시키지 않은 **모든 네트워크에서도 동일하게 적용**되니 주의하여 주시면 되겠습니다.

<img src="./Network/images/Subnet_mask/스크린샷 2019-10-05 오후 2.52.03.png" width="600px">

- http://korean-daeddo.blogspot.com/2016/01/blog-post_26.html

- https://master-hun.tistory.com/4

  <img src="./Network/images/Subnet_mask/스크린샷 2019-10-05 오후 3.11.01.png" width="600px">
  <img src="./Network/images/Subnet_mask/스크린샷 2019-10-05 오후 3.11.07.png" width="600px">

  <img src="./Network/images/Subnet_mask/스크린샷 2019-10-05 오후 3.11.12.png" width="600px">



https://hsol.tistory.com/194

https://captcha.tistory.com/7



-----





### 네트워크 

- 라우터 연결
- TCP / UDP
- 3 hand shake / 4 hand shake 작동 방식 
- 패킷기반 전송방식
  - 사용자가 보내는 데이터가 한 묶음(packet) 단위로 이동
  - bit정보들은 출발지에서 목적지까지 라우터를 거치면서 한 묶음단위로 함께 이동
- 패킷 전송간에 라우터에서 수신할 허용치보다 더 많은 데이터가 들어오는 경우, Queue에 쌓는다.
  - 패킷이 쌓이게 되면 delay 발생.
  - 패킷이 큐에 한계까지 쌓이고 나면 drop 되어 패킷 데이터가 유실됨. 
  - 현존 데이터 유실의 90%가 (큐를 갖는) 라우터에서 발생.

애플리케이션 계층

- ##### 웹과 HTTP

- ##### 비지속연결/지속연결

- ##### 쿠키

- ##### 웹캐싱

- FTP

- SMTP vs HTTP

- ##### DNS 동작원리

- P2P

- ##### UDP / TCP

트랜스포트 계층

- Trans - network 계층 관계
- 다중화/역다중화
- 비연결형 트랜스포트 : UDP
  - UDP 세그먼트 구조
  - UDP 체크섬
- 신뢰성 있는 데이터 전송
  - 파이프라인된 신뢰적 데이터 전송
  - N부터 반복(GBN)
  - 선택적 반복
- 연결 지향형 : TCP
  - TCP 연결
  - TCP 세그먼트 구조
  - RTT예측과 타임아웃
  - 흐름제어
  - TCP 연결관리
- 혼잡제어 원리
  - 혼잡의 원인과 비용
  - 혼잡제어 접근법 

네트워크 계층

- 포워딩, 라우팅, 스위칭

- ##### IPv4 주소체계 vs IPv6 주소체계

- 링크상태 라우팅 알고리즘

- 거리 벡터 라우팅 알고리즘

링크

- 오류 검출 및 정정 기술 

  - ##### 패리티 검사

  - ##### 체크섬 방법

  - 순환 중복 검사

- DHCP 설명

  