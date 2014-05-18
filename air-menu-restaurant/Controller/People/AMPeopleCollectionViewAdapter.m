//
//  AMPeopleCollectionViewAdapter.m
//  Air Menu
//
//  Created by Robert Lis on 04/05/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMPeopleCollectionViewAdapter.h"
#import "AMStaffKindCell+ModelExtension.h"
#import "AMStaffMemberCell+ModelExtension.h"

@implementation AMPeopleCollectionViewAdapter

-(id)dataItemForIndexPath:(NSIndexPath *)indexPath
{
    NSArray *staffKinds = self.dataSource.data;
    AMStaffKind *staffKind = staffKinds[indexPath.section];
    return staffKind.members[indexPath.item];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSArray *staffKinds = self.dataSource.data;
    return staffKinds.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *staffKinds = self.dataSource.data;
    AMStaffKind *staffKind = staffKinds[section];
    return staffKind.members.count;
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    AMStaffKind *fromStaffKind = self.dataSource.data[fromIndexPath.section];
    AMStaffKind *toStaffKind = self.dataSource.data[toIndexPath.section];
    NSMutableArray *fromStaffMembers = [fromStaffKind.members mutableCopy];
    NSMutableArray *toStaffMembers = [toStaffKind.members mutableCopy];
    if(fromStaffKind == toStaffKind) fromStaffMembers = toStaffMembers;
    AMStaffMember *member = fromStaffMembers[fromIndexPath.item];
    [fromStaffMembers removeObjectAtIndex:fromIndexPath.item];
    [fromStaffKind setValue:fromStaffMembers forKey:@"members"];
    [toStaffMembers insertObject:member atIndex:toIndexPath.item];
    [toStaffKind setValue:toStaffMembers forKey:@"members"];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view = [super collectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
    if([view isKindOfClass:[AMStaffKindCell class]])
    {
        NSArray *staffKinds = self.dataSource.data;
        AMStaffKind *staffKind = staffKinds[indexPath.section];
        [(AMStaffKindCell *)view displayData:staffKind atIndexPath:indexPath];
    }
    return view;
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath didMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    return YES;
}

-(void)refreshView:(UIView *)view oldData:(id)oldData
{
    UICollectionView *collectionView = (UICollectionView *)view;
    [collectionView reloadData];
}
@end
