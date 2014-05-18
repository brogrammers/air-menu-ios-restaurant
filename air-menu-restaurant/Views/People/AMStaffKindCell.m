//
//  AMStaffKindCell.m
//  Air Menu
//
//  Created by Robert Lis on 30/04/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMStaffKindCell.h"
#import "UILabel+AttributesCopy.h"
#import "AMLineSpacer.h"
#import "AMButton.h"

@interface AMStaffKindCell()
@property (nonatomic, readwrite, weak) UILabel *staffKindLabel;
@property (nonatomic, readwrite, weak) UILabel *memberCountLabel;
@property (nonatomic, readwrite, weak) UILabel *acceptsOrdersLabel;
@property (nonatomic, readwrite, weak) UILabel *acceptsItemsLabel;
@property (nonatomic, readwrite, weak) AMButton *addMemberButton;
@end

@implementation AMStaffKindCell

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
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self setupStaffKindLabel];
    [self setupMembersCountLabel];
    [self setupAcceptsOrderItemsLabel];
    [self setupAcceptsOrdersLabel];
    [self setupButton];
}

-(void)setupStaffKindLabel
{
    UILabel *staffKindLabel = [UILabel newAutoLayoutView];
    self.staffKindLabel = staffKindLabel;
    [self.contentView addSubview:self.staffKindLabel];
    [self.staffKindLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.contentView withOffset:20.0f];
    [self.staffKindLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:10.0f];
    self.staffKindLabel.attributes = @{NSFontAttributeName : [UIFont fontWithName:GOTHAM_BOOK size:20.0f],
                                       NSForegroundColorAttributeName : [UIColor whiteColor]};
    
}

-(void)setupMembersCountLabel
{
    UILabel *membersCountLabel = [UILabel newAutoLayoutView];
    self.memberCountLabel = membersCountLabel;
    [self.contentView addSubview:self.memberCountLabel];
    [self.memberCountLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.contentView withOffset:20.0f];
    [self.memberCountLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.staffKindLabel withOffset:10.0f];
    self.memberCountLabel.attributes = @{NSFontAttributeName : [UIFont fontWithName:GOTHAM_BOOK size:12.0f],
                                         NSForegroundColorAttributeName : [UIColor whiteColor]};
    self.memberCountLabel.textAlignment = NSTextAlignmentLeft;
}

-(void)setupAcceptsOrderItemsLabel
{
    UILabel *acceptsOrderItemsLabel = [UILabel newAutoLayoutView];
    self.acceptsItemsLabel = acceptsOrderItemsLabel;
    [self.contentView addSubview:self.acceptsItemsLabel];
    [self.acceptsItemsLabel autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.contentView withOffset:-20.0f];
    [self.acceptsItemsLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.staffKindLabel withOffset:10.0f];
    self.acceptsItemsLabel.attributes = @{NSFontAttributeName : [UIFont fontWithName:GOTHAM_BOOK size:12.0f],
                                         NSForegroundColorAttributeName : [UIColor whiteColor]};
    self.acceptsItemsLabel.textAlignment = NSTextAlignmentRight;
}

-(void)setupAcceptsOrdersLabel
{
    UILabel *acceptsOrdersLabel = [UILabel newAutoLayoutView];
    self.acceptsOrdersLabel = acceptsOrdersLabel;
    [self.contentView addSubview:self.acceptsOrdersLabel];
    [self.acceptsOrdersLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:self.contentView];
    [self.acceptsOrdersLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.staffKindLabel withOffset:10.0f];
    self.acceptsOrdersLabel.attributes = @{NSFontAttributeName : [UIFont fontWithName:GOTHAM_BOOK size:12.0f],
                                           NSForegroundColorAttributeName : [UIColor whiteColor]};
    self.acceptsOrdersLabel.textAlignment = NSTextAlignmentCenter;
}

-(void)setupButton
{
    AMButton *newMemberButton = [AMButton button];
    self.addMemberButton = newMemberButton;
    self.addMemberButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.addMemberButton];
    [self.addMemberButton autoAlignAxis:ALAxisVertical toSameAxisOfView:self.contentView];
    [self.addMemberButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.acceptsItemsLabel withOffset:15.0f];
    [newMemberButton setTitle:@"add new member" forState:UIControlStateNormal];
    [newMemberButton setFontSize:12.0f];
    [newMemberButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)buttonTapped:(UIButton *)button
{
    if(self.addAction)
    {
        self.addAction();
    }
}

-(void)setNumberOfMembers:(NSUInteger)numberOfMembers
{
    [self.memberCountLabel setTextWithExistingAttributes:[@"members : " stringByAppendingString:@(numberOfMembers).description]];
}

-(void)setAcceptsItems:(BOOL)acceptsItems
{
    [self.acceptsItemsLabel setTextWithExistingAttributes:[@"items : " stringByAppendingString:(acceptsItems ? @"YES" : @"NO")]];
}

-(void)setAcceptsOrders:(BOOL)acceptsOrders
{
    [self.acceptsOrdersLabel setTextWithExistingAttributes:[@"orders : " stringByAppendingString:(acceptsOrders ? @"YES" : @"NO")]];
}

@end
