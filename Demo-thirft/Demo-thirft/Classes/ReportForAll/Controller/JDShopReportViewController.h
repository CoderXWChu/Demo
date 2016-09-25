//
//  JDShopReportViewController.h
//  Demo-thirft
//
//  Created by DanaChu on 16/9/5.
//  Copyright © 2016年 DanaChu. All rights reserved.
//

#import "DCBaseTableViewController.h"

@interface JDShopReportViewController : DCBaseTableViewController

@property (nonatomic, copy) NSString *selectedDate; ///<  所选择的日期
@property (nonatomic, assign) NSUInteger shopId; ///<  所选择的日期
@property (nonatomic, copy) NSString *shopName; ///< 商铺名称
@end
