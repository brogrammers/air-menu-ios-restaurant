//
//  UICollectionView+AMCollectionViewAdapter.h
//  Air Menu
//
//  Created by Robert Lis on 04/05/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionView (AMCollectionViewAdapter)
@property (nonatomic, readwrite, strong) NSDictionary *identifierToCellClass;
@property (nonatomic, readwrite, strong) NSDictionary *identifierToHeaderClass;
@property (nonatomic, readwrite, strong) NSDictionary *identifierToFooterClass;
@end
