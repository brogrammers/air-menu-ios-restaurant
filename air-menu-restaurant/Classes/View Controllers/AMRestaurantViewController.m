//
//  AMRestaurantViewController.m
//  air-menu-restaurant
//
//  Created by Robert Lis on 24/02/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import <UIView+AutoLayout/UIView+AutoLayout.h>
#import "AMRestaurantViewController.h"
#import "UIViewController+AMTwinViewController.h"
#import "AMRestaurantDataCell.h"
#import "AMSquishyLayout.h"

@interface AMRestaurantViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, strong) AMSquishyLayout *horizontalLayout;
@property (nonatomic, strong) AMSquishyLayout *verticalLayout;
@end

@implementation AMRestaurantViewController

#pragma mark - View Controller lifecycle

-(void)viewDidLoad
{
    [self createCollectionView];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[AMRestaurantDataCell class] forCellWithReuseIdentifier:@"data_cell"];
    self.view.backgroundColor = [UIColor clearColor];
    self.collectionView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tapGestureRecogniser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    [self.collectionView addGestureRecognizer:tapGestureRecogniser];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self adjustLayout];
    [self.collectionView.collectionViewLayout invalidateLayout];
}

-(void)createCollectionView
{
    AMSquishyLayout *layoutOne = [[AMSquishyLayout alloc] init];
    self.horizontalLayout = layoutOne;
    self.horizontalLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    AMSquishyLayout *layoutTwo = [[AMSquishyLayout alloc] init];
    self.verticalLayout = layoutTwo;
    self.verticalLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.verticalLayout];
    [collectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.collectionView = collectionView;
    [self.view addSubview:collectionView];
    [self.collectionView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
}

-(void)adjustLayout
{
    self.horizontalLayout.itemSize = CGSizeMake(310, self.collectionView.bounds.size.height - 60);
    self.horizontalLayout.sectionInset = UIEdgeInsetsMake(40, 5, 20, 5);
    self.horizontalLayout.minimumInteritemSpacing = 20;
    self.horizontalLayout.minimumLineSpacing = 20;
    self.verticalLayout.itemSize = CGSizeMake(310, self.collectionView.bounds.size.height - 60);
    self.verticalLayout.sectionInset = UIEdgeInsetsMake(40, 5, 20, 5);
    self.verticalLayout.minimumInteritemSpacing = 20;
    self.verticalLayout.minimumLineSpacing = -self.collectionView.bounds.size.height + 140;
}


-(void)didTap:(UITapGestureRecognizer *)recogniser
{
    if(recogniser.state == UIGestureRecognizerStateEnded)
    {
        if(self.collectionView.collectionViewLayout == self.horizontalLayout)
        {
            [self.twinViewController shrinkFirstViewControllerWithAnimationBlock:nil completion:nil];            
            self.verticalLayout.isTransitoning = YES;
            [self.collectionView setCollectionViewLayout:self.verticalLayout animated:YES completion:^(BOOL finished) {
                self.verticalLayout.isTransitoning = NO;
            }];
        }
        else
        {
            [self.twinViewController expandFirstViewControllerWithAnimationBlock:nil completion:nil];
            self.horizontalLayout.isTransitoning = YES;
            [self.collectionView setCollectionViewLayout:self.horizontalLayout animated:YES completion:^(BOOL finished) {
                self.verticalLayout.isTransitoning = NO;
            }];
        }
    }
}

#pragma mark - Collection View Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AMRestaurantDataCell *cell = (AMRestaurantDataCell *) [collectionView dequeueReusableCellWithReuseIdentifier:@"data_cell" forIndexPath:indexPath];
    cell.headerLabel.text = @[@"performance", @"menu", @"settings", @"people"][indexPath.row];
    cell.indexPath = indexPath;
    return cell;
}

@end
