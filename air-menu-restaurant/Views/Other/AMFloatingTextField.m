//
//  AMFloatingTextField.m
//  Air Menu
//
//  Created by Robert Lis on 15/04/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMFloatingTextField.h"

@implementation AMFloatingTextField

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.floatingLabel sizeToFit];
    CGRect labelFrame = self.floatingLabel.frame;
    labelFrame.origin.x = 10;
    labelFrame.origin.y += 2;
    self.floatingLabel.frame = labelFrame;
}

- (CGRect)textRectForBounds:(CGRect)bounds;
{
    return CGRectInset([super textRectForBounds:bounds], 10.f, 0.0f);
}

- (CGRect)editingRectForBounds:(CGRect)bounds;
{
    return CGRectInset([super editingRectForBounds:bounds], 10.f, 0.0f);
}
@end
