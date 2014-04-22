//
//  AMRestaurantCell.h
//  Air Menu
//
//  Created by Robert Lis on 14/04/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JCRSlideCollectionViewCell/JCRSlideCollectionViewCell.h>

@interface AMRestaurantCell : JCRSlideCollectionViewCell <UIScrollViewDelegate>
@property (nonatomic, weak, readonly) UILabel *textLabel;
@property (nonatomic, weak, readonly) UILabel *subtitleLabel;
@property (nonatomic, readwrite, strong) NSIndexPath *indexPath;
@property (nonatomic, copy) void (^tapBlock)(NSIndexPath *indexPath);
@end
