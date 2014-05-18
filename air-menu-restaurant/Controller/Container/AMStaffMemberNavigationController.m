//
//  AMStaffMemberNavigationController.m
//  Air Menu
//
//  Created by Robert Lis on 20/04/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMStaffMemberNavigationController.h"
#import "AMRestaurantViewPickerViewController.h"
#import "AMNavigationViewController.h"

@implementation AMStaffMemberNavigationController
-(id)initWithScopes:(NSArray *)scopes user:(AMUser *)user staffMember:(AMStaffMember *)member
{
    self = [super initWithScopes:scopes user:user];
    if(self)
    {
        self.staffMember = member;
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    AMRestaurantViewPickerViewController *viewController = [[AMRestaurantViewPickerViewController alloc] initWithScopes:self.scopes user:self.user];
    viewController.controller = self;
    [self addStylersFromArray:@[[MSDynamicsDrawerShadowStyler styler], [MSDynamicsDrawerResizeStyler styler], [MSDynamicsDrawerScaleStyler styler], [MSDynamicsDrawerFadeStyler styler]] forDirection:MSDynamicsDrawerDirectionLeft];
    [self setDrawerViewController:viewController forDirection:MSDynamicsDrawerDirectionLeft];
    [self setRevealWidth:310 forDirection:MSDynamicsDrawerDirectionLeft];
    
}

@end
