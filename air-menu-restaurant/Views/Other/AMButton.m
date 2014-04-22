//
//  AMButton.m
//  Air Menu
//
//  Created by Robert Lis on 14/04/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMButton.h"
#import <UIView+AutoLayout/UIView+AutoLayout.h>

@implementation AMButton
+ (AMButton *)button
{
    return [AMButton buttonWithType:UIButtonTypeCustom];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.titleEdgeInsets = UIEdgeInsetsMake(3, 20, 3, 20);
        self.titleLabel.font = [UIFont fontWithName:GOTHAM_LIGHT size:20];
    }
    return self;
}

- (CGSize) intrinsicContentSize
{
    CGSize s = [super intrinsicContentSize];
    return CGSizeMake(s.width + self.titleEdgeInsets.left + self.titleEdgeInsets.right,
                      s.height + self.titleEdgeInsets.top + self.titleEdgeInsets.bottom);
    
}

-(void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    [self.titleLabel sizeToFit];
    [self invalidateIntrinsicContentSize];
}

-(void)updateConstraints
{
    [super updateConstraints];
    [UIView autoSetPriority:UILayoutPriorityDefaultHigh
             forConstraints:^{
                 [self autoSetContentCompressionResistancePriorityForAxis:ALAxisHorizontal];
             }];
    
    [UIView autoSetPriority:UILayoutPriorityDefaultLow
             forConstraints:^{
                 [self autoSetContentHuggingPriorityForAxis:ALAxisHorizontal];
             }];
}

-(void)setFontSize:(CGFloat)fontSize
{
    self.titleLabel.font = [UIFont fontWithName:GOTHAM_LIGHT size:fontSize];
}

-(void)setTintColor:(UIColor *)tintColor
{
    [super setTintColor:tintColor];
    [self setTitleColor:tintColor forState:UIControlStateNormal];
}
@end
