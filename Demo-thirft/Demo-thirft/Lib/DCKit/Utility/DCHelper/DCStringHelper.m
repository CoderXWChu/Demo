//
//  DCStringHelper.m
//
//  Created by CoderXWChu on 15/5/12.
//  Copyright © 2015年 CoderXWChu. All rights reserved.
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

#import "DCStringHelper.h"

static NSDateFormatter *s_cachedDateFormatter;
static NSNumberFormatter *s_cachedNumberFormatter;

NSDateFormatter *cachedDateFormatter()
{
    @synchronized(s_cachedDateFormatter) {
        if (!s_cachedDateFormatter) {
            s_cachedDateFormatter = [[NSDateFormatter alloc] init];
        }
    }
    
    return s_cachedDateFormatter;
}

NSNumberFormatter *cachedNumberFormatter()
{
    @synchronized(s_cachedNumberFormatter) {
        if (!s_cachedNumberFormatter) {
            s_cachedNumberFormatter = [[NSNumberFormatter alloc] init];
        }
    }
    
    return s_cachedNumberFormatter;
}

#pragma mark - date

NSString *dc_GetFullFormatTimeString(NSDate *date)
{
    NSDateFormatter *dateFormatter = cachedDateFormatter();
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    NSString *str = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:date]];
    
    return str;
}

NSString *dc_GetSimpleFormatTimeString(NSDate *date)
{
    NSDateFormatter *dateFormatter = cachedDateFormatter();
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    NSString *str = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:date]];
    
    return str;
}

NSString *dc_GetDateCompareDescriptionWithDate(NSDate *date)
{
    BOOL isBeforeNow = NO;
    NSTimeInterval timeInterval = [date timeIntervalSinceNow];
    if (timeInterval <= 0.0f) {
        timeInterval *= -1.0f;
        isBeforeNow = YES;
    }
    
    NSString *str = @"";
    
    if ((timeInterval / s_DCSecsInMinute) < 60.0f) {
        NSUInteger min = (NSUInteger)(timeInterval / s_DCSecsInMinute);
        str = [NSString stringWithFormat:@"%lu 分钟%@", (unsigned long)min, (isBeforeNow ? @"前" : @"后")]; //TRANSLATE
    }
    else if ((timeInterval / s_DCSecsInHour) < 24.0f) {
        NSUInteger hour = (NSUInteger)(timeInterval / s_DCSecsInHour);
        str = [NSString stringWithFormat:@"%lu 小时%@", (unsigned long)hour, (isBeforeNow ? @"前" : @"后")]; //TRANSLATE
    }
    else if ((timeInterval / s_DCSecsInDay) <= 30.0f) {
        NSUInteger day = (NSUInteger)(timeInterval / s_DCSecsInDay);
        str = [NSString stringWithFormat:@"%lu 天%@", (unsigned long)day, (isBeforeNow ? @"前" : @"后")]; //TRANSLATE
    }
    else {
        NSDateFormatter *dateFormatter = cachedDateFormatter();
        [dateFormatter setDateFormat:@"MM/dd"];
        str = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:date]];
    }
    
    return str;
}

NSString *dc_GetFullDateCompareDescriptionWithDate(NSDate *date, BOOL showBeforeAfter)
{
    BOOL isBeforeNow = NO;
    NSTimeInterval timeInterval = [date timeIntervalSinceNow];
    if (timeInterval <= 0.0f) {
        timeInterval *= -1.0f;
        isBeforeNow = YES;
    }
    
    NSString *str = @"";
    
    if ((timeInterval / s_DCSecsInDay) > 0.0f) {
        NSUInteger day = (NSUInteger)(timeInterval / s_DCSecsInDay);
        if (day > 0) {
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%lu 天 ", (unsigned long)day]]; //TRANSLATE
            timeInterval -= (day * s_DCSecsInDay);
        }
    }
    
    if (fmod(timeInterval, s_DCSecsInDay) && (timeInterval / s_DCSecsInHour) > 0.0f) {
        NSUInteger hour = (NSUInteger)(timeInterval / s_DCSecsInHour);
        if (hour > 0) {
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%lu 小时 ", (unsigned long)hour]]; //TRANSLATE
            timeInterval -= (hour * s_DCSecsInHour);
        }
    }
    
    if (fmod(timeInterval, s_DCSecsInHour) && (timeInterval / s_DCSecsInMinute) > 0.0f) {
        NSUInteger min = (NSUInteger)(timeInterval / s_DCSecsInMinute);
        if (min > 0) {
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%lu 分钟 ", (unsigned long)min]]; //TRANSLATE
        }
    }
    
    if ( ![str isEqual:@""] ) {
        str = [str substringToIndex:(str.length - 1)];
        
        if (showBeforeAfter) {
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%@", (isBeforeNow ? @"前" : @"后")]]; //TRANSLATE
        }
    }
    
    return str;
}

