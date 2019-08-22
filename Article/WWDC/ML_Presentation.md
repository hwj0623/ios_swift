

발표 개요

## ML Introduction

### orientation ML (유래?) (2분) 

> v체크만 거론 중간에 다 뺄거임.. 18세기/1950초반/2000년대 이후만 거론

### v Before mordern computer… (18th)

![토마스 베이즈](/Users/hw/CodeSquard/ios_swift/Article/WWDC/images/Thomas_Bayes.png)

- 베이지안 확률로 유명한 영국의 수학/통계학자 토마스 베이즈로부터 그 기원을 찾을 수 있음.

  - #### An Essay towards solving a Problem in the Doctrine of Chances 중..

![확률 밀도 함수](https://wikimedia.org/api/rest_v1/media/math/render/svg/a22c9106c956f5a0ec96189440fecb9bbb575aad)

![베이즈 정리](./images/조건부확률.png)

![트리 다이어그램으로 표현한 약 투여의 예제 ](./images/트리다이어그램-조건부확률예.png)

베이즈 정리 활용 예제 - 트리 다이어그램으로 표현한 약 투여

### 1910's

그밖에.. 안드레이 마코브의 마코브 체인 등 이 있었다.

![마코브 체인](https://upload.wikimedia.org/wikipedia/commons/thumb/2/2b/Markovkate_01.svg/440px-Markovkate_01.svg.png)

![마코브체인 예제](https://upload.wikimedia.org/wikipedia/commons/thumb/9/95/Finance_Markov_chain_example_state_space.svg/800px-Finance_Markov_chain_example_state_space.svg.png)

주식시장에 대한 마코브 체인 예제

> Before 1950's 요약 : `확률` 에 대한 이론적 발전과 함께 태동



### v 1950's

Alan Turing은 `학습하는 기계`에 대한 제안을 하였고, 기계의 AI를 확인하기 위한 튜링 테스트를 고안함.

### v 1952

Arthur Samuel이 체커 게임 방법을 배우는 `최초의 ML 컴퓨터 프로그램`을 개발. 

알고리즘 : 경험으로부터 배우기 위한 발견적 탐색 메모리를 사용

### v 1956

AI라는 용어를 제안 다트머스 워크샵 (Marvin Minsky, John McCarthy, Claude Shannon and Nathan Rochester)

### 1958 

- 시각 인식 작업을 해결하도록 `최초의 인공 신경망인 Perceptron`설계  (Frank Rosenblatt)

- Mark I

  ![이미지](https://tykim.files.wordpress.com/2017/06/mark_i_perceptron.jpeg?w=312&h=384&zoom=2)



### 1970's AI Winter

- 과대광고, 기금 고갈, 하드웨어 기술의 미비



### 1980's AI Summer

- 1981 : 설명 기반 학습 (중요도 낮은 데이터 삭제할 수 있는 훈련 분석 알고리즘 )
- 1985 : 신경망 획기전 발전
  - Backpropagation 알고리즘 (Hidden Layer)에 대한 이론적 제안

### 1980's ~ early 1990's AI Winter

- Neural Network에 대한 좋은 이론 부족 등

### 1990's

- 머신러닝에 대한 통계적 접근 방식 (SVM) 신개념 소개 등 

### 1997

- IBM의 딥블루 VS 체스 그랜드 마스터 대결에서 머신의 승리

  ![이미지](https://tykim.files.wordpress.com/2017/06/ibm_vs_garry.png?w=575&h=311&zoom=2)



### v 2006 ~ 

- Hardware의 성숙, 신경망 모델에 대한 성숙된 이론 보완을 근거로 다시 대두
- Geoffrey Hinton 
  - ML을 위한 Neural Network 개발, Deep Learning 확산



### 2011 

- IBM Watson 컴퓨터 vs 일반 휴먼 참가자들이 참가한 자연어 퀴즈쇼 프로그램에서 왓슨 우승



### v 2012

- Google Brain Project
  - 스탠포드의 제프 딘 교수와 코세라 공동창업자 앤드류 응 교수가 진행한 프로젝트. 
  - 구글의 인프라를 활용하여 이미지와 비디오의 패턴을 감지하는 심층 신경망 개발



### v 2013 

- DeepMind : Atari 게임에서 인간을 이길 수 있는 **심층 강화학습 모델**을 설계 

  ![이미지](https://tykim.files.wordpress.com/2017/06/atari_games.jpg?w=557&h=356&zoom=2)

- https://deepmind.com/blog/article/deep-reinforcement-learning



### 2014

- DeepFace DNN (Facebook) 
  - 사람 얼굴 인식 뉴럴 네트워크 개발 

### 2016 

- 알파고 vs 이세돌

### v 2017

- Google TensorFlow 발표
- MS Cognitive Toolkit 출시

[wiki](https://en.wikipedia.org/wiki/Timeline_of_machine_learning)

[관련 참조](https://www.doc.ic.ac.uk/~jce317/history-machine-learning.html)





## ML definition (5분)

### definition 정의 

AI의 한 분야. 컴퓨터가 학습할 수 있는 알고리즘과 기술을 의미.

> 기계가 일일이 코드로 명시하지 않은 동작을 데이터로부터 학습하여 실행할 수 있도록 하는 알고리즘을 개발하는 연구 분야              
>
> ​													   -  Arthur Samuel

### `표현` 과 `일반화` 가 ML 의 핵심

- 표현 : 데이터에 대한 평가
- 일반화 : unknown data 에 대한 처리. Training 이후에 새롭게 들어온 데이터를 정확히 처리할 수 있는 능력



### 딥러닝? 인공지능과는 무슨 차이?

- **딥러닝과 공통점**
  - 모델을 학습하고 데이터를 분류
- **차이점 (물체 인식 예)**
  - 딥러닝은 이미지를 딥러닝 알고리즘에 직접 제공하여 물체를 예측
    - 트레이닝에 요구되는 데이터 크기가 큼
    - 고유의 특징들을 선택할 수 없음
    - classifier 적음
    - 학습 시간이 상대적으로 길다.
  - 일반적인 머신러닝은 특정 워크 플로우를 따른다.
    - 이미지 수집 -> 특징 추출 -> 물체 특징을 표현하거나 예측하는 모델을 생성
    - 고유 특징 선택 가능
    - 사용 가능한 classifier가 많음. 많은 모델 가운데 비교를 통해 적합한 모델 선정 가능
    - 학습 시간 상대적으로 짧음

- 딥러닝은 머신러닝의 한 분야로, 인공 신경망 중 **심층 인공 신경망(DaNN)**을 의미.
  - 이미지인식, 음성인식, 추천시스템, 자연어 처리 등을 다룸
  - Deep :  신경망에서 레이어의 수를 일컫는 기술 용어
    - 인공 신경망 구성을 위해 네트워크에서 input과 output 사이에 Hidden Layer를 두는데, 다수의 단순한 Hidden Layer들은 서로 다음 레이어와 재결합하여 보다 복잡한 형태의 망을 형성함.
    - 여러 개의 Layer로 이뤄진 네트워크는 더 많은 수학적 연산을 통해 입력 데이터를 전달함.
    - 학습에 더 복잡한 계산이 필요하게 됨
    - 따라서 딥 러닝 모델 학습에는 CPU 뿐만 아니라 병렬처리에 특화된 GPU가 필요
- 머신러닝은 인공지능의 한 분야에 불과하다.





## ML 종류 (5분)

### 지도학습(supervised Learning) 

- 훈련 데이터로부터 하나의 함수를 유추해내기 위한 기계학습의 방법

- 가령, 현재까지의 부동산 매물의 정보를 바탕으로, 방 개수 & 크기 & 위치 = 판매가 를 형성하는 함수를 도출해 낸다.

  ![이미지](https://miro.medium.com/max/1260/1*IzlJNAXx6Mwt02-W8ca_4Q.png)

  ![이미지](https://miro.medium.com/max/1260/1*sLiy7oDqMgLNndKXr2QYyw.png)

- 예 : 회귀분석, 신경망, Naive 베이즈 Classification,  Hidden Markov model 등 



### 자율학습 (비 지도 학습, unsupervised Learning)

- 각 주택의 판매가를 모른다고 해보자.

  ![이미지](https://miro.medium.com/max/1109/1*J63ZucZ84Qd-b-ppigOKAw.png)

- **입력값에 대한 목표치가 주어지지 않음!!** 숫자들이 의미하는 바가 무엇인지는 몰라도, 이 숫자들로부터 패턴이나 그룹화를 시도해볼 수 있다.

- 이를 바탕으로 서로 다른 시장의 세분화를 식별하는 것도 가능하다. 예컨대 대학가에서는 투룸 집을 선호한다든가..

- 응용 : 통계의 밀도 추정과 연관. 

- 예 : 클러스터링, 독립 성분 분석 등



### 강화학습

- 행	동심리학에서 영향 받음
- 어떤 환경 내에서 정의된 Agent가 현재의 상태를 인식하여 선택가능한 행동 중 보상을 최대화하는 행동 또는 행동순서를 선택하는 방법을 의미. 
- [데브시스터즈의 알파런](https://www.slideshare.net/carpedm20/naver-2017)
- [딥마인드 - 벽돌깨기 게임](https://www.youtube.com/watch?v=Q70ulPJW3Gk)
- 응용 분야 : 지능형 로봇 + 자율주행차







## ML in iOS / Xcode (15~20분)

## CoreML Framework

- 머신러닝 모델을 앱에 적용시키기 위해 사용하는 프레임워크.

- 모든 모델에 대해 균일한 representation 을 제공함 / 여기서 representation은 앞서 말한 ML의 핵심인 표현과 일반화의 그 표현을 의미한다고 보면 된다.

- 앱은 사용자 디바이스에서 Core ML APIs와 user data를 통해 예측을 하고, 보다 정교한 모델을 만들기 위해 트레이닝을 시킬 수 있다.

  ![이미지](https://docs-assets.developer.apple.com/published/7e05fb5a2e/4b0ecf58-a51a-4bfa-a361-eb77e59ed76e.png)

- **구조적 특성**

  ![이미지](https://docs-assets.developer.apple.com/published/65b8e13531/e3663268-5db4-42c9-a7f0-2114920a9f1f.png)

  - 하드웨어의 low-level에 위치함.
  -  **Metal Performance Shaders 프레임워크**  : 커널의 그래픽/연산 성능을 최적화하는 GPU Family를 다루는 프레임워크
  - **Accelerate 프레임워크** :  대규모 수학 연산, 이미지 연산, 성능 최적화와 관련된 와 유기적 작동을 위한 프레임워크 
  - **BNNS(Basic neural network subroutines)** - 기존에 확보한 트레이닝 데이터를 바탕으로 신경망 네트워크를 구축하고 작동하기 위한 서브루틴

  

- **지원하는 기능들** 
  - **Vision** for analyzing images
  - **Natural Language** for processing text
  - **Speech** for converting audio to text
  - **SoundAnalysis** for identifying sounds in audio.



## Model

- CoreML, CreateML, Xcode 등 여러 아키텍처 포맷 등에서 사용하기 위한 머신러닝 학습 모델로, **훈련을 위한 데이터 집합에 머신러닝 알고리즘을 적용한 결과**를 말한다.
- `.mlmodel` 확장자
- 여러 기본적인 학습 모델을 제공함 (2017~)
- 2018년부터 CreateML 을 지원하여 적은 코드로 직접 모델을 구축하고 사용할 수 있게 되었다.



###  

## CreateML ( WWDC 18)

- 2017년에 CoreML 출시 이후, **2가지 옵션**으로 ML Model을 제공함. **(~2017)**
  - 1) 애플에서 제공하는 **대표적인 ml 모델을 다운로드**
  - 2) Core ML tools를 사용하기
    - 기존 ML 커뮤니티와 연계하여 사용가능
    - Core ML 출시 당시 5~6개의 트레이닝 라이브러리를 지원하였으나, 현재는 유명한 트레이닝 라이브러리 상당수를 지원함.
    - 더욱 더 customization에 초점

- 스위프트 머신러닝 프레임워크

  - CreateML 내에서 모델을 만들고, CoreML 로 그 머신러닝을 작동시킴

- use case

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

  - **1) Problem** 

    - 먼저 앱을 구현하는 과정에 있어서, 문제 해결방식으로 머신 러닝이 올바른 선택인지 확인하자.  머신러닝을 쓸데없이 적용하진 말자. 머신러닝으로 해결할 문제상황을 정의하자.

  - **2) Collect Data**

    - 수집 데이터가 앱의 실제 사용에 유용함을 반영해야 한다.
    - 예를 들어, 커스텀 이미지 classifier를 만들때, 아이폰에서 사진을 수집하라. 적은  양의 스크린샷을 수집하지 많고 많은 아이폰 사진을 확보하라

  - **3) Train your model** 

  - **4) Evaluation**

    - 모델을 평가하라. 
    - 모델 평가는 별도의 분리된 handout set을 통해 수행한다. 결과가 만족스럽다면 MLModel로 만든다. 
    - 결과가 만족스럽지 않으면 model을 다시 훈련한다. 다양한 파라미터를 적용하거나, 더 많은 데이터를 수집한다.

    

- Create ML은 개발자에게 이 네가지 workflow 단계에 걸쳐서 도움을 준다.

  - **한줄의 코드 작성**으로 모델을 트레이닝 할 수 있다. 
  - 트레이닝이 끝나면 **하드웨어 최적화가 수행**된다.
    - 내장된 평가 메트릭들이 존재하여 개발자가 각각의 정밀도를 작성하고, 리콜 및 혼동 지표를 계산할 필요가 없다.





## CreateML model for Image Classification

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



## Vision 프레임워크를 사용할 때 주의사항

- Vision은 모델을 기반으로 이미지 분류 등의  ML을 수행하기 위한 특화된 프레임워크
- 기본적인 내용은 위와 동일



### Vision FeaturePrint.Scene

- Vision Frameworks FeaturePrint for Image Classification
- Available through ImageClassifier training in Create ML
- Trained on a very large dataset
- Capable of predicting over 1000 categories
- Powers user facing features in Photos (사진 속 얼굴 특징 인식)

**주의사항**

- **해당 모델의 새 버전을 출시 할 때** 새 모델을 재교육하지 않으면, 위와 같은 혜택을 반드시 자동으로 얻을 수있는 것은 아님.



다른 classifier 학습을 위한 프레임워크와 비교

- Resnet : 98MB 모델 크기
- Squeezenet : 더 작은 모델이나 많은 카테고리를 차별화하는 능력은 없음. 5 MB
- Vision : less than 1 MB



### WorkFlow

- 레이블된 이미지들을 수집하여 Create ML로 불러옴
- CreateML은 이미지들로부터 Vision Feature Print를 추출한다.
- CreateML은 우리가 만드려는 classifier를 트레이닝하고, classifier는 CoreML model이 된다.
- 실제로 이미지를 분석하고자 할 때, 필요한 것은 Vision이나 CoreML 내의 모델과 테스트 이미지 뿐

- 테스트 이미지를 분석하는 과정에서 우리의 Vision Feature Print를 사용하고, classification을 재트레이닝시킨다.



### 주의사항 - Refining the App 

- 문제상황 : Classifier는 강화연산된 deep Convolutional network이다. 그래서 Classifier를 실행할 때, 필연적으로 CPU나 GPU를 작동시키므로, Classifier 작동을 on/off 하고 싶을 것이다.

  - 데모에서, 실제로 카메라가 움직일 때가 아니라 실제 항목을 보는 경우에만 classifier를 사용하여 분류한다.

- 방안 : Vision을 이용할 때, `registration`  을 사용할 수 있다.

  > 카메라가 움직이고 있거나, Subject가 움직이지 않을 때는 registration 요청을 보내지 않도록 조정하여, classifier 연산이 작동하지 않도록 앱을 효율적으로 만들 수 있다는게 주요 내용

  - Registration은 두 개의 이미지를 촬영하고, 서로 비교 정렬할 수 있음을 의미한다.
    - 픽셀 간의 이동여부를 판단하여, 실제 분류작업을 위한 카메라 영상인지, 단순 카메라의 이동인지 등을 판단할 수 있는 지표가 된다.
  - 비용이 저렴하고 빠른 알고리즘 연산으로 작동
  - 카메라를 움직이지 않거나, 카메라 앞쪽으로 움직이는 물체가 있는 경우, VN 변환 이미지 Registration 요청( `VNTranslationalImageRegistrationRequest` )을 사용함.

- 문제 : Classification 은 잘못할 수 있다.
  - 높은 신뢰도를 지니고 있더라도, 올바르게 작동하지 않는 경우가 있을 것이다.
  - 따라서 이를 보완할 방법이 필요하다. 
    - 바코드 디텍터 등 대안 identification이 필요하다.
    - 새로운 이미지에 대해 DataSet을 수집하고, 재학습 시켜서 model을 재구축하는 방안이 필요하다.

- 예제에서 DispatchQueue.main.async 사용 이유 
  - 버퍼 release 하고 재사용하기 위함. 
  - 동기작업으로 진행시 큐에 지속적으로 버퍼들이 쌓이고, 백그라운드 작업에서 이와 같은 일이 진행되면 카메라 프레임의 성능저하로 이어진다.
- Recap
  - Scene의 안정성을 위해 Registration을 사용하라
    - VNSequenceRequestHandler와 VNTranslationalImageRegistrationRequest 를 사용하자.
  - 이전 프레임과의 비교작업으로 Registration요청을 보낼지 결정하자.
    - sequenceRequestHandler.perform([request], on: previousBuffer!)
  - Registration은 alignmentObservation.alignTransfrom 을 통해 현재의 픽셀이 과거의 프레임으로부터 얼마나 이동했는지에 대한 translation값을 얻는다.
    - scene이 안정적인 경우에만 분석을 시도한다.
    - 이 때, 현재 프레임에 대해 VNImageRequestHandler를 생성하여 현재 버퍼를 전달하자.
  - manage your buffers
    - 몇몇 비전 분석 요청은 시간이 걸린다.
    - 오래 걸리는 작업들은 비동기로 수행한다.
      - 더 오래 실행되는 작업은 백그라운드 대기열에서 수행하도록 하면서 카메라에서 수행하는 모든 작업들이 계속 실행될 수 있다.
    - 카메라에서 제공하는 버퍼를 계속 큐에 넣지는 말자. 하나의 큐와 작업을 하자.(권장)
  - why not use just Core ML? (Vision 사용 이유)
    - Vision 프레임워크는 버퍼를 카메라에서 가져 와서 RGB로 변환하고 축소하여 모든 작업을 수행하므로 코드를 작성할 필요가 없음
    - Vision을 통한 이미지 요청작업은 CoreML 모델을 훨씬 쉽게 구동할 수 있음



### object recognition

- YOLO (You Only Look Once) 테크닉
  - Fast Object Detection and Classification
    - Label과 Bounding Box
    - 많고 다양한 오브젝트들을 파악
  - 커스텀 오브젝트 훈련
    - ImageClassifier보다 더 트레이닝이 복잡함
  - 장점
    - 실제로 어디에 있든 얻을 수 있음 
    - 이미지 Classifier와 같이 가능한 많은 classification을 얻지는 못함.
    - Turi Create 세션 참고 



- VNRecognizedObjectObservation
  - Result of a VNCoreMLModelRequest
  - New observation subclass VNRecognizedObjectObservation
  - YOLO based models made easy

- Tracking이 Detection 보다 더 빠르게 작동할 수 있다.
  - 일단 한번 Detection 작업 후에 redetection 보다는 tracking 요청이 효과적이다.



### Vision mastery

- Issue 1: 이미지의 방향 (orientation)
  - 모든 비전 알고리즘이 방향에 영향받지 않는 것이 아니다. 
  - 이미지는 항상 upright 방향에 놓여있지 않다.
    - EXIF orientation은 어느 방향이 upright인지 알려준다.
    - input으로 URL을 사용하면, Vision은 파일로부터 EXIF orientation을 읽는다.
  - Live from a capture feed
    - 오리엔테이션은 UIDevice.current.orientation으로부터 추론할 수 있다. 
    - CGImagePropertyOrientation에 매핑될 필요가 있다.
- Vision 좌표계
  - Origin은 좌하단 모서리영역이다. 
  - 모든 이미지 관련 프로세싱은 우상단 좌표계를 갖는다.
  - 따라서 좌표계를 normalized 하는 작업을 거친다. (0.0) to (1.0)
  - face 사각형에 대해 Landmark는 상대적이다.
    - 가령, 전체 좌표계에서 얼굴 사각형의 좌표가 0.3, 0.5에 위치해 있지만, 얼굴사각형의 원점으로부터 입은 0.2, 0.3에 위치한다.
  - `VNUtils.h` provides conversion utils into image coordinates like `VNImageRectForNormalizedRect`
- Confidence Score
  - 신뢰성 수준은 0.0 low 에서 1.0 highest 까지 표현
  - 이미지 분석 요청 유형에 따라 scale이 균일하지는 않다.
  - 1.0이 항상 옳은가?
    - 알고리즘의 기준치는 충족하지만, 실제 인지하는 결과와 다를 수 있다.
  - 임계값(threshold)은 유즈케이스에 따라 달라진다.



[Creating an Image Classifier Model](https://developer.apple.com/documentation/createml/creating_an_image_classifier_model#overview)

https://developer.apple.com/videos/play/wwdc2018/703?time=586

https://developer.apple.com/documentation/createml