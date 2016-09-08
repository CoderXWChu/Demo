//
//  FLRightChatTVCell.h
//  funlive
//
//  Created by rckj on 14/9/6.
//  Copyright © 2014年 renzhen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FLRightChatTVCell : UITableViewCell

@property (nonatomic, strong) NSString *msgContent;

+(instancetype)cellWithTableView:(UITableView*)tableView;
@end
