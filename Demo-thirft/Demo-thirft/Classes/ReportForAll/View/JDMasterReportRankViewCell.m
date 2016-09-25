//
//  JDMasterReportRankViewCell.m
//  Demo-thirft
//
//  Created by DanaChu on 16/8/30.
//  Copyright © 2016年 DanaChu. All rights reserved.
//

#import "JDMasterReportRankViewCell.h"
#import "JDSelectView.h"

typedef NS_ENUM(NSUInteger, JDSaleType) {
    SaleTypeRegular  = 0, // 正餐
    SaleTypeFastFood = 1, // 快餐
    SaleTypeTakeAway = 2, // 外卖
    SaleTypeStore    = 3  // 存储
};

@interface JDMasterReportRankViewCell()<UITableViewDelegate, UITableViewDataSource, JDSelectViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *selectContentView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSUInteger selecedIndex;

@end

@implementation JDMasterReportRankViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = [JDTheme normalThemeColor];
    self.tableView.backgroundColor = [JDTheme normalThemeColor];
    self.tableView.separatorColor = [JDTheme backgroundColor];
//    self.tableView.remembersLastFocusedIndexPath = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    JDSelectView *selectV = [JDSelectView selectViewWithItems:@[@"销量排行",@"售价排行"] delegate:self];
    selectV.backgroundColor = [JDTheme backgroundColor];
    selectV.itemSelectedColor = [JDTheme normalThemeColor];
    selectV.indicatorColor = [JDTheme normalThemeColor];
    [selectV tapViewWithIndex:0];
    [self.selectContentView addSubview:selectV];

}

- (void)setFrame:(CGRect)frame
{
    frame.size.height -= 10;
    [super setFrame:frame];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (UIView *view in self.selectContentView.subviews) {
        if ([view isKindOfClass:[JDSelectView class]]) {
            view.frame = self.selectContentView.bounds;
        }
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setDatasource:(NSArray *)datasource
{
    _datasource = datasource;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.datasource.count > 0) {
        return self.datasource[self.selecedIndex].count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[JDMasterReportRankViewCell identifierForSubCell]];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[JDMasterReportRankViewCell identifierForSubCell]];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [JDTheme normalThemeColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailTextLabel.textColor = [JDTheme wordColor];
        cell.textLabel.textColor = [JDTheme wordColor];
    }
    
    if (_selecedIndex == 0) {
        TTGDailyRankForDish *dish = self.datasource[self.selecedIndex][indexPath.row];
        cell.textLabel.text = dish.name;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d 份", dish.count_D];
    }else{
        TTGDailyRankForPrice *dish = self.datasource[self.selecedIndex][indexPath.row];
        cell.textLabel.text = dish.name;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.1f 元", dish.totalPrice];
    }
    
    return cell;
}


#pragma mark - JDSelectViewDelegate

- (void)selectView:(JDSelectView *)view didSelectedWithIndex:(NSUInteger)index
{
    _selecedIndex = (_selecedIndex == index) ? _selecedIndex : index;
    [self.tableView reloadData];
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
}

#pragma mark - Private

+ (NSString *)identifierForCell
{
    return @"JDMasterReportRankViewCellIdentifer";
}

+ (NSString *)identifierForSubCell
{
    return @"JDMasterReportRankViewSubCellIdentifer";
}


@end
