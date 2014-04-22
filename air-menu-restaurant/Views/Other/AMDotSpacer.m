//
//  AMDotSpacer.m
//  Air Menu C
//
//  Created by Robert Lis on 19/03/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMDotSpacer.h"

@implementation AMDotSpacer

-(id)init
{
    self = [super init];
    if(self)
    {
        self.dotSpacing = 2.0;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGFloat dotSize = MIN(rect.size.height, rect.size.width);
    CGFloat totalSize = dotSize + self.dotSpacing;
    int count = rect.size.width / totalSize;
    CGFloat currentXOffset = dotSize / 2;
    CGFloat y = rect.size.height / 2;
    
    for(int i = 0; i < count; i++)
    {
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(currentXOffset,y)
                                                                  radius:dotSize / 2
                                                              startAngle:0
                                                                endAngle:DEGREES_TO_RADIANS(360)
                                                               clockwise:NO];
        
        [self.tintColor setFill];
        [bezierPath fill];
        currentXOffset += totalSize;
    }
}

@end
