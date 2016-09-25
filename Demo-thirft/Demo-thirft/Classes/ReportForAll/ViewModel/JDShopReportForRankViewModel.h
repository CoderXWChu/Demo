//
//  JDShopReportForRankViewModel.h
//  Demo-thirft
//
//  Created by DanaChu on 2016/9/22.
//  Copyright © 2016年 DanaChu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JDRequestManager+Report.h"


@interface JDShopReportForRankViewModel : NSObject

@property (nonatomic, strong) NSArray *dailyDataForRank;

- (void)getDailyDataForRankWithDate:(NSString *)date sid:(NSString *)sid num:(NSUInteger)num;

@end
