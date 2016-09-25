//
//  JDTheme.h
//
//  Created by DanaChu on 16/8/31.
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

#import <UIKit/UIKit.h>

@interface JDTheme : NSObject

// 深深灰色
+ (UIColor *)backgroundColor;

// 深灰色
+ (UIColor *)selectedThemeColor;

// 灰色
+ (UIColor *)normalThemeColor;

// 浅绿色
+ (UIColor *)greenColorForWord;

// 字体：浅灰色
+ (UIColor *)lightGrayForWord;

// 字体：灰白色
+ (UIColor *)wordColor;

// 比灰白还灰白
+ (UIColor *)borderColor;

// 棕黄色
+ (UIColor *)tipColor;

@end
