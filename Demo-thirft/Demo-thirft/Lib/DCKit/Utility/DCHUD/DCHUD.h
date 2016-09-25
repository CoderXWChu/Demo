//
//  DCHUD.h
//
//  Created by DanaChu on 16/6/2.
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

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import "DCHUDDefine.h"

typedef NS_ENUM(NSUInteger, DCHUDType)
{
    DCHUDTypeSuccessful = 10, // 成功
    DCHUDTypeError      ,     // 错误
    DCHUDTypeWarning    ,     // 警告
    DCHUDTypeInfo             // 信息
};

typedef NS_ENUM(NSUInteger, DCHUDTitleType)
{
    DCHUDTitleTypeLoading        = 1,  // 正在加载...
    DCHUDTitleTypeLoadError      ,     // 加载失败
    DCHUDTitleTypeLoadSuccessful ,     // 加载成功
    DCHUDTitleTypeNoMoreData     ,     // 没有更多数据了
    DCHUDTitleTypeLogin                // 正在登录...
};


@interface DCHUD : MBProgressHUD

// 常用HUD API
/*!
 *  用来显示成功消息的HUD
 *  @param message 成功信息
 *  @param afterSecond  afterSecond时间后移除HUD
 *  @param yesOrNo      是否能与HUD下方的view进行交互
 *  @return HUD
 */
+ (MB_INSTANCETYPE)dc_showSuccessMessage:(NSString *)message;
+ (MB_INSTANCETYPE)dc_showSuccessMessage:(NSString *)message userInterfaceEnable:(BOOL)yesOrNo;
+ (MB_INSTANCETYPE)dc_showSuccessMessage:(NSString *)message hideAfter:(NSTimeInterval)afterSecond;
+ (MB_INSTANCETYPE)dc_showSuccessMessage:(NSString *)message hideAfter:(NSTimeInterval)afterSecond userInterfaceEnable:(BOOL)yesOrNo;

/*!
 *  用来显示错误信息的HUD
 *  @param errormessage 错误信息
 *  @param afterSecond  afterSecond时间后移除HUD
 *  @param yesOrNo      是否能与HUD下方的view进行交互
 *  @return HUD
 */
+ (MB_INSTANCETYPE)dc_showErrorMessage:(NSString *)errormessage;
+ (MB_INSTANCETYPE)dc_showErrorMessage:(NSString *)errormessage userInterfaceEnable:(BOOL)yesOrNo;
+ (MB_INSTANCETYPE)dc_showErrorMessage:(NSString *)errormessage hideAfter:(NSTimeInterval)afterSecond;
+ (MB_INSTANCETYPE)dc_showErrorMessage:(NSString *)errormessage hideAfter:(NSTimeInterval)afterSecond userInterfaceEnable:(BOOL)yesOrNo;
/*!
 *  用来显示message的HUD
 *  @param message 信息
 *  @param afterSecond  afterSecond时间后移除HUD
 *  @param yesOrNo      是否能与HUD下方的view进行交互
 *  @return HUD
 */
+ (MB_INSTANCETYPE)dc_showMessage:(NSString *)message;
+ (MB_INSTANCETYPE)dc_showMessage:(NSString *)message userInterfaceEnable:(BOOL)yesOrNo;
+ (MB_INSTANCETYPE)dc_showMessage:(NSString *)message hideAfter:(NSTimeInterval)afterSecond;
+ (MB_INSTANCETYPE)dc_showMessage:(NSString *)message hideAfter:(NSTimeInterval)afterSecond userInterfaceEnable:(BOOL)yesOrNo;

/*!
 *  显示HUD API 自定义
 */
+ (MB_INSTANCETYPE)dc_showIndeterminateHUDWithTitle:(NSString *)title;
+ (MB_INSTANCETYPE)dc_showIndeterminateHUDWithTitleType:(DCHUDTitleType)titleType;
+ (MB_INSTANCETYPE)dc_showIndeterminateHUDWithTitleType:(DCHUDTitleType)titleType hideAfter:(NSTimeInterval)afterSecond;
+ (MB_INSTANCETYPE)dc_showHUDWithTitle:(NSString *)title hideAfter:(NSTimeInterval)afterSecond;
+ (MB_INSTANCETYPE)dc_showHUDWithTitle:(NSString *)title hideAfter:(NSTimeInterval)afterSecond type:(DCHUDType)hudType;


+ (MB_INSTANCETYPE)dc_showIndeterminateHUDWithTitle:(NSString *)title toView:(UIView *)view;
+ (MB_INSTANCETYPE)dc_showIndeterminateHUDWithTitleType:(DCHUDTitleType)titleType toView:(UIView *)view;
+ (MB_INSTANCETYPE)dc_showHUDWithTitle:(NSString *)title toView:(UIView *)view;  // Default : animated = YES;
+ (MB_INSTANCETYPE)dc_showHUDWithTitle:(NSString *)title toView:(UIView *)view animated:(BOOL)animated;
+ (MB_INSTANCETYPE)dc_showHUDWithTitle:(NSString *)title toView:(UIView *)view type:(DCHUDType)hudType;
+ (MB_INSTANCETYPE)dc_showHUDWithTitle:(NSString *)title toView:(UIView *)view hideAfter:(NSTimeInterval)afterSecond;
+ (MB_INSTANCETYPE)dc_showHUDWithTitle:(NSString *)title toView:(UIView *)view hideAfter:(NSTimeInterval)afterSecond type:(DCHUDType)hudType;


/*!
 *  隐藏HUD API
 */
+ (void)dc_hidePresentedHUD;
- (void)dc_hideAfter:(NSTimeInterval)afterSecond;
- (void)dc_hideWithTitle:(NSString *)title hideAfter:(NSTimeInterval)afterSecond;
- (void)dc_hideWithTitle:(NSString *)title hideAfter:(NSTimeInterval)afterSecond type:(DCHUDType)hudType;


@end
