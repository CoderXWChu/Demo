//
//  JDChartPieViewCell.m
//  Demo-thirft
//
//  Created by DanaChu on 16/8/29.
//  Copyright © 2016年 DanaChu. All rights reserved.
//

#import "JDPieChartViewCell.h"
#import "PNChartDelegate.h"
#import "JDPieChart.h"

#define PieChartWidthProprotion 0.6

typedef NS_ENUM(NSUInteger, JDSaleType) {
    SaleTypeRegular  = 0, // 正餐
    SaleTypeFastFood = 1, // 快餐
    SaleTypeTakeAway = 2, // 外卖
    SaleTypeStore    = 3  // 存储
};

@interface JDPieChartViewCell()
@property (weak, nonatomic) IBOutlet JDPieChart *pieChart; // 饼图
@property (nonatomic, strong) UIView *legendView; // 左上角描述
@property (weak, nonatomic) IBOutlet UIView *chartContentView;
@property (weak, nonatomic) IBOutlet UIView *bottomContentView;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;

@end

@implementation JDPieChartViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [JDTheme normalThemeColor];
    self.chartContentView.backgroundColor = [JDTheme normalThemeColor];
    self.bottomContentView.backgroundColor = [JDTheme normalThemeColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setFrame:(CGRect)frame
{
    frame.size.height -= 10;
    [super setFrame:frame];
}

- (void)setDailyDataForCompany:(TTGDailyDataForCompany *)dailyDataForCompany
{
    _dailyDataForCompany = dailyDataForCompany;
    
    // label
    self.bottomLabel.attributedText = [self shopSaleInfoAttributeText:dailyDataForCompany];
    
    // pie chart
    NSArray *dailyDataForSale= dailyDataForCompany.dailyTotalDataForCompany;
    if (!(dailyDataForSale.count > 0)) return;
    
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:0];
    for (TTGDailyDataForSale *sale in dailyDataForSale) {
        
        NSString *description  = [NSString stringWithFormat:@"%@ %.0f 元  人均%0.f 元",[self saleTypeNameWithType:sale.type], sale.sales, sale.sales/sale.countD];
        
        PNPieChartDataItem * item = [PNPieChartDataItem
                                     dataItemWithValue:sale.sales
                                     color:RandomColor
                                     description:description];
        
        [items addObject:item];
    }
    
    self.pieChart.descriptionTextColor = [UIColor whiteColor];
    self.pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:11.0];
    self.pieChart.descriptionTextShadowColor = [UIColor clearColor];
    self.pieChart.showAbsoluteValues = NO;
    self.pieChart.showOnlyValues = YES;
    [self.pieChart updateChartData:items];
    [self.pieChart strokeChart];
    
    self.pieChart.legendStyle = PNLegendItemStyleStacked;
    self.pieChart.legendFont = [UIFont boldSystemFontOfSize:12.0f];
    
    if (self.legendView)
    {
        [self.legendView removeFromSuperview];
        self.legendView = nil;
    }
    UIView *legend = [self.pieChart getLegendWithMaxWidth:200];
    CGFloat margin = SCREEN_WIDTH * (1 - PieChartWidthProprotion) * 0.5 - 10;
    [legend setFrame:CGRectMake(-margin, -60, legend.frame.size.width, legend.frame.size.height)];
    _legendView = legend;
    [self.pieChart addSubview:legend];
}

- (void)layoutSubviews{
    
    [super layoutSubviews];

    [self setDailyDataForCompany:_dailyDataForCompany];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)identifierForCell
{
    return @"JDPieChartViewCellIdentifier";
}




- (NSString *)saleTypeNameWithType:(JDSaleType)type
{
    switch (type) {
        case SaleTypeRegular:
            return @"正餐";
            break;
        case SaleTypeFastFood:
            return @"快餐";
            break;
        case SaleTypeTakeAway:
            return @"外卖";
            break;
        case SaleTypeStore:
            return @"储值";
            break;
    }
}

- (NSAttributedString *)shopSaleInfoAttributeText:(TTGDailyDataForCompany *)dailyDataForCompany
{
    double precent = (dailyDataForCompany.currentTotalSales - dailyDataForCompany.lastTotalSales)/ dailyDataForCompany.lastTotalSales * 100;
    NSMutableString *temp = [@"" mutableCopy];
    [temp appendFormat:@"较昨日"];
    [temp appendFormat:@"%@", precent > 0 ? @"上涨" : @"下降"];
    [temp appendFormat:@" %.1f%%", fabs(precent)];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:[temp copy]];
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
