//
//  JDRequestManager+Report.m
//
//  Created by DanaChu on 16/9/5.
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

#import "JDRequestManager+Report.h"

@implementation JDRequestManager (Report)


- (void)getDailyDataForSaleWithDate:(NSString *)date callback:(JDDailyReportRequestCallback)callback
{
    TTGdailyReportRequest_C* request = [[TTGdailyReportRequest_C alloc] initWithDate:@"2016.08.28"];
    TTGdailyReportRequest_S* response = [[JDRequestManager shareRequestManager]->service dailyReportRequest:request];
    if (callback) {
        callback(response);
    }
}

- (void)getDailyDataForRankWithDate:(NSString *)date sid:(NSString *)sid num:(NSUInteger)num callback:(JDDailyRankRequestCallback)callback
{
    TTGdailyRankRequest_C* request = [[TTGdailyRankRequest_C alloc] initWithDate:date
                                                                             sid:sid
                                                                             num:@"10"];
        
    TTGdailyRankRequest_S* response = [[JDRequestManager shareRequestManager]->service  dailyRankRequest:request];
    if (callback) {
        callback(response);
    }
}

- (void)getDailyDataForShopWithDate:(NSString *)date sid:(NSString *)sid callback:(JDDailyReportForShopRequestCallback)callback
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy.MM.dd";
    NSTimeInterval time = [[formatter dateFromString:date] timeIntervalSince1970];

    TTGdailyReportForShopRequest_C* request = [[TTGdailyReportForShopRequest_C alloc] initWithDate:time sid:@"1"];
    TTGdailyReportForShopRequest_S* response = [service dailyReportForShopRequest:request];
    if (callback) {
            callback(response);
        }
}


@end
