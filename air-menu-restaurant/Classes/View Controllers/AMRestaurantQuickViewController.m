//
//  AMRestaurantQuickViewController.m
//  air-menu-restaurant
//
//  Created by Robert Lis on 27/02/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import <UIView+AutoLayout/UIView+AutoLayout.h>
#import "AMRestaurantQuickViewController.h"
#import "AMPannableTabBarViewController.h"

@interface AMRestaurantQuickViewController ()
@property (nonatomic, weak, readwrite) UILabel *nameLabel;
@property (nonatomic, weak, readwrite) UILabel *titleLabel;
@property (nonatomic, weak, readwrite) UIView *spacing;
@property (nonatomic, weak, readwrite) UICollectionView *quickViewItemsHeadersCollectionView;
@property (nonatomic, weak, readwrite) AMPannableTabBarViewController *quickViewItemsController;
@property (nonatomic, weak, readwrite) UIPageControl *quickViewItemsPageControl;
@end

@implementation AMRestaurantQuickViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
    [self createLabel];
    [self createTitle];
    [self createSpacing];
    [self createQuickViewItemsPageControl];
    [self createQuickViewItemsHeadersCollectionView];
    [self createQuickViewItemsViewController];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didChangeIndex:)
                                                 name:kAMPannableTabBarViewControllerDidMoveToIndex
                                               object:nil];
}

-(void)createLabel
{
    UILabel *label = [UILabel newAutoLayoutView];
    self.nameLabel = label;
    [self.view addSubview:label];
    [self.nameLabel autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.view withOffset:-50];
    [self.nameLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view withOffset:33];
    self.nameLabel.text = @"Nandos";
    self.nameLabel.font = [UIFont fontWithName:GOTHAM_LIGHT size:40];
    self.nameLabel.textColor = [UIColor whiteColor];
}

-(void)createTitle
{
    UILabel *label = [UILabel newAutoLayoutView];
    self.titleLabel = label;
    [self.view addSubview:label];
    self.titleLabel.text = @"RESTAURANT";
    self.titleLabel.font = [UIFont fontWithName:GOTHAM_BOLD size:10];
    [self.titleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.nameLabel withOffset:20];
    [[@[self.titleLabel, self.nameLabel] autoAlignViewsToEdge:ALEdgeLeading][0] setConstant:-3];
    self.titleLabel.textColor = [UIColor whiteColor];
}

-(void)createSpacing
{
    UIView *view = [UIView newAutoLayoutView];
    view.backgroundColor = [UIColor whiteColor];
    self.spacing = view;
    [self.view addSubview:self.spacing];
    [self.spacing autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.nameLabel withOffset:7];
    [self.spacing autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.view withOffset:0];
    [[@[self.spacing, self.nameLabel] autoAlignViewsToEdge:ALEdgeLeading][0] setConstant:-3];
    [self.spacing autoSetDimension:ALDimensionHeight toSize:2];
}

-(void)createQuickViewItemsPageControl
{
    UIPageControl *control = [UIPageControl newAutoLayoutView];
    self.quickViewItemsPageControl = control;
    self.quickViewItemsPageControl.numberOfPages = 3;
    [self.quickViewItemsPageControl setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:control];
    [self.quickViewItemsPageControl autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:-20.0f];
    [self.quickViewItemsPageControl autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.view];
    [self.quickViewItemsPageControl autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.view];
}

-(void)createQuickViewItemsViewController
{
    AMPannableTabBarViewController *tabBarController = [[AMPannableTabBarViewController alloc] init];
    self.quickViewItemsController = tabBarController;
    self.quickViewItemsController.tabBar.hidden = YES;
    self.quickViewItemsController.view.backgroundColor = [UIColor blueColor];
    [self addChildViewController:tabBarController];
    [self.view addSubview:self.quickViewItemsController.view];
    [self.quickViewItemsController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.quickViewItemsController.view autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.view];
    [self.quickViewItemsController.view autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.view];
    [self.quickViewItemsController.view autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.quickViewItemsHeadersCollectionView];
    [self.quickViewItemsController.view autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.quickViewItemsPageControl withOffset:-20.0f];
    [self.quickViewItemsController didMoveToParentViewController:self];
    

    UIViewController *viewController1 = [[UIViewController alloc] init];
    viewController1.view.backgroundColor = [UIColor grayColor];
    viewController1.title = @"Current Handeled Orders";
    UIViewController *viewController2 = [[UIViewController alloc] init];
    viewController2.view.backgroundColor = [UIColor greenColor];
    viewController2.title = @"Current Standing Orders";
    UIViewController *viewController3 = [[UIViewController alloc] init];
    viewController3.view.backgroundColor = [UIColor yellowColor];
    viewController3.title = @"Miscellaneous";
    [self.quickViewItemsController setViewControllers:@[viewController1, viewController2, viewController3]];
}

-(void)createQuickViewItemsHeadersCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.quickViewItemsHeadersCollectionView = collectionView;
    [self.quickViewItemsHeadersCollectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
    collectionView.backgroundColor = [UIColor redColor];
    [self.view addSubview:collectionView];
    [self.quickViewItemsHeadersCollectionView autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.view];
    [self.quickViewItemsHeadersCollectionView autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.view];
    [self.quickViewItemsHeadersCollectionView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.titleLabel withOffset:20.0f];
    [self.quickViewItemsHeadersCollectionView autoSetDimension:ALDimensionHeight toSize:50];
}

-(void)didChangeIndex:(NSNotification *)notification
{
    self.quickViewItemsPageControl.currentPage = self.quickViewItemsController.selectedIndex;
}

@end
