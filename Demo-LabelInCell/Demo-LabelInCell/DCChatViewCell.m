//
//  DCChatViewCell.m
//  Demo-集成环信
//
//  Created by DanaChu on 14/3/16.
//  Copyright © 2014年 DanaChu. All rights reserved.
//

#import "DCChatViewCell.h"

@interface DCChatViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *iconbutton;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@end

@implementation DCChatViewCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}




- (void)setMessage:(NSString *)message
{
    _message = message;

    self.messageLabel.text = message;
}


@end
