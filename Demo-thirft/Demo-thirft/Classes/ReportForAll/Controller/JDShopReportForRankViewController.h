//
//  JDShopReportForRankViewController.h
//  Demo-thirft
//
//  Created by DanaChu on 2016/9/22.
//  Copyright © 2016年 DanaChu. All rights reserved.
//

#import "DCBaseTableViewController.h"

@interface JDShopReportForRankViewController : DCBaseTableViewController

@property (nonatomic, assign) NSUInteger shopId; ///< shop id
@property (nonatomic, copy) NSString *shopName; ///< shop name
@property (nonatomic, copy) NSString *date; ///< the date

@end
