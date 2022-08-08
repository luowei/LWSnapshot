# LWSnapshot

[![CI Status](https://img.shields.io/travis/luowei/LWSnapshot.svg?style=flat)](https://travis-ci.org/luowei/LWSnapshot)
[![Version](https://img.shields.io/cocoapods/v/LWSnapshot.svg?style=flat)](https://cocoapods.org/pods/LWSnapshot)
[![License](https://img.shields.io/cocoapods/l/LWSnapshot.svg?style=flat)](https://cocoapods.org/pods/LWSnapshot)
[![Platform](https://img.shields.io/cocoapods/p/LWSnapshot.svg?style=flat)](https://cocoapods.org/pods/LWSnapshot)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.


```Objective-C
//listen screen snapshot
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidTakeScreenshotNotification:) name:UIApplicationUserDidTakeScreenshotNotification object:nil];

- (void)appDidTakeScreenshotNotification:(NSNotification *)notification {
    [self showSnapshotView];
}


//show snapshot view
- (void)showSnapshotView {
    LWSnapshotMaskView *snapshotMaskView = [LWSnapshotMaskView showSnapshotMaskInView:self.view];
    snapshotMaskView.snapshotFrame = CGRectMake((self.view.frame.size.width-200)/2, (self.view.frame.size.height-200)/2, 200, 200);
}


//long press gesture recongniz
- (void)longPressGestureAction:(UILongPressGestureRecognizer *)gesture {
    NSLog(@"--------: recongizer gesture snapshot");

    if(gesture.state == UIGestureRecognizerStateBegan ){
        [self showSnapshotView];
    }

}
```

## Requirements

## Installation

LWSnapshot is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'LWSnapshot'
```

**Carthage**
```ruby
github "luowei/LWSnapshot"
```

## Author

luowei, luowei@wodedata.com

## License

LWSnapshot is available under the MIT license. See the LICENSE file for more info.
