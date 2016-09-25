//
//  JDMasterReportShopsViewCell.m
//  Demo-thirft
//
//  Created by DanaChu on 16/8/29.
//  Copyright © 2016年 DanaChu. All rights reserved.
//

#import "JDMasterReportShopsViewCell.h"
#import "JDMasterReportShopInfoViewCell.h"
#import "JDShopReportViewController.h"

@interface JDMasterReportShopsViewCell()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation JDMasterReportShopsViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor =  [JDTheme backgroundColor];
    self.label.backgroundColor = [JDTheme backgroundColor];
    
    NSMutableString *temp = [@" 商铺列表 (Tip: 点击商铺可以查看更多信息哦)" mutableCopy];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:[temp copy]];
    NSRange rang = [temp rangeOfString:@"("];
    rang = NSMakeRange(rang.location, string.length - rang.location);
    [string addAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, string.length)];
    [string addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[JDTheme tipColor]} range:rang];
    self.label.attributedText = string;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 52;
    self.tableView.backgroundColor = [JDTheme normalThemeColor];
    self.tableView.separatorColor = [JDTheme backgroundColor];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JDMasterReportShopInfoViewCell class]) bundle:nil] forCellReuseIdentifier:[JDMasterReportShopInfoViewCell identifierForCell]];
}

- (void)setFrame:(CGRect)frame
{
    frame.size.height -= 10;
    [super setFrame:frame];
}

- (void)setDataSource:(NSArray *)dataSource
{
    _dataSource = dataSource;
    [self.tableView reloadData];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JDMasterReportShopInfoViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[JDMasterReportShopInfoViewCell identifierForCell]];
    TTGDailyDataForShop *dailyDataForShop = self.dataSource[indexPath.row];
    cell.dailyDataForShop = dailyDataForShop;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TTGDailyDataForShop *dailyDataForShop = self.dataSource[indexPath.row];
    JDShopReportViewController *VC = [JDShopReportViewController new];
    VC.shopId = (NSUInteger)dailyDataForShop.sid;
    VC.selectedDate = self.selectedDate;
    VC.shopName = dailyDataForShop.name;
    UIWindow *windown =  [UIApplication sharedApplication].keyWindow;
    
    if ([windown.rootViewController isKindOfClass:[UINavigationController class]]) {
        [((UINavigationController *)windown.rootViewController) pushViewController:VC animated:YES];
    }
}



+ (NSString *)identifierForCell
{
    return @"JDMasterReportShopsViewCellIdentifier";
}

@end
