//
//  AMOrderCell.m
//  Air Menu
//
//  Created by Robert Lis on 03/06/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMOrderCell.h"

@interface AMOrderCell()
@property (nonatomic, readwrite, weak) AMOrderCellView *dataView;
@end

@implementation AMOrderCell
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
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    UINib *nib = [UINib nibWithNibName:@"AMOrderCellView" bundle:[NSBundle mainBundle]];
    NSArray *views = [nib instantiateWithOwner:nil options:nil];
    self.dataView = [views first];
    self.dataView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.dataView];
    self.dataView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.dataView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
}

-(void)displayData:(id)item atIndexPath:(NSIndexPath *)indexPath
{
    AMOrder *order = item;
    self.dataView.tableNumber.text = order.tableNumber;
    self.dataView.whoOrdered.text = order.user.name;
}
@end
