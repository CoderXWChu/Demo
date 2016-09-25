//
//  NSObject+DCExtForNotification.m
//
//  Created by CoderXWChu on 15/10/2.
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

#import "NSObject+DCExtForNotification.h"
#import <objc/runtime.h>
#import <objc/message.h>

static const int DCAllNotificationBlocksKey;
static void * DCNotificationHasSwizzledKey = "DCNotificationHasSwizzledKey";

@interface _DCNSObjectNotificationBlockTarget : NSObject

@property (nonatomic, copy) void(^block)(__weak id __nullable obj, NSNotification *noti);

- (instancetype)initWithBlock:(void (^)(__weak id __nullable, NSNotification *))block;

@end

@implementation _DCNSObjectNotificationBlockTarget

- (instancetype)initWithBlock:(void (^)(__weak id __nullable, NSNotification *))block
{
    self = [super init];
    if (self) {
        self.block = block;
    }
    return self;
}

- (void)receiveNotification:(NSNotification *)noti
{
    if(!self.block) return;
    self.block(noti.object, noti);
}

@end

@implementation NSObject (DCExtForNotification)

- (void)dc_addObserverBlockForNotificationName:(NSString *)aName block:(void (^)(__weak id __nullable, NSNotification * _Nonnull))block
{
    if (!aName || !block) return;
    _DCNSObjectNotificationBlockTarget *target = [[_DCNSObjectNotificationBlockTarget alloc] initWithBlock:block];
    NSMutableDictionary *dict = [self _dc_allNSObjectNotificationBlocks];
    NSMutableArray *arr = dict[aName];
    if (!arr) {
        arr = [NSMutableArray arrayWithCapacity:0];
    }
    [arr addObject:target];
    dict[aName] = arr;
    [[NSNotificationCenter defaultCenter] addObserver:target selector:@selector(receiveNotification:) name:aName object:nil];
}

- (void)dc_removeObserverWithNotificationName:(NSString *)aName
{
    if (!aName) return;
    NSMutableDictionary *dict = [self _dc_allNSObjectNotificationBlocks];
    if (dict.allKeys.count == 0) return;
    NSMutableArray *arr = dict[aName];
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [[NSNotificationCenter defaultCenter] removeObserver:obj];
    }];
    [dict removeObjectForKey:aName];
}

- (void)dc_removeObserverNotificationBlocks
{
    NSMutableDictionary *dic = [self _dc_allNSObjectNotificationBlocks];
    [dic enumerateKeysAndObjectsUsingBlock: ^(NSString *key, NSArray *arr, BOOL *stop) {
        [arr enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
            [[NSNotificationCenter defaultCenter] removeObserver:obj];
        }];
    }];
    
    [dic removeAllObjects];
}

- (NSMutableDictionary *)_dc_allNSObjectNotificationBlocks
{
    NSMutableDictionary *dict = objc_getAssociatedObject(self, &DCAllNotificationBlocksKey);
    if (!dict) {
        dict = [NSMutableDictionary dictionaryWithCapacity:0];
        [self _dc_notificationSwizzleDealloc];
        objc_setAssociatedObject(self, &DCAllNotificationBlocksKey, dict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return dict;
}


- (void)_dc_notificationSwizzleDealloc{
    BOOL swizzled = [objc_getAssociatedObject(self.class, DCNotificationHasSwizzledKey) boolValue];
    if (swizzled) return;
    Class swizzleClass = self.class;
    @synchronized(swizzleClass) {
        SEL deallocSelector = sel_registerName("dealloc");
        __block void (*originalDealloc)(__unsafe_unretained id, SEL) = NULL;
        id newDealloc = ^(__unsafe_unretained id objSelf){
            [objSelf dc_removeObserverNotificationBlocks];
            if (originalDealloc == NULL) {
                struct objc_super superInfo = {
                    .receiver = objSelf,
                    .super_class = class_getSuperclass(swizzleClass)
                };
                void (*msgSend)(struct objc_super *, SEL) = (__typeof__(msgSend))objc_msgSendSuper;
                msgSend(&superInfo, deallocSelector);
            }else{
                originalDealloc(objSelf, deallocSelector);
            }
        };
        IMP newDeallocIMP = imp_implementationWithBlock(newDealloc);
        if (!class_addMethod(swizzleClass, deallocSelector, newDeallocIMP, "v@:")) {
            Method deallocMethod = class_getInstanceMethod(swizzleClass, deallocSelector);
            originalDealloc = (void(*)(__unsafe_unretained id, SEL))method_getImplementation(deallocMethod);
            originalDealloc = (void(*)(__unsafe_unretained id, SEL))method_setImplementation(deallocMethod, newDeallocIMP);
        }
        objc_setAssociatedObject(self.class, DCNotificationHasSwizzledKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

@end
