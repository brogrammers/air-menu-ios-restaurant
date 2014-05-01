//
//  AMStaffKindCell.h
//  Air Menu
//
//  Created by Robert Lis on 30/04/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMSlideCollectionViewCell.h"

typedef void (^ButtonAction)();

@interface AMStaffKindCell : AMSlideCollectionViewCell
@property (nonatomic, readonly, weak) UILabel *staffKindLabel;
@property (nonatomic, readonly, weak) UILabel *memberCountLabel;
@property (nonatomic, readonly, weak) UILabel *acceptsOrdersLabel;
@property (nonatomic, readonly, weak) UILabel *acceptsItemsLabel;
@property (nonatomic, copy) void (^addAction)();
-(void)setNumberOfMembers:(NSUInteger)numberOfMembers;
-(void)setAcceptsItems:(BOOL)acceptsItems;
-(void)setAcceptsOrders:(BOOL)acceptsOrders;
@end
