//
//  JDSalesAlertView.h
//  Demo-thirft
//
//  Created by DanaChu on 2016/9/23.
//  Copyright © 2016年 DanaChu. All rights reserved.
//

#import "JDAlertView.h"

@interface JDSalesAlertView : JDAlertView


+ (void)showSalesAlertWithData:(NSArray<TTGDailyDataForSale *> *)data;

+ (void)showSalesAlert;

@end
