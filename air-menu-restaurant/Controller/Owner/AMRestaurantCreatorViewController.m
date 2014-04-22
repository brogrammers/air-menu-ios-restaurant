//
//  AMRestaurantCreatorViewController.m
//  Air Menu
//
//  Created by Robert Lis on 15/04/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMRestaurantCreatorViewController.h"
#import "AMRestaurantCreatorInputView.h"
#import <UIView+AutoLayout/UIView+AutoLayout.h>

@interface AMRestaurantCreatorViewController ()
@property (nonatomic, readwrite, weak) AMRestaurantCreatorInputView *inputView;
@end

@implementation AMRestaurantCreatorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    AMRestaurantCreatorInputView *inputView = [AMRestaurantCreatorInputView newAutoLayoutView];
    self.inputView = inputView;
    [self.view addSubview:inputView];
    [self.inputView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
