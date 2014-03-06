//
//  AMRestaurantDataCell.h
//  air-menu-restaurant
//
//  Created by Robert Lis on 24/02/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMRestaurantDataCell : UICollectionViewCell
@property (nonatomic, weak, readonly) UILabel *headerLabel;
@property (nonatomic, weak, readonly) UILabel *subheaderLabel;
@property (nonatomic, weak, readonly) UIView *containerView;
@property (nonatomic, strong, readwrite) NSIndexPath *indexPath;
@property (nonatomic, strong, readwrite) UIColor *background;
@end
