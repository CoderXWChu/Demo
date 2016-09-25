//
//  DCTimerManager.m
//
//  Created by DanaChu on 15/12/2.
//  Copyright © 2015年 DanaChu. All rights reserved.
//

#import "DCTimerManager.h"
#import "DCTimer.h"

@implementation DCTimerManager
{
    BOOL _willClean;
    NSMutableDictionary *_timers;
    NSMutableDictionary *_actions;
}

static DCTimerManager *_instance;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _willClean = NO;
        _timers = [NSMutableDictionary dictionaryWithCapacity:0];
        _actions = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return self;
}

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[[self class] alloc] init];
    });
    return _instance;
}

- (void)timerWithTimerName:(NSString *)name
                  fireTime:(NSTimeInterval)start
              timeInterval:(NSTimeInterval)timeinterval
                    repeat:(BOOL)repeat
                    action:(DCTimerAction)action
{
    DCTimer *timer = _timers[name];
    if (timer) {
        [timer invalidate];
    }
    else {
        timer = [[DCTimer alloc] initWithTimeName:name
                                         fireTime:start
                                     timeInterval:timeinterval
                                           target:self
                                         selector:@selector(performActionWithTimerName:)
                                           object:name
                                           repeat:repeat];
        [_timers setObject:timer forKey:name];
        [_actions setObject:[action copy] forKey:name];
    }
}

- (void)timerWithTimerName:(NSString *)name
              timeInterval:(NSTimeInterval)timeinterval
                    repeat:(BOOL)repeat
                    action:(DCTimerAction)action
{
    return [self timerWithTimerName:name
                           fireTime:timeinterval
                       timeInterval:timeinterval
                             repeat:repeat
                             action:action];
}


- (void)invalidateWithName:(NSString *)name
{
    if(!name || name.length == 0) return;
    DCTimer *timer = _timers[name];
    if (timer) {
        [timer invalidate];
    }
}

- (void)performActionWithTimerName:(NSString *)name
{
    if(!name || name.length == 0) return;
    if (_willClean) {
        [self removeInvalidTimer];
        _willClean = NO;
    }
    DCTimer *timer = _timers[name];
    if (nil == timer) return;
    if (!timer.isRepeat) {
        _willClean = YES;
    }
    void (^action)() = _actions[name];
    if (action) {
        action();
    }
}

- (void)removeInvalidTimer
{
    for (NSString *name in _timers.allKeys) {
        DCTimer *timer = _timers[name];
        if (!timer.isValid) {
            [_timers removeObjectForKey:name];
            [_actions removeObjectForKey:name];
        }
    }
}

- (void)dealloc
{
    for (NSString *name in _timers.allKeys) {
        DCTimer *timer = _timers[name];
        if (timer.isValid) {
            [timer invalidate];
        }
    }
}

@end
