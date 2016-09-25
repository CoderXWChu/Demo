//
//  DCRegExHelper.m
//
//  Created by CoderXWChu on 14/3/13.
//  Copyright © 2014年 CoderXWChu. All rights reserved.
//

#import "DCRegExHelper.h"

@implementation DCRegExHelper

+ (BOOL)dc_isValidWithTelPhone:(NSString *)phonenum
{
    NSString *telPhoneRegEx = @"^(\\d{3,4}-)\\d{7,8}$";
    return [self isValidWithCharacters:phonenum regExString:telPhoneRegEx];
}

+ (BOOL)dc_isValidWithMobilePhone:(NSString *)phonenum
{
    NSString *mobilePhoneRegEx = @"^1[3|4|5|7|8][0-9]\\d{8}$";
    return [self isValidWithCharacters:phonenum regExString:mobilePhoneRegEx];
}

+ (BOOL)dc_isValidWithEmail:(NSString *)email
{
    NSString *emailRegEx = @"^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$";
    return [self isValidWithCharacters:email regExString:emailRegEx];
}

+ (BOOL)dc_isValidWithOnlyNumber:(NSString *)characters
{
    NSString *RegEx = @"^[0-9]*$";
    return [self isValidWithCharacters:characters regExString:RegEx];
}

+ (BOOL)dc_isValidWithOnlyNumber:(NSString *)characters leastLength:(NSUInteger)n
{
    NSString *RegEx = @"^[0-9]*$";
    return [self isValidWithCharacters:characters regExString:RegEx leastLength:n];
}

+ (BOOL)dc_isValidWithOnlyNumberAndCharacter:(NSString *)characters
{
    NSString *RegEx = @"^[A-Za-z0-9]+$";
    return [self isValidWithCharacters:characters regExString:RegEx];
}

+ (BOOL)dc_isValidWithOnlyNumberAndCharacter:(NSString *)characters leastLength:(NSUInteger)n
{
    NSString *RegEx = @"^[A-Za-z0-9]+$";
    return [self isValidWithCharacters:characters regExString:RegEx leastLength:n];
}

+ (BOOL)dc_isValidWithLowerCharacters:(NSString *)characters
{
    NSString *RegEx = @"^[a-z]+$";
    return [self isValidWithCharacters:characters regExString:RegEx];
}

+ (BOOL)dc_isValidWithUpperCharacters:(NSString *)characters
{
    NSString *RegEx = @"^[A-Z]+$";
    return [self isValidWithCharacters:characters regExString:RegEx];
}

#pragma mark - Private

+ (BOOL)isValidWithCharacters:(NSString *)characters regExString:(NSString *)regExString
{
    if (!characters || [characters isEqualToString:@""]) return NO;
    NSError *error = nil;
    NSRegularExpression *regEx = [NSRegularExpression regularExpressionWithPattern:regExString
                                                                           options:NSRegularExpressionDotMatchesLineSeparators
                                                                             error:&error];
    if (error) return NO;
        
    NSArray *matchArray =  [regEx matchesInString:characters
                                          options:NSMatchingReportCompletion
                                            range:NSMakeRange(0, [characters length])];
    return [matchArray count] == 1;
}


+ (BOOL)isValidWithCharacters:(NSString *)characters regExString:(NSString *)regExString leastLength:(NSUInteger)n
{
    if ([self isValidWithCharacters:characters regExString:regExString]) {
        return characters.length >= n;
    }
    return NO;
}

@end
