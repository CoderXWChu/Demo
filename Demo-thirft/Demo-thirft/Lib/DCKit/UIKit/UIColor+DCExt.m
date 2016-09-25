//
//  UIColor+DCExt.m
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

#import "UIColor+DCExt.h"

@implementation UIColor (DCExt)

+ (UIColor *)dc_ColorWithHexRed:(NSUInteger)red green:(NSUInteger)green blue:(NSUInteger)blue alpha:(CGFloat)alpha
{
    return [[UIColor alloc] initWithHexRed:red green:green blue:blue alpha:alpha];
}

- (UIColor *)initWithHexRed:(NSUInteger)red green:(NSUInteger)green blue:(NSUInteger)blue alpha:(CGFloat)alpha
{
    return [self initWithRed:red / (0xff*1.0f) green:green / (0xff*1.0f) blue:blue / (0xff*1.0f) alpha:alpha];
}

+ (UIColor *)dc_ColorWithHexString:(NSString *)hexString
{
    return [[UIColor alloc] initWithHexString:hexString];
}

+ (UIColor *)dc_ColorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha
{
    return [[UIColor dc_ColorWithHexString:hexString] colorWithAlphaComponent:alpha];
}

- (UIColor *)initWithHexString:(NSString *)hexString
{
    NSUInteger rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    if ( [hexString hasPrefix:@"#"] ) {
        [scanner setScanLocation:1];
    }else
    if ( [hexString hasPrefix:@"0X"] ) {
        [scanner setScanLocation:2];
    }else
    if ( hexString.length == 6 ){
        [scanner setScanLocation:0];
    }
    [scanner scanHexInt:(unsigned int *)&rgbValue];
    
    return [self initWithHexNumber:rgbValue];
}

+ (UIColor *)dc_ColorWithHexNumber:(NSUInteger)hexNumber
{
    return [[UIColor alloc] initWithHexNumber:hexNumber];
}

- (UIColor *)initWithHexNumber:(NSUInteger)hexNumber
{
    CGFloat red   = ((hexNumber & 0xff0000) >> 16) / 255.0f;
    CGFloat green = ((hexNumber & 0x00ff00) >>  8) / 255.0f;
    CGFloat blue  = ((hexNumber & 0x0000ff)      ) / 255.0f;
    
    return [self initWithRed:red green:green blue:blue alpha:1.0f];
}


- (UIColor *)dc_ColorShiftBySaturation:(CGFloat)shiftValue
{
    CGFloat hue, saturation, brightness, alpha;
    
    [self getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    saturation += shiftValue;
    saturation = MIN(saturation, 1.0f);
    saturation = MAX(saturation, 0.0f);
    
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha];
}

- (UIColor *)dc_ColorShiftByBrightness:(CGFloat)shiftValue
{
    CGFloat hue, saturation, brightness, alpha;
    
    [self getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    brightness += shiftValue;
    brightness = MIN(brightness, 1.0f);
    brightness = MAX(brightness, 0.0f);
    
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha];
}

- (UIColor *)dc_ColorShiftByAlpha:(CGFloat)shiftValue
{
    CGFloat hue, saturation, brightness, alpha;
    
    [self getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    alpha += shiftValue;
    alpha = MIN(alpha, 1.0f);
    alpha = MAX(alpha, 0.0f);
    
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha];
}

- (UIColor *)dc_ColorShiftByHue:(CGFloat)shiftValue
{
    CGFloat hue, saturation, brightness, alpha;
    
    [self getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    hue += shiftValue;
    hue = MIN(hue, 1.0f);
    hue = MAX(hue, 0.0f);
    
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha];
}

// reference to http://stackoverflow.com/questions/970475/how-to-compare-uicolors
- (BOOL)dc_IsEqualToColor:(UIColor *)anotherColor
{
    if (self == anotherColor)
        return YES;
    
    CGColorSpaceRef colorSpaceRGB = CGColorSpaceCreateDeviceRGB();
    
    UIColor *(^convertColorToRGBSpace)(UIColor*) = ^(UIColor *color)
    {
        if (CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) == kCGColorSpaceModelMonochrome)
        {
            const CGFloat *oldComponents = CGColorGetComponents(color.CGColor);
            CGFloat components[4] = {oldComponents[0], oldComponents[0], oldComponents[0], oldComponents[1]};
            CGColorRef colorRef = CGColorCreate(colorSpaceRGB, components);
            UIColor *color = [UIColor colorWithCGColor:colorRef];
            CGColorRelease(colorRef);
            return color;
        }
        else
            return color;
    };
    
    UIColor *selfColor = convertColorToRGBSpace(self);
    anotherColor = convertColorToRGBSpace(anotherColor);
    CGColorSpaceRelease(colorSpaceRGB);
    
    return [selfColor isEqual:anotherColor];
}



- (CGFloat)dc_ColorHue
{
    CGFloat hue, saturation, brightness, alpha;
    [self getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    return hue;
}

- (CGFloat)dc_ColorAlpha
{
    CGFloat hue, saturation, brightness, alpha;
    [self getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    return alpha;
}

- (CGFloat)dc_ColorSaturation
{
    CGFloat hue, saturation, brightness, alpha;
    [self getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    return saturation;
}

- (CGFloat)dc_ColorBrightness
{
    CGFloat hue, saturation, brightness, alpha;
    [self getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    return brightness;
}

- (NSString *)dc_HexString
{
    const CGFloat *components = CGColorGetComponents(self.CGColor);
    
    CGFloat red = components[0];
    CGFloat greeen = components[1];
    CGFloat blue = components[2];
    
    return [NSString stringWithFormat:@"%02lX%02lX%02lX", lroundf(red * 255), lroundf(greeen * 255), lroundf(blue * 255)];
}

@end
