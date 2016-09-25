//
//  JDShopReportTakeAwayViewCell.m
//  Demo-thirft
//
//  Created by DanaChu on 16/9/12.
//  Copyright © 2016年 DanaChu. All rights reserved.
//

#import "JDShopReportTakeAwayViewCell.h"
#import "JDTakeAwayReportView.h"

@interface JDShopReportTakeAwayViewCell()
@property (nonatomic, weak) UIView *topContentView; ///< <#注释#>
@property (nonatomic, weak) UIView *bottomContentView; ///< <#注释#>
@property (nonatomic, weak) UILabel *leftLabel; ///< <#注释#>
@property (nonatomic, weak) UILabel *rightLabel; ///< <#注释#>
@property (nonatomic, weak) JDTakeAwayReportView *reportView; ///< <#注释#>
@end

@implementation JDShopReportTakeAwayViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        [self addSubviews];
        [self initalBinding];
    }
    return self;
}

- (void)setupUI
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
}

- (void)addSubviews
{
    UIView *topContentView = [UIView new];
    [self.contentView addSubview:topContentView];
    self.topContentView = topContentView;
    self.topContentView.backgroundColor = [UIColor clearColor];
    
    UILabel *leftLabel = [UILabel new];
    leftLabel.text = @"外卖总量:";
    leftLabel.textColor = [JDTheme lightGrayForWord];
    leftLabel.textAlignment = NSTextAlignmentLeft;
    [topContentView addSubview:leftLabel];
    self.leftLabel = leftLabel;
    self.leftLabel.backgroundColor = [UIColor clearColor];

    UILabel *rightLabel = [UILabel new];
    rightLabel.text = @"单";
    rightLabel.textColor = [JDTheme lightGrayForWord];
    rightLabel.textAlignment = NSTextAlignmentRight;
    [topContentView addSubview:rightLabel];
    self.rightLabel = rightLabel;
    self.rightLabel.backgroundColor = [UIColor clearColor];

    
    UIView *bottomContentView = [UIView new];
    [self.contentView addSubview:bottomContentView];
    self.bottomContentView = bottomContentView;
    self.bottomContentView.backgroundColor = [UIColor clearColor];
    
    JDTakeAwayReportView *reportView = [JDTakeAwayReportView new];
    [self.bottomContentView addSubview:reportView];
    self.reportView = reportView;
    
    [self addConstraints];
}

- (void)addConstraints
{
    [self.topContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.top.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.offset(44.f);
    }];
    
    
    [self.bottomContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.bottom.offset(0);
        make.right.offset(0);
        make.top.equalTo(self.topContentView.mas_bottom).offset(0);
    }];
    
    
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(15);
        make.bottom.offset(0);
        make.width.offset(150);
    }];
    
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topContentView);
        make.right.equalTo(self.topContentView).offset(-15);
        make.bottom.equalTo(self.topContentView);
        make.width.offset(150);
    }];
    
    
    [self.reportView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bottomContentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
}

- (void)initalBinding
{
    @weakify(self)
    [[[RACSignal combineLatest:@[RACObserve(self, takeAwayInfoList), RACObserve(self, takeAwayInfoListInDayTime), RACObserve(self, takeAwayInfoListInWeekTime)] reduce:^id(NSArray *x, NSArray *y, NSArray *z){
        return @((x!=nil)&&(y!=nil)&&(z!=nil));
    }] skip:2] subscribeNext:^(id x){
        @strongify(self)
        self.reportView.takeAwayInfoList = self.takeAwayInfoList;
        self.reportView.takeAwayInfoListInDayTime = self.takeAwayInfoListInDayTime;
        self.reportView.takeAwayInfoListInWeekTime = self.takeAwayInfoListInWeekTime;
        
        // 设置外卖总数量
        int total = 0;
        for (TTGTakeAwayInfo *info in self.takeAwayInfoList) {
            total += info.countT;
        }
        self.rightLabel.text = [NSString stringWithFormat:@"%d 单", total];
    }];
    
    
}





+ (NSString *)cellIdentifier
{
    return @"JDShopReportTakeAwayViewCellIdentifier";
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
