//
//  AMOwnerNavigationController.m
//  Air Menu
//
//  Created by Robert Lis on 14/04/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMOwnerNavigationController.h"
#import "AMCompanyViewController.h"
#import "AMNavigationViewController.h"
#import "AMInitialViewController.h"

@implementation AMOwnerNavigationController

-(id)initWithScopes:(NSArray *)scopes currentUser:(AMUser *)user
{
    self = [super init];
    if(self)
    {
        self.scopes = scopes;
        self.user = user;
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    AMCompanyViewController *viewController = [[AMCompanyViewController alloc] initWithScopes:self.scopes user:self.user navigationController:self];
    viewController.controller = self;
    UINavigationController *navigationController = [[AMNavigationViewController alloc] initWithRootViewController:viewController];
    [navigationController setNavigationBarHidden:YES];
    navigationController.interactivePopGestureRecognizer.delegate = navigationController.viewControllers.lastObject;
    [self addStylersFromArray:@[[MSDynamicsDrawerShadowStyler styler], [MSDynamicsDrawerResizeStyler styler], [MSDynamicsDrawerScaleStyler styler], [MSDynamicsDrawerFadeStyler styler]] forDirection:MSDynamicsDrawerDirectionLeft];
    [self setDrawerViewController:navigationController forDirection:MSDynamicsDrawerDirectionLeft];
    [self setRevealWidth:310 forDirection:MSDynamicsDrawerDirectionLeft];
    [self setPaneViewController:[[AMInitialViewController alloc] init] animated:NO completion:nil];
}

@end
