//
//  NSObject+DictToModel.m
//
//  Created by cxw on 13/06/17.
//  Copyright © 2013年 cxw. All rights reserved.
//

#import "NSObject+DictToModel.h"
#import <objc/runtime.h>

@implementation NSObject (DictToModel)

+ (NSMutableArray *)dc_objectWithArray:(NSArray *)array
{
    NSMutableArray *modelArray = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id model = [self dc_objectWithDictionary:obj];
        [modelArray addObject:model];
    }];
    return modelArray;
}


+ (instancetype)dc_objectWithDictionary:(NSDictionary *)dict
{
    id model = [[self alloc]init];
    
    // 第一层: (Ivar:成员属性)
    // 思路:获取模型中的成员属性列表,遍历属性列表,属性名作为关键字去字典中取值,将取出的值赋给该属性
    unsigned int count = 0;
    Ivar *ivarList = class_copyIvarList([self class], &count);
    
    for (int i = 0; i < count; ++i) {
        Ivar ivar = ivarList[i];
        NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
        key = [key substringFromIndex:1];
        id value = dict[key];
        
        // 第二层:
        // 思路:判断key对应的value是否为NSDictionary,如果是字典,并且模型中对应属性的类型是用户自定义的模型类,递归调用 objectWithDictionary:
        // 转化后的classOfKey格式是: @"@\"NSString\""  需要处理
        NSString *classOfKey = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        classOfKey = [classOfKey stringByReplacingOccurrencesOfString:@"@" withString:@""];
        classOfKey = [classOfKey stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
        if([value isKindOfClass:[NSDictionary class]] && ![classOfKey hasPrefix:@"NS"]) {

            value = [NSClassFromString(classOfKey) dc_objectWithDictionary:value];
        }
        
        // 第三层:
        // 思路:判断key对应的value是否为NSArray,如果是数组,并且实现了: + containsModelInArray,遍历数组,递归调用 objectWithDictionary:
        if ([value isKindOfClass:[NSArray class]] && [self respondsToSelector:@selector(dc_containsModelInArray)]) {
            NSDictionary *tmpDict = [self dc_containsModelInArray];
            NSMutableArray *tmpArray = [NSMutableArray array];
            [value enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                id modelInArray = [NSClassFromString(tmpDict[key]) dc_objectWithDictionary:obj];
                [tmpArray addObject:modelInArray];
            }];
            value = tmpArray;
        }
        
        if (model) {
            [model setValue:value forKey:key];
        }
    }
    return model;
}


+ (NSDictionary *)dc_containsModelInArray{
    return nil;
}

@end
