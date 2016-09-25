//
//  UIImage+DCExt.m
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

#import "UIImage+DCExt.h"
@import Accelerate;

@implementation UIImage (DCExt)

+ (instancetype)dc_ResizableWithImageName:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
    
}

+ (UIImage *)dc_CaptureView:(UIView *)view
{
    return [self dc_CaptureView:view withFrame:view.bounds];
}

+ (UIImage *)dc_CaptureView:(UIView *)view withFrame:(CGRect)rect
{
    // ref:http://stackoverflow.com/questions/20558033/ios-7-taking-screenshot-of-part-of-a-uiview
    CGRect cropRect = view.bounds;
    cropRect.origin.x = -CGRectGetMinX(rect);
    cropRect.origin.y = -CGRectGetMinY(rect);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    [view drawViewHierarchyInRect:cropRect afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)dc_ResizeByMaxLength:(NSInteger)maxLength
{
    CGFloat ratio = self.size.height / self.size.width;
    CGSize newSize;
    if (self.size.width >= self.size.height) {
        newSize = CGSizeMake(maxLength, maxLength * ratio);
    } else {
        newSize = CGSizeMake(maxLength / ratio, maxLength);
    }
    
    return [self dc_ScaleToSize:newSize];
}

- (UIImage *)dc_ScaleToSize:(CGSize)newSize
{
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, [[UIScreen mainScreen] scale]);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)dc_CropSize:(CGSize)cropSize
{
    return [self dc_CropRect:CGRectMake(0.0f, 0.0f, cropSize.width, cropSize.height)];
}

- (UIImage *)dc_CropRect:(CGRect)cropRect
{
    UIGraphicsBeginImageContextWithOptions(cropRect.size, NO, self.scale);
    [self drawAtPoint:CGPointMake(-cropRect.origin.x, -cropRect.origin.y)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

///< 高斯模糊
- (UIImage *)dc_GaussianBlurWithRadius:(NSInteger)blurRadius
{
    CGRect imageDrawRect = CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef effectInContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(effectInContext, 1.0, -1.0);
    CGContextTranslateCTM(effectInContext, 0, -self.size.height);
    CGContextDrawImage(effectInContext, imageDrawRect, self.CGImage);
    
    vImage_Buffer effectInBuffer;
    effectInBuffer.data     = CGBitmapContextGetData(effectInContext);
    effectInBuffer.width    = CGBitmapContextGetWidth(effectInContext);
    effectInBuffer.height   = CGBitmapContextGetHeight(effectInContext);
    effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext);
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef effectOutContext = UIGraphicsGetCurrentContext();
    vImage_Buffer effectOutBuffer;
    effectOutBuffer.data     = CGBitmapContextGetData(effectOutContext);
    effectOutBuffer.width    = CGBitmapContextGetWidth(effectOutContext);
    effectOutBuffer.height   = CGBitmapContextGetHeight(effectOutContext);
    effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);
    
    CGFloat inputRadius = blurRadius * [[UIScreen mainScreen] scale];
    uint32_t radius = floorl(inputRadius * 3. * sqrt(2 * M_PI) / 4 + 0.5);
    if (radius % 2 != 1) {
        radius += 1;
    }
    vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
    vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
    vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
    
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef outputContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(outputContext, 1.0, -1.0);
    CGContextTranslateCTM(outputContext, 0, -self.size.height);
    
    CGContextDrawImage(outputContext, imageDrawRect, self.CGImage);
    
    CGContextSaveGState(outputContext);
    CGContextDrawImage(outputContext, imageDrawRect, finalImage.CGImage);
    CGContextRestoreGState(outputContext);
    
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outputImage;
}

///<  Mask UIImage with UIColor
- (UIImage *)dc_MaskImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, self.scale);
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    [self drawInRect:rect];
    CGContextSetFillColorWithColor(contextRef, [color CGColor]);
    CGContextFillRect(contextRef, rect);
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return result;
}