NSString *dc_GetStyledDateCompareDescriptionWithDate(NSDate *date, DCDateCompareStyle style)
{
    BOOL showZeroUnit = (style & DCDateCompareOptionShowZeroUnit);
    BOOL showBeforeAfter = (style & DCDateCompareOptionShowBeforeAfter);
    BOOL appendZeroPrefix = (style & DCDateCompareOptionAppendZeroPrefix);
    BOOL spaceBetweenUnits = (style & DCDateCompareOptionSpaceBetweenUnits);
    
    BOOL isBeforeNow = NO;
    NSTimeInterval timeInterval = [date timeIntervalSinceNow];
    if (timeInterval <= 0.0f) {
        timeInterval *= -1.0f;
        isBeforeNow = YES;
    }
    
    NSString *strDateDay = @"天";            // TRANSLATE
    NSString *strDateHour = @"小时";          // TRANSLATE
    NSString *strDateMinute = @"分";         // TRANSLATE
    NSString *strDateSecond = @"秒";         // TRANSLATE
    NSString *strDateBefore = @"前";         // TRANSLATE
    NSString *strDateAfter = @"后";          // TRANSLATE
    
    NSString *unitSpacer = spaceBetweenUnits ? @" " : @"";
    NSString *str = @"";
    NSInteger timeUnits = 0;
    
    if ((timeInterval / s_DCSecsInDay) > 0.0f) {
        NSUInteger day = (NSUInteger)(timeInterval / s_DCSecsInDay);
        if (day > 0) {
            NSString *timeFormatterStr = @"%lu";
            str = [str stringByAppendingString:[NSString stringWithFormat:timeFormatterStr, (unsigned long) day]];
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%@%@%@", unitSpacer, strDateDay, unitSpacer]];
            timeInterval -= (day * s_DCSecsInDay);
            timeUnits++;
        }
    }
    
    if (timeUnits < (style & DCDateCompareStyleMask)) {
        if (fmod(timeInterval, s_DCSecsInDay) && (timeInterval / s_DCSecsInHour) > 0.0f) {
            NSUInteger hour = (NSUInteger)(timeInterval / s_DCSecsInHour);
            if (hour > 0 || (timeUnits && showZeroUnit)) {
                NSString *timeFormatterStr = (appendZeroPrefix && timeUnits) ? @"%02lu" : @"%lu";
                str = [str stringByAppendingString:[NSString stringWithFormat:timeFormatterStr, (unsigned long) hour]];
                str = [str stringByAppendingString:[NSString stringWithFormat:@"%@%@%@", unitSpacer, strDateHour, unitSpacer]];
                timeUnits++;
            }
            timeInterval -= (hour * s_DCSecsInHour);
        }
    }
    
    if (timeUnits < (style & DCDateCompareStyleMask)) {
        if (fmod(timeInterval, s_DCSecsInHour) && (timeInterval / s_DCSecsInMinute) > 0.0f) {
            NSUInteger min = (NSUInteger)(timeInterval / s_DCSecsInMinute);
            if (min > 0 || (timeUnits && showZeroUnit)) {
                NSString *timeFormatterStr = (appendZeroPrefix && timeUnits) ? @"%02lu" : @"%lu";
                str = [str stringByAppendingString:[NSString stringWithFormat:timeFormatterStr, (unsigned long) min]];
                str = [str stringByAppendingString:[NSString stringWithFormat:@"%@%@%@", unitSpacer, strDateMinute, unitSpacer]];
                timeUnits++;
            }
        }
    }
    
    if (style & DCDateCompareStyleFull) {
        if (fmod(timeInterval, s_DCSecsInHour) && (timeInterval / s_DCSecsInMinute) > 0.0f) {
            NSUInteger sec = (NSUInteger)((int) timeInterval % (int) s_DCSecsInMinute);
            NSString *timeFormatterStr = (appendZeroPrefix && timeUnits) ? @"%02lu" : @"%lu";
            str = [str stringByAppendingString:[NSString stringWithFormat:timeFormatterStr, (unsigned long) sec]];
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%@%@%@", unitSpacer, strDateSecond, unitSpacer]];
        }
    }
    
    if (str.length > 0) {
        if (unitSpacer.length > 0) {
            str = [str substringToIndex:(str.length - unitSpacer.length)];
        }
        
        if (showBeforeAfter) {
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%@", (isBeforeNow ? strDateBefore : strDateAfter)]];
        }
    }
    
    return str;
}

#pragma mark - format
NSString *dc_GetThousandSeparatorNumberString(NSInteger number)
{
    return dc_GetCurrencyStringWithCurrencySymbolAndMaximumFractionDigits([NSNumber numberWithInteger:number], @"", 0);
}

NSString *dc_GetCurrencyStringWithCurrencySymbolAndMaximumFractionDigits(NSNumber *number, NSString *currencySymbol, NSInteger maximumFractionDigits)
{
    NSNumberFormatter *formatter = cachedNumberFormatter();
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    formatter.currencySymbol = currencySymbol;
    formatter.maximumFractionDigits = maximumFractionDigits;
    
    return [formatter stringFromNumber:number];
}

NSString *dc_FirstNonEmptyString(NSInteger num, ...)
{
    va_list ap;
    NSString *result;
    
    va_start(ap, num);
    for (int i = 0; i < num; i++) {
        NSString *str = va_arg(ap, NSString *);
        if (str && [str isKindOfClass:[NSString class]] && [str length] > 0) {
            result = str;
            break;
        }
    }
    
    return result ? result : @"";
}

#pragma mark - File Path

NSString *dc_ApplicationDocumentsDirectory()
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = [paths lastObject];
    return basePath;
}

NSString *dc_ApplicationCacheDirectory()
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *basePath = [paths lastObject];
    return basePath;
}

#pragma mark - string tool

NSString *dc_RandomString(int length)
{
    NSString *standards = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *temp = [NSMutableString stringWithCapacity:length];
    int count = (int)standards.length;
    for (int i=0; i<length; i++) {
        [temp appendFormat: @"%C", [standards characterAtIndex: arc4random_uniform(count)]];
    }
    return [temp copy];
}

