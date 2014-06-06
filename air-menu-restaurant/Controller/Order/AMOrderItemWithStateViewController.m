//
//  AMOrderItemWithState.m
//  Air Menu
//
//  Created by Robert Lis on 03/06/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMOrderItemWithStateViewController.h"
#import "AMCollectionView.h"
#import "AMOrderItemCell.h"
#import "UICollectionView+AMCollectionViewAdapter.h"
#import "AMDataSource.h"
#import "AMCollectionViewAdapter.h"
#import "AMCollectionView.h"

@interface AMOrderItemWithStateViewController() <UICollectionViewDelegate>
@property (nonatomic, readwrite) AMCollectionView *collectionView;
@property (nonatomic, readwrite) AMDataSource *dataSource;
@property (nonatomic, readwrite) NSArray *states;
@end

@implementation AMOrderItemWithStateViewController
-(id)initWithScopes:(NSArray *)scopes user:(AMUser *)user requiredState:(AMOrderItemState)state
{
    self = [super initWithScopes:scopes user:user];
    if(self)
    {
        self.stateToShow = state;
        self.states = @[@(AMOrderItemStateNew),
                        @(AMOrderItemStateApproved),
                        @(AMOrderItemStateBeingPrepared),
                        @(AMOrderItemStatePrepared)];
        [self setup];
    }
    return self;
}

-(void)setup
{
    self.view.backgroundColor = [UIColor clearColor];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    AMCollectionView *collectionView = [[AMCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView = collectionView;
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.collectionView];
    [self.collectionView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    self.collectionView.contentInset = UIEdgeInsetsMake(30, 0, 0, 0);
    self.collectionView.identifierToCellClass = @{@"order_cell" : [AMOrderItemCell class]};
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    __weak typeof(self) weakSelf = self;
    self.collectionView.refreshBlock = ^{
        [weakSelf.dataSource refresh];
    };
    
    self.dataSource = [[AMDataSource alloc] initWithBlock:^(Done block) {
        [[AMClient sharedClient] findOrderItemsOfCurrentUserWithState:self.stateToShow completion:^(NSArray *orderItems, NSError *error) {
            if(!error)
            {
                block(orderItems);
            }
            [self.collectionView didEndRefreshing];
        }];
    } destination:self.collectionView adapter:[self adapter]];
}

-(id <AMDataSourceAdapter>)adapter
{
    AMCollectionViewAdapter *adapter= [[AMCollectionViewAdapter alloc] init];
    adapter.cellBlock = ^(UICollectionViewCell *cell, NSIndexPath *indexPath){
        AMOrderItemCell *orderItemCell = (AMOrderItemCell *)cell;
        orderItemCell.rightBlock = ^() {[self transitionOrderItem:self.dataSource.data[indexPath.row]];};
    };
    return adapter;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.bounds.size.width, 80.0f);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

-(void)transitionOrderItem:(AMOrderItem *)orderItem
{
    AMOrderItemState nextState = [self nextState];
    [self transitionOrderItem:orderItem toNewState:nextState];
}

-(AMOrderItemState)nextState
{
    NSUInteger stateIndex = [self.states indexOfObject:@(self.stateToShow)];
    if(stateIndex != NSNotFound && ++stateIndex < self.states.count)
    {
        return [self.states[++stateIndex] unsignedIntegerValue];
    }
    else
    {
        return AMOrderItemStateNone;
    }
}

-(void)transitionOrderItem:(AMOrderItem *)orderItem toNewState:(AMOrderItemState)state
{
    [[AMClient sharedClient] updateOrderItem:orderItem withNewComment:nil newCount:nil newState:state completion:^(AMOrderItem *order, NSError *error) {
        [self.dataSource refresh];
    }];
}

@end
