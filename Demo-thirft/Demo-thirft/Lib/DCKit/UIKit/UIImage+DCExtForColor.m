//
//  UIImage+DCExtForColor.m
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

#import "UIImage+DCExtForColor.h"
#import "UIColor+DCExt.h"

typedef NS_ENUM(NSUInteger, DCColorReplaceMode) {
    DCColorReplaceModeReplace = 0,
    DCColorReplaceModeTint,
    DCColorReplaceModeInstead,
};

static NSCache *s_imageCache;

@implementation UIImage (DCExtForColor)

+ (void)load
{
    s_imageCache = [[NSCache alloc] init];
}

+ (UIImage *)dc_Image:(UIImage *)image tintColor:(UIColor *)color
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    [color setFill];
    CGContextTranslateCTM(contextRef, 0.0f, image.size.height);
    CGContextScaleCTM(contextRef, 1.0f,  -1.0f);
    CGRect drawRect = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);
    CGContextDrawImage(contextRef, drawRect, image.CGImage);
    CGContextSetBlendMode(contextRef, kCGBlendModeMultiply);
    CGContextClipToMask(contextRef, drawRect, image.CGImage);
    CGContextAddRect(contextRef, drawRect);
    CGContextDrawPath(contextRef, kCGPathFill);
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return [UIImage imageWithCGImage:[resultImage CGImage] scale:image.scale orientation:image.imageOrientation];
}

+ (UIImage *)dc_Image:(UIImage *)image replaceColor:(UIColor *)color
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    [color setFill];
    CGContextTranslateCTM(contextRef, 0.0f, image.size.height);
    CGContextScaleCTM(contextRef, 1.0f,  -1.0f);
    CGRect drawRect = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);
    CGContextDrawImage(contextRef, drawRect, image.CGImage);
    CGContextClipToMask(contextRef, drawRect, image.CGImage);
    CGContextAddRect(contextRef, drawRect);
    CGContextDrawPath(contextRef, kCGPathFill);
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return [UIImage imageWithCGImage:[resultImage CGImage] scale:image.scale orientation:image.imageOrientation];
}

