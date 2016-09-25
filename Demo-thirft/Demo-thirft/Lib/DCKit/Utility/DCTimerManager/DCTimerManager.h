//
//  DCTimerManager.h
//
//  Created by DanaChu on 15/12/2.
//  Copyright © 2015年 DanaChu. All rights reserved.
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

NS_ASSUME_NONNULL_BEGIN

typedef void(^DCTimerAction)();

@interface DCTimerManager : NSObject

+ (instancetype)new UNAVAILABLE_ATTRIBUTE;
- (instancetype)init UNAVAILABLE_ATTRIBUTE;


/*!
 *  定时器管理者单例模式
 *  @return 全局唯一的定时器管理者
 */
+ (instancetype)shareInstance;


/*!
 *  创建定时器,执行定时任务
 *  @param name         定时器名称
 *  @param start        开始时间
 *  @param timeinterval 时间间隔
 *  @param repeat       是否重复
 *  @param action       执行任务代码块
 */
- (void)timerWithTimerName:(NSString *)name
                  fireTime:(NSTimeInterval)start
              timeInterval:(NSTimeInterval)timeinterval
                    repeat:(BOOL)repeat
                    action:(DCTimerAction)action;

/*!
 *  创建定时器,执行定时任务
 *  @param name         定时器名称
 *  @param timeinterval 时间间隔
 *  @param repeat       是否重复
 *  @param action       执行任务代码块
 */
- (void)timerWithTimerName:(NSString *)name
            timeInterval:(NSTimeInterval)timeinterval
                  repeat:(BOOL)repeat
                  action:(DCTimerAction)action;


/*!
 *  移除无效定时器
 */
- (void)removeInvalidTimer;

/*!
 *  根据定时器名称销毁定时器
 *  @param name 定时器名称
 */
- (void)invalidateWithName:(NSString *)name;


@end

NS_ASSUME_NONNULL_END
