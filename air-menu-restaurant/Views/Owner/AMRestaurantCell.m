//
//  AMRestaurantCell.m
//  Air Menu
//
//  Created by Robert Lis on 14/04/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMRestaurantCell.h"
#import <UIView+AutoLayout/UIView+AutoLayout.h>
#import "AMLineSpacer.h"

@interface AMRestaurantCell()
@property (nonatomic, weak, readwrite) UILabel *textLabel;
@property (nonatomic, weak, readwrite) UILabel *subtitleLabel;
@property (nonatomic, weak, readwrite) UILabel *iconLabel;
@end

@interface JCRSlideCollectionViewCell() <UIScrollViewDelegate>
@end

@implementation AMRestaurantCell
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self setup];
    }
    return self;
}

-(void)setup
{
    [self setupTextLabel];
    [self setupSubtitleLabel];
    [self setupIconLabel];
    [self setupSpacer];
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *gestureRecogniser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    [self.contentView addGestureRecognizer:gestureRecogniser];
}

-(void)setupTextLabel
{
    UILabel *textLabel = [UILabel newAutoLayoutView];
    self.textLabel = textLabel;
    [self.contentView addSubview:self.textLabel];
    [self.textLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.contentView withOffset:20.0f];
    [self.textLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:10.0f];
    [self.textLabel autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.contentView];
    self.textLabel.font = [UIFont fontWithName:GOTHAM_LIGHT size:20.0];
    self.textLabel.textColor = [UIColor whiteColor];
}

-(void)setupSubtitleLabel
{
    UILabel *subtitleLabel = [UILabel newAutoLayoutView];
    self.subtitleLabel = subtitleLabel;
    [self.contentView addSubview:self.subtitleLabel];
    [self.subtitleLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.contentView withOffset:20.0f];
    [self.subtitleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.textLabel withOffset:20.0f];
    [self.subtitleLabel autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.contentView];
    [self.subtitleLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView];
    self.subtitleLabel.font = [UIFont fontWithName:GOTHAM_LIGHT size:15.0];
    self.subtitleLabel.textColor = [UIColor whiteColor];
}

-(void)setupIconLabel
{
    UILabel *iconLabel = [UILabel newAutoLayoutView];
    self.iconLabel = iconLabel;
    [self.contentView addSubview:iconLabel];
    self.iconLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    self.iconLabel.font = [UIFont fontWithName:ICON_FONT size:20.0];
    self.iconLabel.text = @"";
    [self.iconLabel autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.contentView withOffset:-20.0f];
    [self.iconLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.contentView];
}

-(void)didTap:(UITapGestureRecognizer *)recogniser
{
    if(self.tapBlock)
    {
        self.tapBlock(self.indexPath);
    }
}

-(void)setupSpacer
{
    AMLineSpacer *spacer = [AMLineSpacer newAutoLayoutView];
    [self.contentView addSubview:spacer];
    [spacer autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.contentView withOffset:20.0f];
    [spacer autoPinEdge:ALEdgeTrailing toEdge:ALEdgeLeading ofView:self.iconLabel withOffset:-20.0f];
    [spacer autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.textLabel withOffset:5.0f];
    [spacer autoSetDimension:ALDimensionHeight toSize:0.5];
    spacer.shouldFade = NO;
    spacer.alpha = 0.2;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
    
    CGFloat xOffset = [scrollView contentOffset].x;
    CGFloat alpha = xOffset / (320 / 2);
    if (xOffset < 0)
    {
        self.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:fabs(alpha)];
    }
    else if (xOffset > 0)
    {
        self.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:fabsf(alpha)];
    }
}

@end
