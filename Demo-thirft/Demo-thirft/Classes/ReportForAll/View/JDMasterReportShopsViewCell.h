//
//  JDMasterReportShopsViewCell.h
//  Demo-thirft
//
//  Created by DanaChu on 16/8/29.
//  Copyright © 2016年 DanaChu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JDMasterReportViewModel;

@interface JDMasterReportShopsViewCell : UITableViewCell

@property (nonatomic, strong) NSArray *dataSource; ///<

@property (nonatomic, copy) NSString *selectedDate;

+ (NSString *)identifierForCell;

@end
