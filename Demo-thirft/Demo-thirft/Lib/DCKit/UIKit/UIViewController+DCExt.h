//
//  UIViewController+DCExt.h
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

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BackButtonHandlerProtocol <NSObject>
@optional
// Override this method in UIViewController derived class to handle 'Back' button click
-(BOOL)navigationShouldPopOnBackButton;
@end


typedef void(^DCPickerFinishBlock)(UIImagePickerController *imagePC ,NSDictionary *info);
typedef void(^DCPickerCancelBlock)(UIImagePickerController *imagePC);
typedef void(^DCPickerBlock)(UIImagePickerController *imagePC);


@interface UIViewController (DCExt)<BackButtonHandlerProtocol>

/*!
 *  @brief 在控制器中调用 UIImagePickerController的简易方法, 在 BLOCK 中调用方法
 *  -setImagePickerFinishBlock: 与 -setImagePickerCancelBlock: 实现原代理方法。
 *
 *  @param block      在 block中可以设置 imagePickerController的相关属性
 *  @param animated    present 控制器时是否动画
 *  @param completion  present 完控制器后的操作
 */
- (void)dc_presentImagePickerController:(DCPickerBlock)block animated:(BOOL)animated completion:(void (^ __nullable)(void))completion;

// 在 -dc_dc_presentViewController:animated:completion: 的 block 中调用；
// 方法内需采用用引用 __weak typeof(self) wSelf = self;
- (void)dc_setImagePickerFinishBlock:(DCPickerFinishBlock)fblock;
- (void)dc_setImagePickerCancelBlock:(DCPickerCancelBlock)cblock;


@end

NS_ASSUME_NONNULL_END
