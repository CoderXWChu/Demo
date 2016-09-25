//
//  UIView+DCExt.m
//
//  Created by CoderXWChu on 15/5/12.
//  Copyright © 2015年 CoderXWChu. All rights reserved.
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

#import "UIView+DCExt.h"

@implementation UIView (DCExt)

- (UIViewController *)dc_ParentViewController
{
    id nextRespond = [self nextResponder];
    if ([nextRespond isKindOfClass:[UIViewController class]]) {
        return nextRespond;
    }else if ([nextRespond isKindOfClass:[UIView class]]){
        return ((UIView *)nextRespond).dc_ParentViewController;
    }
    return nil;
}


- (void)dc_PopUpAnimation
{
    self.alpha = 1.0f;
    
    CAKeyframeAnimation *bounce = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    bounce.values = [NSArray arrayWithObjects:
                     [NSNumber numberWithFloat:0.5f],
                     [NSNumber numberWithFloat:1.1f],
                     [NSNumber numberWithFloat:0.8f],
                     [NSNumber numberWithFloat:1.0f], nil];
    bounce.duration = 0.4f;
    bounce.removedOnCompletion = NO;
    [self.layer addAnimation:bounce forKey:@"bounce"];
}


- (BOOL)dc_ExclusiveTouchInWholeView
{
    self.exclusiveTouch = YES;
    for (UIView *view in self.subviews) {
        view.exclusiveTouch = YES;
    }
    return YES;
}


@end
