//
//  DCCalculatorHelper.m
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

#import "DCCalculatorHelper.h"

#pragma mark - mathematics

CGFloat dc_RandomFloatNumber(CGFloat maxBound, CGFloat minBound)
{
    //reference: http://kirenenko-tw.blogspot.com/2012/10/objectc.html
    //max-value of arc4random() is 0×100000000 (4294967296), and RAND_MAX would only be 0x7fffffff (2147483647)
    //to mode (RAND_MAX + 1) would get 0 ~ RAND_MAX, then calculate its percentage, and then multi with diff
    CGFloat diff = maxBound - minBound;
    //because RAND_MAX is too much and in order to improve performance and make it more random, use ceil insteadly
    CGFloat diffCeil = ceil(diff*3.14f);
    return (((CGFloat) (arc4random() % ((unsigned)diffCeil + 1)) / diffCeil) * diff) + minBound;
}

#pragma mark - discount calculate

CGFloat dc_GetDiscountFromPrices(CGFloat price, CGFloat marketPrice)
{
    CGFloat discount = 0.0;
    if (marketPrice > 0.0f && price > 0.0f) {
        discount = (100.0f - fabs(marketPrice - price) / fabs(marketPrice) * 100.0f);
        
        if (marketPrice <= price || discount < 10.0f) {
            // specail case:marketPrice <= price or 0.1%
            discount = NAN;
        } else if ((int)discount % 10 == 0) {
            discount = floor(discount * 0.1f);
        } else {
            discount = floor(discount);
        }
    }
    
    return discount;
}

#pragma mark - CGRect operation

CGRect dc_ShrinkToZeroHeight(CGRect frame)
{
    frame.size.height = 0.0f;
    return frame;
}

CGRect dc_ExtendToScreenWidth(CGRect frame)
{
    frame.size.width = dc_ScreenSize().width;
    return frame;
}

CGSize dc_ScreenSize()
{
    UIScreen *screen = [UIScreen mainScreen];
    return screen.bounds.size;
}

