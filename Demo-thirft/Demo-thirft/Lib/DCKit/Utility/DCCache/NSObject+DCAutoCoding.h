//
//  NSObject+DCAutoCoding.h
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

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//============================================================
// NSObject+DCAutoCoding.h 是实现自动 Coding 的分类,
// 你可以使用 macro : DCAutoCodingImplementation 完成自动编码
// 在 - dc_ignorePropertyForCoding 中返回不需要编码的属性名;
// 或者
// 在 - dc_AllowPropertyForCoding 中返回需要编码的属性名;
//============================================================

@interface NSObject (DCAutoCoding)<NSCoding>

/*!
 *  编码
 */
- (void)dc_encode:(NSCoder *)encoder;

/*!
 *  解码
 */
- (void)dc_decode:(NSCoder *)decoder;

/*!
 *  由子类 override
 *  不需要编码/解码的属性名数组, 其他的都编码
 *  @return 属性名数组
 */
- (NSArray *)dc_ignorePropertyForCoding;

/*!
 *  由子类 override
 *  需要编码/解码的属性名数组, 仅对数组中的属性进行编码/解码
 *  @return 属性名数组
 */
- (NSArray *)dc_AllowPropertyForCoding;

@end

NS_ASSUME_NONNULL_END

#define DCAutoCodingImplementation \
- (id)initWithCoder:(NSCoder *)decoder \
{ \
if (self = [super init]) { \
[self dc_decode:decoder]; \
} \
return self; \
} \
\
- (void)encodeWithCoder:(NSCoder *)encoder \
{ \
[self dc_encode:encoder]; \
}


