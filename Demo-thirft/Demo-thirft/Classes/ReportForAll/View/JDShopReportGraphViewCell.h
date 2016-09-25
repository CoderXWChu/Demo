//
//  JDShopReportGraphViewCell.h
//  Demo-thirft
//
//  Created by DanaChu on 16/9/9.
//  Copyright © 2016年 DanaChu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDShopReportGraphViewCell : UITableViewCell

@property (nonatomic, strong) NSArray *chartDatasForDay; ///< <#注释#>
@property (nonatomic, strong) NSArray *chartDatasForWeek; ///< <#注释#>

+ (NSString *)cellIdentifier;

@end
