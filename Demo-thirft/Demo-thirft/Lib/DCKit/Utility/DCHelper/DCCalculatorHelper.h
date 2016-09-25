//
//  DCCalculatorHelper.h
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
#import <UIKit/UIKit.h>

#pragma mark - mathematics

/*!
 *  生成给定范围内的而随机浮点数
 *  @param maxBound 最大的浮点数
 *  @param minBound 最小浮点数
 *  @return 随机浮点数
 */
CGFloat dc_RandomFloatNumber(CGFloat maxBound, CGFloat minBound);

/*!
 *  根据当前价格和市场价格计算折扣
 *  @param price       当前价格
 *  @param marketPrice 市场价格
 *  @return 折扣
 */
CGFloat dc_GetDiscountFromPrices(CGFloat price, CGFloat marketPrice);

#pragma mark - CGRect operation

///< 将 frame 的高度改为0
CGRect dc_ShrinkToZeroHeight(CGRect frame);

///< 将 frame 的宽度增加大屏幕宽度
CGRect dc_ExtendToScreenWidth(CGRect frame);

///< 屏幕 size
CGSize dc_ScreenSize();

