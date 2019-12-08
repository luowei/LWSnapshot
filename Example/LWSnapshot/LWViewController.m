//
//  LWViewController.m
//  LWSnapshot
//
//  Created by luowei on 05/20/2019.
//  Copyright (c) 2019 luowei. All rights reserved.
//

#import <LWSnapshot/LWSnapshotMaskView.h>
#import "LWViewController.h"

@interface LWViewController ()

@end

@implementation LWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    //手势截图
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] init];
    longPressGesture.numberOfTouchesRequired = 2;
    [longPressGesture addTarget:self action:@selector(longPressGestureAction:)];
    [self.view addGestureRecognizer:longPressGesture];

    //监听屏幕截图
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidTakeScreenshotNotification:) name:UIApplicationUserDidTakeScreenshotNotification object:nil];
}

- (void)appDidTakeScreenshotNotification:(NSNotification *)notification {
    [self showSnapshotView];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (IBAction)btnAction:(UIButton *)sender {
    [self showSnapshotView];
}

//手势截图分享
- (void)longPressGestureAction:(UILongPressGestureRecognizer *)gesture {
    NSLog(@"--------: 识别到手势截图");

    if(gesture.state == UIGestureRecognizerStateBegan ){
        [self showSnapshotView];
    }

}

//显示截图
- (void)showSnapshotView {
    LWSnapshotMaskView *snapshotMaskView = [LWSnapshotMaskView showSnapshotMaskInView:self.view];
    snapshotMaskView.snapshotFrame = CGRectMake((self.view.frame.size.width-200)/2, (self.view.frame.size.height-200)/2, 200, 200);
}


@end
