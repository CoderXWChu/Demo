//
//  DCRequestCenter.m
//
//  Created by DanaChu on 16/4/7.
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

#import "DCRequestManager.h"

#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"

#define DCTaskLockName @"DCRequestCenter_taskArray_Lock"

@interface DCRequestManager ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong) NSMutableArray *tasks;
@property (nonatomic, strong) NSLock *lock;

@end

@implementation DCRequestManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 添加初始化操作
        
        // 默认开启网络监视
        [[self class] dc_startMonitoring];
    }
    return self;
}

static DCRequestManager * _instance = nil;

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[[self class]alloc]init];
    });
    return _instance;
}


- (void)dealloc
{
    [[self class] dc_stopMonitoring];
}

#pragma mark - Publick

- (NSURLSessionDataTask *)sendGetRequestWithURL:(NSString *)url parameters:(NSDictionary *)parameters callback:(DCRequestCallBack)callback
{
    return [self sendGetRequestWithURL:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, NSMutableDictionary * _Nullable result) {
        NSAssert(callback, @"请求回调不能为空. ");
        callback(task, result, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSAssert(callback, @"请求回调不能为空. ");
        callback(task, nil, error);
    }];
}

- (NSURLSessionDataTask *)sendGetRequestWithURL:(NSString *)url parameters:(NSDictionary *)parameters success:(DCRequestSuccessCallBack)success failure:(DCRequestFailureCallBack)failure
{
    //============================================================
    // 执行请求前先从任务队列中找，是否存在  // 待完成
    // 1.存在  :恢复任务
    // 2.不存在: 创建任务，将任务添加到任务队列中
    //============================================================
    //if(!self.reachable) return nil;
    
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *task = [self.manager GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        if (success) {
            dispatch_main_async_safe(^{
                success(task, responseObject);
            });
        }
        
        [strongSelf.lock lock];
        [strongSelf.tasks removeObject:task];
        [strongSelf.lock unlock];
        
        return;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        if (failure) {
            dispatch_main_async_safe(^{
                failure(task, error);
            });
        }
        
        [strongSelf.lock lock];
        [strongSelf.tasks removeObject:task];
        [strongSelf.lock unlock];
        
        return;
    }];
    
    [self.lock lock];
    [self.tasks addObject:task];
    [self.lock unlock];
    
    return task;
}



- (NSURLSessionDataTask *)sendPostRequestWithURL:(NSString *)url parameters:(NSDictionary *)parameters callback:(DCRequestCallBack)callback
{
    return [self sendPostRequestWithURL:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, NSMutableDictionary * _Nullable result) {
        NSAssert(callback, @"请求回调不能为空. ");
        callback(task, result, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSAssert(callback, @"请求回调不能为空. ");
        callback(task, nil, error);
    }];
}


- (NSURLSessionDataTask *)sendPostRequestWithURL:(NSString *)url parameters:(NSDictionary *)parameters success:(DCRequestSuccessCallBack)success failure:(DCRequestFailureCallBack)failure
{
    //============================================================
    // 执行请求前先从任务队列中找，是否存在  // 待完成
    // 1.存在  :恢复任务
    // 2.不存在: 创建任务，将任务添加到任务队列中
    //============================================================
    //if(!self.reachable) return nil;
    
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *task = [self.manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        if (success) {
            dispatch_main_async_safe(^{
                success(task, responseObject);
            });
        }
        
        [strongSelf.lock lock];
        [strongSelf.tasks removeObject:task];
        [strongSelf.lock unlock];
        
        return;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        if (failure) {
            dispatch_main_async_safe(^{
                failure(task, error);
            });
        }
        
        [strongSelf.lock lock];
        [strongSelf.tasks removeObject:task];
        [strongSelf.lock unlock];
        
        return;
    }];
    
    [self.lock lock];
    [self.tasks addObject:task];
    [self.lock unlock];
    
    return task;
}


- (void)cancalAllTasks
{
    [self.manager.tasks enumerateObjectsUsingBlock:^(NSURLSessionTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj cancel];
    }];
}


+ (void)dc_startMonitoring
{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status)
        {
            case AFNetworkReachabilityStatusUnknown:
                [DCRequestManager sharedManager].netWorkStatus = DCNetworkStatusUnknown;
                break;
            case AFNetworkReachabilityStatusNotReachable:
                [DCRequestManager sharedManager].netWorkStatus = DCNetworkStatusNotReachable;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                [DCRequestManager sharedManager].netWorkStatus = DCNetworkStatusReachableViaWWAN;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [DCRequestManager sharedManager].netWorkStatus = DCNetworkStatusReachableViaWiFi;
                break;
        }
    }];
    [manager startMonitoring];
}

+ (void)dc_stopMonitoring
{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager stopMonitoring];
}

#pragma mark - Private



#pragma mark - getter setter 

- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        NSURL *baseURL = [NSURL URLWithString:BaseURL];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.timeoutIntervalForRequest = 30;
        _manager = [[AFHTTPSessionManager alloc]initWithBaseURL:baseURL sessionConfiguration:configuration];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
        _manager.operationQueue.maxConcurrentOperationCount = 4;
    }
    return _manager;
}

- (NSMutableArray *)tasks
{
    if (!_tasks) {
        _tasks = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _tasks;
}


- (BOOL)reachable
{
    return self.manager.reachabilityManager.reachable;
}

- (NSLock *)lock
{
    if(!_lock){
        _lock = [[NSLock alloc]init];
        _lock.name = DCTaskLockName;
    }
    return _lock;
}

@end
