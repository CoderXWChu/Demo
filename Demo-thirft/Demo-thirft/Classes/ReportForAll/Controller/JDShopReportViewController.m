//
//  JDShopReportViewController.m
//  Demo-thirft
//
//  Created by DanaChu on 16/9/5.
//  Copyright © 2016年 DanaChu. All rights reserved.
//

#import "JDShopReportViewController.h"
#import "JDShopReportViewModel.h"
#import "JDShopReportPayViewCell.h"
#import "JDShopReportGraphViewCell.h"
#import "JDShopReportTakeAwayViewCell.h"
#import "JDShopReportForRankViewController.h"

#import "DXPopover.h"

@interface JDShopReportViewController ()

@property (nonatomic, strong) JDShopReportViewModel *viewModel;


@end

@implementation JDShopReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    [self initialBinding];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self pullDownRefreshAction];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    NSLogDealloc;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [self.tableView reloadData];
}


- (void)setupUI
{
    self.navigationController.navigationBar.tintColor = [JDTheme backgroundColor];
    self.navigationController.navigationBar.barTintColor = [JDTheme greenColorForWord];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage dc_imageWithOriginalMode:@"more_menu_icon"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(moreButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItems = @[item];
    
    self.navigationItem.title = _shopName;
    self.isHasRefreshHeader = YES;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [JDTheme backgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
    lab.text = [NSString stringWithFormat:@"  🕓 %@", self.selectedDate];
    lab.textColor = [JDTheme lightGrayForWord];
    lab.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = lab;
    
    [self.tableView registerClass:[JDShopReportGraphViewCell class] forCellReuseIdentifier:[JDShopReportGraphViewCell cellIdentifier]];
    [self.tableView registerClass:[JDShopReportTakeAwayViewCell class] forCellReuseIdentifier:[JDShopReportTakeAwayViewCell cellIdentifier]];
}

- (void)initialBinding
{
    @weakify(self);
    [[RACObserve(self.viewModel, dailyReportForShop) filter:^BOOL(id value) {
        return value ? YES : NO;
    }]
     subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
        [self headerEndRefresh];
        [DCHUD dc_hidePresentedHUD];
    }];
    
    [[RACObserve(self.viewModel, index) filter:^BOOL(id value) {
        return value ? YES : NO;
    }]
     subscribeNext:^(NSNumber *x) {
         @strongify(self);

         switch (x.unsignedIntegerValue) {
             case 0:
             {
                 JDShopReportForRankViewController *VCForRank = [JDShopReportForRankViewController new];
                 VCForRank.shopId = self.shopId;
                 VCForRank.shopName = self.shopName;
                 VCForRank.date = self.selectedDate;
                 [self.navigationController pushViewController:VCForRank animated:YES];
                 
             }
                 break;
                 
             default:
                 break;
         }
     }];
}


#pragma mark - Action

- (void)pullDownRefreshAction
{
    [DCHUD dc_showIndeterminateHUDWithTitle:@""];
    [self.viewModel getDailyDataForShopWithDate:self.selectedDate sid:self.shopId];
}

- (void)moreButtonClicked:(UIButton *)button
{
    [button dc_PopUpAnimation];
    [self.viewModel.popover showAtView:button withContentView:self.viewModel.popTableView];
}


#pragma mark - UITableViewDelegate UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 1;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section >=0 && indexPath.section <= 2) {
        UITableViewCell *cell;
        cell = [tableView dequeueReusableCellWithIdentifier:[JDShopReportPayViewCell cellIdentifier]];
        if (!cell) {
            cell = [[JDShopReportPayViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[JDShopReportPayViewCell cellIdentifier]];
        }
        switch (indexPath.section) {
            case 0:
                cell.textLabel.text = @"银联支付";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%.0f 元", self.viewModel.dailyReportForShop.unionPay];
                break;
            case 1:
                cell.textLabel.text = @"移动支付";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%.0f 元", self.viewModel.dailyReportForShop.mobilePay];
                break;
            case 2:
                cell.textLabel.text = @"其他支付";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%.0f 元", self.viewModel.dailyReportForShop.otherPay];
                break;
                
            default:
                break;
        }
        return cell;
    }else if (indexPath.section == 3)
    {
        JDShopReportGraphViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[JDShopReportGraphViewCell cellIdentifier]];
        cell.chartDatasForDay = self.viewModel.dailyReportForShop.saleInDayTime;
        cell.chartDatasForWeek = self.viewModel.dailyReportForShop.saleInWeekTime;
        return cell;
    }else if (indexPath.section == 4)
    {
        JDShopReportTakeAwayViewCell*cell = [tableView dequeueReusableCellWithIdentifier:[JDShopReportTakeAwayViewCell cellIdentifier]];
        cell.takeAwayInfoList = self.viewModel.dailyReportForShop.takeAwayInfoList;
        cell.takeAwayInfoListInDayTime = self.viewModel.dailyReportForShop.takeAwayInfoListInDayTime;
        cell.takeAwayInfoListInWeekTime = self.viewModel.dailyReportForShop.takeAwayInfoListInWeekTime;
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 3){
        return 320;
    }else if(indexPath.section == 4){
        return UITableViewAutomaticDimension;
    }else{
        return 44;
    }
}



#pragma mark - getter setter

- (JDShopReportViewModel *)viewModel
{
    if (!_viewModel)
    {
        _viewModel = [[JDShopReportViewModel alloc] init];
    }
    return _viewModel;
}


@end
