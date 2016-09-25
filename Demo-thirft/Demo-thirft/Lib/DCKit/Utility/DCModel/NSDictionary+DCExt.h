//
//  NSDictionary+DCExt.h
//
//  Created by cxw on 13/06/17.
//  Copyright © 2013年 cxw. All rights reserved.
//

/*!
 *  用于字典转模型时,格式化输出属性
 */
#import <Foundation/Foundation.h>

@interface NSDictionary (DCExt)

/*!
 *  根据字典的key值自动创建属性,并打印输出
 */
- (void)dc_creatPropertys;

@end
