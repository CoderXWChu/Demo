//
//  NSObject+DCExtensionForNotification.h
//
//  Created by CoderXWChu on 15/10/2.
//  Copyright © 2015年 CoderXWChu. All rights reserved.
//
// 参考作者: ibireme 原创: [YYKit/NSObject+YYAddForKVO]
// 参考地址: https://github.com/ibireme/YYKit

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (DCExtForNotification)

//============================================================
// 一句代码实现通知监听, 自动实现通知的移除操作.
//============================================================


/*!
 *  用于监听通知
 *  @param aName 通知名称
 *  @param block 监听到通知后执行的 block
 */
- (void)dc_addObserverBlockForNotificationName:(NSString *)aName block:(void(^)(__weak id __nullable obj, NSNotification *noti))block;

/*!
 *  移除对通知的监听
 *  @param aName 通知名称
 */
- (void)dc_removeObserverWithNotificationName:(NSString *)aName;

/*!
 *  移除所有通知的监听
 */
- (void)dc_removeObserverNotificationBlocks;


@end

NS_ASSUME_NONNULL_END
