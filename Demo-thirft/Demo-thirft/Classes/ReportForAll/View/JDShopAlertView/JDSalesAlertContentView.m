//
//  JDSalesAlertContentView.m
//  Demo-thirft
//
//  Created by DanaChu on 2016/9/23.
//  Copyright © 2016年 DanaChu. All rights reserved.
//

#import "JDSalesAlertContentView.h"

@interface JDSalesAlertContentView()

@property (weak, nonatomic) IBOutlet UIView *topContentView;
@property (weak, nonatomic) IBOutlet UILabel *topLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *topRightLabel;

@property (weak, nonatomic) IBOutlet UIView *midContentView;
@property (weak, nonatomic) IBOutlet UILabel *RegularLabel;
@property (weak, nonatomic) IBOutlet UILabel *eachRegLabel;
@property (weak, nonatomic) IBOutlet UILabel *fastFoodLabel;
@property (weak, nonatomic) IBOutlet UILabel *eachPepLabel;
@property (weak, nonatomic) IBOutlet UILabel *takeAwayLabel;
@property (weak, nonatomic) IBOutlet UILabel *eachLabel;
@property (weak, nonatomic) IBOutlet UILabel *storeLabel;
@property (weak, nonatomic) IBOutlet UILabel *otherLabel;

@property (weak, nonatomic) IBOutlet UIView *bottomContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomContentHeightConstraint;

@end

@implementation JDSalesAlertContentView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5.0;
    
    self.topContentView.backgroundColor = [JDTheme greenColorForWord];
    self.midContentView.backgroundColor = [UIColor whiteColor];
    self.bottomContentHeightConstraint.constant = 0;
    self.height -= 44;
    self.topLeftLabel.text = @"🕓 时间点";
    self.topRightLabel.text = @"天气将在这里展示";
}

+ (instancetype)salesAlertContentView
{
   return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
}


- (void)setData:(NSArray<TTGDailyDataForSale *> *)data
{
    /*
     
     SaleType_SaleTypeRegular = 0,
     SaleType_SaleTypeFastFood = 1,
     SaleType_SaleTypeTakeAway = 2,
     SaleType_SaleTypeStore = 3
     
     */
    [data enumerateObjectsUsingBlock:^(TTGDailyDataForSale * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *totalSales = [NSString stringWithFormat:@"%0.1f 元" , obj.sales];
        NSString *eachSales = [NSString stringWithFormat:@"%0.1f 元" , (obj.sales == 0) ? 0.0 : obj.sales / obj.countD];
        
        switch (obj.type) {
            case SaleType_SaleTypeRegular:
            {
                self.RegularLabel.text = totalSales;
                self.eachRegLabel.text = eachSales;
            }
                break;
            case SaleType_SaleTypeFastFood:
            {
                self.fastFoodLabel.text = totalSales;
                self.eachPepLabel.text = eachSales;
            }
                break;
            case SaleType_SaleTypeTakeAway:
            {
                self.takeAwayLabel.text = totalSales;
                self.eachLabel.text = eachSales;
            }
                break;
            case SaleType_SaleTypeStore:
            {
                self.storeLabel.text = totalSales;
            }
                break;
            default:
            {
                self.otherLabel.text = totalSales;
            }
                break;
        }
    }];
    
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
