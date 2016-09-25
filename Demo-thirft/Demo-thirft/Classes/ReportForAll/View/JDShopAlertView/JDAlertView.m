//
//  JDShopAlertView.m
//  Demo-thirft
//
//  Created by DanaChu on 2016/9/23.
//  Copyright © 2016年 DanaChu. All rights reserved.
//

#import "JDAlertView.h"

@interface JDAlertView()

@property (nonatomic, strong) CALayer *backgroundLayer; ///< <#注释#>

@end

@implementation JDAlertView

- (instancetype)init
{
    if (self = [super init]) {
        [self addComponents];
    }
    return self;
}

- (void)addComponents
{
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor clearColor];
    
    // 默认为 Mask 模式
    [self setDisplayMode:JDAlertDisplayMask];
}

- (void)showAlertView
{
    NSAssert(self.contentView != nil, @"contentView cannot be nil!");
    
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    if (topController.presentedViewController) {
        while (topController.presentedViewController) {
            topController = topController.presentedViewController;
        }
    }
    
    [topController.view addSubview:self];
    [self.contentView  dc_PopUpAnimation];
}

- (void)dismiss
{
    self.contentView.alpha = 1;
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.transform = CGAffineTransformMakeScale(0.3, 0.3);
        self.contentView.alpha = 0;
        if (self.displayMode == JDAlertDisplayMask) {
            [self.backgroundLayer removeFromSuperlayer];
        }
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

// 点击小窗口以外的区域，执行关闭窗口动画
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (!CGRectContainsPoint(self.contentView.frame , point))
    {
        [self dismiss];
        return self;
    }
    return [super hitTest:point  withEvent:event];
}

#pragma mark - getter setter


- (CALayer *)backgroundLayer
{
    if (!_backgroundLayer)
    {
        _backgroundLayer = [CALayer layer];
        _backgroundLayer.frame = self.bounds;
        _backgroundLayer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3].CGColor;
    }
    return _backgroundLayer;
}


- (void)setDisplayMode:(JDAlertDisplayMode)displayMode
{
    _displayMode = displayMode;
    switch (displayMode) {
        case JDAlertDisplayMask:
            [self.layer addSublayer:self.backgroundLayer];
            break;
        case JDAlertDisplayNone:
            [self.backgroundLayer removeFromSuperlayer];
            break;
    }
}

- (void)setContentView:(UIView *)contentView
{
    if (_contentView) {
        [_contentView removeFromSuperview];
        _contentView = nil;
    }
    _contentView = contentView;
    _contentView.center = self.center;
    [self addSubview:_contentView];
}

@end
