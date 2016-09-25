//
//  NSObject+DictToModel.h
//
//  Created by cxw on 13/06/17.
//  Copyright © 2013年 cxw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (DictToModel)

/*!
 *  根据字典转换为模型: 如果字典中的字典需要转换为模型,直接更改模型中对应的属性类型;
 *                   如果字典中的数组内部是模型,需要调用+ containsModelInArray,
                     返回键值对,例如:return @{@"user":@"User"};
 *  @param dict 需要转换的字典
 *  @return 转换后的模型
 */
+ (instancetype)dc_objectWithDictionary:(NSDictionary *)dict;

/*!
 *  根据字典数组转换为模型数组
 *  @param array 需要转换的字典数组
 *  @return 转换后的模型数组
 */
+ (NSMutableArray *)dc_objectWithArray:(NSArray *)array;


/*!
 *  字典转换为模型中,如果字典中的数组内部是模型,需要调用此方法返回键值对,
 *  如:return @{@"user":@"User"}; "user"为属性名,"User"为模型名称.
 *  @return 字典
 */
+ (NSDictionary *)dc_containsModelInArray;

@end
