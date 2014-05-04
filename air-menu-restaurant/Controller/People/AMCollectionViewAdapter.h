//
//  AMCollectionViewAdapter.h
//  Air Menu
//
//  Created by Robert Lis on 03/05/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMDataSource.h"
#import "UICollectionView+AMCollectionViewAdapter.h"

typedef void (^CellCustomizationBlock)(UICollectionViewCell *cell, NSIndexPath *indexPath);
typedef void (^HeaderCustomiztionBlock)(UICollectionReusableView *heaeder, NSIndexPath *indexPath);
typedef void (^FooterCustomiztionBlock)(UICollectionReusableView *footer, NSIndexPath *indexPath);

@interface AMCollectionViewAdapter : NSObject <UICollectionViewDataSource, AMDataSourceAdapter>
@property (nonatomic, readwrite, weak) AMDataSource *dataSource;
@property (nonatomic, readwrite, strong) CellCustomizationBlock cellBlock;
@property (nonatomic, readwrite, strong) HeaderCustomiztionBlock headerBlock;
@property (nonatomic, readwrite, strong) FooterCustomiztionBlock footerBlock;
-(id)dataItemForIndexPath:(NSIndexPath *)indexPath;
@end
