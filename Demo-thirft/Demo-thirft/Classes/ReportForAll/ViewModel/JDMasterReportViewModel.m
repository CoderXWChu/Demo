//
//  JDMasterReportViewModel.m
//
//  Created by DanaChu on 16/8/29.
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

#import "JDMasterReportViewModel.h"

@interface JDMasterReportViewModel ()


@end

@implementation JDMasterReportViewModel

- (instancetype)init
{
    if (self = [super init]) {
        self.luckyDay = [NSDate date];
    }
    return self;
}

- (RACSignal *)refrashSignal
{
    @weakify(self)
    NSString *date = [[self dateFormatter] stringFromDate:self.luckyDay];

    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self)
            [self getDailyDataForSaleWithDate:date];
            [subscriber sendNext:@(YES)];
        });
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self)
            [self getDailyDataForRankWithDate:date sid:@"" num:10];
            [subscriber sendNext:@(YES)];
        });
        
        return nil;
    }] subscribeOn:[RACScheduler schedulerWithPriority:RACSchedulerPriorityBackground]];
}


- (void)getDailyDataForSaleWithDate:(NSString *)date {
    
    [[JDRequestManager shareRequestManager] getDailyDataForSaleWithDate:date callback:^(TTGdailyReportRequest_S *response) {
        self.dailyDataForCompany = response.dailyDataForCompany;
        self.dailyDataForShopList = [response.dailyDataForShopList copy];
    }];
    
}

- (void)getDailyDataForRankWithDate:(NSString *)date sid:(NSString *)sid num:(NSUInteger)num {
    
    [[JDRequestManager shareRequestManager] getDailyDataForRankWithDate:date sid:sid num:num callback:^(TTGdailyRankRequest_S *response) {
        
        self.dailyDataForRank = @[response.dailyRank.dailyRankForSaleGoodList, response.dailyRank.dailyRankForPriceList, response.dailyRank.dailyRankForSaleTerribleList];
    }];
    
}

- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"yyyy.MM.dd";
    }
    
    return dateFormatter;
}

@end
