//
//  JDShopReportForRankViewController.m
//  Demo-thirft
//
//  Created by DanaChu on 2016/9/22.
//  Copyright © 2016年 DanaChu. All rights reserved.
//

#import "JDShopReportForRankViewController.h"
#import "JDShopReportForRankViewModel.h"

#import "JDMasterReportRankViewCell.h"
#import "JDMasterReportWorseRankViewCell.h"

@interface JDShopReportForRankViewController ()

@property (nonatomic, strong) JDShopReportForRankViewModel *viewModel; ///< <#注释#>

@end

@implementation JDShopReportForRankViewController

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

- (void)setupUI
{
    self.isHasRefreshHeader = YES;
    self.navigationItem.title = @"销售排行";
    self.tableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [JDTheme backgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
    lab.text = [NSString stringWithFormat:@"  🕓 %@", self.date];
    lab.textColor = [JDTheme lightGrayForWord];
    lab.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = lab;
    
    
    [self registerCell];
}

- (void)registerCell
{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JDMasterReportRankViewCell class]) bundle:nil] forCellReuseIdentifier:[JDMasterReportRankViewCell identifierForCell]];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JDMasterReportWorseRankViewCell class]) bundle:nil] forCellReuseIdentifier:[JDMasterReportWorseRankViewCell identifierForCell]];
}

- (void)initialBinding
{
    @weakify(self);
    [[RACObserve(self.viewModel, dailyDataForRank) filter:^BOOL(id value) {
        return value ? YES : NO;
    }]
     subscribeNext:^(id x) {
         @strongify(self);
         [self.tableView reloadData];
         [self headerEndRefresh];
         [DCHUD dc_hidePresentedHUD];
     }];
}


#pragma mark - Action

- (void)pullDownRefreshAction
{
    [DCHUD dc_showIndeterminateHUDWithTitle:@""];
    [self.viewModel getDailyDataForRankWithDate:_date
                                            sid:[NSString stringWithFormat:@"%ld", _shopId]
                                            num:30];
}

#pragma mark - UITableViewDataSource UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.dailyDataForRank ? 2 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        JDMasterReportRankViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[JDMasterReportRankViewCell identifierForCell]];
        cell.datasource = @[self.viewModel.dailyDataForRank[0], self.viewModel.dailyDataForRank[1]];
        return cell;
    }else{
        JDMasterReportWorseRankViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[JDMasterReportWorseRankViewCell identifierForCell]];
        cell.datasource = self.viewModel.dailyDataForRank[2];
        return cell;
    }
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     return 300;
}


#pragma mark - getter

- (JDShopReportForRankViewModel *)viewModel
{
    if (!_viewModel)
    {
        _viewModel = [[JDShopReportForRankViewModel alloc] init];
    }
    return _viewModel;
}




@end
