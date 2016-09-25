//
//  JDShopAlertView.h
//  Demo-thirft
//
//  Created by DanaChu on 2016/9/23.
//  Copyright © 2016年 DanaChu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JDAlertViewProtocal.h"

typedef NS_ENUM(NSUInteger, JDAlertDisplayMode) {
    JDAlertDisplayMask = 0, // Default
    JDAlertDisplayNone
};


@interface JDAlertView : UIView

@property (nonatomic, strong) UIView<JDAlertViewProtocal> *contentView; ///< 弹窗内容

@property (nonatomic, assign) JDAlertDisplayMode displayMode; ///< Default: JDAlertDisplayMask

- (void)showAlertView;

- (void)dismiss;

@end
