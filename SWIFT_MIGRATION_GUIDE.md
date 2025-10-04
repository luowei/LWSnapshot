# LWSnapshot Swift/SwiftUI Migration Guide

This guide helps you migrate from the Objective-C version to the Swift/SwiftUI version of LWSnapshot.

## Overview

LWSnapshot is a customizable screenshot capture component that allows users to select and capture specific regions of the screen. The Swift version maintains full API compatibility while adding modern Swift and SwiftUI support.

## File Structure

```
LWSnapshot/Classes/
├── LWSnapshotMaskView.swift     # Main Swift implementation (UIKit)
├── LWSnapshotView.swift          # SwiftUI wrapper
├── LWSnapshot.swift              # Convenience API
└── Examples/
    ├── UIKitExample.swift        # UIKit usage examples
    └── SwiftUIExample.swift      # SwiftUI usage examples
```

## Migration from Objective-C to Swift

### Objective-C (Old)
```objc
#import <LWSnapshot/LWSnapshotMaskView.h>

// Show snapshot mask
LWSnapshotMaskView *maskView = [LWSnapshotMaskView showSnapshotMaskInView:self.view];
maskView.snapshotFrame = CGRectMake(50, 100, 200, 200);

// Hide snapshot mask
[LWSnapshotMaskView hideSnapshotMaskInView:self.view];
```

### Swift (New)
```swift
import LWSnapshot

// Method 1: Using static method
let maskView = LWSnapshotMaskView.showSnapshotMask(in: view)
maskView.snapshotFrame = CGRect(x: 50, y: 100, width: 200, height: 200)

// Method 2: Using convenience API
LWSnapshot.show(in: view) {
    print("Snapshot closed")
}

// Method 3: Using view controller extension
showSnapshotMask {
    print("User cancelled")
}

// Hide
LWSnapshot.hide(in: view)
// or
hideSnapshotMask()
```

## SwiftUI Integration

### Basic Usage
```swift
import SwiftUI
import LWSnapshot

struct ContentView: View {
    @State private var showSnapshot = false

    var body: some View {
        VStack {
            Button("Take Screenshot") {
                showSnapshot = true
            }
        }
        .snapshotMask(isPresented: $showSnapshot) {
            print("Snapshot closed")
        }
    }
}
```

### Advanced Usage with Frame Tracking
```swift
struct ContentView: View {
    @State private var showSnapshot = false
    @State private var snapshotFrame: CGRect = .zero

    var body: some View {
        VStack {
            Text("Frame: \(snapshotFrame)")

            Button("Take Screenshot") {
                showSnapshot = true
            }
        }
        .snapshot(isPresented: $showSnapshot, snapshotFrame: $snapshotFrame) {
            print("Final frame: \(snapshotFrame)")
        }
    }
}
```

## API Reference

### LWSnapshotMaskView (UIKit)

#### Properties
- `selectRegion: UIView?` - Selected region view
- `cancelBtn: UIButton` - Cancel button
- `shareBtn: UIButton` - Share button
- `fullScreenBtn: UIButton` - Full screen button
- `snapshotFrame: CGRect` - Current snapshot frame
- `closeBlock: (() -> Void)?` - Closure called when closed

#### Static Methods
```swift
class func showSnapshotMask(in view: UIView) -> LWSnapshotMaskView
class func hideSnapshotMask(in view: UIView)
```

#### Instance Methods
```swift
func location(of point: CGPoint) -> PointLocation
```

### LWSnapshot (Convenience API)

```swift
// Show in specific view
LWSnapshot.show(in: view) { /* close handler */ }

// Show in key window
LWSnapshot.show() { /* close handler */ }

// Hide in specific view
LWSnapshot.hide(in: view)

// Hide in key window
LWSnapshot.hide()
```

### UIViewController Extensions

```swift
extension UIViewController {
    func showSnapshotMask(closeHandler: (() -> Void)? = nil) -> LWSnapshotMaskView
    func hideSnapshotMask()
}
```

### UIView Extensions

```swift
extension UIView {
    func showSnapshotMask(closeHandler: (() -> Void)? = nil) -> LWSnapshotMaskView
    func hideSnapshotMask()
    func snapshot_image(in rect: CGRect) -> UIImage?
    func snapshot_superView<T: UIResponder>(withClass: T.Type) -> UIResponder?
}
```

### SwiftUI Modifiers

```swift
extension View {
    func snapshotMask(isPresented: Binding<Bool>, onClose: (() -> Void)? = nil) -> some View

    func snapshot(
        isPresented: Binding<Bool>,
        snapshotFrame: Binding<CGRect>? = nil,
        onClose: (() -> Void)? = nil
    ) -> some View
}
```

## Common Use Cases

### 1. Screenshot on Long Press (UIKit)
```swift
let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
longPress.numberOfTouchesRequired = 2
view.addGestureRecognizer(longPress)

@objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
    if gesture.state == .began {
        showSnapshotMask()
    }
}
```

### 2. Screenshot on System Capture (UIKit)
```swift
NotificationCenter.default.addObserver(
    self,
    selector: #selector(screenCaptured),
    name: UIApplication.userDidTakeScreenshotNotification,
    object: nil
)

@objc func screenCaptured() {
    showSnapshotMask()
}
```

### 3. Tab-Based App (SwiftUI)
```swift
struct App: View {
    @State private var showSnapshot = false

    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Home", systemImage: "house") }

            SettingsView()
                .tabItem { Label("Settings", systemImage: "gear") }
        }
        .snapshotMask(isPresented: $showSnapshot)
    }
}
```

## PointLocation Enum

```swift
enum PointLocation {
    case outside
    case inControl
    case onControl
    case onTopEdge
    case onBottomEdge
    case onLeftEdge
    case onRightEdge
    case onLeftTopCorner
    case onRightTopCorner
    case onLeftBottomCorner
    case onRightBottomCorner
}
```

## Installation

### CocoaPods
```ruby
pod 'LWSnapshot'
```

### Swift Package Manager
```swift
dependencies: [
    .package(url: "https://github.com/luowei/LWSnapshot.git", from: "1.0.0")
]
```

## Features

- ✅ Customizable screenshot region selection
- ✅ Drag and resize support
- ✅ Share captured image
- ✅ Full screen capture
- ✅ UIKit and SwiftUI support
- ✅ Modern Swift API
- ✅ Closure-based callbacks
- ✅ View extensions for convenience

## Requirements

- iOS 13.0+
- Swift 5.3+
- Xcode 12.0+

## License

MIT License - See LICENSE file for details