+ (UIImage *)dc_Image:(UIImage *)image replaceColor:(UIColor *)fromColor toColor:(UIColor *)toColor
{
    CGImageRef imageRef = image.CGImage;
    
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    NSUInteger bitmapByteCount = bytesPerRow * height;
    
    unsigned char *rawData = (unsigned char*) calloc(bitmapByteCount, sizeof(unsigned char));
    
    CGContextRef contextRef = CGBitmapContextCreate(rawData, width, height,
                                                    bitsPerComponent, bytesPerRow, colorSpace,
                                                    kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(contextRef, CGRectMake(0.0f, 0.0f, width, height), imageRef);
    
    CGColorRef fromColorRef = fromColor.CGColor;
    const CGFloat *fromColorComponents = CGColorGetComponents(fromColorRef);
    float fromColorRed = fromColorComponents[0];
    float fromColorGreen = fromColorComponents[1];
    float fromColorBlue = fromColorComponents[2];
    float fromColorAlpha = fromColorComponents[3];
    fromColorRed = fromColorRed * 255.0f;
    fromColorGreen = fromColorGreen * 255.0f;
    fromColorBlue = fromColorBlue * 255.0f;
    fromColorAlpha = fromColorAlpha * 255.0f;
    
    CGColorRef toColorRef = toColor.CGColor;
    const CGFloat *toColorComponents = CGColorGetComponents(toColorRef);
    float toColorRed = toColorComponents[0];
    float toColorGreen = toColorComponents[1];
    float toColorBlue = toColorComponents[2];
    float toColorAlpha = toColorComponents[3];
    toColorRed = toColorRed * 255.0f;
    toColorGreen = toColorGreen * 255.0f;
    toColorBlue = toColorBlue * 255.0f;
    toColorAlpha = toColorAlpha * 255.0f;
    
    int byteIndex = 0;
    
    while (byteIndex < bitmapByteCount) {
        float currentRed = rawData[byteIndex];
        float currentGreen = rawData[byteIndex + 1];
        float currentBlue = rawData[byteIndex + 2];
        float currentAlpha = rawData[byteIndex + 3];
        
        if (currentRed == fromColorRed && currentGreen == fromColorGreen && currentBlue == fromColorBlue && currentAlpha == fromColorAlpha) {
            rawData[byteIndex] = toColorRed;
            rawData[byteIndex + 1] = toColorGreen;
            rawData[byteIndex + 2] = toColorBlue;
            rawData[byteIndex + 3] = toColorAlpha;
        }
        
        byteIndex += 4;
    }
    
    CGImageRef imageResultRef = CGBitmapContextCreateImage(contextRef);
    UIImage *resultImage = [UIImage imageWithCGImage:imageResultRef];
    
    CGImageRelease(imageResultRef);
    CGContextRelease(contextRef);
    free(rawData);
    
    return [UIImage imageWithCGImage:[resultImage CGImage] scale:image.scale orientation:image.imageOrientation];
}

+ (UIImage *)dc_ImageNamed:(NSString *)name tintColor:(UIColor *)color
{
    NSString *cacheKeyString = [UIImage cacheKeyStringWithImageNamed:name
                                                    colorReplaceMode:DCColorReplaceModeTint
                                                               color:color];
    UIImage *resultImage = [s_imageCache objectForKey:cacheKeyString];
    if (resultImage) {
        return resultImage;
    }
    
    UIImage *image = [UIImage imageNamed:name];
    resultImage = [UIImage dc_Image:image tintColor:color];
    if (resultImage) {
        [s_imageCache setObject:resultImage forKey:cacheKeyString];
    }
    
    return resultImage;
}

+ (UIImage *)dc_ImageNamed:(NSString *)name replaceColor:(UIColor *)color
{
    NSString *cacheKeyString = [UIImage cacheKeyStringWithImageNamed:name
                                                    colorReplaceMode:DCColorReplaceModeReplace
                                                               color:color];
    UIImage *resultImage = [s_imageCache objectForKey:cacheKeyString];
    if (resultImage) {
        return resultImage;
    }
    
    UIImage *image = [UIImage imageNamed:name];
    resultImage = [UIImage dc_Image:image replaceColor:color];
    if (resultImage) {
        [s_imageCache setObject:resultImage forKey:cacheKeyString];
    }
    
    return resultImage;
}

+ (UIImage *)dc_ImageNamed:(NSString *)name replaceColor:(UIColor *)fromColor withColor:(UIColor *)toColor
{
    NSString *cacheKeyString = [UIImage cacheKeyStringWithImageNamed:name
                                                    colorReplaceMode:DCColorReplaceModeInstead
                                                           fromColor:fromColor
                                                             toColor:toColor];
    UIImage *resultImage = [s_imageCache objectForKey:cacheKeyString];
    if (resultImage) {
        return resultImage;
    }
    
    UIImage *image = [UIImage imageNamed:name];
    resultImage = [UIImage dc_Image:image replaceColor:fromColor toColor:toColor];
    if (resultImage) {
        [s_imageCache setObject:resultImage forKey:cacheKeyString];
    }
    
    return resultImage;
}

+ (UIImage *)dc_ImageWithColor:(UIColor *)color size:(CGSize)size;
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(size);
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    if (contextRef) {
        CGContextSetFillColorWithColor(contextRef, [color CGColor]);
        CGContextFillRect(contextRef, rect);
    }
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

+ (UIImage *)dc_Image:(UIImage *)image colorWithAlphaComponent:(CGFloat)alpha
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(contextRef, 0.0f, image.size.height);
    CGContextScaleCTM(contextRef, 1.0f, -1.0f);
    CGContextSetAlpha(contextRef, alpha);
    CGRect drawRect = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);
    CGContextDrawImage(contextRef, drawRect, image.CGImage);
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return [UIImage imageWithCGImage:[resultImage CGImage] scale:image.scale orientation:image.imageOrientation];
}

+ (NSString *)cacheKeyStringWithImageNamed:(NSString *)name colorReplaceMode:(DCColorReplaceMode)mode color:(UIColor *)color
{
    NSString *hexString = [color dc_HexString];
    NSString *modeString = (mode == DCColorReplaceModeReplace) ? @"replace" : @"tint";
    NSString *keyString = [NSString stringWithFormat:@"%@-%@-%@", name, modeString, hexString];
    
    return keyString;
}

+ (NSString *)cacheKeyStringWithImageNamed:(NSString *)name colorReplaceMode:(DCColorReplaceMode)mode fromColor:(UIColor *)fromColor toColor:(UIColor *)toColor
{
    NSString *fromHexString = [fromColor dc_HexString];
    NSString *toHexString = [toColor dc_HexString];
    NSString *modeString = (mode == DCColorReplaceModeReplace) ? @"replace" : @"tint";
    NSString *keyString = [NSString stringWithFormat:@"%@-%@-%@:%@", name, modeString, fromHexString, toHexString];
    
    return keyString;
}

void ProviderReleaseData (void *info, const void *data, size_t size){
    free((void*)data);
}

// 生成一个彩色图片
- (UIImage*)dc_imageBlackToTransparentWithRed:(CGFloat)r green:(CGFloat)g blue:(CGFloat)b
{
    const int imageWidth = self.size.width;
    const int imageHeight = self.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), self.CGImage);
    // 遍历像素
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900)    // 将白色变成透明
        {
            // 改成下面的代码，会将图片转成想要的颜色
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = r; //0~255
            ptr[2] = g;
            ptr[1] = b;
        }
        else
        {
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
    // 输出图片
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    // 清理空间
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
}


@end
