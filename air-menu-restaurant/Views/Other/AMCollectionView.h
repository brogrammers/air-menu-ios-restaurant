//
//  AMCollectionView.h
//  Air Menu
//
//  Created by Robert Lis on 21/04/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMCollectionView : UICollectionView
+(AMCollectionView *)collectionViewWithLayoutClass:(Class)layoutClass;
@property (nonatomic, readwrite, weak) UIView *headerView;
@property (nonatomic, copy) void (^refreshBlock)();
-(void)didEndRefreshing;
@end
