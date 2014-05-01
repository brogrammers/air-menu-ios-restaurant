//
//  AMBackgroundDecorationView.m
//  Air Menu
//
//  Created by Robert Lis on 29/04/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMBackgroundDecorationView.h"

@implementation AMBackgroundDecorationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
