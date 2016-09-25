//
//  UIColor+DCExt.h
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

#import <UIKit/UIKit.h>

@interface UIColor (DCExt)

/*!
 *  构造方法
 *  @param red   红色值
 *  @param green 绿色值
 *  @param blue  蓝色值
 *  @param alpha 透明度
 *  @return 颜色
 */
- (UIColor *)initWithHexRed:(NSUInteger)red green:(NSUInteger)green blue:(NSUInteger)blue alpha:(CGFloat)alpha;
+ (UIColor *)dc_ColorWithHexRed:(NSUInteger)red green:(NSUInteger)green blue:(NSUInteger)blue alpha:(CGFloat)alpha;

/*!
 *  构造方法
 *  @param hexString 颜色的十六进制
 *  @note: 支持 #ff2efa 、 0Xff2efa 、 ff2efa
 */
- (UIColor *)initWithHexString:(NSString *)hexString;
+ (UIColor *)dc_ColorWithHexString:(NSString *)hexString;
+ (UIColor *)dc_ColorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

/*!
 *  构造方法
 *  @param hexNumber 十六进制数值
 */
- (UIColor *)initWithHexNumber:(NSUInteger)hexNumber;

/*!
 *  构造方法
 *  @param hexNumber 十六进制数值
 */
+ (UIColor *)dc_ColorWithHexNumber:(NSUInteger)hexNumber;


/*!
 *  增加颜色的 饱和度(0.0f~1.0f)
 *  @param shiftValue 饱和度增量大小
 *  @return 改变饱和度后的颜色
 */
- (UIColor *)dc_ColorShiftBySaturation:(CGFloat)shiftValue;

/*!
 *  增加颜色的 亮度(0.0f~1.0f)
 *  @param shiftValue 亮度增量大小
 *  @return 改变亮度后的颜色
 */
- (UIColor *)dc_ColorShiftByBrightness:(CGFloat)shiftValue;

/*!
 *  增加颜色的 透明度(0.0f~1.0f)
 *  @param shiftValue 透明度增量大小
 *  @return 改变透明度后的颜色
 */
- (UIColor *)dc_ColorShiftByAlpha:(CGFloat)shiftValue;

/*!
 *  增加颜色的 色度(0.0f~1.0f)
 *  @param shiftValue 色度增量大小
 *  @return 改变色度后的颜色
 */
- (UIColor *)dc_ColorShiftByHue:(CGFloat)shiftValue;

/*!
 *  判断两种颜色是否相同
 *  @param anotherColor 另一种颜色
 *  @return 是否相同
 */
- (BOOL)dc_IsEqualToColor:(UIColor *)anotherColor;

/*!
 *  颜色的色度
 *  @return 色度值
 */
- (CGFloat)dc_ColorHue;

/*!
 *  颜色的透明度
 *  @return 透明度
 */
- (CGFloat)dc_ColorAlpha;

/*!
 *  颜色的亮度值
 *  @return 亮度值
 */
- (CGFloat)dc_ColorBrightness;

/*!
 *  颜色的饱和度
 *  @return 饱和度值
 */
- (CGFloat)dc_ColorSaturation;


/*!
 *  生成颜色对应得 十六进制字符串
 *  @return 色值对应的十六进制字符串
 */
- (NSString *)dc_HexString;



@end
