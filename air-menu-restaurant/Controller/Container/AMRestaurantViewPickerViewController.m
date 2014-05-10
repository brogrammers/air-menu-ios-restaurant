//
//  AMRestaurantPickerViewController.m
//  Air Menu
//
//  Created by Robert Lis on 20/04/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMRestaurantViewPickerViewController.h"
#import "AMPeopleViewController.h"
#import "AMDevicesViewController.h"
#import "AMMenusViewController.h"

@interface AMRestaurantViewPickerViewController ()

@end

@implementation AMRestaurantViewPickerViewController

-(id)initWithScopes:(NSArray *)scopes user:(AMUser *)user
{
    self = [super initWithScopes:scopes user:user];
    if(self)
    {
        [self configure];
    }
    return self;
}

-(void)setRestaurant:(AMRestaurant *)restaurant
{
    _restaurant = restaurant;
    [self.controllers each:^(UIViewController *controller) {
       if([controller isKindOfClass:[AMRestaurantDrivenViewController class]])
       {
           AMRestaurantDrivenViewController *restaurantDrivenController = (AMRestaurantDrivenViewController *) controller;
           restaurantDrivenController.restaurant = restaurant;
       }
    }];
}

-(void)configure
{
    NSMutableArray *controllers = [NSMutableArray array];
    NSMutableArray *names = [NSMutableArray array];
    NSMutableArray *icons = [NSMutableArray array];
    
    if([self.scopes containsObject:@(AMOAuthScopeGetMenus)] || self.user.type == AMUserTypeOwner)
    {
        [controllers addObject:[[AMMenusViewController alloc] initWithScopes:self.scopes user:self.user restaurant:nil]];
        [names addObject:@"MENUS"];
        [icons addObject:@""];
    }
    
    if([self.scopes containsObject:@(AMOAuthScopeGetStaffKinds)] ||
       [self.scopes containsObject:@(AMOAuthScopeGetStaffMembers)] ||
       self.user.type == AMUserTypeOwner)
    {
        [controllers addObject:[[AMPeopleViewController alloc] initWithScopes:self.scopes user:self.user restaurant:nil]];
        [names addObject:@"PEOPLE"];
        [icons addObject:@""];
    }
    
    if([self.scopes containsObject:@(AMOAuthScopeGetDevices)] ||
       [self.scopes containsObject:@(AMOAuthScopeGetGroups)] ||
       self.user.type == AMUserTypeOwner)
    {
        [controllers addObject:[[AMDevicesViewController alloc] initWithScopes:self.scopes user:self.user restaurant:nil]];
        [names addObject:@"DEVICES"];
        [icons addObject:@""];
    }
    
    self.names = names;
    self.icons = icons;
    self.controllers = controllers;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
