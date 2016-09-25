//
//  DCGCDHelper.m
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

#import "DCGCDHelper.h"

void dc_dispatch_sync_main_safe(dispatch_block_t block)
{
    dispatch_sync(dispatch_get_main_queue(), block);
}

void dc_dispatch_async_main_safe(dispatch_block_t block)
{
    dispatch_async(dispatch_get_main_queue(), block);
}

void dc_dispatch_main_sync_safe(dispatch_block_t block)
{
    if ([NSThread isMainThread]) {
        !block ? : block();
    } else {
        dc_dispatch_sync_main_safe(block);
    }
}

void dc_dispatch_main_async_safe(dispatch_block_t block)
{
    if ([NSThread isMainThread]) {
        !block ? : block();
    } else {
        dc_dispatch_async_main_safe(block);
    }
}


void dc_dispatch_async_limit(dispatch_queue_t queue, NSUInteger maxQueueCount, dispatch_block_t block) {
    static dispatch_semaphore_t limitSemaphore;
    static dispatch_queue_t limitQueue;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        limitSemaphore = dispatch_semaphore_create(maxQueueCount);
        limitQueue = dispatch_queue_create("com.dc.dispatch.async.limit.queue", DISPATCH_QUEUE_SERIAL);
    });
    
    dispatch_async(limitQueue, ^{
        dispatch_semaphore_wait(limitSemaphore, DISPATCH_TIME_FOREVER);
        dispatch_async(queue, ^{
            !block ? : block();
            dispatch_semaphore_signal(limitSemaphore);
        });
    });
}