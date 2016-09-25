//
//  DCQRCodeTool.m
//
//  Created by cxw on 14/11/26.
//  Copyright © 2014年 cxw. All rights reserved.
//

#import "DCQRCodeTool.h"
#import <CoreImage/CoreImage.h>

@implementation DCQRCodeTool

+ (UIImage *)dc_createQRCodeWithString:(NSString *)string size:(CGFloat)size iconName:(NSString *)iconName
{
     UIImage *image = [UIImage imageNamed:iconName];
    return [self dc_createQRCodeWithString:string size:size image:image];
}

+ (UIImage *)dc_createQRCodeWithString:(NSString *)string size:(CGFloat)size image:(UIImage *)image
{
    UIImage *imageQRCoder = [self dc_createQRCodeWithString:string size:size];
    UIGraphicsBeginImageContext(CGSizeMake(200, 200));
    [imageQRCoder drawInRect:CGRectMake(0, 0, 300, 300)];
    [image drawInRect:CGRectMake(125, 125, 50, 50)];
    
    return UIGraphicsGetImageFromCurrentImageContext();
}


+ (UIImage *)dc_createQRCodeWithString:(NSString *)string
{
    return [self dc_createQRCodeWithString:string size:100];
}

+ (UIImage *)dc_createQRCodeWithString:(NSString *)string size:(CGFloat)size
{
    
    // 1. 创建一个滤镜(二维码)
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 1.1 恢复滤镜默认设置
    [filter setDefaults];
    
    // 2. 设置路径输入(NSData)
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    
    // 3. 从滤镜里面获取图片数据(27
    CIImage *ciImage = [filter outputImage];
    UIImage *image = [self createNonInterpolatedUIImageFormCIImage:ciImage size:size];
    
    return image;
}


// 根据CIImage, 和指定大小, 生成UIImage图片
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image size:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}


@end
