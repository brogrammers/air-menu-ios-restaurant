//
//  AMOrderItemCell.m
//  Air Menu
//
//  Created by Robert Lis on 04/06/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMOrderItemCell.h"

@interface AMOrderItemCell()
@property (weak) UILabel *count;
@property (weak) UILabel *name;
@end

@implementation AMOrderItemCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *countLabel = [UILabel newAutoLayoutView];
        UILabel *nameItem = [UILabel newAutoLayoutView];
        [countLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.contentView withOffset:20.0f];
        [countLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:20.0f];
        [nameItem autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:20.0f];
        [nameItem autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.contentView withOffset:20.0f];
    }
    return self;
}

-(void)displayData:(id)item
       atIndexPath:(NSIndexPath *)indexPath
{
    AMOrderItem *orderItem = item;
    self.count.text = orderItem.count.description;
    self.name.text = orderItem.menuItem.name;
}

@end
