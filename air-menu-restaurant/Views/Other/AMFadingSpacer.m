//
//  AMFadingSpacer.m
//  Air Menu C
//
//  Created by Robert Lis on 19/03/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMFadingSpacer.h"

@implementation AMFadingSpacer

-(id)init
{
    self = [super init];
    if(self)
    {
        self.fadePercentage = 0.4;
        self.tintColor = [UIColor whiteColor];
        self.shouldFade = YES;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];

    if(self.shouldFade)
    {
        CAGradientLayer *gradientLayer;
        
        if (!self.layer.mask)
        {
            gradientLayer = [CAGradientLayer layer];
            gradientLayer.startPoint = CGPointMake(0.0, 0.5);
            gradientLayer.endPoint = CGPointMake(1.0, 0.5);
            self.layer.mask = gradientLayer;
        }
        else
        {
            gradientLayer = (CAGradientLayer *) self.layer.mask;
        }
        
        CGColorRef transparent = [UIColor colorWithWhite:0 alpha:0].CGColor;
        CGColorRef opaque =  [UIColor colorWithWhite:0 alpha:1].CGColor;
        gradientLayer.frame = self.bounds;
        gradientLayer.colors = @[(__bridge id) transparent, (__bridge id) opaque, (__bridge id) opaque, (__bridge id) transparent];
        gradientLayer.locations =  @[[NSNumber numberWithFloat:0.0],
                                     [NSNumber numberWithFloat:self.fadePercentage],
                                     [NSNumber numberWithFloat:1.0 - self.fadePercentage],
                                     [NSNumber numberWithFloat:1.0]];
    }
    else
    {
        self.layer.mask = nil;
    }
}
@end
