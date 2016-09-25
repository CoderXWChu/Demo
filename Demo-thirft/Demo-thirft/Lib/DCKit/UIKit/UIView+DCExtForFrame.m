//
//  UIView+DCExtForFrame.m
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

#import "UIView+DCExtForFrame.h"

@implementation UIView (DCExtForFrame)

#pragma mark - Setters

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (void)setWidth:(CGFloat)width {
    CGSize size = self.size;
    size.width = width;
    self.size = size;
}

- (void)setHeight:(CGFloat)height {
    CGSize size = self.size;
    size.height = height;
    self.size = size;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (void)setX:(CGFloat)x {
    CGPoint origin = self.origin;
    origin.x = x;
    self.origin = origin;
}

- (void)setY:(CGFloat)y {
    CGPoint origin = self.origin;
    origin.y = y;
    self.origin = origin;
}

- (void)setLeft:(CGFloat)left {
    CGPoint origin = self.origin;
    origin.x = left;
    self.origin = origin;
}

- (void)setTop:(CGFloat)top {
    CGPoint origin = self.origin;
    origin.y = top;
    self.origin = origin;
}

- (void)setBottom:(CGFloat)bottom {
    CGPoint origin = self.origin;
    origin.y = bottom - self.height;
    self.origin = origin;
}

- (void)setRight:(CGFloat)right {
    CGPoint origin = self.origin;
    origin.x = right - self.width;
    self.origin = origin;
}

- (void)setTopLeft:(CGPoint)topLeft {
    self.origin = topLeft;
}

- (void)setTopRight:(CGPoint)topRight {
    CGPoint origin = self.origin;
    origin.x = topRight.x - self.width;
    origin.y = topRight.y;
    self.origin = origin;
}

- (void)setBottomLeft:(CGPoint)bottomLeft {
    CGPoint origin = self.origin;
    origin.x = bottomLeft.x;
    origin.y = bottomLeft.y - self.height;
    self.origin = origin;
}

- (void)setBottomRight:(CGPoint)bottomRight {
    CGPoint origin = self.origin;
    origin.x = bottomRight.x - self.width;
    origin.y = bottomRight.y - self.height;
    self.origin = origin;
}

#pragma mark - Getters

- (CGSize)size {
    return self.frame.size;
}

- (CGFloat)width {
    return self.size.width;
}

- (CGFloat)height {
    return self.size.height;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (CGFloat)x {
    return self.origin.x;
}

- (CGFloat)y {
    return self.origin.y;
}

- (CGFloat)left {
    return self.origin.x;
}

- (CGFloat)top {
    return self.origin.y;
}

- (CGFloat)bottom {
    return self.origin.y + self.size.height;
}

- (CGFloat)right {
    return self.origin.x + self.size.width;
}

- (CGPoint)topLeft {
    return CGPointMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame));
}

- (CGPoint)topRight {
    return CGPointMake(CGRectGetMaxX(self.frame), CGRectGetMinY(self.frame));
}

- (CGPoint)bottomRight {
    return CGPointMake(CGRectGetMaxX(self.frame), CGRectGetMaxY(self.frame));
}

- (CGPoint)bottomLeft {
    return CGPointMake(CGRectGetMinX(self.frame), CGRectGetMaxY(self.frame));
}


@end
