//
//  NSObject+DCExtForKVO.h
//
//  Created by CoderXWChu on 15/10/2.
//  Copyright © 2015年 CoderXWChu. All rights reserved.
//
// 参考作者: ibireme 原创: [YYKit/NSObject+YYAddForKVO]
// 参考地址: https://github.com/ibireme/YYKit

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (DCExtForKVO)

//============================================================
// 一句代码实现 KVO 监听, 自动实现观察者的移除操作. 支持同一路径,多个
//============================================================

/*!
 *  用于KVO监听 属性值
 *  @param keyPath  KVO 中的 属性路径
 *  @param block    属性值改变后所需要执行的操作
 */
- (void)dc_addObserverBlockForKeyPath:(NSString *)keyPath block:(void (^)(__weak id _Nonnull obj, _Nullable id oldVal, _Nullable id newVal))block;

/*!
 *  根据路径移除对路径的监听
 *  @param keyPath 属性路径
 */
- (void)dc_removeObserverBlocksForKeyPath:(NSString *)keyPath;

/*!
 *  移除所有的 KVO 路径
 */
- (void)dc_removeObserverKVOBlocks;


@end

NS_ASSUME_NONNULL_END
