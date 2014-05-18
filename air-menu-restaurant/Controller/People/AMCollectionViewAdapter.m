//
//  AMCollectionViewAdapter.m
//  Air Menu
//
//  Created by Robert Lis on 03/05/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMCollectionViewAdapter.h"
#import "AMDataAwareReusableView.h"
#import "NSArray+Updates.h"

@implementation AMCollectionViewAdapter

-(id)dataItemForIndexPath:(NSIndexPath *)indexPath
{
    return [self.dataSource.data objectAtIndex:indexPath.row];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [(NSArray *)self.dataSource.data count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [[collectionView.identifierToCellClass allKeys] firstObject];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if(self.cellBlock)
    {
        self.cellBlock(cell, indexPath);
    }
    
    if([cell respondsToSelector:@selector(displayData:atIndexPath:)])
    {
        id dataItem = [self dataItemForIndexPath:indexPath];
        [(id <AMDataAwareReusableView>)cell displayData:dataItem atIndexPath:indexPath];
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view;
    
    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        NSString *identifier = [[collectionView.identifierToHeaderClass allKeys] firstObject];
        view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifier forIndexPath:indexPath];
        if(self.headerBlock) self.headerBlock(view, indexPath);
    }
    else if([kind isEqualToString:UICollectionElementKindSectionFooter])
    {
        NSString *identifier = [[collectionView.identifierToFooterClass allKeys] firstObject];
        view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifier forIndexPath:indexPath];
        if(self.footerBlock) self.footerBlock(view, indexPath);
    }
    
    return view;
}

-(void)adaptView:(UIView *)view
{
    UICollectionView *collectionView = (UICollectionView *) view;
    collectionView.dataSource = (id <UICollectionViewDataSource>) self.dataSource;
}

-(void)refreshView:(UIView *)view oldData:(id)oldData
{
    UICollectionView *collectionView = (UICollectionView *) view;
    [collectionView performBatchUpdates:^{
        [[oldData toRemove:self.dataSource.data] each:^(AMRestaurant *restaurant) {
            NSUInteger index = [oldData indexOfObject:restaurant];
            [collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]]];
        }];
        
        [[oldData toUpdate:self.dataSource.data] each:^(AMRestaurant *restaurant) {
            NSUInteger oldIndex = [oldData indexOfObject:restaurant];
            NSUInteger newIndex = [self.dataSource.data indexOfObject:restaurant];
            [collectionView moveItemAtIndexPath:[NSIndexPath indexPathForItem:oldIndex inSection:0]
                                         toIndexPath:[NSIndexPath indexPathForItem:newIndex inSection:0]];
        }];
        
        [[oldData toAdd:self.dataSource.data] each:^(AMRestaurant *restaurant) {
            NSUInteger index = [self.dataSource.data indexOfObject:restaurant];
            [collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]]];
        }];
        
    } completion:nil];
}

@end
