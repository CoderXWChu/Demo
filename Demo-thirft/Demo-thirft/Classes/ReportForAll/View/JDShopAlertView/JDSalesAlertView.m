//
//  JDSalesAlertView.m
//  Demo-thirft
//
//  Created by DanaChu on 2016/9/23.
//  Copyright © 2016年 DanaChu. All rights reserved.
//

#import "JDSalesAlertView.h"
#import "JDSalesAlertContentView.h"

@interface JDSalesAlertView()



@end

@implementation JDSalesAlertView


- (instancetype)init
{
    if (self = [super init]) {
        [self addContentView];
    }
    return self;
}

- (void)addContentView
{
    JDSalesAlertContentView *contentView = [JDSalesAlertContentView salesAlertContentView];
    contentView.width = SCREEN_WIDTH * 0.85;
    [self setContentView:contentView];

    
}

#pragma mark - Public

+ (void)showSalesAlert
{
    JDSalesAlertView * alert = [[JDSalesAlertView alloc] init];
    [alert showAlertView];
}

+ (void)showSalesAlertWithData:(NSArray<TTGDailyDataForSale *> *)data
{
    JDSalesAlertView * alert = [[JDSalesAlertView alloc] init];
    
    alert.contentView.data = data;
    
    [alert showAlertView];

}

@end
