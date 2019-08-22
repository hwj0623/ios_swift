# Vision with Core ML _ 717

Custom Image Classification



이미지 수집

- Sort into folders—the folder names are used as labels

- How many data do I need
  - Minimum of 10 per category but more is better/ 다다익선
  - Highly imbalanced datasets are hard to train / 가령 하나의 label 은 1000개, 하나는 10개 인 불균형은 학습이 어렵다.
- Augmentation adds some robustness on top of it but doesn’t replace variety
  - 이미지에 대한 노이즈, 블러, 로테이션등의 증강/로버스트 들은 이미지 훈련을 돕는다.
- Transfer Learning
  - Starts with a pre-trained model
    - This is the heavy load
  - Use that model as a Feature Extractor Pre-trained Model
  - Train a last layer as a classifier with your labeled data



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

[Classifying Images with Vision and Core ML](https://developer.apple.com/documentation/vision/classifying_images_with_vision_and_core_ml)

[Detecting Objects in Still Images](https://developer.apple.com/documentation/vision/detecting_objects_in_still_images)

