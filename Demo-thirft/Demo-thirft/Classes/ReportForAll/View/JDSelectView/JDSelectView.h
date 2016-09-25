//
//  JDSelectView.h
//
//  Created by DanaChu on 16/8/30.
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
@protocol JDSelectViewDelegate ;

@interface JDSelectView : UIView

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, weak) id<JDSelectViewDelegate > delegate;

@property (nonatomic) UIFont *itemFont; ///< font for button
@property (nonatomic) UIColor *itemColor; ///< color for button title
@property (nonatomic) UIColor *itemSelectedColor; ///< color for button title in selected state
@property (nonatomic) UIColor *indicatorColor; ///< color for indicator View

+ (instancetype)selectViewWithItems:(NSArray *)items
                           delegate:(id<JDSelectViewDelegate >)delegate;

- (void)tapViewWithIndex:(NSUInteger)index;

@end

@protocol JDSelectViewDelegate <NSObject>

- (void)selectView:(JDSelectView *)view didSelectedWithIndex:(NSUInteger)index;

@end
