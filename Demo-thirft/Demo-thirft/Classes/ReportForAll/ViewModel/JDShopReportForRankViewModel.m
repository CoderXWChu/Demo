//
//  JDShopReportForRankViewModel.m
//  Demo-thirft
//
//  Created by DanaChu on 2016/9/22.
//  Copyright © 2016年 DanaChu. All rights reserved.
//

#import "JDShopReportForRankViewModel.h"


@implementation JDShopReportForRankViewModel

- (void)getDailyDataForRankWithDate:(NSString *)date sid:(NSString *)sid num:(NSUInteger)num {
    
    @weakify(self)
    dispatch_async(dispatch_get_main_queue(), ^{
        [[JDRequestManager shareRequestManager] getDailyDataForRankWithDate:date sid:sid num:num callback:^(TTGdailyRankRequest_S *response) {
            @strongify(self)
            
            self.dailyDataForRank = @[response.dailyRank.dailyRankForSaleGoodList, response.dailyRank.dailyRankForPriceList, response.dailyRank.dailyRankForSaleTerribleList];
        }];
    });
}

@end
