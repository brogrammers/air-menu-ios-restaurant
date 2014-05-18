//
//  AMBackgroundDecorationView.m
//  Air Menu
//
//  Created by Robert Lis on 29/04/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMBackgroundDecorationView.h"
#import "AMLineSpacer.h"

@implementation AMBackgroundDecorationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup];
    }
    return self;
}

-(void)setup
{
    AMLineSpacer *spacerTop = [AMLineSpacer newAutoLayoutView];
    AMLineSpacer *spacerBottom = [AMLineSpacer newAutoLayoutView];
    
    [self addSubview:spacerTop];
    [spacerTop autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self withOffset:20.0f];
    [spacerTop autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self withOffset:-20.0];
    [spacerTop autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:0.0f];
    [spacerTop autoSetDimension:ALDimensionHeight toSize:1.0];
    spacerTop.alpha = 1.0;
    spacerTop.shouldFade = NO;
    
    [self addSubview:spacerBottom];
    [spacerBottom autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self withOffset:20.0f];
    [spacerBottom autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self withOffset:-20.0];
    [spacerBottom autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:0.0f];
    [spacerBottom autoSetDimension:ALDimensionHeight toSize:1.0];
    spacerBottom.alpha = 1.0;
    spacerBottom.shouldFade = NO;
}
@end
