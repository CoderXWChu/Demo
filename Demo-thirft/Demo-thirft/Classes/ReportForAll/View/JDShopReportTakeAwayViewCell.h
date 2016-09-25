//
//  JDShopReportTakeAwayViewCell.h
//  Demo-thirft
//
//  Created by DanaChu on 16/9/12.
//  Copyright © 2016年 DanaChu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDShopReportTakeAwayViewCell : UITableViewCell

@property (nonatomic, strong) NSArray *takeAwayInfoList; ///< <#注释#>
@property (nonatomic, strong) NSArray *takeAwayInfoListInDayTime; ///< <#注释#>
@property (nonatomic, strong) NSArray *takeAwayInfoListInWeekTime; ///< <#注释#>

+ (NSString *)cellIdentifier;

@end
