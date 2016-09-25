//
//  JDMasterReportWorseRankViewCell.m
//  Demo-thirft
//
//  Created by DanaChu on 16/8/30.
//  Copyright © 2016年 DanaChu. All rights reserved.
//

#import "JDMasterReportWorseRankViewCell.h"

@interface JDMasterReportWorseRankViewCell()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation JDMasterReportWorseRankViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.label.text = @"  销售最差菜品:";
    self.label.backgroundColor = [JDTheme backgroundColor];
    
    self.contentView.backgroundColor = [JDTheme backgroundColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor clearColor];
}

- (void)setFrame:(CGRect)frame
{
    //frame.size.height -= 10;
    [super setFrame:frame];
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
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[JDMasterReportWorseRankViewCell identifierForSubCell]];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[JDMasterReportWorseRankViewCell identifierForSubCell]];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [JDTheme normalThemeColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailTextLabel.textColor = [JDTheme wordColor];
        cell.textLabel.textColor = [JDTheme wordColor];
    }
    
    TTGDailyRankForDish *dish = self.datasource[indexPath.row];
    cell.textLabel.text = dish.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d 份", dish.count_D];
    
    return cell;
}



#pragma mark - Private

+ (NSString *)identifierForCell
{
    return @"JDMasterReportWorseRankViewCellIdentifier";
}

+ (NSString *)identifierForSubCell
{
    return @"JDMasterReportWorseRankViewSubCellIdentifier";
}

@end
