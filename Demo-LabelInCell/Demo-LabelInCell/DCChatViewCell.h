//
//  DCChatViewCell.h
//  Demo-集成环信
//
//  Created by DanaChu on 14/3/16.
//  Copyright © 2014年 DanaChu. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *DCChatSenderCellID = @"ChatSenderCellID";
@interface DCChatViewCell : UITableViewCell

@property (nonatomic, copy) NSString *message; /**< 消息 */


@end
