//
//  DCClassHandle.m
//
//  Created by xiaoweiChu on 15/2/03.
//  Copyright © 2015年 xiaoweiChu. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "DCClassHandle.h"
#import <objc/runtime.h>
#import "NSObject+Database.h"

@interface DCClassHandle()

@property (nonatomic, strong) NSMutableDictionary *classInfo; ///< 类属性列表集合

@end


@implementation DCClassHandle

static DCClassHandle *_instance;
+ (instancetype)shareInstance
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        _instance = [[[self class] alloc] init];
    });
    return _instance;
}

- (NSDictionary *)getClassPropertyInfoToAbsoluteSqliteTypeWithClassname:(NSString *)classname
{
    NSDictionary *dict = [self getClassPropertyInfoWithClassname:classname];
    return [self dc_convertToAbsoluteSqliteTypeWith:dict];
}

- (NSDictionary *)getClassPropertyInfoWithClassname:(NSString *)classname
{
    return [self dc_getAccuratePropertysWithClass:classname];
}


- (NSDictionary *)dc_getAccuratePropertysWithClass:(NSString *)classname
{
    
    if (self.classInfo[classname]) return self.classInfo[classname];
    
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:
                                     [self dc_getClassPropertyInfoWithClassname:classname]];
    
    id obj = [[NSClassFromString(classname) alloc]init];
    if ([obj respondsToSelector:@selector(dc_ignorePropertys)]) {
        NSArray *ignore = [obj dc_ignorePropertys];
        if (ignore.count > 0) {
            for (NSString *name in ignore) {
                [tempDict removeObjectForKey:name];
            }
        }
    }
    [self.classInfo setObject:[tempDict copy] forKey:classname];
    return [tempDict copy];
}



- (NSDictionary *)dc_getClassPropertyInfoWithClassname:(NSString *)classname
{
    unsigned int outCount = 0;
    objc_property_t *propertys = class_copyPropertyList(NSClassFromString(classname), &outCount);
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]initWithCapacity:0];
    for (int i = 0; i < outCount; ++i) {
        objc_property_t p = propertys[i];
        NSString *name = [NSString stringWithCString:property_getName(p) encoding:NSUTF8StringEncoding];
        NSString *type = [self getPropertyAttributeTypeWith:p];
        type = [self dc_convertAttributeTypeToSqliteTypeWith:type];
        [tempDict setValue:type forKey:name];
    }
    free(propertys);
    return [tempDict copy];
}


- (NSString *)getPropertyAttributeTypeWith:(objc_property_t)property
{
    NSString *type = [NSString stringWithCString:property_getAttributes(property)
                                        encoding:NSUTF8StringEncoding];
    NSString *tempString = [type componentsSeparatedByString:@","].firstObject;
    if ([type containsString:@"@"]) {
        type = [tempString substringWithRange:NSMakeRange(3, tempString.length - 4)];
        return type;
    }
    
    tempString = [tempString substringWithRange:NSMakeRange(1, 1)];
    NSDictionary *dict = @{@"f":@"float",
                           @"i":@"int",
                           @"d":@"double",
                           @"l":@"long",
                           @"q":@"long",
                           @"c":@"BOOL",
                           @"B":@"BOOL",
                           @"s":@"short",
                           @"I":@"NSInteger",
                           @"Q":@"NSUInteger",
                           @"#":@"Class"};
    
    type = dict[tempString];
    return type;
}

- (NSString *)dc_convertAttributeTypeToSqliteTypeWith:(NSString *)attributeType
{
    NSString *type = attributeType;
    if ([type isEqualToString:NSStringFromClass(NSArray.class)]) {
        type = @"ARRAY";
    }else if ([type isEqualToString:NSStringFromClass(NSDictionary.class)]){
        type = @"DICTIONARY";
    }else if ([type isEqualToString:NSStringFromClass(NSString.class)]){
        type = @"TEXT";
    }else if ([type isEqualToString:NSStringFromClass(NSData.class)]){
        type = @"BLOB";
    }else if ([type isEqualToString:@"BOOL"] ||
              [type isEqualToString:@"CGFloat"] ||
              [type isEqualToString:@"double"]){
        type = @"REAL";
    }else if ([type isEqualToString:@"int"] ||
              [type isEqualToString:@"NSInteger"] ||
              [type isEqualToString:@"NSUInteger"] ||
              [type isEqualToString:@"long"]){
        type = @"INTEGER";
    }
    return type;
}

- (NSDictionary *)dc_convertToAbsoluteSqliteTypeWith:(NSDictionary *)attributeInfo
{
    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]initWithDictionary:attributeInfo];
    for (NSString *key in mutableDict.allKeys) {
        NSString *type = mutableDict[key];
        if ([type isEqualToString:@"DICTIONARY"] ||
            [type isEqualToString:@"ARRAY"]) {
            [mutableDict setValue:@"TEXT" forKey:key];
        }
    }
    return [mutableDict copy];
}



#pragma mark - getter setter

- (NSMutableDictionary *)classInfo
{
    if(!_classInfo)
    {
        _classInfo = [[NSMutableDictionary alloc]initWithCapacity:0];
    }
    return _classInfo;
}


@end
