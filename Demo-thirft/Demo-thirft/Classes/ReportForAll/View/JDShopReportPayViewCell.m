//
//  JDShopReportPayViewCell.m
//  Demo-thirft
//
//  Created by DanaChu on 16/9/9.
//  Copyright © 2016年 DanaChu. All rights reserved.
//

#import "JDShopReportPayViewCell.h"

@interface JDShopReportPayViewCell()

//@property (nonatomic, strong) UIImageView *imageV; ///<
@property (strong, nonatomic) CALayer *borderLayer;
@end

@implementation JDShopReportPayViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews
{
    self.borderLayer = [CALayer layer];
    self.borderLayer.backgroundColor = [JDTheme selectedThemeColor].CGColor;
    [self.contentView.layer addSublayer:self.borderLayer];
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.detailTextLabel.textColor = [JDTheme greenColorForWord];
    self.textLabel.textColor = [JDTheme greenColorForWord];
    
//    _imageV = [UIImageView new];
//    _imageV.image = [UIImage imageNamed:@"error.png"];
//    self.accessoryView = _imageV;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat borderWidth = CGRectGetWidth(self.frame);
    CGFloat borderHeight = 1.0f;
    CGFloat borderX = 0.0f;
    CGFloat borderY = CGRectGetHeight(self.frame) - borderHeight;
    
    [CATransaction begin];
    [CATransaction setValue:@(YES) forKey:kCATransactionDisableActions];
    self.borderLayer.frame = CGRectMake(borderX, borderY, borderWidth, borderHeight);
    [CATransaction commit];
}

+ (NSString *)cellIdentifier
{
    return @"JDShopReportPayViewCellIdentifier";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
