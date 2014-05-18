//
//  AMUserView.m
//  Air Menu C
//
//  Created by Robert Lis on 19/03/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMUserView.h"
#import <UIView+AutoLayout/UIView+AutoLayout.h>

@interface AMUserView()
@property (nonatomic, readwrite, weak) UIImageView *userPicture;
@property (nonatomic, readwrite, weak) UILabel *nameLabel;
@property (nonatomic, readwrite, weak) UILabel *typeLabel;
@property (nonatomic, readwrite, weak) UIView *spacer;
@end


@implementation AMUserView

#pragma mark - Lifecycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.userPicture.layer.cornerRadius = self.userPicture.layer.bounds.size.width / 2;
}

#pragma mark - Spacer

-(void)setup
{
    [self setupUserPicture];
  //  [self setupSpacer];
    [self setupNameLabel];
  //  [self setupTypeLabel];
}

-(void)setupUserPicture
{
    UIImageView *userPicture = [UIImageView newAutoLayoutView];
    self.userPicture = userPicture;
    [self addSubview:self.userPicture];
    [self.userPicture autoSetDimension:ALDimensionHeight toSize:85.0f];
    [self.userPicture autoSetDimension:ALDimensionWidth toSize:85.0f];
    [self.userPicture autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self withOffset:20.0f];
    [self.userPicture autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self];
    self.userPicture.layer.masksToBounds = YES;
    self.userPicture.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:1.0].CGColor;
    self.userPicture.layer.borderWidth = 3.0f;
}

-(void)setupSpacer
{
    UIView *spacer = [UIView newAutoLayoutView];
    spacer.backgroundColor = [UIColor whiteColor];
    self.spacer = spacer;
    [self addSubview:self.spacer];
    [self.spacer autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.userPicture withOffset:20.0f];
    [self.spacer autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.userPicture];
    [self.spacer autoSetDimension:ALDimensionHeight toSize:1.0];
}

-(void)setupNameLabel
{
    UILabel *nameLabel = [UILabel newAutoLayoutView];
    self.nameLabel = nameLabel;
    [self addSubview:self.nameLabel];
    //[@[self.nameLabel, self.spacer] autoAlignViewsToEdge:ALEdgeLeading];
    //[self.nameLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.spacer withOffset:-10.f];
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.font = [UIFont fontWithName:GOTHAM_LIGHT size:27.0f];
   // [self.spacer autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.nameLabel withOffset:0];
    [self.nameLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.userPicture withOffset:0.0];
    [self.nameLabel autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self withOffset:-20.0f];
    [self.nameLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self];
    [self.nameLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
}

-(void)setupTypeLabel
{
    UILabel *typeLabel = [UILabel newAutoLayoutView];
    self.typeLabel = typeLabel;
    [self addSubview:typeLabel];
    [@[self.typeLabel, self.spacer] autoAlignViewsToEdge:ALEdgeLeading];
    [self.typeLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.spacer withOffset:10.0f];
    self.typeLabel.font = [UIFont fontWithName:GOTHAM_MEDIUM size:15.0f];
    self.typeLabel.textColor = [UIColor whiteColor];
}
@end








