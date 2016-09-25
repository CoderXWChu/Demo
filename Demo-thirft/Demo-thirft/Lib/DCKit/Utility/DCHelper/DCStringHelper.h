//
//  DCStringHelper.h
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

#import <Foundation/Foundation.h>

static const NSTimeInterval s_DCSecsInMinute = 60.0f;
static const NSTimeInterval s_DCSecsInHour = 60.0f * s_DCSecsInMinute;
static const NSTimeInterval s_DCSecsInDay = 24.0f * s_DCSecsInHour;

typedef NS_ENUM(NSUInteger, DCDateCompareStyle) {
    DCDateCompareStyleShort = 0x0001,                     // 1 unit
    DCDateCompareStyleMedium = 0x0002,                    // 2 units
    DCDateCompareStyleLong = 0x0003,                      // 3 units
    DCDateCompareStyleFull = 0x0004,                      // all units (including seconds)
    DCDateCompareStyleMask = 0x000F
};

typedef NS_ENUM(NSUInteger, DCDateCompareOption) {
    DCDateCompareOptionShowZeroUnit = 0x0010,             // X days 00 hours
    DCDateCompareOptionShowBeforeAfter = 0x0020,          // XX days (before|after)
    DCDateCompareOptionAppendZeroPrefix = 0x0040,         // 0X mins
    DCDateCompareOptionSpaceBetweenUnits = 0x0080         // XdaysYhours v.s. X days Y hours
};

// Date formatter
/**
 *  @brief Getting a fill format time string from a specific date.
 *
 *  @param date Assign the NSDate want to format it.
 *
 *  @return Retuen a full date format string.
 */
NSString *dc_GetFullFormatTimeString(NSDate *date);

/**
 *  @brief Getting a simple format time string from a specific date.
 *
 *  @param date Assign the NSDate want to format it.
 *
 *  @return Retuen a simple date format string.
 */
NSString *dc_GetSimpleFormatTimeString(NSDate *date);

/**
 *  @brief Getting a comparing format time string from a specific date to current time.
 *
 *  @param date Assign the NSDate want to compare it.
 *
 *  @return Return a time distance format string.
 */
NSString *dc_GetDateCompareDescriptionWithDate(NSDate *date);

/**
 *  @brief Getting a full and comparing format time string from a specific date to current time.
 *
 *  @param date Assign the NSDate want to compare it.
 *
 *  @param showBeforeAfter To show before/after string or not.
 *
 *  @return Return a time distance format string.
 */
NSString *dc_GetFullDateCompareDescriptionWithDate(NSDate *date, BOOL showBeforeAfter);

/**
 *  @brief Getting a comparing long format time string from a specific date to current time.
 *
 *  @param date Assign the NSDate want to compare it.
 *  @param style Assign the NSDate want to format it.
 *
 *  @return Return a time distance format string.
 */
NSString *dc_GetStyledDateCompareDescriptionWithDate(NSDate *date, DCDateCompareStyle style);

// Number formatter
/**
 *  @brief Getting a currency format from giving number.
 *
 *  @param number Assign the NSInteger want to format it.
 *
 *  @return Retuen a currency format string.
 */
NSString *dc_GetThousandSeparatorNumberString(NSInteger number);

// Number formatter
/**
 *  @brief Getting a currency format from giving number with currency symbol.
 *
 *  @param number Assign the NSInteger want to format it.
 *  @param symbol Assign the NSString want to format it.
 *
 *  @return Retuen a currency format string.
 */
NSString *dc_GetCurrencyStringWithCurrencySymbolAndMaximumFractionDigits(NSNumber *number, NSString *currencySymbol, NSInteger maximumFractionDigits);

NSString *dc_FirstNonEmptyString(NSInteger num, ...);

// Directory path
/**
 *  @brief Getting the application Document file path.
 */
NSString *dc_ApplicationDocumentsDirectory();

/**
 *  @brief Getting the [application]/library/cache file path.
 *
 *  @return path of cache directory
 */
NSString *dc_ApplicationCacheDirectory();

/*!
 *  @brief 生成随机字符串的方法
 *
 *  @param length 随机字符串的长度
 *
 *  @return 返回随机字符串
 */
NSString *dc_RandomString(int length);





