//
//  AMHeaderCellWithAdd.h
//  Air Menu
//
//  Created by Robert Lis on 14/04/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMHeaderCellWithAdd : UICollectionViewCell
@property (nonatomic, readonly, weak) UILabel *titleLabel;
@property (nonatomic, copy) void (^tapBlock)();
@property (nonatomic, copy) void (^touchBlock)();
@end
