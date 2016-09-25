//
//  JDSelectView.m
//
//  Created by DanaChu on 16/8/30.
//  Copyright © 2016年 DanaChu. All rights reserved.
//

#import "JDSelectView.h"

@interface JDSelectView()

@property (weak, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIView *indicatorView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *indicatorWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *indicatorLeadingConstraint;

@end

@implementation JDSelectView

- (void)awakeFromNib
{
    [super awakeFromNib];

}

+ (instancetype)selectViewWithItems:(NSArray *)items delegate:(id<JDSelectViewDelegate>)delegate
{
    JDSelectView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    view.items = items;
    view.delegate = delegate;
    view.itemFont = [UIFont systemFontOfSize:17];
    view.itemColor = [UIColor whiteColor];
    view.backgroundColor = [UIColor lightTextColor];
    view.itemSelectedColor = [UIColor darkGrayColor];
    return view;
}

- (void)setItems:(NSArray *)items
{
    _items = items;
    NSUInteger count = items.count;
    
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
    
    for (NSUInteger i = 0 ; i < count; i++) {
        NSString *name = items[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        CGFloat width = SCREEN_WIDTH / count;
        button.frame = CGRectMake(i*width, 0, width, self.view.height);
        
        [button setTitle:name forState:UIControlStateNormal];
        [button setTitleColor:_itemColor forState:UIControlStateNormal];
        button.titleLabel.font = _itemFont;
        [button addTarget:self action:@selector(buttonTaped:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        if (i == 0) [self animationWithButton:button];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = 0;
    if (_items) {
        width = SCREEN_WIDTH / _items.count;
        self.indicatorView.width = width;
    }
    
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            view.frame = CGRectMake(view.tag*width, 0, width, self.view.height);
        }
    }
}


- (void)setIndicatorColor:(UIColor *)indicatorColor
{
    _indicatorColor = indicatorColor;
    self.indicatorView.backgroundColor = indicatorColor;
}

#pragma mark - action

- (void)buttonTaped:(UIButton *)button
{
    // animation
    [self animationWithButton:button];
    
    if (_delegate) {
        [_delegate selectView:self didSelectedWithIndex:(NSUInteger)(button.x / button.width)];
    }
}

- (void)animationWithButton:(UIButton *)button
{
    self.indicatorLeadingConstraint.constant = button.x;
    self.indicatorWidthConstraint.constant = button.width;
    [UIView animateWithDuration:0.2 animations:^{
        [self layoutIfNeeded];
    }];
    
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            view.backgroundColor = self.backgroundColor;
        }
    }
    
    button.backgroundColor = _itemSelectedColor;
}

- (void)tapViewWithIndex:(NSUInteger)index
{
    if (index >= _items.count) return;
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            if ((NSUInteger)(view.x / view.width) == index) {
                [self animationWithButton:(UIButton *)view];
            }
        }
    }
    
}

@end
