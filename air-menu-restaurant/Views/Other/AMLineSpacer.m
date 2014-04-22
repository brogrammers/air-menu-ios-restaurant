//
//  AMLineSpacer.m
//  Air Menu C
//
//  Created by Robert Lis on 19/03/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMLineSpacer.h"

@implementation AMLineSpacer

-(void)drawRect:(CGRect)rect
{
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:rect];
    [self.tintColor setStroke];
    [self.tintColor setFill];
    [bezierPath fill];
    [bezierPath stroke];
}

@end
