//
//  JDTakeAwayAlertContentView.m
//  Demo-thirft
//
//  Created by DanaChu on 2016/9/23.
//  Copyright © 2016年 DanaChu. All rights reserved.
//

#import "JDTakeAwayAlertContentView.h"

@interface JDTakeAwayAlertContentView()

@property (weak, nonatomic) IBOutlet UIView *topContentView;
@property (weak, nonatomic) IBOutlet UILabel *topLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *topRightLabel;

@property (weak, nonatomic) IBOutlet UIView *midContentView;
@property (weak, nonatomic) IBOutlet UILabel *takeAwayCount;
@property (weak, nonatomic) IBOutlet UILabel *takeAwaySalesLabel;
@property (weak, nonatomic) IBOutlet UILabel *increaseCustomCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *abandonCountLabel;

@property (weak, nonatomic) IBOutlet UIView *bottomContentView;
@property (weak, nonatomic) IBOutlet UILabel *phoneCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *baiduLabel;
@property (weak, nonatomic) IBOutlet UILabel *elemeLabel;
@property (weak, nonatomic) IBOutlet UILabel *koubeiLabel;
@property (weak, nonatomic) IBOutlet UILabel *meituanLabel;
@property (weak, nonatomic) IBOutlet UILabel *otherLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomContentHeightConstraint;
@end

@implementation JDTakeAwayAlertContentView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5.0;
    
//    self.topContentView.backgroundColor = [JDTheme greenColorForWord];
    self.midContentView.backgroundColor = [UIColor whiteColor];
    self.bottomContentHeightConstraint.constant = 100;
    self.topLeftLabel.text = @"🕓 时间点";
    self.topRightLabel.text = @"天气将在这里展示";
}


+ (instancetype)takeAwayAlertContentView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
}

- (void)setData:(NSArray<TTGTakeAwayInfo *> *)data
{
    /*
     TakeAwayType_TakeAwayTypePhone = 0,
     TakeAwayType_TakeAwayTypeBaidu = 1,
     TakeAwayType_TakeAwayTypeEleme = 2,
     TakeAwayType_TakeAwayTypeKoubei = 3,
     TakeAwayType_TakeAwayTypeMeituan = 4
     
     */
    __block int totalCount = 0;
    __block double totalSales = 0;
    
    [data enumerateObjectsUsingBlock:^(TTGTakeAwayInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        totalCount += obj.countT;
        totalSales += obj.sales;
        
        NSString *count = [NSString stringWithFormat:@"%d 单" , obj.countT];
        
        switch (obj.type) {
            case TakeAwayType_TakeAwayTypePhone:
            {
                self.phoneCountLabel.text = count;
            }
                break;
            case TakeAwayType_TakeAwayTypeBaidu:
            {
                self.baiduLabel.text = count;
            }
                break;
            case TakeAwayType_TakeAwayTypeEleme:
            {
                self.elemeLabel.text = count;
            }
                break;
            case TakeAwayType_TakeAwayTypeKoubei:
            {
                self.koubeiLabel.text = count;
            }
                break;
            case TakeAwayType_TakeAwayTypeMeituan:
            {
                self.meituanLabel.text = count;
            }
                break;
            default:
            {
                self.otherLabel.text = count;
            }
                break;
        }
    }];
    
    self.takeAwayCount.text = [NSString stringWithFormat:@"%d 单", totalCount];
    self.takeAwaySalesLabel.text = [NSString stringWithFormat:@"%0.1f 元", totalSales];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
