## Internationalization & Localization (국제화 및 지역화)



#### Localization - L10N, l10n 

- l과 n 사이의 10글자

#### Internationalization - I18N, i18n

- i와 n사이에 18글자



언어

날짜/시간

화폐 

…등등



#### 수동 포맷 (권장 x )

let formatter = DateFormatter()

formatter.dateFormat = "YYYY MM DD hh:mm:ss "

let str = formatter.string(from: date)



#### Formatters 종류

DateFormatter, DateComponentsFormatter, DateIntervalFormatter, PersonNameComponentsFormatter, NumberFormatter, ...





#### XLIFF - key(원문단어) : value(번역할 단어) 자료의 한계

- visual context
- resource data
- custom metadata
- size and length restriction





### Xcode 10 - Localization Catalog 

404 - new localization_workflows_in_xcode_10  WWDC 참고

**메타데이터 첨부** 가능 (contents.json)

- (어느언어->타겟번역언어) 
- 버전정보

리소스 파일 추가 - **LocalizedContents**

- xliff, lproj 등 파일에 Source Contents의 Base.lproj 도 첨부 
- Notes에 스크린샷, README 첨부 가능

- 언어별로 다른 Assets 이미지 설정 등 



언어에 따른 글자표기 등은 **`Stringsdict`** 를 활용해왔다. 

- 언어별로 Stringsdict를 사용가능.

- 단수/복수에 따른 별도 표기등 지정 가능
- 단어 글자수 너비에 따라 표현방식을 달리 할 수 있다.
  - label.text = NSLocalizedString("GDP", comment:"A territory's GDP (Gross Domestic Product)")
  - ex: (let widthFormattedString = string.variantFittingPresentationWidth(20))

- 글자수 제한 등을 표기하여 번역에 위임가능
- WWDC 2018 참고



#### Xcode 9(2016) , Xcode10(2017), Xcode11(2018) 영상 확인

