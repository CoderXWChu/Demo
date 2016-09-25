//
//  UIView+DCExtForOperation.m
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

#import "UIView+DCExtForOperation.h"
#import <objc/runtime.h>

static char nametag_key;

@implementation UIView (DCExtForOperation)


- (void)setNameTag:(NSString *)nameTag
{
    objc_setAssociatedObject(self, &nametag_key, nameTag, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSString *)nameTag
{
    return objc_getAssociatedObject(self, &nametag_key);
}

- (UIView *)viewWithNameTag:(NSString *)aName
{
    if (!aName) return nil;
    if ([[self nameTag] isEqualToString:aName])
        return self;
    for (UIView *subview in self.subviews) {
        UIView *resultView = [subview dc_viewNamed:aName];
        if (resultView) return  resultView;
    }
    
    return nil;
}
- (UIView *)dc_viewNamed:(NSString *)aName
{
    if (!aName) return nil;
    return [self viewWithNameTag:aName];
}


- (void) dc_setCornerRadius : (CGFloat) radius {
    self.layer.cornerRadius = radius;
}

- (void) dc_setBorder : (UIColor *) color width : (CGFloat) width  {
    self.layer.borderColor = [color CGColor];
    self.layer.borderWidth = width;
}

- (void) dc_setShadow : (UIColor *)color opacity:(CGFloat)opacity offset:(CGSize)offset blurRadius:(CGFloat)blurRadius {
    CALayer *l = self.layer;
    l.shadowColor = [color CGColor];
    l.shadowOpacity = opacity;
    l.shadowOffset = offset;
    l.shadowRadius = blurRadius;
}

- (NSString *)dc_XMLWithViewComponent
{
    if ([self isKindOfClass:[UITableViewCell class]]) return @"";
    NSMutableString *xml = [NSMutableString string];
    [xml appendFormat:@"<%@ frame=\"%@\"", self.class, NSStringFromCGRect(self.frame)];
    if (!CGPointEqualToPoint(self.bounds.origin, CGPointZero)) {
        [xml appendFormat:@" bounds=\"%@\"", NSStringFromCGRect(self.bounds)];
    }
    if ([self isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scroll = (UIScrollView *)self;
        if (!UIEdgeInsetsEqualToEdgeInsets(UIEdgeInsetsZero, scroll.contentInset)) {
            [xml appendFormat:@" contentInset=\"%@\"", NSStringFromUIEdgeInsets(scroll.contentInset)];
        }
    }
    if (self.subviews.count == 0) {
        [xml appendString:@" />"];
        return xml;
    } else {
        [xml appendString:@">"];
    }
    for (UIView *child in self.subviews) {
        NSString *childXml = [child dc_XMLWithViewComponent];
        [xml appendString:childXml];
    }
    [xml appendFormat:@"</%@>", self.class];
    
    return xml;
}

@end
