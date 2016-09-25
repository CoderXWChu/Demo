//
//  JDTakeAwayAlertView.h
//  Demo-thirft
//
//  Created by DanaChu on 2016/9/23.
//  Copyright © 2016年 DanaChu. All rights reserved.
//

#import "JDAlertView.h"

@interface JDTakeAwayAlertView : JDAlertView

+ (void)showTakeAwayAlertWithData:(NSArray <TTGTakeAwayInfo *>*)data;

+ (void)showTakeAwayAlert;

@end
