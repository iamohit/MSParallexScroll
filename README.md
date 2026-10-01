# MSParallexScroll

Image parallax for UIKit and SwiftUI. The image shifts a little while the nearest table or collection view scrolls.

Default is `amount` `0.35` on both axes.

## UIKit

Set the image view class to `ParallaxImageView`.

```swift
imageView.amount = 0.5
imageView.axis = .horizontal // .vertical or .both
```

## SwiftUI

```swift
AsyncImageFromURL(imageURL: url)
    .frame(height: 150)
    .parallax(amount: 0.5, axis: .vertical)
```

`.parallax()` with no arguments uses the default.
