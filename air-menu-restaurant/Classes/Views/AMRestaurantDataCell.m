//
//  AMRestaurantDataCell.m
//  air-menu-restaurant
//
//  Created by Robert Lis on 24/02/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMRestaurantDataCell.h"
#import <UIView+AutoLayout/UIView+AutoLayout.h>

@interface AMRestaurantDataCell()
@property (nonatomic, weak, readwrite) UILabel *headerLabel;
@property (nonatomic, weak, readwrite) UILabel *subheaderLabel;
@property (nonatomic, weak, readwrite) UIView *containerView;
@property (nonatomic, weak, readwrite) UIView *parent;
@property (nonatomic, weak, readwrite) UIView *border;
@end

@implementation AMRestaurantDataCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(self.bounds, 3, 0) cornerRadius:20].CGPath;
}

-(void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    if(indexPath.row == 0)
    {
        self.layer.shadowColor = nil;
        self.layer.shadowOffset = CGSizeZero;
        self.layer.shadowRadius = 0;
        self.layer.shadowOpacity = 1;
    }
    else
    {
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, -3);
        self.layer.shadowRadius = 3;
        self.layer.shadowOpacity = 0.6;
    }
}

-(void)setup
{
    [self createParent];
    [self createHeader];
    [self createSubheader];
    [self createBorder];
    [self createContainer];
    self.backgroundColor = [UIColor clearColor];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

-(void)createParent
{
    UIView *parent = [UIView newAutoLayoutView];
    self.parent = parent;
    self.parent.backgroundColor = [UIColor colorWithRed:53/255.0f green:84/255.0f blue:100/255.0f alpha:1.0];
    self.parent.layer.cornerRadius = 20;
    [self.contentView addSubview:self.parent];
    [self.parent autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
}

-(void)createHeader
{
    UILabel *label = [UILabel newAutoLayoutView];
    self.headerLabel = label;
    self.headerLabel.font = [UIFont fontWithName:GOTHAM_LIGHT size:20.0f];
    self.headerLabel.textAlignment = NSTextAlignmentRight;
    self.headerLabel.textColor = [UIColor whiteColor];
    [self.parent addSubview:self.headerLabel];
    [self.headerLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.parent withOffset:0];
    [self.headerLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.parent withOffset:0];
    [self.headerLabel autoPinEdge:ALEdgeTrailing toEdge:ALEdgeRight ofView:self.parent withOffset:-20];
    [self.headerLabel autoSetDimension:ALDimensionHeight toSize:60];
}

-(void)createSubheader
{
    UILabel *label = [UILabel newAutoLayoutView];
    self.subheaderLabel = label;
    self.subheaderLabel.font = [UIFont fontWithName:ICON_FONT size:30];
    self.subheaderLabel.text = @"";
    self.subheaderLabel.textColor = [UIColor colorWithRed:34.0f/255.0f green:54.0f/255.0f blue:64.0f/255.0f alpha:1.0];
    [self.parent addSubview:self.subheaderLabel];
    [self.subheaderLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.parent withOffset:20];
    [self.parent addConstraint:[NSLayoutConstraint constraintWithItem:self.subheaderLabel
                                                            attribute:NSLayoutAttributeCenterY
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.headerLabel
                                                            attribute:NSLayoutAttributeCenterY
                                                           multiplier:1.0
                                                             constant:0]];
    
}

-(void)createBorder
{
    UIView *border = [UIView newAutoLayoutView];
    self.border = border;
    self.border.backgroundColor = [UIColor colorWithRed:40.0/255.0f green:64.0f/255.0f blue:76.0f/255.0f alpha:1];
    [self.parent addSubview:self.border];
    [self.border autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.parent];
    [self.border autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.parent];
    [self.border autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.headerLabel];
    [self.border autoSetDimension:ALDimensionHeight toSize:1];
}

-(void)createContainer
{
    UIView *containerView = [UIView newAutoLayoutView];
    self.containerView = containerView;
    [self.contentView addSubview:self.containerView];
    [self.containerView autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.parent withOffset:0];
    [self.containerView autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.parent withOffset:0];
    [self.containerView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.parent withOffset:0];
    [self.containerView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.headerLabel];
}

@end
