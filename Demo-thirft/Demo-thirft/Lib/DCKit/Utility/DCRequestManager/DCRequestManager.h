//
//  DCRequestCenter.h
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

#import <Foundation/Foundation.h>

#import "DCRequestConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

/*!
 *  网络状态
 */
typedef NS_ENUM(NSInteger, DCNetworkStatus) {
    /*!
     *  未知网络
     */
    DCNetworkStatusUnknown     = -1,
    /*!
     *  网络不可用
     */
    DCNetworkStatusNotReachable,
    /*!
     *  蜂窝网络
     */
    DCNetworkStatusReachableViaWWAN,
    /*!
     *  WiFi
     */
    DCNetworkStatusReachableViaWiFi
};


/*!
 *  用于网络请求的回调程序块
 *  @param error  传入的错误
 *  @param result 传入的相应结果
 */
typedef void(^DCRequestCallBack)(NSURLSessionDataTask * task, NSMutableDictionary *_Nullable result, NSError * _Nullable error);
typedef void(^DCRequestSuccessCallBack)(NSURLSessionDataTask * task, NSMutableDictionary *_Nullable result);
typedef void(^DCRequestFailureCallBack)(NSURLSessionDataTask * _Nullable task, NSError * error);


@interface DCRequestManager : NSObject

/*!
 *  网络是否可用
 */
@property (nonatomic, assign) BOOL reachable;

/*!
 *  当前网络状态
 */
@property (nonatomic, assign) DCNetworkStatus netWorkStatus;


#pragma mark - initialize

/*!
 *  用来获取全局唯一网络请求对象
 */
+ (instancetype)sharedManager;

+ (instancetype)new  UNAVAILABLE_ATTRIBUTE;
- (instancetype)init UNAVAILABLE_ATTRIBUTE;

#pragma mark - Methods
/*!
 *  取消所有任务
 */
- (void)cancalAllTasks;

/*!
 *  开始监视/停止监视网络状态 , 默认打开;
 */
+ (void)dc_startMonitoring;
+ (void)dc_stopMonitoring;


#pragma mark - GET

/*!
 *  发起 GET 请求
 *  @param url        网络请求路径《相对路径》
 *  @param parameters 网络请求参数
 *  @param callback   网络请求回调
 *  @return 网络请求任务
 */
- (NSURLSessionDataTask *)sendGetRequestWithURL:(NSString *)url parameters:(NSDictionary *)parameters callback:(DCRequestCallBack)callback;

/*!
 *  发起 GET 请求
 *  @param url        网络请求路径《相对路径》
 *  @param parameters 网络请求参数
 *  @param success    网络请求成功回调
 *  @param failure    网络请求失败回调
 *  @return 网络请求任务
 */
- (NSURLSessionDataTask *)sendGetRequestWithURL:(NSString *)url parameters:(NSDictionary *)parameters success:(DCRequestSuccessCallBack _Nullable)success failure:(DCRequestFailureCallBack _Nullable)failure;

#pragma mark - POST

/*!
 *  发起 POST 请求
 *  @param url        网络请求路径《相对路径》
 *  @param parameters 网络请求参数
 *  @param callback   网络请求回调
 *  @return 网络请求任务
 */
- (NSURLSessionDataTask *)sendPostRequestWithURL:(NSString *)url parameters:(NSDictionary *)parameters callback:(DCRequestCallBack)callback;



/*!
 *  发起 POST 请求
 *  @param url        网络请求路径《相对路径》
 *  @param parameters 网络请求参数
 *  @param success    网络请求成功回调
 *  @param failure    网络请求失败回调
 *  @return 网络请求任务
 */
- (NSURLSessionDataTask *)sendPostRequestWithURL:(NSString *)url parameters:(NSDictionary *)parameters success:(DCRequestSuccessCallBack _Nullable)success failure:(DCRequestFailureCallBack _Nullable)failure;


@end


NS_ASSUME_NONNULL_END
