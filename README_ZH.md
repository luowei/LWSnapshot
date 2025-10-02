# LWSnapshot

[![CI Status](https://img.shields.io/travis/luowei/LWSnapshot.svg?style=flat)](https://travis-ci.org/luowei/LWSnapshot)
[![Version](https://img.shields.io/cocoapods/v/LWSnapshot.svg?style=flat)](https://cocoapods.org/pods/LWSnapshot)
[![License](https://img.shields.io/cocoapods/l/LWSnapshot.svg?style=flat)](https://cocoapods.org/pods/LWSnapshot)
[![Platform](https://img.shields.io/cocoapods/p/LWSnapshot.svg?style=flat)](https://cocoapods.org/pods/LWSnapshot)

一个功能强大且易于使用的 iOS 截图组件，支持自定义选取截图区域，提供多种触发方式和直观的用户交互体验。

## 功能特性

### 核心功能
- **可自定义截图区域**：用户可以通过手势自由调整截图的选取范围
- **多种触发方式**：
  - 系统截图监听（按下电源键+音量键触发）
  - 自定义手势识别（如双指长按）
  - 代码主动调用
- **直观的可视化界面**：
  - 半透明遮罩层突出显示选取区域
  - 虚线边框和四个角点清晰标识选取范围
  - 提供取消、全屏和分享按钮
- **灵活的区域调整**：
  - 拖动内部区域移动截图框
  - 拖动边缘调整宽度或高度
  - 拖动四角同时调整宽度和高度
- **一键分享**：集成系统分享功能，支持多种分享渠道

### 技术特点
- 基于 Objective-C 开发
- 支持 iOS 8.0 及以上版本
- 采用手势识别实现流畅的交互体验
- 使用 Core Graphics 绘制高质量的截图效果
- 自动适配屏幕旋转

## 安装方式

### CocoaPods

在你的 `Podfile` 中添加：

```ruby
pod 'LWSnapshot'
```

然后执行：

```bash
pod install
```

### Carthage

在你的 `Cartfile` 中添加：

```ruby
github "luowei/LWSnapshot"
```

## 使用方法

### 快速开始

#### 1. 导入头文件

```objective-c
#import <LWSnapshot/LWSnapshotMaskView.h>
```

#### 2. 监听系统截图通知

```objective-c
// 在 viewDidLoad 或其他适当位置注册通知
[[NSNotificationCenter defaultCenter] addObserver:self
                                         selector:@selector(appDidTakeScreenshotNotification:)
                                             name:UIApplicationUserDidTakeScreenshotNotification
                                           object:nil];

- (void)appDidTakeScreenshotNotification:(NSNotification *)notification {
    [self showSnapshotView];
}

// 记得在 dealloc 中移除通知
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
```

#### 3. 使用手势识别

```objective-c
// 添加双指长按手势
UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] init];
longPressGesture.numberOfTouchesRequired = 2;  // 需要两个手指
[longPressGesture addTarget:self action:@selector(longPressGestureAction:)];
[self.view addGestureRecognizer:longPressGesture];

- (void)longPressGestureAction:(UILongPressGestureRecognizer *)gesture {
    if(gesture.state == UIGestureRecognizerStateBegan) {
        [self showSnapshotView];
    }
}
```

#### 4. 显示截图视图

```objective-c
- (void)showSnapshotView {
    // 在指定视图中显示截图遮罩
    LWSnapshotMaskView *snapshotMaskView = [LWSnapshotMaskView showSnapshotMaskInView:self.view];

    // 自定义初始截图区域（可选）
    CGFloat width = 200;
    CGFloat height = 200;
    CGFloat x = (self.view.frame.size.width - width) / 2;
    CGFloat y = (self.view.frame.size.height - height) / 2;
    snapshotMaskView.snapshotFrame = CGRectMake(x, y, width, height);
}
```

### 高级用法

#### 自定义关闭回调

```objective-c
LWSnapshotMaskView *snapshotMaskView = [LWSnapshotMaskView showSnapshotMaskInView:self.view];
snapshotMaskView.closeBlock = ^{
    NSLog(@"截图视图已关闭");
    // 执行自定义操作
};
```

#### 隐藏截图视图

```objective-c
[LWSnapshotMaskView hideSnapshotMaskInView:self.view];
```

#### 代码触发截图

```objective-c
// 通过按钮或其他交互触发
- (IBAction)takeSnapshot:(UIButton *)sender {
    [self showSnapshotView];
}
```

## 用户交互说明

### 调整截图区域

1. **移动截图框**：点击并拖动截图框内部区域
2. **调整宽度**：拖动左边缘或右边缘
3. **调整高度**：拖动上边缘或下边缘
4. **同时调整宽高**：拖动四个角点

### 控制按钮

- **取消按钮**（左上角）：关闭截图视图，不保存
- **全屏按钮**（中上方）：将截图区域扩展至全屏
- **分享按钮**（右上角）：截取选定区域并打开系统分享面板

## API 文档

### LWSnapshotMaskView

#### 属性

| 属性 | 类型 | 说明 |
|------|------|------|
| `snapshotFrame` | `CGRect` | 截图选取区域的位置和大小 |
| `selectRegion` | `UIView *` | 选取区域视图（已废弃） |
| `cancelBtn` | `UIButton *` | 取消按钮 |
| `shareBtn` | `UIButton *` | 分享按钮 |
| `fullScreenBtn` | `UIButton *` | 全屏按钮 |
| `closeBlock` | `void (^)()` | 关闭视图时的回调 |

#### 类方法

```objective-c
// 在指定视图中显示截图遮罩
+ (LWSnapshotMaskView *)showSnapshotMaskInView:(UIView *)view;

// 从指定视图中隐藏截图遮罩
+ (void)hideSnapshotMaskInView:(UIView *)view;
```

#### 实例方法

```objective-c
// 判断点击位置在截图框的哪个区域
- (PointLocation)locationOfPoint:(CGPoint)point;
```

### UIView (SSRotation) 分类

```objective-c
// 获取指定类型的父视图
- (id)snapshot_superViewWithClass:(Class)clazz;

// 递归向子视图发送屏幕旋转消息
- (void)snapshot_rotationToInterfaceOrientation:(UIInterfaceOrientation)orientation;

// 截取 UIView 指定区域的图像
- (UIImage *)snapshot_imageInRect:(CGRect)rect;
```

### PointLocation 枚举

```objective-c
typedef NS_ENUM(NSInteger, PointLocation) {
    Outside = 1 << 0,                    // 外部
    InControl = 1 << 1,                  // 内部
    OnControl = 1 << 2,                  // 框上
    OnTopEdge = (1 << 3) | OnControl,    // 顶边上
    OnBottomEdge = (1 << 4) | OnControl, // 底边上
    OnLeftEdge = (1 << 5) | OnControl,   // 左边上
    OnRightEdge = (1 << 6) | OnControl,  // 右边上
    OnLeftTopCorner = (1 << 7) | OnControl,      // 左上角
    OnRightTopCorner = (1 << 8) | OnControl,     // 右上角
    OnLeftBottomCorner = (1 << 9) | OnControl,   // 左下角
    OnRightBottomCorner = (1 << 10) | OnControl, // 右下角
};
```

## 示例项目

要运行示例项目，请按以下步骤操作：

1. 克隆仓库到本地
```bash
git clone https://github.com/luowei/LWSnapshot.git
cd LWSnapshot
```

2. 安装依赖
```bash
cd Example
pod install
```

3. 打开工作空间
```bash
open LWSnapshot.xcworkspace
```

## 系统要求

- iOS 8.0 或更高版本
- Xcode 9.0 或更高版本

## 实现原理

### 核心技术

1. **手势识别**：使用 `UIPanGestureRecognizer` 实现拖动调整功能
2. **图形绘制**：
   - 使用 `UIBezierPath` 绘制遮罩层和选取框
   - 使用 `CGContextSetBlendMode` 实现透明选取区域效果
   - 绘制虚线边框和四个圆形角点作为视觉引导
3. **截图生成**：使用 `drawViewHierarchyInRect:afterScreenUpdates:` 高效截取指定区域
4. **系统集成**：通过 `UIActivityViewController` 提供原生分享体验

### 触摸事件处理

组件通过精确的触摸位置判断实现灵活的区域调整：

- 判断触摸点是否在选取框的内部、边缘或角点
- 根据不同位置执行相应的拖动逻辑
- 限制最小尺寸（30x30）防止区域过小
- 边界检测确保选取框不超出视图范围

## 注意事项

1. **内存管理**：记得在 `dealloc` 中移除通知观察者
2. **iPad 适配**：分享功能在 iPad 上会以 Popover 形式展示
3. **屏幕旋转**：组件会在屏幕旋转时自动移除，需要重新显示
4. **性能优化**：使用 `drawViewHierarchyInRect:afterScreenUpdates:` 替代旧的 `renderInContext:` 方法以提升截图性能

## 常见问题

### 1. 如何修改默认的截图区域大小？

设置 `snapshotFrame` 属性即可：

```objective-c
LWSnapshotMaskView *maskView = [LWSnapshotMaskView showSnapshotMaskInView:self.view];
maskView.snapshotFrame = CGRectMake(x, y, width, height);
```

### 2. 如何自定义按钮样式？

可以访问 `cancelBtn`、`shareBtn` 和 `fullScreenBtn` 属性进行自定义：

```objective-c
maskView.shareBtn.backgroundColor = [UIColor blueColor];
[maskView.shareBtn setTitle:@"保存" forState:UIControlStateNormal];
```

### 3. 如何获取截图而不分享？

可以直接调用 UIView 分类中的方法：

```objective-c
UIImage *screenshot = [self.view snapshot_imageInRect:rect];
// 保存或处理截图
```

### 4. 支持横屏模式吗？

组件会在屏幕旋转时自动移除。如需在横屏模式下使用，需要在旋转完成后重新调用显示方法。

## 更新日志

### 1.0.0
- 首次发布
- 支持自定义区域截图
- 集成系统分享功能
- 支持多种触发方式

## 贡献指南

欢迎提交 Issue 和 Pull Request！

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

## 许可证

LWSnapshot 基于 MIT 许可证开源。详见 [LICENSE](LICENSE) 文件。

## 作者

**luowei** - [luowei@wodedata.com](mailto:luowei@wodedata.com)

## 致谢

感谢所有为这个项目做出贡献的开发者。

---

如果这个项目对你有帮助，欢迎 Star 支持！
