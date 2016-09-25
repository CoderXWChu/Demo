//
//  JDShopReportViewModel.m
//
//  Created by DanaChu on 16/9/5.
//  Copyright © 2016年 DanaChu. All rights reserved.
//

#import "JDShopReportViewModel.h"

@interface JDShopReportViewModel()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation JDShopReportViewModel



- (void)getDailyDataForShopWithDate:(NSString *)date sid:(NSUInteger)sid
{
    @weakify(self)
    dispatch_async(dispatch_get_main_queue(), ^{
    
        NSString *ID = [NSString stringWithFormat:@"%ld", sid];
        [[JDRequestManager shareRequestManager] getDailyDataForShopWithDate:date sid:ID callback:^(TTGdailyReportForShopRequest_S *response) {
            @strongify(self)
            
            self.dailyReportForShop =  response.dailyReportForShop;
            
        }];
    });
}


#pragma mark - UITableViewDelegate UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PopoverTableViewCellIdentifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"PopoverTableViewCellIdentifier"];
        cell.textLabel.textColor = [JDTheme lightGrayForWord];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"菜品销售信息";
            break;
        case 1:
            cell.textLabel.text = @"店员状况";
            break;
        case 2:
            cell.textLabel.text = @"预测信息";
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.popover dismiss];
    self.index = @(indexPath.row);
}


#pragma mark - getter

- (DXPopover *)popover
{
    if (_popover == nil) {
        _popover = [DXPopover popover];
        _popover.betweenAtViewAndArrowHeight = 16;
        _popover.maskType = DXPopoverMaskTypeBlack;
        _popover.applyShadow = YES;
        _popover.cornerRadius = 4.0f;
        _popover.animationSpring = YES;
        _popover.backgroundColor =  [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    return _popover;
}
- (UITableView *)popTableView
{
    if (_popTableView == nil) {
        _popTableView = [[UITableView alloc] init];
        _popTableView.delegate = self;
        _popTableView.dataSource = self;
        _popTableView.tableFooterView = [[UIView alloc] init];
        _popTableView.scrollEnabled = NO;
        _popTableView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        CGRect tableViewFrame = _popTableView.frame;
        tableViewFrame.size.height = 44.0*3 + 10;
        tableViewFrame.size.width = 150.0f;
        _popTableView.frame = tableViewFrame;
    }
    return _popTableView;
    
}


@end
