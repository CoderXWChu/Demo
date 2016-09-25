//
//  JDMasterReportRankViewCell.h
//  Demo-thirft
//
//  Created by DanaChu on 16/8/30.
//  Copyright © 2016年 DanaChu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDMasterReportRankViewCell : UITableViewCell

@property (nonatomic, strong) NSArray <NSArray *>*datasource;

+ (NSString *)identifierForCell;

@end
