//
//  DCBaseViewController.m
//
//  Created by DanaChu on 16/8/29.
//  Copyright © 2016年 DanaChu. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "DCBaseViewController.h"

@interface DCBaseViewController()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIPanGestureRecognizer *pan;

@end

@implementation DCBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)setIsSupportFullScreenBack:(BOOL)isSupportFullScreenBack
{
    
    if (_isSupportFullScreenBack == isSupportFullScreenBack) return;
    
    _isSupportFullScreenBack = isSupportFullScreenBack;
    
    if (_isSupportFullScreenBack) {

        id target = self.navigationController.interactivePopGestureRecognizer.delegate;
        
        
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        // 创建全屏滑动手势，调用系统自带滑动手势的target的action方法
        self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
#pragma clang diagnostic pop
        
        // 设置手势代理，拦截手势触发
        self.pan.delegate = self;
        // 给导航控制器的view添加全屏滑动手势
        [self.view addGestureRecognizer:self.pan];
        // 禁止使用系统自带的滑动手势
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }else{
    
        self.pan = nil;
    }
    
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == _pan) {
        // 注意：只有非根控制器才有滑动返回功能，根控制器没有。
        // 判断导航控制器是否只有一个子控制器，如果只有一个子控制器，肯定是根控制器
        if (self.navigationController.childViewControllers.count == 1) {
            // 表示用户在根控制器界面，就不需要触发滑动手势，
            return NO;
        }
        
        CGPoint point = [_pan translationInView:self.view];
        if (point.x < 0) {
            return NO;
        }
        
        return YES;
    }
    
    return YES;
}


@end
