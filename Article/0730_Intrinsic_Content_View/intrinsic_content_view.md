Intrinsic Content Size

- 뷰 컨텐츠 고유의 사이즈
- 기본 컨트롤은 대부분 고유 사이즈 활용 가능



Priority의 2가지 종류

Content Hugging / Compression Resistance

- 컨텐츠를 감싸는 힘 (늘어나지 않으려는 힘)
- 컨텐츠를 필요이상 늘리지 않으려는 힘 ex) Label의 텍스트가 긴 경우..

- 두 Label이 서로 충돌하는 경우
  - Content Hugging과 Compression Resistance가 같은경우.
  - 만약 왼쪽의 Hugging이 더 크면 왼쪽을 맞추고 오른쪽을 그에 맞춤(vise versa)



Priority

- 제약사항의 우선도
- Constraint
  - Content Hugging Priority
  - Compression Resistance Priority





Stack View

- 콘텐츠로 들어오는 컴포넌트의 고유사이즈에 맞춰서 자기 사이즈를 조절하는 경향이 있다.
- Alignment
  - fill : 가로 크기를 hugging priority가 적은 컨텐츠를 화면에 맞게 채운다.
  - firstBaseline: 첫 줄 간격을 같게
  - button : 
  - lastBaseline: 맨 마지막 줄 간격을 같게
- Distribution : vertical 크기를 조정
  - fill : hugging priority가 가장 작은 것을 늘린다.
  - fill equality : 
  - fillProportionally :
  - equalSpacing: 같은 너비
  - equalCentering : 센터끼리 간격을 같게 해줌



Layout Margin

- Safe Area 개념으로 변환. Safe area와Margins로 나뉨.| | safe area | |
- before safe area  
  - Navibar와 center를 포함한 영역에서 center를 지정

- Directional Layout Margins



Preserve Superview Margins

- 상



Scroll View 

- scroll view는 자기의 크기를 모름. 내부 컨텐츠를 바탕으로 자신의 크기를 정함
- 내부에 Label을 직접 두면 안되고, view를 두고 두어야 함



**TableView** 만들어보기

- Delegation pattern과 protocol 학습
- 문서 보고 만들어볼 것



TableView Guide 강의 슬라이드 참고!!!!!





# TableView (08/01/2019)

- 테이블뷰는 `UITableViewController` 나 `UITableView`를 통해서 만들 수 있다.
- 아무튼 테이블 뷰를 구현하기 위해서는 DataSource와 Delegate가 필요하다. 
  - NSObject를 상속하는 각각의 서브클래스에 UITableViewDataSource 와 UITableViewDelegate 를 채택하도록 하든가, 뷰컨트롤러에서 위 프로토콜을 채택해도 된다.

- 테이블 뷰는 섹션과 Row의 개념이 존재한다.
  - 섹션 : 테이블에 나타낼 정보묶음의 단위
  - Row: 섹션 내의 인덱스로 연결된 각 셀

- DataSource의 역할

  - 테이블 뷰에 필요한 데이터를 DataSource에게 메시지(메서드) 요청하고, 이에 DataSource는 알맞는 정보를 (메서드를 통해) 리턴한다.
  - 대표적으로 다음과 같은 메서드가 존재한다.
  - 프로토콜을 준수하는 메서드들의 설명은 `Ask` , 혹은 `Tell` 로 시작하는데, `반드시 필요한 데이터에 대한 요청은 Ask`, `통보는 Tell`로 서술한다.

- Delegate의 역할

  - TableView의 특성, Appearance, 사용자와의 Interaction을 관리한다.
  - 역시 통보는 `Tell`, 필요한 메시지에 대한 요청 메서드는 `Ask`로 이뤄진다.

- Tell vs Ask

  - Ask에 해당하는 tableView 메서드는 보통 리턴값이 존재한다. (tell은 없고)

- tableView.dequeueReusableCell 메서드

  - identifier를 지정한 tableViewCell을 찾아서 테이블뷰에 보여줄 셀로 지정한다.
  - 큐에 대기중인 셀이 없으면 셀을 하나 생성하여 테이블 뷰에 넘긴다.
  - 대기중인 셀이 있으면 대기중인 셀을 재사용한다.

- Cell 재사용으로 인한 문제점 

  - DataSource에 다음과 같이 코드를 수정해보자.

    ```swift
    /// 각각의 테이블 뷰에서 보여줄 셀이 내용은 무엇인가?
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = contacts.map{$0.key}[indexPath.row]
            /// 추가한 코드
            if indexPath.row == 0 {
                cell.backgroundColor = .red
            }
            return cell
        }
    ```

  - 원하는 의도와 달리, 다음과 같은 결과가 나온다.



- 원인

  - 화변 밖으로 나간 cell은 원칙적으로 reusableQueue에 들어간다.
  - 해당 cell은 하단 스크롤에 따라 새로 보여줘야할 cell로 재사용된다.
  - 0번째 index가 아님에도 불구하고 변경된 값이 적용된 상태로 재사용된다.

- 해결

  - 변하는 셀에 대해 변하지 않는 케이스에 원복시키는 방식을 로직에 포함시킨다.

    ```swift
    if indexPath.row == 0 {
    		cell.backgroundColor = .red
    }else{
    		cell.backgroundColor = .white
    }
    ```

  - 또는, prepareForReuse() 메서드를 활용하여 재사용시의 셀의 초기화 기능을 재정의한다.

    ```swift
    override func prepareForReuse() {
        super.prepareForReuse()
        //hide or reset anything you want hereafter, for example
        cell.backgroundColor = .white
    }
    ```

    