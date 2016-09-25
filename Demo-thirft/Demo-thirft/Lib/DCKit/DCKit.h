//
//  DCKit.h
//
//  Created by CoderXWChu on 16/5/10.
//  Copyright © 2015年 CoderXWChu. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __has_include(<DCKit/DCKit.h>)

#import <DCKit/DCCommonDefine.h>

#import <DCKit/NSObject+DCExtForKVO.h>
#import <DCKit/NSObject+DCExtForNotification.h>
#import <DCKit/NSObject+DictToModel.h>
#import <DCKit/NSDictionary+DCExt.h>
#import <DCKit/NSObject+DCExt.h>
#import <DCKit/NSString+Hash.h>

#import <DCKit/UIView+DCExt.h>
#import <DCKit/UIView+DCExtForFrame.h>
#import <DCKit/UIView+DCExtForOperation.h>
#import <DCKit/UIColor+DCExt.h>
#import <DCKit/UIImage+DCExt.h>
#import <DCKit/UIImage+DCExtForColor.h>
#import <DCKit/UITextField+DCExt.h>
#import <DCKit/UIViewController+DCExt.h>

#import <DCKit/DCCache.h>
#import <DCKit/DCDatabase.h>
#import <DCKit/NSObject+DCAutoCoding.h>

#import <DCKit/DCHUD.h>
#import <DCKit/DCFileManager.h>
#import <DCKit/DCTimer.h>
#import <DCKit/DCTimerManager.h>

#import <DCKit/DCRequestConfiguration.h>
#import <DCKit/DCRequestManager.h>
#import <DCKit/DCRequestManager+Login.h>

#import <DCKit/DCQRCodeTool.h>
#import <DCKit/DCRegExHelper.h>
#import <DCKit/DCStringHelper.h>
#import <DCKit/DCRuntimeHelper.h>
#import <DCKit/DCCalculatorHelper.h>

#import <DCKit/CALayer+DCExt.h>


#else


#import "DCCommonDefine.h"

#import "NSObject+DCExtForKVO.h"
#import "NSObject+DCExtForNotification.h"
#import "NSObject+DictToModel.h"
#import "NSDictionary+DCExt.h"
#import "NSObject+DCExt.h"
#import "NSString+Hash.h"

#import "UIView+DCExt.h"
#import "UIView+DCExtForFrame.h"
#import "UIView+DCExtForOperation.h"
#import "UIColor+DCExt.h"
#import "UIImage+DCExt.h"
#import "UIImage+DCExtForColor.h"
#import "UITextField+DCExt.h"
#import "UIViewController+DCExt.h"

#import "DCCache.h"
#import "DCDatabase.h"
#import "NSObject+DCAutoCoding.h"

#import "DCHUD.h"
#import "DCFileManager.h"
#import "DCTimer.h"
#import "DCTimerManager.h"

#import "DCRequestConfiguration.h"
#import "DCRequestManager.h"
#import "DCRequestManager+Login.h"

#import "DCQRCodeTool.h"
#import "DCStringHelper.h"
#import "DCRegExHelper.h"
#import "DCRuntimeHelper.h"
#import "DCCalculatorHelper.h"

#import "CALayer+DCExt.h"


#endif
