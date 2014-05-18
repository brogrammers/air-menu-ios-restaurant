//
//  AMMenuItemView.h
//  Air Menu C
//
//  Created by Robert Lis on 21/03/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AXRatingView/AXRatingView.h>
#import "AMSlideCollectionViewCell.h"

@interface AMMenuItemCell : AMSlideCollectionViewCell
@property (nonatomic, readonly, weak) UITextView *itemNameLabel;
@property (nonatomic, readonly, weak) UILabel *itemDescriptionLabel;
@property (nonatomic, readonly, weak) UILabel *itemPriceLabel;
@property (nonatomic, readonly, weak) AXRatingView *ratingView;
@property (nonatomic, readwrite, strong) NSIndexPath *indexPath;
-(void)setName:(NSString *)name;
-(void)setDescription:(NSString *)description;
-(void)setPrice:(NSString *)price;
@end
