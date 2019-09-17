## Key Chain



### Online Security Survey by Google / Harris Poll

- 똑같은 비밀번호 여러 곳에 사용?
- ...



편리한 사용자 경험 vs 개인정보 보호



### Security Framework

- 사용자 앱에 대해 다음을 지원
  - 사용자 인증/권한 
  - 데이터 보호
  - 코드 사이닝
  - 암호화
- 사용자의 보안사항 (단순히 비밀번호 외에도 )을 저장하는 데이터베이스에 가까움
- KeyChain Item
  - 생성날짜 등을 Attributes에 넣고 조합



### KeyChain Item

- 클래스를 통해서 직접 생성하지는 않는다. 

  let item = SetKeychainItem() 이 아님

  Add / Search / Update / Delete의 메서드를 제공한다.

- 키체인 아이템

  - 데이터(아이템 클래스;인스턴스 클래스라기보다는 키체인 아이템의 카테고리 정보를 의미함, 키/밸류) / 어트리뷰트(아이템 어크리뷰트, 키/밸류)로 구성
    - ex ) query[kSecClass as String ] = kSecClassGenericPassword 설정만 하면 암호화가 필요한 정보라는 것을 인식함
  - Item Class, Item Attributes 각각을 딕셔너리 타입으로 관리



### Access (접근성)

- 앱들은 Access Group을 지님.

  - Access Group ; 특정 그룹 이름으로 태깅된 앱들의 logical collection

- 같은 Access Group에 속한 앱들은 키체인을 공유할 수 있음

- 시스템 > 앱마다 AG List (AGL)를 만듬 

  - AGL은 3가지 속성으로 구성됨

    - AppID

      - TeamID와 BundleID를 통해서 만든다.
      - [$(teamID).com.example.AppOne] = **AppID**
      - [$(teamID).com.example.**AppOne**] 
      - [$(teamID).com.example.**AppTwo**] 
      - 가족앱(같은 액세스 그룹에 속하는)인 두 앱에서 공통 키체인을 생성할 수 있다.
        - ex: ) [$(teamID).com.example.**SharedItem**] 

    - Restricting Keychain Access 

      - 디바이스 상태에 따라 접근제어를 설정한다.
      - Attributes 에서 `Acceessibility` 설정 가능
        - When Passcode Set - 잠금화면처럼 foreground에서 작동되지 않는 경우, 패스코드 입력 후에 아이템에 접근 가능
        - **When Unlocked** - 잠금 해제될 때 아이템에 접근이 가능
        - After First Unlock - (전원키고나서) 첫 번째 잠금해제된 경우, 이후에 계속 접근 가능
        - Always - 항상 접근 가능

    - Wrapper 사용

      - Security 프로그램은 대부분 C로 구성되어있음.
      - swift에서 사용하기 위한 작업이 번거롭기 때문에 Wrapper를 사용
      - `Generic Keychain` 

      

      

  # QnA

  - Data와 Attributes 가 각각 K/V 형태로 저장된다.

  - Attributes는 Salt의 개념은 아니다.

    - Restricting Keychain Access 등 접근성 설정에 쓰인다.

  - KeyChain에 저장되는 아이템은 이미지같은 대용량의 데이터는 바람직하지 않다. 간단한 스트링 형태가 적당

  - Data에는 Class 인스턴스를 저장하는 것도 가능하다. 굳이 Serialization을 먼저 해줄 필요는 없다.

    