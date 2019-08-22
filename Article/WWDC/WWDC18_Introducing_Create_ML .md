# Introducing Create ML

CoreML

- integerate an ML model in the app

- Idea

  - get an ML Model, drag and drop in Xcode, with just 3 lines of code, can run state- of-the-art ML model
  - 사용자는 프라이버시를 지원하는 실시간 머신러닝의 기회를 얻을 수 있음.

- 2017년에 CoreML 출시 이후, **2가지 옵션**으로 ML Model을 제공함. **(~2017)**

  - 1) 애플에서 제공하는 **대표적인 ml 모델을 다운로드**
  - 2) Core ML tools를 사용하기
    - 기존 ML 커뮤니티와 연계하여 사용가능함.
  - Core ML 출시 당시 5~6개의 트레이닝 라이브러리를 지원하였으나, 현재는 유명한 트레이닝 라이브러리 상당수를 지원함.
  - 더욱 더 customization에 초점

- **Turi Create (2018 말 출시 )**

  - 오픈소스 머신러닝 라이브러리 

- **Create ML (2018 ~ )**

  - 스위프트 머신러닝 프레임워크
    - ? -> mlmodel -> App built using  Xcode
    - complete end to end machine learning in Swift
      - CreateML 내에서 모델을 만들고, CoreML 로 그 머신러닝을 작동시킴
  - use cases
    - 1) images
      - 커스텀 이미지 분류 : 직접 커스텀한 제품 카탈로그를 이미지 인식 기술을 통해 분류할 수 있도록 하는 유즈 케이스 
        - make custom image classifier that can recognize product from your product catalog
    - 2) text
      - Input text —> output Label
      - 글의 sentiment 분석, 주제분석, 도메인 분석
    - 3) tabular Data
      - tabular Data에 대한 클래식한 회귀분석과 분류 수행 가능
      - ex) 화학 composition을 바탕으로 와인의 퀄리티를 예측하는 것

  - 일반적인 ML work flow
    - 1) Problem 
      - 먼저 앱을 구현하는 과정에 있어서, 문제 해결방식으로 머신 러닝이 올바른 선택인지 확인하자.  머신러닝을 쓸데없이 적용하진 말자. 머신러닝으로 해결할 문제상황을 정의하자.
    - 2) Collect Data
      - 수집 데이터가 앱의 실제 사용에 유용함을 반영해야 한다.
      - 예를 들어, 커스텀 이미지 classifier를 만들때, 아이폰에서 사진을 수집하라. 적은  양의 스크린샷을 수집하지 많고 많은 아이폰 사진을 확보하라
    - 3) Train your model 
    - 4) Evaluation
      - 모델을 평가하라. 
      - 모델 평가는 별도의 분리된 handout set을 통해 수행한다. 결과가 만족스럽다면 MLModel로 만든다. 
      - 결과가 만족스럽지 않으면 model을 다시 훈련한다. 다양한 파라미터를 적용하거나, 더 많은 데이터를 수집한다.
  - Create ML은 개발자에게 이 네가지 workflow 단계에 걸쳐서 도움을 준다.
    - 한줄의 코드 작성으로 모델을 트레이닝 할 수 있다. 
    - 트레이닝이 끝나면 하드웨어 최적화가 수행된다.
      - 내장된 평가 메트릭들이 존재하여 개발자가 각각의 정밀도를 작성하고, 리콜 및 혼동 지표를 계산할 필요가 없다.



### CreateModel for Image Classification

- 이미지 분류는 이미지에 적용할 카테고리 집합 중에 어떤 레이블을 식별하는지에 관한 문제입니다.
- 트레이닝 데이터의 타입에 따라, 개발자의 앱에 도메인 특화된 유즈 케이스를 목표로 할 수 있다.

