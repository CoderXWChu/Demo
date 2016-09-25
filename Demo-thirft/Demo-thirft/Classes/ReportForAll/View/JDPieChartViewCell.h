//
//  JDChartPieViewCell.h
//  Demo-thirft
//
//  Created by DanaChu on 16/8/29.
//  Copyright © 2016年 DanaChu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDPieChartViewCell : UITableViewCell

@property (nonatomic, strong) TTGDailyDataForCompany *dailyDataForCompany;; ///<

+ (NSString *)identifierForCell;

@end
