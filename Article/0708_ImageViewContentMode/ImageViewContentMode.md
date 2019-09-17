## ImageView ContentMode



- 이미지뷰는 contentMode 프로퍼티가 존재합니다. 이 프로퍼티는 이미지가 화면에 어떻게 보여질지를 겨라는데 사용됩니다.

```swift
var contentMode: UIView.ContentMode { get set }
```

- 특정 콘텐츠모드로 뷰를 다시 강제로 그리게 하고 싶다면 아래의 함수를 호출하면 됩니다.
  -  [`setNeedsDisplay()`](https://developer.apple.com/documentation/uikit/uiview/1622437-setneedsdisplay) 
  -  [`setNeedsDisplay(_:)`](https://developer.apple.com/documentation/uikit/uiview/1622587-setneedsdisplay) 



### Scale To Fill([`UIView.ContentMode.scaleToFill`](https://developer.apple.com/documentation/uikit/uiview/contentmode/scaletofill)) 

- imageView의 width와 height에 맞게 이미지를 scale하여 넣습니다.
- **원본 비율을 무시**하므로 권장되지는 않습니다.

### Aspect To Fit ([`UIView.ContentMode.scaleAspectFit`](https://developer.apple.com/documentation/uikit/uiview/contentmode/scaleaspectfit) )

- 비율을 **원본 비율로 유지**합니다.
- 이미지가 imageView의 크기를 벗어나지 않는 범위 내에서 최대값(width or height) 을 갖습니다.
- 이미지의 비율이 imageView 크기와 맞지 않으면 **`여백` 이 생김**

### Aspect To Fill [`UIView.ContentMode.scaleAspectFill`](https://developer.apple.com/documentation/uikit/uiview/contentmode/scaleaspectfill)

- **원본 비율을 유지**합니다.
- imageView 의 내부에 **`여백`은 생기지 않습니다.**
- 이미지가 **imageView의 영역 밖으로 나갈 수** 있습니다. 
  - imageView의 inspector에서 `clip to bounds` 설정 체크시, 이미지가 imageView 밖으로 나가는 것을 막습니다.



### Redraw

- 결과만 놓고 보면 Scale To Fill과 같음
- 내부적으로  drawRect를 많이 호출하므로 꼭 필요한 경우가 아니면 사용을 자제



### CF 

- 기타 [Center], [Right], [Left], [Top], [Bottom], [Top Left], [Top Right], [Bottom Left], [Bottom Right] 등이 존재. 
  - 크기 변화는 없이 전체 Rect에 대비하여 View를 어디에 맞출 것인지에 따라 다릅니다.
  - 크기 변화를 일으키는 것은 앞서 거론한 4개입니다.

- 리사이즈 가능한 이미지의 경우 다음의 UIImage의 메서드를 활용해 볼 수 있습니다.
- [`resizableImage(withCapInsets:resizingMode:)`](https://developer.apple.com/documentation/uikit/uiimage/1624127-resizableimage)
  - 해당 메서드 사용시 이미지를 보통 [`UIView.ContentMode.scaleToFill`](https://developer.apple.com/documentation/uikit/uiview/contentmode/scaletofill) 로 설정하여 이미지 뷰의 경계선에 맞게 이미지를 적절하게 늘이거나 채울 수 있습니다.

### Reference

https://developer.apple.com/documentation/uikit/uiimageview

https://developer.apple.com/documentation/uikit/uiimage/1624127-resizableimage

 https://oneday0012.tistory.com/119 

[이미지 뷰 Content Mode를 Aspect To Fill 로 하는 경우의 이슈](https://zeddios.tistory.com/311)

[masksToBounds/clipsToBounds의 차이점](https://zeddios.tistory.com/37)

