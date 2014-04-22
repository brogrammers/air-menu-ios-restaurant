//
//  AMStaffMemberNavigationController.m
//  Air Menu
//
//  Created by Robert Lis on 20/04/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMStaffMemberNavigationController.h"
#import "AMRestaurantViewPickerViewController.h"

@implementation AMStaffMemberNavigationController

-(void)viewDidLoad
{
    [super viewDidLoad];
    AMRestaurantViewPickerViewController *viewController = [[AMRestaurantViewPickerViewController alloc] initWithScopes:self.scopes user:self.user];
    [self addStylersFromArray:@[[MSDynamicsDrawerShadowStyler styler], [MSDynamicsDrawerResizeStyler styler], [MSDynamicsDrawerScaleStyler styler], [MSDynamicsDrawerFadeStyler styler]] forDirection:MSDynamicsDrawerDirectionLeft];
    [self setDrawerViewController:viewController forDirection:MSDynamicsDrawerDirectionLeft];
    [self setRevealWidth:310 forDirection:MSDynamicsDrawerDirectionLeft];
}

@end
