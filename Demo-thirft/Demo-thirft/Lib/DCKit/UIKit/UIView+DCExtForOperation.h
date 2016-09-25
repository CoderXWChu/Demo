//
//  UIView+DCExtForOperation.h
//
//  Created by DanaChu on 16/8/12.
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

@interface UIView (DCExtForOperation)

@property (nonatomic, strong)  NSString *nameTag; /**< 名称标签 */

/*!
 *  找出 self 中有没有以 aName 为命名标签的视图
 *  @param aName 标签
 *  @return 视图/子视图
 */
-(UIView *)dc_viewNamed:(NSString *)aName;

/*!
 *  设置圆角半径
 *  @param radius 半径值
 */
- (void)dc_setCornerRadius:(CGFloat)radius;

/*!
 *  设置视图的边框颜色和边框宽度
 *  @param color 边框颜色
 *  @param width 边框宽度
 */
- (void)dc_setBorder:(UIColor *)color width:(CGFloat)width;


/*!
 *  设置视图阴影 : Example: [view setShadow:[UIColor blackColor] opacity:0.5 offset:CGSizeMake(1.0, 1.0) blueRadius:3.0];
 *  @param color      阴影颜色
 *  @param opacity    不透明度
 *  @param offset     阴影偏移量
 *  @param blurRadius 模糊半径
 */
- (void)dc_setShadow:(UIColor *)color opacity:(CGFloat)opacity offset:(CGSize)offset blurRadius:(CGFloat)blurRadius;

/*!
 *  将视图属性说明转化为XML标签样式
 *  @return XML字符串
 */
- (NSString *)dc_XMLWithViewComponent;


@end
