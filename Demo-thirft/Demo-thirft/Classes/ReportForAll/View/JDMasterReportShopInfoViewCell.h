//
//  JDMasterReportShopInfoViewCell.h
//  Demo-thirft
//
//  Created by DanaChu on 16/8/29.
//  Copyright © 2016年 DanaChu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDMasterReportShopInfoViewCell : UITableViewCell

//@property (nonatomic, copy) NSString *shopName; ///< <#注释#>
//@property (nonatomic, assign) double lastSale; ///< <#注释#>
//@property (nonatomic, assign) double currentSale; ///< <#注释#>

@property (nonatomic, strong) TTGDailyDataForShop *dailyDataForShop; ///< <#注释#>


+ (NSString *)identifierForCell;

@end
