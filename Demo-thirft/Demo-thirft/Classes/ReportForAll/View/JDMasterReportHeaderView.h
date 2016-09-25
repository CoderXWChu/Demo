//
//  JDMasterReportHeaderView.h
//  Demo-thirft
//
//  Created by DanaChu on 16/8/29.
//  Copyright © 2016年 DanaChu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDMasterReportHeaderView : UIView

@property (nonatomic, strong) NSDate *dateSelected; ///< 选中日期

+ (instancetype)headerView;

- (void)updateIfNeeded;

@end
