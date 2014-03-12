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
    [self.button setTitleColor:[UIColor colorWithRed:1.0f/255.0f green:57.0f/255.0f blue:83.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    self.button.titleLabel.font = [UIFont fontWithName:MENSCH_THIN size:30];
    self.button.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.2].CGColor;
    self.button.layer.shadowOpacity = 1.0;
    self.button.layer.shadowRadius = 1.0;
    self.button.layer.shadowOffset = CGSizeMake(0.0f,1.0f);
}
@end
