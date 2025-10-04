# LWSnapshot

[![CI Status](https://img.shields.io/travis/luowei/LWSnapshot.svg?style=flat)](https://travis-ci.org/luowei/LWSnapshot)
[![Version](https://img.shields.io/cocoapods/v/LWSnapshot.svg?style=flat)](https://cocoapods.org/pods/LWSnapshot)
[![License](https://img.shields.io/cocoapods/l/LWSnapshot.svg?style=flat)](https://cocoapods.org/pods/LWSnapshot)
[![Platform](https://img.shields.io/cocoapods/p/LWSnapshot.svg?style=flat)](https://cocoapods.org/pods/LWSnapshot)

[English](./README.md) | [中文版](./README_ZH.md) | [Swift Version](./README_SWIFT_VERSION.md)

---

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [Interactive Features](#interactive-features)
- [API Documentation](#api-documentation)
- [Technical Details](#technical-details)
- [Example Project](#example-project)
- [FAQ](#frequently-asked-questions-faq)
- [Contributing](#contributing)
- [License](#license)

---

## Overview

LWSnapshot is a powerful and easy-to-use iOS screenshot/snapshot library that provides an elegant way to capture screenshots with a customizable mask view and region selection. It supports automatic screenshot detection, manual triggering through gestures, and provides an intuitive interface for users to adjust the snapshot area with full editing capabilities.

## Features

### Core Capabilities
- **Customizable Snapshot Region**: Users can freely adjust the snapshot area through intuitive gestures
- **Multiple Trigger Methods**:
  - System screenshot detection (Power + Volume buttons)
  - Custom gesture recognition (e.g., two-finger long press)
  - Programmatic invocation
- **Intuitive Visual Interface**:
  - Semi-transparent mask layer highlighting the selection area
  - Dashed borders and four corner indicators for clear visual guidance
  - Cancel, fullscreen, and share buttons for easy control
- **Flexible Region Editing**:
  - Drag the inner area to move the snapshot frame
  - Drag edges to adjust width or height
  - Drag corners to adjust both dimensions simultaneously
- **One-Tap Sharing**: Integrated with iOS native share sheet for multiple sharing options

### Technical Highlights
- Built with Objective-C
- Support for iOS 8.0+
- Gesture-based smooth interaction
- Core Graphics for high-quality snapshot rendering
- Automatic screen rotation adaptation
- Easy integration with CocoaPods or Carthage

## Requirements

- iOS 8.0 or later
- Xcode 9.0 or later

## Installation

LWSnapshot is available through [CocoaPods](https://cocoapods.org) and Carthage.

### CocoaPods

Add the following line to your Podfile:

```ruby
pod 'LWSnapshot'
```

Then run:

```bash
pod install
```

### Carthage

Add the following line to your Cartfile:

```ruby
github "luowei/LWSnapshot"
```

## Usage

### Quick Start

#### 1. Import the Header

```objective-c
#import <LWSnapshot/LWSnapshotMaskView.h>
```

#### 2. Automatic Screenshot Detection

Listen for system screenshot notifications to automatically display the snapshot mask:

```objective-c
// Register for screenshot notifications in viewDidLoad or an appropriate location
[[NSNotificationCenter defaultCenter] addObserver:self
                                         selector:@selector(appDidTakeScreenshotNotification:)
                                             name:UIApplicationUserDidTakeScreenshotNotification
                                           object:nil];

- (void)appDidTakeScreenshotNotification:(NSNotification *)notification {
    [self showSnapshotView];
}

// Remember to remove observer in dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
```

#### 3. Manual Trigger with Gesture Recognition

Add a two-finger long press gesture to trigger snapshot mode:

```objective-c
// Add two-finger long press gesture recognizer
UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] init];
longPressGesture.numberOfTouchesRequired = 2;  // Requires two fingers
[longPressGesture addTarget:self action:@selector(longPressGestureAction:)];
[self.view addGestureRecognizer:longPressGesture];

- (void)longPressGestureAction:(UILongPressGestureRecognizer *)gesture {
    if(gesture.state == UIGestureRecognizerStateBegan) {
        [self showSnapshotView];
    }
}
```

#### 4. Display Snapshot View

```objective-c
- (void)showSnapshotView {
    // Display the snapshot mask in the specified view
    LWSnapshotMaskView *snapshotMaskView = [LWSnapshotMaskView showSnapshotMaskInView:self.view];

    // Customize initial snapshot area (optional)
    CGFloat width = 200;
    CGFloat height = 200;
    CGFloat x = (self.view.frame.size.width - width) / 2;
    CGFloat y = (self.view.frame.size.height - height) / 2;
    snapshotMaskView.snapshotFrame = CGRectMake(x, y, width, height);
}
```

#### 5. Programmatic Trigger

```objective-c
// Trigger snapshot via button or other interaction
- (IBAction)takeSnapshot:(UIButton *)sender {
    [self showSnapshotView];
}
```

### Advanced Usage

#### Custom Close Callback

You can set a callback block that executes when the snapshot view is closed:

```objective-c
LWSnapshotMaskView *snapshotMaskView = [LWSnapshotMaskView showSnapshotMaskInView:self.view];
snapshotMaskView.closeBlock = ^{
    NSLog(@"Snapshot view has been closed");
    // Perform custom actions
};
```

#### Hide Snapshot View Programmatically

```objective-c
[LWSnapshotMaskView hideSnapshotMaskInView:self.view];
```

#### Customize Button Appearance

Access and customize the control buttons:

```objective-c
LWSnapshotMaskView *maskView = [LWSnapshotMaskView showSnapshotMaskInView:self.view];

// Customize share button
maskView.shareBtn.backgroundColor = [UIColor blueColor];
[maskView.shareBtn setTitle:@"Save" forState:UIControlStateNormal];

// Customize cancel button
maskView.cancelBtn.tintColor = [UIColor redColor];

// Customize fullscreen button
maskView.fullScreenBtn.alpha = 0.8;
```

#### Capture Screenshot Without Sharing

Use the UIView category method to capture a screenshot directly:

```objective-c
UIImage *screenshot = [self.view snapshot_imageInRect:rect];
// Save or process the screenshot as needed
UIImageWriteToSavedPhotosAlbum(screenshot, nil, nil, nil);
```

## Interactive Features

### Understanding the Mask View

The `LWSnapshotMaskView` provides an interactive overlay with the following components:

1. **Semi-transparent Mask**: Darkens the area outside the selection
2. **Selection Frame**: The highlighted area that will be captured
3. **Dashed Border**: Visual indicator of the selection boundaries
4. **Corner Indicators**: Four circular markers at corners for resizing
5. **Control Buttons**: Cancel, fullscreen, and share buttons at the top

### Editing the Snapshot Region

Users can interact with the snapshot mask to adjust the capture area:

#### 1. Moving the Selection Frame

- **Action**: Tap and drag inside the selection frame
- **Result**: The entire frame moves while maintaining its size
- **Visual Feedback**: The frame follows the touch position smoothly

#### 2. Adjusting Width

- **Action**: Drag the left or right edge of the frame
- **Result**: The width adjusts while height remains constant
- **Minimum Size**: 30 pixels to prevent the frame from becoming too small

#### 3. Adjusting Height

- **Action**: Drag the top or bottom edge of the frame
- **Result**: The height adjusts while width remains constant
- **Minimum Size**: 30 pixels to prevent the frame from becoming too small

#### 4. Adjusting Both Dimensions

- **Action**: Drag any of the four corner indicators
- **Result**: Both width and height adjust simultaneously
- **Behavior**: Maintains natural proportions based on drag direction

### Control Buttons

#### Cancel Button (Top Left)
- Closes the snapshot view without saving
- Returns to normal view mode
- Triggers the `closeBlock` if defined

#### Fullscreen Button (Top Center)
- Expands the selection frame to cover the entire screen
- Quick way to capture the full screen content
- Useful when you want to capture everything

#### Share Button (Top Right)
- Captures the current selection area
- Opens the iOS native share sheet (UIActivityViewController)
- Supports multiple sharing options:
  - Save to Photos
  - Share via Messages, Mail, etc.
  - Copy to clipboard
  - Third-party app integrations

### Snapshot Frame Configuration

You can customize the initial snapshot view frame programmatically:

```objective-c
LWSnapshotMaskView *snapshotMaskView = [LWSnapshotMaskView showSnapshotMaskInView:self.view];

// Set custom frame (x, y, width, height)
snapshotMaskView.snapshotFrame = CGRectMake(50, 100, 300, 400);

// Center the snapshot view
CGFloat centerX = (self.view.frame.size.width - 200) / 2;
CGFloat centerY = (self.view.frame.size.height - 200) / 2;
snapshotMaskView.snapshotFrame = CGRectMake(centerX, centerY, 200, 200);

// Full screen snapshot
snapshotMaskView.snapshotFrame = self.view.bounds;
```

## API Documentation

### LWSnapshotMaskView

The main class that provides the snapshot mask view functionality.

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| `snapshotFrame` | `CGRect` | The frame of the snapshot selection area |
| `selectRegion` | `UIView *` | The selection region view (deprecated) |
| `cancelBtn` | `UIButton *` | The cancel button |
| `shareBtn` | `UIButton *` | The share button |
| `fullScreenBtn` | `UIButton *` | The fullscreen button |
| `closeBlock` | `void (^)()` | Callback block executed when the view is closed |

#### Class Methods

```objective-c
// Display the snapshot mask in the specified view
+ (LWSnapshotMaskView *)showSnapshotMaskInView:(UIView *)view;

// Hide the snapshot mask from the specified view
+ (void)hideSnapshotMaskInView:(UIView *)view;
```

#### Instance Methods

```objective-c
// Determine which area of the snapshot frame a point is in
- (PointLocation)locationOfPoint:(CGPoint)point;
```

### UIView (SSRotation) Category

Extension methods for view manipulation and screenshot capture.

```objective-c
// Get the superview of a specified class type
- (id)snapshot_superViewWithClass:(Class)clazz;

// Recursively send screen rotation messages to subviews
- (void)snapshot_rotationToInterfaceOrientation:(UIInterfaceOrientation)orientation;

// Capture an image of a UIView in the specified rect
- (UIImage *)snapshot_imageInRect:(CGRect)rect;
```

### PointLocation Enumeration

Defines the touch location relative to the snapshot frame:

```objective-c
typedef NS_ENUM(NSInteger, PointLocation) {
    Outside = 1 << 0,                    // Outside the frame
    InControl = 1 << 1,                  // Inside the frame
    OnControl = 1 << 2,                  // On the frame
    OnTopEdge = (1 << 3) | OnControl,    // On top edge
    OnBottomEdge = (1 << 4) | OnControl, // On bottom edge
    OnLeftEdge = (1 << 5) | OnControl,   // On left edge
    OnRightEdge = (1 << 6) | OnControl,  // On right edge
    OnLeftTopCorner = (1 << 7) | OnControl,      // On left top corner
    OnRightTopCorner = (1 << 8) | OnControl,     // On right top corner
    OnLeftBottomCorner = (1 << 9) | OnControl,   // On left bottom corner
    OnRightBottomCorner = (1 << 10) | OnControl, // On right bottom corner
};
```

## Technical Details

### Implementation

The library leverages several iOS frameworks and technologies to provide a seamless user experience:

#### Core Technologies

1. **Gesture Recognition**: Uses `UIPanGestureRecognizer` for drag-to-adjust functionality
2. **Graphics Rendering**:
   - `UIBezierPath` for drawing mask layers and selection frames
   - `CGContextSetBlendMode` for transparent selection area effect
   - Dashed borders and circular corner indicators for visual guidance
3. **Screenshot Generation**: Uses `drawViewHierarchyInRect:afterScreenUpdates:` for efficient region capture
4. **System Integration**: `UIActivityViewController` for native sharing experience

#### Touch Event Handling

The component uses precise touch location detection for flexible region adjustment:

- Determines if touch point is inside, on edges, or on corners of selection frame
- Executes appropriate drag logic based on touch location
- Enforces minimum size constraint (30x30) to prevent frame from becoming too small
- Boundary detection ensures selection frame stays within view bounds

## Example Project

To run the example project:

1. Clone the repository:
```bash
git clone https://github.com/luowei/LWSnapshot.git
cd LWSnapshot
```

2. Install dependencies:
```bash
cd Example
pod install
```

3. Open the workspace:
```bash
open LWSnapshot.xcworkspace
```

### Important Notes

1. **Memory Management**: Remember to remove notification observers in `dealloc`
2. **iPad Compatibility**: Share functionality displays as a popover on iPad
3. **Screen Rotation**: The component automatically removes itself during screen rotation and needs to be displayed again
4. **Performance Optimization**: Uses `drawViewHierarchyInRect:afterScreenUpdates:` instead of legacy `renderInContext:` for better screenshot performance

## Frequently Asked Questions (FAQ)

### How do I change the default snapshot region size?

Set the `snapshotFrame` property:

```objective-c
LWSnapshotMaskView *maskView = [LWSnapshotMaskView showSnapshotMaskInView:self.view];
maskView.snapshotFrame = CGRectMake(x, y, width, height);
```

### How do I customize button styles?

Access the `cancelBtn`, `shareBtn`, and `fullScreenBtn` properties:

```objective-c
maskView.shareBtn.backgroundColor = [UIColor blueColor];
[maskView.shareBtn setTitle:@"Save" forState:UIControlStateNormal];
```

### How do I get a screenshot without sharing?

Call the UIView category method directly:

```objective-c
UIImage *screenshot = [self.view snapshot_imageInRect:rect];
// Save or process the screenshot
```

### Does it support landscape mode?

The component removes itself during screen rotation. To use in landscape mode, display the view again after rotation completes.

## Contributing

Contributions are welcome! Please feel free to submit issues and pull requests.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

LWSnapshot is available under the MIT license. See the [LICENSE](LICENSE) file for more info.

## Author

**luowei** - [luowei@wodedata.com](mailto:luowei@wodedata.com)

## Support

If you find this project helpful, please consider giving it a star on GitHub. For bug reports and feature requests, please open an issue.

## Acknowledgments

Thanks to all contributors who have helped make this project better.