- (UIImage *)dc_BlackAndWhiteImage
{
    CGColorSpaceRef colorSapce = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate(nil, self.size.width * self.scale, self.size.height * self.scale, 8, self.size.width * self.scale, colorSapce, kCGBitmapByteOrderDefault);
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGContextSetShouldAntialias(context, NO);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, self.size.width * self.scale, self.size.height * self.scale), self.CGImage);
    
    CGImageRef bwImage = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSapce);
    
    UIImage *resultImage = [UIImage imageWithCGImage:bwImage];
    CGImageRelease(bwImage);
    
    return resultImage;
}


+ (UIImage *)dc_imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();    UIGraphicsEndImageContext();
    
    return theImage;
}

+ (UIImage *)dc_CircleImageInFrameWithBorder:(CGFloat)border image:(UIImage *)image
{
    CGRect rect = CGRectMake(0, 0, image.size.width + 2 * border, image.size.height + 2 * border);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
    [[UIColor blueColor] set];
    [path fill];
    
    path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(border, border, image.size.width, image.size.height)];
    [path addClip];
    [image drawAtPoint:CGPointMake(border, border)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIColor *)dc_PixelColorAtLocation:(CGPoint)point {
    UIColor *color = nil;
    CGImageRef inImage = self.CGImage;
    CGContextRef contexRef = [self ARGBBitmapContextFromImage:inImage];
    if (contexRef == NULL) return nil;
    
    size_t w = CGImageGetWidth(inImage);
    size_t h = CGImageGetHeight(inImage);
    CGRect rect = {{0,0},{w,h}};
    
    // Draw the image to the bitmap context. Once we draw, the memory
    // allocated for the context for rendering will then contain the
    // raw image data in the specified color space.
    CGContextDrawImage(contexRef, rect, inImage);
    
    // Now we can get a pointer to the image data associated with the bitmap
    // context.
    unsigned char* data = CGBitmapContextGetData (contexRef);
    if (data != NULL) {
        //offset locates the pixel in the data from x,y.
        //4 for 4 bytes of data per pixel, w is width of one row of data.
        int offset = 4*((w*round(point.y))+round(point.x));
        int alpha =  data[offset];
        int red = data[offset+1];
        int green = data[offset+2];
        int blue = data[offset+3];
        //		NSLog(@"offset: %i colors: RGB A %i %i %i  %i",offset,red,green,blue,alpha);
        color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
    }
    
    // When finished, release the context
    CGContextRelease(contexRef);
    // Free image data memory for the context
    if (data) { free(data); }
    
    return color;
}

/**
 *  根据CGImageRef来创建一个ARGBBitmapContext
 */
- (CGContextRef)ARGBBitmapContextFromImage:(CGImageRef) inImage {
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    NSInteger             bitmapByteCount;
    NSInteger             bitmapBytesPerRow;
    
    // Get image width, height. We'll use the entire image.
    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHigh = CGImageGetHeight(inImage);
    
    // Declare the number of bytes per row. Each pixel in the bitmap in this
    // example is represented by 4 bytes; 8 bits each of red, green, blue, and
    // alpha.
    bitmapBytesPerRow   = (pixelsWide * 4);
    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
    
    // Use the generic RGB color space.
    //colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);  //deprecated
    colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL)
    {
        fprintf(stderr, "Error allocating color space\n");
        return NULL;
    }
    
    // Allocate memory for image data. This is the destination in memory
    // where any drawing to the bitmap context will be rendered.
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL)
    {
        fprintf (stderr, "Memory not allocated!");
        CGColorSpaceRelease( colorSpace );
        return NULL;
    }
    
    // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
    // per component. Regardless of what the source image format is
    // (CMYK, Grayscale, and so on) it will be converted over to the format
    // specified here by CGBitmapContextCreate.
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,      // bits per component
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
    if (context == NULL)
    {
        free (bitmapData);
        fprintf (stderr, "Context not created!");
    }
    
    // Make sure and release colorspace before returning
    CGColorSpaceRelease( colorSpace );
    
    return context;
}

- (UIImage *)dc_imageWithOriginalMode
{
    return [self imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

+ (UIImage *)dc_imageWithOriginalMode:(NSString *)imageName
{
    UIImage *imageSel = [UIImage imageNamed:imageName];
    return [imageSel dc_imageWithOriginalMode];
}

@end
