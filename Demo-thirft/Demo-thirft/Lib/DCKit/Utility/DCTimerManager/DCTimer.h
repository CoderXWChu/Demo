//
//  DCTimer.h
//
//  Created by DanaChu on 15/12/2.
//  Copyright © 2015年 DanaChu. All rights reserved.
//
// 参考作者: ibireme 原创: [YYTimer]
// 参考地址: https://github.com/ibireme/YYKit

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DCTimer : NSObject

@property (nonatomic, copy, readonly) NSString *name; ///< timer's name
@property (nonatomic, assign, readonly, getter=isValid) BOOL valid;
@property (nonatomic, assign, readonly, getter=isRepeat) BOOL repeat;
@property (nonatomic, assign, readonly) NSTimeInterval timeinterval; ///< timeinterval for repeat
- (instancetype)init UNAVAILABLE_ATTRIBUTE;

/*!
 *  创建定时器
 *  @param name     定时器名称
 *  @param interval 时间间隔
 *  @param target   目标
 *  @param selector 目标方法
 *  @param repeat   是否重复
 *  @return 定时器对象
 */
+ (DCTimer *)timerWithTimeName:(NSString *)name
                  timeInterval:(NSTimeInterval)interval
                        target:(id)target
                      selector:(SEL)selector
                        repeat:(BOOL)repeat;
/*!
 *  创建定时器
 *  @param name     定时器名称
 *  @param start    定时器开始时间
 *  @param interval 时间间隔
 *  @param target   目标
 *  @param selector 目标方法
 *  @param repeat   是否重复
 *  @return 定时器对象
 */
- (instancetype)initWithTimeName:(NSString *)name
                        fireTime:(NSTimeInterval)start
                    timeInterval:(NSTimeInterval)interval
                          target:(id)target
                        selector:(SEL)selector
                          repeat:(BOOL)repeat;

/*!
 *  创建定时器
 *  @param name     定时器名称
 *  @param start    定时器开始时间
 *  @param interval 时间间隔
 *  @param target   目标
 *  @param selector 目标方法
 *  @param object   目标方法参数
 *  @param repeat   是否重复
 *  @return 定时器对象
 */
- (instancetype)initWithTimeName:(NSString *)name
                        fireTime:(NSTimeInterval)start
                    timeInterval:(NSTimeInterval)interval
                          target:(id)target
                        selector:(SEL)selector
                          object:(id _Nullable)object
                          repeat:(BOOL)repeat NS_DESIGNATED_INITIALIZER;

/*!
 *  销毁定时器
 */
- (void)invalidate;


/*!
 *  执行定时器任务
 */
- (void)fire;

@end

NS_ASSUME_NONNULL_END