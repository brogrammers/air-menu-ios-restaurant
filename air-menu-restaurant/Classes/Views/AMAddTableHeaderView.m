//
//  AMHeaderAddTableHeaderView.m
//  Air Menu
//
//  Created by Robert Lis on 11/03/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMAddTableHeaderView.h"
#import <UIView+Autolayout.h>

@implementation AMAddTableHeaderView

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setup];
    }
    return self;
}

-(void)setup
{
    [self setupLabel];
    [self setupButton];
}

-(void)setupLabel
{
    UILabel *label = [UILabel newAutoLayoutView];
    self.label = label;
    [self.contentView addSubview:label];
    [self.label autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
}

-(void)setupButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    self.button = button;
    [self.button setTranslatesAutoresizingMaskIntoConstraints:YES];
    [self.contentView addSubview:self.button];
    [self.button autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.contentView];
    [self.button autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.contentView];
}

@end
