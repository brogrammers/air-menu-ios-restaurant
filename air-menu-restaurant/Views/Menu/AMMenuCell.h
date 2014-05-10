//
//  AMMenuCell.h
//  Air Menu
//
//  Created by Robert Lis on 06/05/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMSlideCollectionViewCell.h"
#import "AMButton.h"

@interface AMMenuCell : AMSlideCollectionViewCell
@property (nonatomic, readwrite, strong) NSIndexPath *indexPath;
@property (nonatomic, readonly, weak) UILabel *nameLabel;
@property (nonatomic, readonly, weak) AMButton *addButton;
@property (nonatomic, readonly, weak) UIView *container;
@property (nonatomic, copy) void (^tapBlock)(NSIndexPath *indexPath);
@property (nonatomic, copy) void (^addBlock)(NSIndexPath *indexPath);
-(void)setViewToContain:(UIView *)view;
-(void)setName:(NSString *)name;
-(void)setActive:(BOOL)active;
@end
