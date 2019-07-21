## UICollectionView

- UITableView는 리스트형태로 1열로 보여주는 형태로 구성되어있음.

- 화면을 그리드 형태로 다양하게 레이아웃하여 보여줄 수 있음
- 하나 이상의 컬럼
- 데이터의 나열을 수평/수직방향으로 줄 것인지 지정 가능
- 직접 커스터마이징 가능



## UICollectionViewLayout

- 줄 정렬 등 CollectionView를 꾸미기 위한 레이아웃 객체

- **`UICollectionViewFlowLayout`** 은 iOS에서 기본으로 제공하는 레이아웃 
- Datasource & Delegate 패턴을 사용



TableView나 CollectionView도 cell에 대한 reuse를 위해 cell에 대해 Attribute Inspector에서 identifier를 지정하는 것이 좋다.







----

# Animation

### Position & Size

- bounds
- frame
- center



### Transformation

- rotation
- scale
- translation
- CGAffineTransform을 사용ㄴ

- 중첩하여 사용 가능



### Appearance

- backgroundColors
- alpha



### 주의

- Autolayout과 상충되는 것에 대해서 조심해야 한다.