- 단계 1: 데이터 수집 방식

  - 보고자하는 실제 데이터를 반영하는 다양한 유형의 이미지를 수집 한 다음 레이블을 지정하려고 한다면

    - 이미지 배열들에 해당하는 문자열 label을 지닌 사전으로 이를 수행한다.

      - [ Passion Fruit : 사진 사진 DataSet, Blueberry : 사진 DataSet … ]

    - 또는 데이터 셋이 계층적 디렉토리 구조로 구성되어 레이블이 그 안에 모든 이미지를 포함하는 이름이 되도록 한다.

      ![이미지](https://docs-assets.developer.apple.com/published/981240227d/c0ddbd6a-b60d-4a32-9726-6a9df5d7fbb9.png)

      ![이미지2](https://docs-assets.developer.apple.com/published/4bd09c3420/b789d462-92c2-4d26-9479-d5288eef2438.png)

- 단계2 : 트레이닝

  - 방법 1: 입력 이미지에 대해 매우 복잡한 모델을 처음부터 학습 할 수 있음. 이를 위해서는 많은 레이블 데이터가 필요함

    - 방대한 연산과 인내가 필요
    - 제로베이스에서부터 방대한 이미지 레이블 데이터로부터 트레이닝을 하는 것을 의미

  - **방법 2: transfer learning** 

    - 복잡한 기계 학습 모델을 훈련한 경험을 다수 보유하므로, OS에서 활용할 수 있는 모델을 활용한다. 
    - OS 내에 이미 존재하는 모델 위에 Transfer learning을 적용하고, 이를 확장(argumentation)하여 마지막으로 몇개의 레이어를 특정 데이터로 재교육함으로써 더 이상 수백만 개의 이미지가 필요하지 않음
    - 이미 애플이 보유한 데이터 양을 사용하여 우수한 classifier를 훈련시킬 수 있다.
    - 장점
      - 트레이닝 시간 단축
      - 모델의 크기 감소 (hundreds MB -> few MB, few MB -> few KB)

  - **How to use?**

    ![이미지](https://docs-assets.developer.apple.com/published/e6ad1efd6a/d926fc62-3dea-4447-86fc-920d4d6c4781.png)

    - 1) CreateMLUI 를 사용한 방식

    ```swift
    import CreateMLUI
    let builder = MLImageClassifierBuilder()
    builder.showInLiveView()
    ```

    - Playground나 macOS Command Line Tool에서 위 코드 치면 ImageClassifier 생성을 위한 GUI가 뜬다.

    - drag and drop으로 훈련용 이미지 데이터셋을 담은 폴더를 전달하면 트레이닝을 시작하고, test 이미지 데이터셋을 넘기면 트레이닝한 모델을 바탕으로 테스트 데이터셋을 평가한다.

    

    - 2) CreateML을 사용한 방식 

      ```swift
      import Foundation
      import CreateML
      // Specify Data
      let trainDirectory = URL(fileURLWithPath: "/Users/createml/Desktop/Fruits")
      let testDirectory = URL(fileURLWithPath: "/Users/createml/Desktop/TestFruits")
      
      // Create Model
      let model = try MLImageClassifier(trainingData: .labeledDirectories(at: trainDirectory))
      
      // Evaluate Model
      let evaluation = model.evaluation(on: .labeledDirectories(at: testDirectory))
      
      // Save Model
      try model.write(to: URL(fileURLWithPath: "/Users/createml/Desktop/FruitClassifier.mlmodel"))
      ```

      - GUI가 아닌, 코드기반으로 mlmodel 생성 가능

    - 공통점

      - Swift, macOS playground 로 맥에서 커스텀 머신러닝 모델을 생성할 수 있다.

    - 유의사항

      - 평가시 트레이닝할 데이터셋과 가급적 겹치지 않는 데이터셋으로 테스트를 진행
      - 평가결과가 만족스럽다면 CoreML 을 사용하여 앱에 통합시킬 수 있음





[Creating an Image Classifier Model](https://developer.apple.com/documentation/createml/creating_an_image_classifier_model#overview)

[struct MLImageClassifier](https://developer.apple.com/documentation/createml/mlimageclassifier)

[struct MLObjectDetector -- 베타](https://developer.apple.com/documentation/createml/mlobjectdetector)





https://developer.apple.com/videos/play/wwdc2018/703?time=586

https://developer.apple.com/documentation/createml

