//
//  AMOrderCell.h
//  Air Menu
//
//  Created by Robert Lis on 03/06/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMSlideCollectionViewCell.h"
#import "AMDataAwareReusableView.h"
#import "AMOrderCellView.h"
@interface AMOrderCell : AMSlideCollectionViewCell <AMDataAwareReusableView>
@property (nonatomic, readonly, weak) AMOrderCellView *dataView;
@end
