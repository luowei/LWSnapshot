# LWSnapshot Swift Version

## 概述

LWSnapshot_swift 是 LWSnapshot 的 Swift 版本实现，提供了现代化的 Swift API 用于实现可自定义选取截取范围的截图功能。

## 安装

### CocoaPods

在您的 `Podfile` 中添加：

```ruby
pod 'LWSnapshot_swift'
```

然后运行：

```bash
pod install
```

## 使用方法

### Swift / SwiftUI

```swift
import LWSnapshot_swift

// 使用 LWSnapshot
let snapshot = LWSnapshot()
snapshot.takeSnapshot { image in
    // 处理截图
}

// 使用 LWSnapshotView
let snapshotView = LWSnapshotView()
view.addSubview(snapshotView)

// 使用 LWSnapshotMaskView
let maskView = LWSnapshotMaskView()
view.addSubview(maskView)
```

## 系统要求

- iOS 11.0+
- Swift 5.0+
- Xcode 12.0+

## 与 Objective-C 版本的关系

- **LWSnapshot**: Objective-C 版本，适用于传统的 Objective-C 项目
- **LWSnapshot_swift**: Swift 版本，提供现代化的 Swift API

您可以根据项目需要选择合适的版本。两个版本功能相同，只是 API 风格不同。

## License

LWSnapshot_swift is available under the MIT license. See the LICENSE file for more info.
