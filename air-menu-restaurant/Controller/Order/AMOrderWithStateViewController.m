//
//  AMOrderWithStateViewController.m
//  Air Menu
//
//  Created by Robert Lis on 03/06/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMOrderWithStateViewController.h"
#import "AMCollectionView.h"
#import "AMOrderCell.h"
#import "AMDataSource.h"
#import "AMCollectionViewAdapter.h"
#import "UICollectionView+AMCollectionViewAdapter.h"

@interface AMOrderWithStateViewController() <UICollectionViewDelegateFlowLayout>
@property (nonatomic, readwrite, weak) AMCollectionView *collectionView;
@property (nonatomic, readwrite, strong) AMDataSource *dataSource;
@end

@implementation AMOrderWithStateViewController
-(id)initWithScopes:(NSArray *)scopes user:(AMUser *)user requiredState:(AMOrderState)state
{
    self = [super initWithScopes:scopes user:user];
    if(self)
    {
        self.stateToShow = state;
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
    self.collectionView.identifierToCellClass = @{@"order_cell" : [AMOrderCell class]};
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.refreshBlock = ^{
        [self.dataSource refresh];
    };
    
    self.dataSource = [[AMDataSource alloc] initWithBlock:^(Done block) {
        [[AMClient sharedClient] findOrdersOfCurrentUserWithState:self.stateToShow completion:^(NSArray *orders, NSError *error) {
            if(!error)
            {
                block(orders);
            }
            [self.collectionView didEndRefreshing];
        }];
    } destination:self.collectionView adapter:[self adapter]];
}

-(id <AMDataSourceAdapter>)adapter
{
    AMCollectionViewAdapter *adapter= [[AMCollectionViewAdapter alloc] init];
    adapter.cellBlock = ^(UICollectionViewCell *cell, NSIndexPath *indexPath){
        AMOrderCell *orderCell = (AMOrderCell *) cell;
        orderCell.leftBlock = ^(){[self declineOrder:self.dataSource.data[indexPath.row]];};
        orderCell.rightBlock = ^(){[self acceptOrder:self.dataSource.data[indexPath.row]];};
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

-(void)acceptOrder:(AMOrder *)order
{
    
}

-(void)declineOrder:(AMOrder *)order
{
   
}

@end
