//
//  JDTakeAwayAlertView.m
//  Demo-thirft
//
//  Created by DanaChu on 2016/9/23.
//  Copyright © 2016年 DanaChu. All rights reserved.
//

#import "JDTakeAwayAlertView.h"
#import "JDTakeAwayAlertContentView.h"

@implementation JDTakeAwayAlertView

- (instancetype)init
{
    if (self = [super init]) {
        [self addContentView];
    }
    return self;
}

- (void)addContentView
{
    JDTakeAwayAlertContentView *contentView = [JDTakeAwayAlertContentView takeAwayAlertContentView];
    contentView.width = SCREEN_WIDTH * 0.85;
    [self setContentView:contentView];
}

#pragma mark - Public

+ (void)showTakeAwayAlert
{
    JDTakeAwayAlertView * alert = [[JDTakeAwayAlertView alloc] init];
    [alert showAlertView];
}

+ (void)showTakeAwayAlertWithData:(NSArray<TTGTakeAwayInfo *> *)data
{
    JDTakeAwayAlertView * alert = [[JDTakeAwayAlertView alloc] init];
    alert.contentView.data = data;
    [alert showAlertView];
}

@end
