//
//  JDMasterReportShopInfoViewCell.m
//  Demo-thirft
//
//  Created by DanaChu on 16/8/29.
//  Copyright © 2016年 DanaChu. All rights reserved.
//

#import "JDMasterReportShopInfoViewCell.h"


@interface JDMasterReportShopInfoViewCell()
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopSaleInfoLabel;

@end
@implementation JDMasterReportShopInfoViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [JDTheme normalThemeColor];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    backgroundView.backgroundColor = [JDTheme normalThemeColor];
    self.selectedBackgroundView = backgroundView;
}


- (void)setDailyDataForShop:(TTGDailyDataForShop *)dailyDataForShop
{
    self.shopNameLabel.text = dailyDataForShop.name;
    self.shopSaleInfoLabel.attributedText = [self shopSaleInfoAttributeText:dailyDataForShop];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)identifierForCell
{
    return @"JDMasterReportShopInfoViewCellIdentifier";
}


#pragma mark - private

- (NSAttributedString *)shopSaleInfoAttributeText:(TTGDailyDataForShop *)dailyDataForShop
{
    double precent = (dailyDataForShop.currentSales - dailyDataForShop.lastSales)/ dailyDataForShop.lastSales * 100;
    NSMutableString *temp = [[NSString stringWithFormat:@"%.1f元", dailyDataForShop.currentSales] mutableCopy];
    [temp appendFormat:@" 较昨日"];
    [temp appendFormat:@"%@", precent > 0 ? @"上涨" : @"下降"];
    [temp appendFormat:@" %.1f%%", fabs(precent)];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:[temp copy]];
    [string addAttributes:@{NSForegroundColorAttributeName:[JDTheme wordColor]} range:NSMakeRange(0, string.length)];
    if (precent > 0) {
        NSRange rang = [temp rangeOfString:@"日"];
        rang = NSMakeRange(rang.location + 3, temp.length - rang.location - 3);
        [string addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:RGB(10, 255, 10)} range:rang];
    }else{
        NSRange rang = [temp rangeOfString:@"日"];
        rang = NSMakeRange(rang.location + 3, temp.length - rang.location - 3);
        [string addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:RGB(255, 10, 10)} range:rang];
    }
    
    return [string copy];
}



@end
