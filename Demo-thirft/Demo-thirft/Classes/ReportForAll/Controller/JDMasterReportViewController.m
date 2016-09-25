//
//  JDMasterReportViewController.m
//
//  Created by DanaChu on 16/8/29.
//  Copyright © 2016年 DanaChu. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "JDMasterReportViewController.h"

#import "JDMasterReportViewModel.h"
#import "JDMasterReportHeaderView.h"
#import "JDMasterReportShopsViewCell.h"
#import "JDPieChartViewCell.h"
#import "JDMasterReportRankViewCell.h"
#import "JDMasterReportWorseRankViewCell.h"

//#define HeaderHeight 44.f

@interface JDMasterReportViewController()
@property (nonatomic, strong) JDMasterReportViewModel *masterReportViewModel;
@property (nonatomic, strong) JDMasterReportHeaderView *headerView;
@property (nonatomic, copy) NSString *selectedDate;
@property (nonatomic, copy) NSString *selectedShop;
@end

@implementation JDMasterReportViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self masterReportViewModel];
    
    [self setupUI];
    
    [self initialBinding];
    
    self.selectedDate = [[self dateFormatter]stringFromDate:[NSDate date]];
    
    [self pullDownRefreshAction];
}

// 将要旋转时销毁 CalendarPickerView
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [self.headerView updateIfNeeded];
}


#pragma mark - Private


- (void)initialBinding
{
    
    @weakify(self)

    [[RACObserve(self.headerView, dateSelected) filter:^BOOL(NSDate *x) {
        return x ? YES : NO;
    }]
     subscribeNext:^(NSDate *date) {
         @strongify(self)
        self.masterReportViewModel.luckyDay = date;
         self.selectedDate = [[self dateFormatter] stringFromDate:date];
        [self pullDownRefreshAction];
    }];
    
}

- (void)pullDownRefreshAction
{
    [DCHUD dc_showIndeterminateHUDWithTitle:@""];
    
    @weakify(self)
    [[[self.masterReportViewModel refrashSignal] skip:1]
     subscribeNext:^(NSNumber *x) {
         @strongify(self)
         if (x.boolValue) {
             [self headerEndRefresh];
                 @strongify(self)
                 [self.tableView reloadData];
         }
         [DCHUD dc_hidePresentedHUD];
     }];
}

- (void)setupUI
{
    self.isHasRefreshHeader = YES;
    self.navigationItem.title = @"今日报表";
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 200;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [JDTheme backgroundColor]; 
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self registerCell];
}

- (void)registerCell
{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JDMasterReportShopsViewCell class]) bundle:nil] forCellReuseIdentifier:[JDMasterReportShopsViewCell identifierForCell]];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JDPieChartViewCell class]) bundle:nil] forCellReuseIdentifier:[JDPieChartViewCell identifierForCell]];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JDMasterReportRankViewCell class]) bundle:nil] forCellReuseIdentifier:[JDMasterReportRankViewCell identifierForCell]];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JDMasterReportWorseRankViewCell class]) bundle:nil] forCellReuseIdentifier:[JDMasterReportWorseRankViewCell identifierForCell]];
}



#pragma mark - UITableViewDataSource UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger rows = (self.masterReportViewModel.dailyDataForShopList ? 2 : 0) + (self.masterReportViewModel.dailyDataForRank ? 2 : 0);
    
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        JDPieChartViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[JDPieChartViewCell identifierForCell]];
        cell.dailyDataForCompany = self.masterReportViewModel.dailyDataForCompany;
        return cell;
    }else if(indexPath.row == 1){
        JDMasterReportShopsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[JDMasterReportShopsViewCell identifierForCell]];
        cell.dataSource = self.masterReportViewModel.dailyDataForShopList;
        cell.selectedDate = self.selectedDate;
        return cell;
    }else if(indexPath.row == 2){
        JDMasterReportRankViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[JDMasterReportRankViewCell identifierForCell]];
        cell.datasource = @[self.masterReportViewModel.dailyDataForRank[0], self.masterReportViewModel.dailyDataForRank[1]];
        return cell;
    }else{
        JDMasterReportWorseRankViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[JDMasterReportWorseRankViewCell identifierForCell]];
        cell.datasource = self.masterReportViewModel.dailyDataForRank[2];
        return cell;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return UITableViewAutomaticDimension;
    }else if(indexPath.row == 1){
        return 200;
    }else if(indexPath.row == 2){
        return 300;
    }else{
        return 300;
    }
}

#pragma mark - UIScrollViewDelegate

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if (scrollView.contentOffset.y < HeaderHeight && scrollView.contentOffset.y >= 0) {
//        self.tableView.contentInset = UIEdgeInsetsMake( - scrollView.contentOffset.y, 0, 0, 0);
//    }else if(scrollView.contentOffset.y >=  HeaderHeight) {
//        self.tableView.contentInset = UIEdgeInsetsMake(- HeaderHeight, 0, 0, 0);
//    }
//}


#pragma mark - getter setter

- (JDMasterReportViewModel *)masterReportViewModel
{
    if (!_masterReportViewModel) {
        _masterReportViewModel = [[JDMasterReportViewModel alloc]init];
    }
    return _masterReportViewModel;
}

- (JDMasterReportHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [JDMasterReportHeaderView headerView];

    }
    return _headerView;
}


- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"yyyy.MM.dd";
    }
    
    return dateFormatter;
}



@end
