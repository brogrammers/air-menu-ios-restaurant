//
//  AMDeviceCell.m
//  Air Menu
//
//  Created by Robert Lis on 06/06/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMDeviceCell.h"
#import "UILabel+AttributesCopy.h"

@interface AMDeviceCell()
@property (nonatomic, readwrite, weak) UILabel *name;
@property (nonatomic, readwrite, weak) UILabel *platform;
@property (nonatomic, readwrite, weak) UILabel *uuid;
@end

@implementation AMDeviceCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupName];
        [self setupPlatform];
        [self setupUUID];
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)setupName
{
    UILabel *label = [UILabel newAutoLayoutView];
    [self.contentView addSubview:label];
    [label autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.contentView withOffset:20.0f];
    [label autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:20.0f];
    label.attributes = @{ NSFontAttributeName : [UIFont fontWithName:GOTHAM_BOOK size:15.0f],
                          NSForegroundColorAttributeName : [UIColor whiteColor]};
    self.name = label;
}

-(void)setupPlatform
{
    UILabel *label = [UILabel newAutoLayoutView];
    [self.contentView addSubview:label];
    [label autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.contentView withOffset:-20.0f];
    [label autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:20.0f];
    label.attributes = @{ NSFontAttributeName : [UIFont fontWithName:GOTHAM_BOOK size:15.0f],
                           NSForegroundColorAttributeName : [UIColor whiteColor]};
    self.platform = label;
}

-(void)setupUUID
{
    UILabel *label = [UILabel newAutoLayoutView];
    [self.contentView addSubview:label];
    [label autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.name withOffset:10.0f];
    [label autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.contentView withOffset:20.0f];
    label.attributes = @{ NSFontAttributeName : [UIFont fontWithName:GOTHAM_BOOK size:10.0f],
                          NSForegroundColorAttributeName : [UIColor whiteColor]};
    self.uuid = label;
}

-(void)displayData:(id)item
       atIndexPath:(NSIndexPath *)indexPath
{
    AMDevice *device = item;
    [self.name setTextWithExistingAttributes:device.name];
    [self.platform setTextWithExistingAttributes:device.platform];
    [self.uuid setTextWithExistingAttributes:device.uuid];
}
@end
