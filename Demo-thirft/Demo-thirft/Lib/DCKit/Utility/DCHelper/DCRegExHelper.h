//
//  DCRegExHelper.h
//
//  Created by CoderXWChu on 14/3/13.
//  Copyright © 2014年 CoderXWChu. All rights reserved.
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

@interface DCRegExHelper : NSObject

/*!
 *  @brief 验证电话的有效性
 *
 *  @param phonenum  eg:@"021-12345678"
 *
 *  @return 是否有效
 */
+ (BOOL)dc_isValidWithTelPhone:(NSString *)phonenum;

/*!
 *  @brief 验证手机号码的有效性
 *
 *  @param phonenum  eg:@"13501234567"
 *
 *  @return 是否有效
 */
+ (BOOL)dc_isValidWithMobilePhone:(NSString *)phonenum;

/*!
 *  @brief 验证邮箱的有效性
 *
 *  @param phonenum  eg:@"example@email.com"
 *
 *  @return 是否有效
 */
+ (BOOL)dc_isValidWithEmail:(NSString *)email;

/*!
 *  @brief 验证字符串是否仅仅为 数字和26个英文字母
 *
 *  @param phonenum  eg:@"as124sd5f8r7"
 *
 *  @return 是否有效
 */
+ (BOOL)dc_isValidWithOnlyNumberAndCharacter:(NSString *)characters;

/*!
 *  @brief 验证字符串是否仅仅为 数字和26个英文字母 至少n位
 *
 */
+ (BOOL)dc_isValidWithOnlyNumberAndCharacter:(NSString *)characters leastLength:(NSUInteger)n;


/*!
 *  @brief 验证字符串是否仅仅为 数字
 *
 *  @param phonenum  eg:@"012345678"
 *
 *  @return 是否有效
 */
+ (BOOL)dc_isValidWithOnlyNumber:(NSString *)characters;

/*!
 *  @brief 验证字符串是否仅仅为 数字 至少n位
 *
 */
+ (BOOL)dc_isValidWithOnlyNumber:(NSString *)characters leastLength:(NSUInteger)n;

/*!
 *  @brief 验证字符串是否仅仅为 小写英文字母
 *
 */
+ (BOOL)dc_isValidWithLowerCharacters:(NSString *)characters;

/*!
 *  @brief 验证字符串是否仅仅为 大写英文字母
 *
 */
+ (BOOL)dc_isValidWithUpperCharacters:(NSString *)characters;



@end
