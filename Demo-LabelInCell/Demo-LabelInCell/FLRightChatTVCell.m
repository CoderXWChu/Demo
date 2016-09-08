//
//  FLRightChatTVCell.m
//  funlive
//
//  Created by rckj on 14/9/6.
//  Copyright © 2014年 renzhen. All rights reserved.
//

#import "FLRightChatTVCell.h"
#import "Masonry.h"

@interface FLRightChatTVCell()
{
    
}
@property (nonatomic, strong) UIImageView*  mCellBgIV;
@property (nonatomic, strong) UILabel*      mTextLB;
@end


@implementation FLRightChatTVCell

-(void)setMsgContent:(NSString *)msgContent
{
    _msgContent = msgContent;
    self.mTextLB.text = _msgContent;
}

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    id cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (cell == nil)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
    }
    return cell;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor redColor];
    
    [self selfAddSubView];          // 添加子视图
    [self selfAddSubViewFrame];     // 添加子视图约束
}

-(void)selfAddSubView
{
    self.mCellBgIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"r_ios_message_buddle_right"]];
    self.mCellBgIV.backgroundColor = [UIColor blueColor];
    [self addSubview:self.mCellBgIV];

    self.mTextLB = [UILabel new];
    self.mTextLB.backgroundColor = [UIColor purpleColor];
    self.mTextLB.numberOfLines = 0;
    [self addSubview:self.mTextLB];
}

-(void)selfAddSubViewFrame
{
    [self.mCellBgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-16.f);
        make.top.equalTo(self).offset(8.f);
        make.left.greaterThanOrEqualTo(self).offset(16.f);
        make.bottom.equalTo(self).offset(-8.f);
    }];
    [self.mCellBgIV setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.mTextLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.mCellBgIV).insets(UIEdgeInsetsMake(11.f, 11.f, 11.f, 11.f));
    }];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
