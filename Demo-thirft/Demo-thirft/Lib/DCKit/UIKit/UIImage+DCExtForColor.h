//
//  UIImage+DCExtForColor.h
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

@interface UIImage (DCExtForColor)

/**
 * @brief Mix specific color with image instance.
 *
 * @param image The image instace want to process.
 * @param color The color will affect image result.
 *
 * @return The instance of result UIImage.
 */
+ (UIImage *)dc_Image:(UIImage *)image tintColor:(UIColor *)color;

/**
 * @brief Replace opacity pixel with specific color in image instance.
 *
 * @param image The image instace want to process.
 * @param color The color will affect image result.
 *
 * @return The instance of result UIImage.
 */
+ (UIImage *)dc_Image:(UIImage *)image replaceColor:(UIColor *)color;

/**
 * @brief Replace specific color with another color in image instance.
 *
 * @param image The image instace want to process.
 * @param fromColor The original color need be replaced.
 * @param toColor The color will replace original color.
 *
 * @return The instance of result UIImage.
 */
+ (UIImage *)dc_Image:(UIImage *)image replaceColor:(UIColor *)fromColor toColor:(UIColor *)toColor;

/**
 * @brief Mix specific color with image name.
 *
 * @param name The image name want to process.
 * @param color The color will affect image result.
 *
 * @return The instance of result UIImage.
 */
+ (UIImage *)dc_ImageNamed:(NSString *)name tintColor:(UIColor *)color;

/**
 * @brief Replace opacity pixel with specific color in image name.
 *
 * @param name The image name want to process.
 * @param color The color will affect image result.
 *
 * @return The instance of result UIImage.
 */
+ (UIImage *)dc_ImageNamed:(NSString *)name replaceColor:(UIColor *)color;

/**
 * @brief Replace specific color with another color in image name.
 *
 * @param name The image name want to process.
 * @param fromColor The original color need be replaced.
 * @param toColor The color will replace original color.
 *
 * @return The instance of result UIImage.
 */
+ (UIImage *)dc_ImageNamed:(NSString *)name replaceColor:(UIColor *)fromColor withColor:(UIColor *)toColor;

/**
 * @brief Overlap specific color on image instance.
 *
 * @param color The color will affect image result.
 * @param size The expected final result image size.
 *
 * @return The instance of result UIImage.
 */
+ (UIImage *)dc_ImageWithColor:(UIColor *)color size:(CGSize)size;

/**
 * @brief Change image instance's alpha value.
 *
 * @param image The image instace want to process.
 * @param alpha The expected alpha value for result image.
 *
 * @return The instance of result UIImage.
 */
+ (UIImage *)dc_Image:(UIImage *)image colorWithAlphaComponent:(CGFloat)alpha;

/*!
 *  @brief 生成彩色照片
 *
 *  @param r red
 *  @param g green
 *  @param b blue
 *
 *  @return 处理后的图片
 */
- (UIImage*)dc_imageBlackToTransparentWithRed:(CGFloat)r green:(CGFloat)g blue:(CGFloat)b;

@end
