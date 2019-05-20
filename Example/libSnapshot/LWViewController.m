//
//  LWViewController.m
//  libSnapshot
//
//  Created by luowei on 05/20/2019.
//  Copyright (c) 2019 luowei. All rights reserved.
//

#import <libSnapshot/LWSnapshotMaskView.h>
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

}

- (IBAction)btnAction:(UIButton *)sender {
    
}

//手势截图分享
- (void)longPressGestureAction:(UILongPressGestureRecognizer *)gesture {
    NSLog(@"--------: 识别到手势截图");

    if(gesture.state == UIGestureRecognizerStateBegan ){
        LWSnapshotMaskView *snapshotMaskView = [LWSnapshotMaskView showSnapshotMaskInView:self.view];
        snapshotMaskView.snapshotFrame = CGRectMake((self.view.frame.size.width-200)/2, (self.view.frame.size.height-200)/2, 200, 200);
    }

}


@end
