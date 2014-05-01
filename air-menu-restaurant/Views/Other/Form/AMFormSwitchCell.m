//
//  AMFormSwitchCell.m
//  Air Menu
//
//  Created by Robert Lis on 29/04/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMFormSwitchCell.h"
#import "AMLineSpacer.h"

@implementation AMFormSwitchCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        AMLineSpacer *spacer = [AMLineSpacer newAutoLayoutView];
        [self.contentView addSubview:spacer];
        [spacer autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView withOffset:0.0];
        [spacer autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.contentView withOffset:30.0];
        [spacer autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.contentView withOffset:0];
        [spacer autoSetDimension:ALDimensionHeight toSize:0.5];
        spacer.alpha = 0.1;
        spacer.shouldFade = NO;
    }
    return self;
}

-(void)update
{
    [super update];
    self.textLabel.font = [UIFont fontWithName:GOTHAM_LIGHT size:18];
    self.textLabel.textColor = [UIColor whiteColor];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGRect textLabelFrame = self.textLabel.frame;
    textLabelFrame.origin.x += 15;
    self.textLabel.frame = textLabelFrame;
}

+(CGFloat)formDescriptorCellHeightForRowDescription:(XLFormRowDescriptor *)rowDescriptor
{
    return 60;
}

@end
