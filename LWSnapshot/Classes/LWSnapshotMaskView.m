//
// Created by Luo Wei on 2017/10/23.
// Copyright (c) 2017 wodedata. All rights reserved.
//

#import "LWSnapshotMaskView.h"

#define Edge_Padding 20
#define Default_HalfLen 80
#define CornerPoint_Dia 6


@implementation LWSnapshotMaskView {
    UIColor *_color;
    UIColor *_bgColor;
    BOOL _btnisHiden;
}

+(LWSnapshotMaskView *)showSnapshotMaskInView:(UIView *)view{
    LWSnapshotMaskView *snapshutMask = nil;
    for(UIView *v in view.subviews){
        if([v isKindOfClass:[LWSnapshotMaskView class]]){
            snapshutMask = (LWSnapshotMaskView *)v;
            [view bringSubviewToFront:snapshutMask];
            break;
        }
    }
    if(!snapshutMask){
        snapshutMask = [[LWSnapshotMaskView alloc] initWithFrame:view.bounds];
        [view addSubview:snapshutMask];
        [view bringSubviewToFront:snapshutMask];
    }
    return snapshutMask;
}

+(void)hideSnapshotMaskInView:(UIView *)view{
    for(UIView *v in view.subviews){
        if([v isKindOfClass:[LWSnapshotMaskView class]]){
            [v removeFromSuperview];
            break;
        }
    }

}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.cancelBtn];
        self.shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.shareBtn];
        self.fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.fullScreenBtn];

        [self.cancelBtn addTarget:self action:@selector(cancelBtnTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [self.shareBtn addTarget:self action:@selector(shareBtnTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [self.fullScreenBtn addTarget:self action:@selector(fullScreenBtnTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];

        [self.cancelBtn setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
        [self.cancelBtn setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
        self.cancelBtn.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
        self.cancelBtn.contentEdgeInsets = UIEdgeInsetsMake(4, 10, 16, 10);
        [self.shareBtn setTitle:NSLocalizedString(@"Share", nil) forState:UIControlStateNormal];
        [self.shareBtn setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
        self.shareBtn.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
        self.shareBtn.contentEdgeInsets = UIEdgeInsetsMake(4, 10, 16, 10);
        [self.fullScreenBtn setTitle:NSLocalizedString(@"FullScreen", nil) forState:UIControlStateNormal];
        [self.fullScreenBtn setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
        self.fullScreenBtn.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
        self.fullScreenBtn.contentEdgeInsets = UIEdgeInsetsMake(4, 10, 16, 10);

        self.cancelBtn.translatesAutoresizingMaskIntoConstraints = NO;
        self.shareBtn.translatesAutoresizingMaskIntoConstraints = NO;
        self.fullScreenBtn.translatesAutoresizingMaskIntoConstraints = NO;

        NSLayoutConstraint *cancelBtnTop = [NSLayoutConstraint constraintWithItem:self.cancelBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:5];
        NSLayoutConstraint *cancelBtnLeading = [NSLayoutConstraint constraintWithItem:self.cancelBtn attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:CornerPoint_Dia];
        [NSLayoutConstraint activateConstraints:@[cancelBtnTop,cancelBtnLeading]];

        NSLayoutConstraint *shareBtnTop = [NSLayoutConstraint constraintWithItem:self.shareBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:5];
        NSLayoutConstraint *shareBtnLeading = [NSLayoutConstraint constraintWithItem:self.shareBtn attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-CornerPoint_Dia];
        [NSLayoutConstraint activateConstraints:@[shareBtnTop,shareBtnLeading]];

        NSLayoutConstraint *fullScreenBtnTop = [NSLayoutConstraint constraintWithItem:self.fullScreenBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:5];
        NSLayoutConstraint *fullScreenBtnLeading = [NSLayoutConstraint constraintWithItem:self.fullScreenBtn attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
        [NSLayoutConstraint activateConstraints:@[fullScreenBtnTop,fullScreenBtnLeading]];

        _color = [UIColor whiteColor];
        _bgColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        _btnisHiden = NO;

        //????????????????????????
        self.prePoint = CGPointMake(frame.size.width / 2, frame.size.height / 2);
        self.snapshotFrame = CGRectMake(frame.size.width / 2 - Default_HalfLen, frame.size.height / 2 - Default_HalfLen, Default_HalfLen * 2, Default_HalfLen * 2);
        //????????????
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onDrag:)];
        [self addGestureRecognizer:panGesture];

        //?????????????????????
        UIFont *font = [UIFont systemFontOfSize:14];
        self.cancelBtn.titleLabel.font = font;
        self.cancelBtn.layer.cornerRadius = 4;
        self.shareBtn.titleLabel.font = font;
        self.shareBtn.layer.cornerRadius = 4;
        self.fullScreenBtn.titleLabel.font = font;
        self.fullScreenBtn.layer.cornerRadius = 4;

    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.frame = self.superview.bounds;
}

- (void)rotationToInterfaceOrientation:(UIInterfaceOrientation)orientation {
    [super snapshot_rotationToInterfaceOrientation:orientation];
    [self removeFromSuperview];
}


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    //??????????????????
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: self.bounds];
    [_bgColor setFill];
    [rectanglePath fill];

    //??????????????????????????????
    [self drawRectangleWithFrame:self.snapshotFrame];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if(_btnisHiden){
        self.cancelBtn.hidden = NO;
        self.fullScreenBtn.hidden = NO;
        self.shareBtn.hidden = NO;
    }
    [self.nextResponder touchesBegan:touches withEvent:event];
}


//????????????
- (void)onDrag:(UIPanGestureRecognizer *)panGesture {

    switch (panGesture.state){
        case UIGestureRecognizerStateBegan:{
            self.prePoint = [panGesture locationInView:self];
            self.pointLocation = [self locationOfPoint:self.prePoint];
            break;
        }
        case UIGestureRecognizerStateChanged:{
            CGPoint point = [panGesture locationInView:self];
            [self updateSnapshotFrameWithPoint:point];
            [self setNeedsDisplay];
            break;
        }
        case UIGestureRecognizerStateEnded: {
            CGPoint point = [panGesture locationInView:self];
            [self updateSnapshotFrameWithPoint:point];
            self.pointLocation = Outside;
            [self setNeedsDisplay];
            break;
        }
        default:{
            self.pointLocation = Outside;
            break;
        }
    }
}

//?????? point ????????? SnapshotFrame
-(void)updateSnapshotFrameWithPoint:(CGPoint)point{

    switch (self.pointLocation){
        case InControl:{
            CGSize size = self.snapshotFrame.size;
            CGFloat detaX = point.x - self.prePoint.x;
            CGFloat detaY = point.y - self.prePoint.y;
            self.snapshotFrame = CGRectMake(self.snapshotFrame.origin.x + detaX, self.snapshotFrame.origin.y + detaY, size.width, size.height);
            self.prePoint = point;
            break;
        }
        case OnLeftEdge:{
            CGFloat width = self.snapshotFrame.size.width + (self.snapshotFrame.origin.x - point.x);
            CGSize size = CGSizeMake(width > 30 ? width : 30, self.snapshotFrame.size.height);
            self.snapshotFrame = CGRectMake(point.x, self.snapshotFrame.origin.y, size.width, size.height);
            break;
        }
        case OnRightEdge:{
            CGFloat width = self.snapshotFrame.size.width - ((self.snapshotFrame.origin.x + self.snapshotFrame.size.width) - point.x);
            CGSize size = CGSizeMake(width > 30 ? width : 30, self.snapshotFrame.size.height);
            self.snapshotFrame = CGRectMake(self.snapshotFrame.origin.x, self.snapshotFrame.origin.y, size.width, size.height);
            break;
        }
        case OnTopEdge:{
            CGFloat height = self.snapshotFrame.size.height + (self.snapshotFrame.origin.y - point.y);
            CGSize size = CGSizeMake(self.snapshotFrame.size.width, height > 30 ? height : 30);
            self.snapshotFrame = CGRectMake(self.snapshotFrame.origin.x, point.y, size.width, size.height);
            break;
        }
        case OnBottomEdge:{
            CGFloat height = self.snapshotFrame.size.height - ((self.snapshotFrame.origin.y + self.snapshotFrame.size.height) - point.y);
            CGSize size = CGSizeMake(self.snapshotFrame.size.width, height > 30 ? height : 30);
            self.snapshotFrame = CGRectMake(self.snapshotFrame.origin.x, self.snapshotFrame.origin.y, size.width, size.height);
            break;
        }
        case OnLeftTopCorner:{
            CGFloat width = self.snapshotFrame.size.width + (self.snapshotFrame.origin.x - point.x);
            CGFloat height = self.snapshotFrame.size.height + (self.snapshotFrame.origin.y - point.y);
            CGSize size = CGSizeMake(width > 30 ? width : 30, height > 30 ? height : 30);
            self.snapshotFrame = CGRectMake(point.x, point.y, size.width, size.height);
            break;
        }
        case OnRightTopCorner:{
            CGFloat width = self.snapshotFrame.size.width - ((self.snapshotFrame.origin.x + self.snapshotFrame.size.width) - point.x);
            CGFloat height = self.snapshotFrame.size.height + (self.snapshotFrame.origin.y - point.y);
            CGSize size = CGSizeMake(width > 30 ? width : 30, height > 30 ? height : 30);
            self.snapshotFrame = CGRectMake(self.snapshotFrame.origin.x, point.y, size.width, size.height);
            break;
        }
        case OnLeftBottomCorner:{
            CGFloat width = self.snapshotFrame.size.width + (self.snapshotFrame.origin.x - point.x);
            CGFloat height = self.snapshotFrame.size.height - ((self.snapshotFrame.origin.y + self.snapshotFrame.size.height) - point.y);
            CGSize size = CGSizeMake(width > 30 ? width : 30, height > 30 ? height : 30);
            self.snapshotFrame = CGRectMake(point.x, self.snapshotFrame.origin.y, size.width, size.height);
            break;
        }
        case OnRightBottomCorner:{
            CGFloat width = self.snapshotFrame.size.width - ((self.snapshotFrame.origin.x + self.snapshotFrame.size.width) - point.x);
            CGFloat height = self.snapshotFrame.size.height - ((self.snapshotFrame.origin.y + self.snapshotFrame.size.height) - point.y);
            CGSize size = CGSizeMake(width > 30 ? width : 30, height > 30 ? height : 30);
            self.snapshotFrame = CGRectMake(self.snapshotFrame.origin.x, self.snapshotFrame.origin.y, size.width, size.height);
            break;
        }
        default:{
            break;
        }
    }

    CGFloat minX = CGRectGetMinX(self.snapshotFrame) > 5 ? CGRectGetMinX(self.snapshotFrame) : 0;
    CGFloat minY = CGRectGetMinY(self.snapshotFrame) > 5 ? CGRectGetMinY(self.snapshotFrame) : 0;
    CGFloat maxX = CGRectGetMaxX(self.snapshotFrame) < self.bounds.size.width - 5 ? CGRectGetMaxX(self.snapshotFrame) : self.bounds.size.width;
    CGFloat maxY = CGRectGetMaxY(self.snapshotFrame) < self.bounds.size.height - 5 ? CGRectGetMaxY(self.snapshotFrame) : self.bounds.size.height;
    self.snapshotFrame = CGRectMake(minX, minY, maxX - minX, maxY - minY);
}

//?????? point ??? snapshotFrame ???????????????
- (PointLocation)locationOfPoint:(CGPoint)point {
    //????????????????????????snapshotFrame????????????
    BOOL isInControl = CGRectContainsPoint(CGRectInset(self.snapshotFrame,Edge_Padding,Edge_Padding), point);
    //BOOL isOnControl = CGRectContainsPoint(CGRectInset(self.snapshotFrame,-Edge_Padding,-Edge_Padding), point) && !isInControl;
    BOOL isOnTopEdge = (point.y > self.snapshotFrame.origin.y - Edge_Padding) && (point.y < self.snapshotFrame.origin.y + Edge_Padding);
    BOOL isOnBottomEdge = (point.y > self.snapshotFrame.origin.y + self.snapshotFrame.size.height - Edge_Padding) && (point.y < self.snapshotFrame.origin.y + self.snapshotFrame.size.height + Edge_Padding);
    BOOL isOnLeftEdge = (point.x > self.snapshotFrame.origin.x - Edge_Padding) && (point.x < self.snapshotFrame.origin.x + Edge_Padding);
    BOOL isOnRightEdge = (point.x > self.snapshotFrame.origin.x + self.snapshotFrame.size.width - Edge_Padding) && (point.x < self.snapshotFrame.origin.x + self.snapshotFrame.size.width + Edge_Padding);
    BOOL isOnLeftTopCorner = isOnLeftEdge && isOnTopEdge;
    BOOL isOnRightTopCorner = isOnRightEdge && isOnTopEdge;
    BOOL isOnLeftBottomCorner = isOnLeftEdge && isOnBottomEdge;
    BOOL isOnRightBottomCorner = isOnRightEdge && isOnBottomEdge;

    PointLocation pointLocation = Outside;
    if (isInControl) {    //??????
        pointLocation = InControl;
    } else if (isOnLeftTopCorner) {    //?????????
        pointLocation = OnLeftTopCorner;
    } else if (isOnRightTopCorner) {   //?????????
        pointLocation = OnRightTopCorner;
    } else if (isOnLeftBottomCorner) { //?????????
        pointLocation = OnLeftBottomCorner;
    } else if (isOnRightBottomCorner) {    //?????????
        pointLocation = OnRightBottomCorner;
    } else if (isOnTopEdge) { //??????
        pointLocation = OnTopEdge;
    } else if (isOnLeftEdge) { //??????
        pointLocation = OnLeftEdge;
    } else if (isOnBottomEdge) {   //??????
        pointLocation = OnBottomEdge;
    } else if (isOnRightEdge) {    //??????
        pointLocation = OnRightEdge;
    }
    return pointLocation;
}


//??????????????????????????????
- (void)drawRectangleWithFrame:(CGRect)frame {
    CGContextRef context = UIGraphicsGetCurrentContext();

    UIBezierPath *snapshotPath = [UIBezierPath bezierPathWithRect:frame];

    //????????????????????????,????????????????????????
    CGContextSetBlendMode(context, kCGBlendModeClear);
    [_color setFill];
    [snapshotPath fill];

    if(_btnisHiden){
        return;
    }

    //?????????????????????
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    [snapshotPath setLineDash: (CGFloat[]){8,5}  count: 2 phase: 0];
    [_color setStroke];
    snapshotPath.lineWidth = 1.0;
    [snapshotPath stroke];

    //??????4????????????
    CGRect oval1Rect = CGRectMake(CGRectGetMinX(self.snapshotFrame) - CornerPoint_Dia/2, CGRectGetMinY(self.snapshotFrame) - CornerPoint_Dia/2, CornerPoint_Dia, CornerPoint_Dia);
    UIBezierPath* oval1Path = [UIBezierPath bezierPathWithOvalInRect: oval1Rect];
    [_color setFill];
    [oval1Path fill];

    CGRect oval2Rect = CGRectMake(CGRectGetMaxX(self.snapshotFrame) - CornerPoint_Dia/2, CGRectGetMinY(self.snapshotFrame) - CornerPoint_Dia/2, CornerPoint_Dia, CornerPoint_Dia);
    UIBezierPath* oval2Path = [UIBezierPath bezierPathWithOvalInRect: oval2Rect];
    [_color setFill];
    [oval2Path fill];

    CGRect oval3Rect = CGRectMake(CGRectGetMinX(self.snapshotFrame) - CornerPoint_Dia/2, CGRectGetMaxY(self.snapshotFrame) - CornerPoint_Dia/2, CornerPoint_Dia, CornerPoint_Dia);
    UIBezierPath* oval3Path = [UIBezierPath bezierPathWithOvalInRect: oval3Rect];
    [_color setFill];
    [oval3Path fill];

    CGRect oval4Rect = CGRectMake(CGRectGetMaxX(self.snapshotFrame) - CornerPoint_Dia/2, CGRectGetMaxY(self.snapshotFrame) - CornerPoint_Dia/2, CornerPoint_Dia, CornerPoint_Dia);
    UIBezierPath* oval4Path = [UIBezierPath bezierPathWithOvalInRect: oval4Rect];
    [_color setFill];
    [oval4Path fill];
}


#pragma mark - Btn Action

//??????????????????
- (void)cancelBtnTouchUpInside:(UIButton *)btn {
    if(self.closeBlock){
        self.closeBlock();
    }
    [self removeFromSuperview];
}

//??????????????????
- (void)fullScreenBtnTouchUpInside:(UIButton *)btn {
    self.snapshotFrame = self.bounds;
    [self setNeedsDisplay];
}

//??????????????????
- (void)shareBtnTouchUpInside:(UIButton *)btn {
    UIViewController *vc = [self snapshot_superViewWithClass:[UIViewController class]];

    NSLog(@"======????????????======");
    UIImage *image = [self.superview snapshot_imageInRect:self.snapshotFrame];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[image] applicationActivities:nil];
    //???????????????
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        UIPopoverController *popoverController = [[UIPopoverController alloc] initWithContentViewController:activityVC];
        CGRect rect = [[UIScreen mainScreen] bounds];
        [popoverController presentPopoverFromRect:rect inView:vc.view permittedArrowDirections:0 animated:YES];
    } else {
        [vc presentViewController:activityVC animated:YES completion:nil];
    }

    [self removeFromSuperview];

//    dispatch_main_async_safe(^{
//
//    });

}

@end


@implementation UIView (SSRotation)

//?????????class??????????????????
- (id)snapshot_superViewWithClass:(Class)clazz {
    UIResponder *responder = self;
    while (![responder isKindOfClass:clazz]) {
        responder = [responder nextResponder];
        if (nil == responder) {
            break;
        }
    }
    return [responder isKindOfClass:clazz]? responder : nil;
}


//?????????????????????????????????????????????????????????
- (void)snapshot_rotationToInterfaceOrientation:(UIInterfaceOrientation)orientation {
    for (UIView *v in self.subviews) {
        [v snapshot_rotationToInterfaceOrientation:orientation];
    }
}

//?????? UIView ?????? rect ?????????
- (UIImage *)snapshot_imageInRect:(CGRect)rect {
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    [self drawViewHierarchyInRect:CGRectMake(-rect.origin.x, -rect.origin.y, self.bounds.size.width, self.bounds.size.height) afterScreenUpdates:YES];
    // old style [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end