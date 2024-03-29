//
//  AMRestaurantViewController.m
//  air-menu-restaurant
//
//  Created by Robert Lis on 24/02/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import <UIView+AutoLayout/UIView+AutoLayout.h>
#import "AMRestaurantCardsViewController.h"
#import "UIViewController+AMTwinViewController.h"
#import "AMRestaurantDataCell.h"
#import "AMSquishyLayout.h"

@interface AMRestaurantCardsViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, strong) AMSquishyLayout *horizontalLayout;
@property (nonatomic, strong) AMSquishyLayout *verticalLayout;
@end

@implementation AMRestaurantCardsViewController

#pragma mark - View Controller lifecycle

-(void)viewDidLoad
{
    [self createCollectionView];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.panGestureRecognizer.maximumNumberOfTouches = 1;
    self.collectionView.panGestureRecognizer.minimumNumberOfTouches = 1;
    self.collectionView.clipsToBounds = NO;
    self.view.clipsToBounds = NO;
    [self.collectionView registerClass:[AMRestaurantDataCell class] forCellWithReuseIdentifier:@"data_cell"];
    self.view.backgroundColor = [UIColor clearColor];
    self.collectionView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tapGestureRecogniser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    [self.collectionView addGestureRecognizer:tapGestureRecogniser];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
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

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return gestureRecognizer.numberOfTouches == 1;
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
    cell.background = @[[UIColor colorWithRed:53.0f/255.0f green:84.0f/255.0f blue:100.0f/255.0f alpha:1.0],
                        [UIColor colorWithRed:58.0f/255.0f green:147/255.0f blue:221/255.0f alpha:1.0],
                        [UIColor colorWithRed:251.0f/255.0f green:165.0f/255.0f blue:63.0f/255.0f alpha:1.0],
                        [UIColor colorWithRed:27.0f/255.0f green:117.0f/255.0f blue:158.0f/255.0f alpha:1.0]][indexPath.row];
    cell.indexPath = indexPath;
    cell.subheaderLabel.text = @[@"", @"", @"", @""][indexPath.row];
    cell.subheaderLabel.textAlignment = NSTextAlignmentCenter;
    if(indexPath.row == 3 || indexPath.row == 2)
    {
        cell.subheaderLabel.font = [UIFont fontWithName:ICON_FONT size:34];
    }
    return cell;
}

@end
