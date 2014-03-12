//
//  AMRestaurantCell.m
//  air-menu-restaurant
//
//  Created by Robert Lis on 06/03/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import <UIView+AutoLayout/UIView+AutoLayout.h>
#import "AMRestaurantCell.h"

@interface AMRestaurantCell()
@end

@implementation AMRestaurantCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setupViews];
    }
    return self;
}

-(void)setupViews
{
    UILabel *label = [UILabel newAutoLayoutView];
    label.font = [UIFont fontWithName:GOTHAM_XLIGHT size:25];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    self.restaurantNameLabel = label;
    [self.contentView addSubview:label];
    [self.restaurantNameLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:0];
    [self.restaurantNameLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.contentView withOffset:0];
    [self.restaurantNameLabel autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.contentView withOffset:0];
    [self.restaurantNameLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView withOffset:0];
}
@end
