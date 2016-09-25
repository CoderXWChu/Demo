//
//  NSObject+DCAutoCoding.m
//
//  Created by DanaChu on 16/8/10.
//  Copyright © 2016年 DanaChu. All rights reserved.
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

#import "NSObject+DCAutoCoding.h"
#import <objc/message.h>

@implementation NSObject (DCAutoCoding)

#pragma mark - Public

- (void)encodeWithCoder:(NSCoder *)aCoder
{}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    if (self) {
    }
    return self;
}


///< 由子类重写
- (NSArray *)dc_ignorePropertyForCoding { return @[]; }
- (NSArray *)dc_AllowPropertyForCoding { return @[]; }


- (void)dc_encode:(NSCoder *)encoder
{
    NSArray *allowedPropertyArr = [self dc_AllowPropertyForCoding];
    NSArray *ignorePropertyArr  = [self dc_ignorePropertyForCoding];

    NSMutableDictionary *pd = [self dc_classCodingPropertyDictionaryForCoding];
    for (NSString *key in pd.allKeys) {
        if (allowedPropertyArr.count && ![allowedPropertyArr containsObject:key]) continue;
        if ([ignorePropertyArr containsObject:key]) continue;
        
        id value = [self valueForKey:key];
        if (!value) value = [NSNull null];
        [encoder encodeObject:value forKey:key];
    }
}

- (void)dc_decode:(NSCoder *)decoder
{
    NSArray *allowedPropertyArr = [self dc_AllowPropertyForCoding];
    NSArray *ignorePropertyArr  = [self dc_ignorePropertyForCoding];
    
    NSMutableDictionary *pd = [self dc_classCodingPropertyDictionaryForCoding];
    for (NSString *key in pd.allKeys) {
        if (allowedPropertyArr.count && ![allowedPropertyArr containsObject:key]) continue;
        if ([ignorePropertyArr containsObject:key]) continue;
        
        id value = [decoder decodeObjectForKey:key];
        if ([value isKindOfClass:[NSNull class]]) value = nil;
        [self setValue:value forKey:key];
    }
}


#pragma mark - private

- (NSMutableDictionary *)dc_classCodingPropertyDictionaryForCoding
{
    NSMutableDictionary *propertyDictionary = objc_getAssociatedObject(self, _cmd);
    if (!propertyDictionary) {
        propertyDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
        Class subClass = [self class];
        while (subClass && subClass != [NSObject class]) {
            [propertyDictionary addEntriesFromDictionary:
             [subClass dc_getClassPropertyInfoWithClassname:NSStringFromClass(subClass)]];
            subClass = [subClass superclass];
        }
        objc_setAssociatedObject(self, _cmd, propertyDictionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return propertyDictionary;
}


+ (NSDictionary *)dc_getClassPropertyInfoWithClassname:(NSString *)classname
{
    unsigned int outCount = 0;
    objc_property_t *propertys = class_copyPropertyList(NSClassFromString(classname), &outCount);
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]initWithCapacity:0];
    for (int i = 0; i < outCount; ++i) {
        objc_property_t p = propertys[i];
        NSString *name = [NSString stringWithCString:property_getName(p) encoding:NSUTF8StringEncoding];
        NSString *type = [self dc_getPropertyAttributeTypeWith:p];
        [tempDict setValue:type forKey:name];
    }
    free(propertys);
    return [tempDict copy];
}

+ (NSString *)dc_getPropertyAttributeTypeWith:(objc_property_t)property
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


@end
