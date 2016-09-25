//
//  DCTimer.m
//
//  Created by DanaChu on 15/12/2.
//  Copyright © 2015年 DanaChu. All rights reserved.
//
// 参考作者: ibireme 原创: [YYTimer]
// 参考地址: https://github.com/ibireme/YYKit

#import "DCTimer.h"

@implementation DCTimer
{
    dispatch_source_t _source;
    dispatch_semaphore_t _lock;
    __weak id _target;
    SEL _selector;
    id _object;
}
@synthesize name = _name;
@synthesize valid = _valid;
@synthesize repeat = _repeat;
@synthesize timeinterval = _timeinterval;


+ (DCTimer *)timerWithTimeName:(NSString *)name
                  timeInterval:(NSTimeInterval)interval
                        target:(id)target
                      selector:(SEL)selector
                        repeat:(BOOL)repeat
{
    return [[[self class] alloc] initWithTimeName:name
                                         fireTime:0
                                     timeInterval:interval
                                           target:target
                                         selector:selector
                                           repeat:repeat];
}

- (instancetype)initWithTimeName:(NSString *)name
                        fireTime:(NSTimeInterval)start
                    timeInterval:(NSTimeInterval)interval
                          target:(id)target
                        selector:(SEL)selector
                          object:(id _Nullable)object
                          repeat:(BOOL)repeat
{
    self = [super init];
    if (self) {
        _name = name;
        _repeat = repeat;
        _valid = YES;
        _timeinterval = interval;
        _target = target;
        _selector = selector;
        _object = object;
        _lock = dispatch_semaphore_create(1);
        _source = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
        dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, start * NSEC_PER_SEC);
        dispatch_source_set_timer(_source, timer, _timeinterval * NSEC_PER_SEC, 0);
        __weak typeof(self) weakSelf = self;
        dispatch_source_set_event_handler(_source, ^{[weakSelf fire];});
        dispatch_resume(_source);
    }
    return self;
}

- (instancetype)initWithTimeName:(NSString *)name
                        fireTime:(NSTimeInterval)start
                    timeInterval:(NSTimeInterval)interval
                          target:(id)target
                        selector:(SEL)selector
                          repeat:(BOOL)repeat
{
    return [self initWithTimeName:name
                         fireTime:start
                     timeInterval:interval
                           target:target
                         selector:selector
                           object:nil
                           repeat:repeat];
}

- (void)invalidate {
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    if (_valid) {
        dispatch_source_cancel(_source);
        _source = NULL;
        _target = nil;
        _object = nil;
        _valid = NO;
    }
    dispatch_semaphore_signal(_lock);
}

- (void)fire {
    if (!_valid) return;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    id target = _target;
    if (!target) {
        dispatch_semaphore_signal(_lock);
        [self invalidate];
    } else {
        dispatch_semaphore_signal(_lock);
        [target performSelector:_selector withObject:_object];
        if (!_repeat) {
            [self invalidate];
        }
    }
#pragma clang diagnostic pop
}

- (NSString *)name
{
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    NSString *name = _name;
    dispatch_semaphore_signal(_lock);
    return name;
}

- (BOOL)isValid
{
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    BOOL valid = _valid;
    dispatch_semaphore_signal(_lock);
    return valid;
}

- (BOOL)isRepeat
{
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    BOOL repeat = _repeat;
    dispatch_semaphore_signal(_lock);
    return repeat;
}

- (NSTimeInterval)timeinterval
{
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    NSTimeInterval timeinterval = _timeinterval;
    dispatch_semaphore_signal(_lock);
    return timeinterval;
}

- (void)dealloc
{
    [self invalidate];
}

@end
