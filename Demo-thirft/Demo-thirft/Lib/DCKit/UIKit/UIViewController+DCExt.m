//
//  UIViewController+DCExt.m
//
//  Created by CoderXWChu on 16/1/26.
//  Copyright © 2016年 CoderXWChu. All rights reserved.
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

#import "UIViewController+DCExt.h"
#import <objc/runtime.h>

@interface  _DCUIImagePCDelegate: NSObject <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, copy) DCPickerFinishBlock fblock;
@property (nonatomic, copy) DCPickerCancelBlock cblock;

@end

@implementation _DCUIImagePCDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    if (self.fblock) {
        _fblock(picker, info);
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if (self.cblock) {
        _cblock(picker);
    }
}

@end

static const char *_DCImagePickerVirtualDelgateKey = "_DCImagePickerVirtualDelgateKey";

@implementation UIViewController (DCExt)

- (void)dc_presentImagePickerController:(DCPickerBlock)block animated:(BOOL)animated completion:(void (^ _Nullable)(void))completion
{
    UIImagePickerController *imagePVC = [[UIImagePickerController alloc]init];
    _DCUIImagePCDelegate *virtualDelgate = [_DCUIImagePCDelegate new];
    objc_setAssociatedObject(self, _DCImagePickerVirtualDelgateKey, virtualDelgate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    imagePVC.delegate = virtualDelgate;
    block(imagePVC);
    [self presentViewController:imagePVC animated:YES completion:completion];
}

- (_DCUIImagePCDelegate *)imagePickerVirtualDelgate
{
    return objc_getAssociatedObject(self, _DCImagePickerVirtualDelgateKey);
}

- (void)dc_setImagePickerFinishBlock:(DCPickerFinishBlock)fblock
{
    self.imagePickerVirtualDelgate.fblock = fblock;
}

- (void)dc_setImagePickerCancelBlock:(DCPickerCancelBlock)cblock
{
    self.imagePickerVirtualDelgate.cblock = cblock;
}

@end

@implementation UINavigationController (ShouldPopOnBackButton)

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    
    if([self.viewControllers count] < [navigationBar.items count]) {
        return YES;
    }
    
    BOOL shouldPop = YES;
    UIViewController* vc = [self topViewController];
    if([vc respondsToSelector:@selector(navigationShouldPopOnBackButton)]) {
        shouldPop = [vc navigationShouldPopOnBackButton];
    }
    
    if(shouldPop) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self popViewControllerAnimated:YES];
        });
    } else {
        // Workaround for iOS7.1. Thanks to @boliva - http://stackoverflow.com/posts/comments/34452906
        for(UIView *subview in [navigationBar subviews]) {
            if(subview.alpha < 1.) {
                [UIView animateWithDuration:.25 animations:^{
                    subview.alpha = 1.;
                }];
            }
        }
    }
    
    return NO;
}

@end
