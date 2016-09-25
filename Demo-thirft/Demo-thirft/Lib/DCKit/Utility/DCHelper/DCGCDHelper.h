//
//  DCGCDHelper.h
//
//  Created by DanaChu on 16/8/17.
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

/*!
 *  @brief 主线程下同步执行, 等待执行完以后再往下执行
 *
 *  @param block  action
 */
void dc_dispatch_main_sync_safe(dispatch_block_t block);

/*!
 *  @brief 主线程下异步执行, 不等待执行完, 就往下执行
 *
 *  @param block  action
 */
void dc_dispatch_main_async_safe(dispatch_block_t block);

/*!
 *  @brief 限制异步线程的最大并发数, 采用 dispatch_async_limit 执行的任务所开启的线程数,
 *         无论队列 queue 是否相同, 在同一时刻都会计入统计总量中;
 *
 *  @param block  action
 */
void dc_dispatch_async_limit(dispatch_queue_t queue, NSUInteger maxQueueCount, dispatch_block_t block);



