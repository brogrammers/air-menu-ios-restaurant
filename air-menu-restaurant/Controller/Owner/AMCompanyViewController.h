//
//  AMCompanyViewController.h
//  Air Menu
//
//  Created by Robert Lis on 14/04/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AirMenuKit/AirMenuKit.h>
#import "AMScopeDrivenViewController.h"
#import "AMOwnerNavigationController.h"

@interface AMCompanyViewController : AMScopeDrivenViewController
@property (nonatomic, readwrite, weak) AMOwnerNavigationController *controller;
-(id)initWithScopes:(NSArray *)scopes user:(AMUser *)user navigationController:(AMOwnerNavigationController *)controller;
@end
