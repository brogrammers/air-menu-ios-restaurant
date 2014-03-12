//
//  AMRestaurantCreatorViewController.m
//  Air Menu
//
//  Created by Robert Lis on 12/03/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMRestaurantCreatorViewController.h"
#import <UIView+AutoLayout/UIView+AutoLayout.h>
#import "AMFormView.h"

@interface AMRestaurantCreatorViewController ()

@end

@implementation AMRestaurantCreatorViewController

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        [self setup];
    }
    return self;
}

-(void)setup
{
    [self setupFormView];
    [self createLabel];
    [self createButton];
    self.view.backgroundColor = [UIColor clearColor];
}

-(void)setupFormView
{

}

-(void)createLabel
{
    UILabel *label = [UILabel newAutoLayoutView];
    self.titleLabel = label;
    [self.view addSubview:self.titleLabel];
    [self.titleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view withOffset:20.0f];
    [self.titleLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    self.titleLabel.text = @"create new restaurant";
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont fontWithName:GOTHAM_LIGHT size:15];
}

-(void)createButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    self.button = button;
    [self.view addSubview:self.button];
    self.button.translatesAutoresizingMaskIntoConstraints = NO;
    [self.button autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:-20.0f];
    [self.button autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.button setTitle:@"CREATE" forState:UIControlStateNormal];
}
@end
