//
//  JDTakeAwayAlertContentView.h
//  Demo-thirft
//
//  Created by DanaChu on 2016/9/23.
//  Copyright © 2016年 DanaChu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JDAlertViewProtocal.h"

@class TTGDailyDataForSale;

@interface JDTakeAwayAlertContentView : UIView<JDAlertViewProtocal>

@property (nonatomic, strong) NSArray<TTGTakeAwayInfo *> *data;

+ (instancetype)takeAwayAlertContentView;

@end
