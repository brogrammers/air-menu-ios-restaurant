//
//  AMRestaurantDrivenViewController.h
//  Air Menu
//
//  Created by Robert Lis on 29/04/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMScopeDrivenNavigationController.h"

@interface AMRestaurantDrivenViewController : AMScopeDrivenNavigationController
@property (nonatomic, readwrite) AMRestaurant *restaurant;
-(id)initWithScopes:(NSArray *)scopes user:(AMUser *)user restaurant:(AMRestaurant *)restaurant;
@end
