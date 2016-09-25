//
//  UIImage+DCExt.h
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

@interface UIImage (DCExt)

/*!
 *  @brief 根据图片名称返回一张从 默认0.5 *width 0.5 * hight 位置拉伸延展的图片
 */
+ (instancetype)dc_ResizableWithImageName:(NSString *)imageName;

/*!
 *  截屏操作
 *  @param view 截取图片的视图
 *  @return 截取的图片
 */
+ (UIImage *)dc_CaptureView:(UIView *)view;

/*!
 *  截取视图规定矩形内的图片
 *  @param view 要截取图片的视图
 *  @param rect 规定的矩形框
 *  @return 截取的图片
 */
+ (UIImage *)dc_CaptureView:(UIView *)view withFrame:(CGRect)rect;

/*!
 *  调整图片大小到 宽/高 最大长度为 maxLength
 *  @param maxLength 宽/高 最大长度
 *  @return 调整后的图片
 */
- (UIImage *)dc_ResizeByMaxLength:(NSInteger)maxLength;

/*!
 *  调整图片到新的尺寸, 像素比例为当前设备的像素比例
 *  @param newSize 新尺寸
 *  @return 返回调整后的图片
 */
- (UIImage *)dc_ScaleToSize:(CGSize)newSize;

/*!
 *  裁剪下图片上指定的 size
 *  @param cropSize 指定的裁剪尺寸, 左上角为顶点
 *  @return 返回裁剪后的图片
 */
- (UIImage *)dc_CropSize:(CGSize)cropSize;

/*!
 *  裁剪下图片上指定的 矩形框
 *  @param cropRect 指定的裁剪矩形框
 *  @return 返回裁剪后的图片
 */
- (UIImage *)dc_CropRect:(CGRect)cropRect;

/*!
 *  生成高斯模糊图片
 *  @param blurRadius 模糊半径
 *  @return 返回处理后的图片
 */
- (UIImage *)dc_GaussianBlurWithRadius:(NSInteger)blurRadius;

/*!
 *  将图片主色调调整为指定颜色
 *  @param color 指定颜色
 *  @return 返回渲染后的新图片
 */
- (UIImage *)dc_MaskImageWithColor:(UIColor *)color;

/*!
 *  将图片渲染成黑白照片
 *  @return 返回新的照片
 */
- (UIImage *)dc_BlackAndWhiteImage;

/*!
 *  @brief 根据颜色生成1*1的图片
 */
+ (UIImage *)dc_imageWithColor:(UIColor *)color;


/*!
 *  @brief 获得某个像素的颜色
 *
 *  @param point 像素点的位置
 */
- (UIColor *)dc_PixelColorAtLocation:(CGPoint)point;

/*!
 *  根据图片,输出一张不会被渲染的原始图片
 *  @return 图片
 */
- (UIImage *)dc_imageWithOriginalMode;
+ (UIImage *)dc_imageWithOriginalMode:(NSString *)imageName;

/*!
 *  @brief 裁剪圆形头像：根据传入的边框宽度，图片名称，依照图片原有尺寸返回一张带圆形边框的图像
 *
 *  @param border    边框宽度
 *  @param imageName 照片名称
 *
 *  @return 发返回一张带圆形边框的头像
 */
+ (UIImage *)dc_CircleImageInFrameWithBorder:(CGFloat)border image:(UIImage *)image;


@end
