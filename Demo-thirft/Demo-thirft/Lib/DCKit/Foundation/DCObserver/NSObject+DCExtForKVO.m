//
//  NSObject+DCExtensionForKVO.m
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

#import "NSObject+DCExtForKVO.h"
#import <objc/runtime.h>
#import <objc/message.h>

static const int DCAllKVOBlocksKey;
static void * DCKVOHasSwizzledKey = "DCHasSwizzledKey";

@interface _DCNSObjectKVOBlockTarget : NSObject

@property (nonatomic, copy) void (^block)(__weak id _Nonnull obj, _Nullable id oldVal, _Nullable id newVal);

- (instancetype)initWithBlock:(void (^)(__weak id _Nonnull obj, _Nullable id oldVal, _Nullable id newVal))block;

@end

@implementation _DCNSObjectKVOBlockTarget

- (instancetype)initWithBlock:(void (^)(id  _Nonnull __weak, id _Nullable, id _Nullable))block
{
    self = [super init];
    if (self) {
        self.block = block;
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (!self.block) return;
    BOOL isPrior = [[change objectForKey:NSKeyValueChangeNotificationIsPriorKey] boolValue];
    if (isPrior) return;
    
    NSKeyValueChange changeKind = [[change objectForKey:NSKeyValueChangeKindKey] integerValue];
    if (changeKind != NSKeyValueChangeSetting) return;
    
    id oldVal = [change objectForKey:NSKeyValueChangeOldKey];
    if (oldVal == [NSNull null]) oldVal = nil;
    
    id newVal = [change objectForKey:NSKeyValueChangeNewKey];
    if (newVal == [NSNull null]) newVal = nil;
    
    self.block(object, oldVal, newVal);
}

@end

@implementation NSObject (DCExtForKVO)

- (void)dc_addObserverBlockForKeyPath:(NSString *)keyPath block:(void (^)(id  _Nonnull __weak, id _Nullable, id _Nullable))block
{
    if (!keyPath || !block) return;
    _DCNSObjectKVOBlockTarget *target = [[_DCNSObjectKVOBlockTarget alloc] initWithBlock:block];
    NSMutableDictionary *dict = [self _dc_allNSObjectKVOBlocks];
    NSMutableArray *arr = dict[keyPath];
    if (!arr) {
        arr = [NSMutableArray arrayWithCapacity:0];
    }
    [arr addObject:target];
    dict[keyPath] = arr;
    [self addObserver:target forKeyPath:keyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
}

- (void)dc_removeObserverBlocksForKeyPath:(NSString *)keyPath
{
    if (!keyPath) return;
    NSMutableDictionary *dict = [self _dc_allNSObjectKVOBlocks];
    if (dict.allKeys.count == 0) return;
    NSMutableArray *arr = dict[keyPath];
    
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self removeObserver:obj forKeyPath:keyPath];
    }];
    
    [dict removeObjectForKey:keyPath];
}

- (void)dc_removeObserverKVOBlocks
{
    NSMutableDictionary *dic = [self _dc_allNSObjectKVOBlocks];
    [dic enumerateKeysAndObjectsUsingBlock: ^(NSString *key, NSArray *arr, BOOL *stop) {
        [arr enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
            [self removeObserver:obj forKeyPath:key];
        }];
    }];
    
    [dic removeAllObjects];
}

- (NSMutableDictionary *)_dc_allNSObjectKVOBlocks
{
    NSMutableDictionary *dict = objc_getAssociatedObject(self, &DCAllKVOBlocksKey);
    if (!dict) {
        dict = [NSMutableDictionary dictionaryWithCapacity:0];
        [self _dc_kvoSwizzleDealloc];
        objc_setAssociatedObject(self, &DCAllKVOBlocksKey, dict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return dict;
}

- (void)_dc_kvoSwizzleDealloc{
    BOOL swizzled = [objc_getAssociatedObject(self.class, DCKVOHasSwizzledKey) boolValue];
    if (swizzled) return;
    Class swizzleClass = self.class;
    @synchronized(swizzleClass) {
        SEL deallocSelector = sel_registerName("dealloc");
        __block void (*originalDealloc)(__unsafe_unretained id, SEL) = NULL;
        id newDealloc = ^(__unsafe_unretained id objSelf){
            [objSelf dc_removeObserverKVOBlocks];
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
        objc_setAssociatedObject(self.class, DCKVOHasSwizzledKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

@end
