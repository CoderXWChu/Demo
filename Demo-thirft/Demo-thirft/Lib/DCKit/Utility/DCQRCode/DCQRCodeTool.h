//
//  DCQRCodeTool.h
//
//  Created by cxw on 14/11/26.
//  Copyright © 2014年 cxw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DCQRCodeTool : NSObject

/*!
 *  根据字符串创建二维码,默认size为100
 *  @param string 信息
 *  @return 二维码照片
 */
+ (UIImage *)dc_createQRCodeWithString:(NSString *)string;
/*!
 *  根据二维码信息和尺寸创建二维码
 *  @param string 二维码信息
 *  @param size   二维码尺寸
 *  @return 二维码照片
 */
+ (UIImage *)dc_createQRCodeWithString:(NSString *)string size:(CGFloat)size;

/*!
 *  根据二维码信息,尺寸,以及中间的图片创建二维码
 *  @param string 二维码信息
 *  @param size   二维码尺寸
 *  @param imageName 中间头像的图片名称
 *  @return 二维码照片
 */
+ (UIImage *)dc_createQRCodeWithString:(NSString *)string size:(CGFloat)size iconName:(NSString *)iconName;

/*!
 *  根据二维码信息,尺寸,以及中间的图片创建二维码
 *  @param string 二维码信息
 *  @param size   二维码尺寸
 *  @param icon 中间头像的图片
 *  @return 二维码照片
 */
+ (UIImage *)dc_createQRCodeWithString:(NSString *)string size:(CGFloat)size image:(UIImage *)image;

@end
